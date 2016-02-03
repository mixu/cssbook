home: index.html
prev: 2-box-model.html
next: 4-flexbox.html
---
# 3. Additional properties that influence positioning

Now that we have discussed how the box model properties vary across different element types, let's take a look several additional features which influence how the box model and positioning work. In particular:

- *Margin collapsing* affects adjacent margins so that only the larger of two margins is applied.
- *Negative margins*. Negative values (e.g. `-10px`) are allowed for margins, and these can be used to position content.
- *Overflow*. When the content inside a container box is larger than its parent or positioned at an offset that is beyond the parent's box, it overflows. The `overflow` property controls how this is handled.
- *max-width, max-height, min-width, min-height*, Width and height can be further constrained by using the `max-width`, `max-height`, `min-width` and `min-height` properties.
- *Pseudo-elements* allow additional elements to be generated within the selected element from CSS. They are often used to generate additional content for layout or for to provide a particular visual appearance.
- *Stacking contexts and rendering order* determine the z-axis rendering of boxes.

### Margin collapsing

Margins have special interactions with other margins: adjoining vertical margins of two or more boxes can combine into a single margin. This is known as margin collapsing.

When there are two adjacent vertical margins, the greater of the two is used and the other is ignored. The example below illustrates:

```snippet
<p class="five blue">5 px margin-top/bottom</p>
<p class="ten green">10 px margin-top/bottom</p>
<p class="twenty red">20 px margin-top/bottom</p>
---
.five {
  margin: 5px 0;
}
.ten {
  margin: 10px 0;
}
.twenty {
  margin: 20px 0;
}
---
```

As you can see, the margin between the 5px and 10px blocks is 10px, and the margin between the 10px and 20px blocks is 20px. This is because the adjacent margins collapse, and only the greater of the two is applied.

Having read the spec extensively for the book, I find that in this case the wording in the spec is more confusing than helpful, so I will not quote the [spec for collapsing margins](http://www.w3.org/TR/2011/REC-CSS2-20110607/box.html#collapsing-margins) directly.

There are several rules which restrict which margins may collapse. The four high-level rules are:

1. Only vertical margins can collapse - horizontal margins never collapse.
2. Only margins from block-level boxes can collapse. In other words, margins of floats, absolutely positioned elements, inline-block elements never collapse. Inline-level boxes don't have margins, so they don't collapse either.
3. Only margins from boxes that participate in the same block formatting context can collapse. Note that block formatting contexts are not established by block boxes with `overflow: visible` (the default value). In this sense, margin collapsing behaves similar to floats, which only affect line boxes of block-level boxes in the same formatting context.
4. Only margins that are considered to be adjoining can collapse.

The notion of adjointness is explained in a roundabout way in the spec, but I found it easiest to think about the margin-top and margin-bottom values as rectangles on their own - ignoring the box that generates them - and then looking at whether those margin rectangles touch each other.

If you think of the margins as boxes on their own, then you can see that two margins will be next to each other when they are:

- parent and child margins
- margins between siblings
- grandparent and parent and child margins
- margins from elements with no content

All of these cases are eligible for margin collapsing. Two margins will only collapse if they are not separated by:

- content (e.g. text in line boxes)
- padding or borders (e.g. if a parent has padding or borders, its margins cannot collapse with the margins of its children but otherwise they will)
- clearance (e.g. the result of clearing a float may separate the margins enough that they cannot collapse.)

What happens when margins collapse?

> When two or more margins collapse, the resulting margin width is the maximum of the collapsing margins' widths. In the case of negative margins, the maximum of the absolute values of the negative adjoining margins is deducted from the maximum of the positive adjoining margins. If there are no positive margins, the maximum of the absolute values of the adjoining margins is deducted from zero.

The following three snippets illustrate the difference between collapsing margins and non-collapsing margins.

```snippet
<div class="parent">
  <div class="m">Hello world</div>
  <div class="m">Hello world</div>
  <div class="m">Hello world</div>
</div>
---
.m {
  margin: 10px;
  background-color: #fb9a99;
}
.parent {
  margin: 10px;
  background-color: #a6cee3;
}
body {
  background-color: #b2df8a;
}
---
```

```snippet
<div class="parent">
  <div class="m">Hello world</div>
  <div class="m">Hello world</div>
  <div class="m">Hello world</div>
</div>
---
.m {
  overflow: auto;
  margin: 10px;
  background-color: #fb9a99;
}
.parent {
  overflow: auto;
  margin: 10px;
  background-color: #a6cee3;
}
body {
  overflow: auto;
  background-color: #b2df8a;
}
---
```

```snippet
<div class="parent">
  <div class="m">Hello world</div>
  <div class="m">Hello world</div>
  <div class="m">Hello world</div>
</div>
---
.m {
  margin: 10px;
  background-color: #fb9a99;
  border: 3px solid #e31a1c;
}
.parent {
  margin: 10px;
  background-color: #a6cee3;
  border: 3px solid #1f78b4;
}
body {
  background-color: #b2df8a;
  border: 3px solid #33a02c;
}
---
```

As you can see:

- in the first example, margins collapse both between siblings and between parents. The "Hello world" text is only 10 px from the top.
- in the second example, I've added `overflow: auto` to every div. This means that every div creates its own block formatting context. Notice how the margins of sibling divs still collapse, but margins between parents and children do not.
- in the third example, I've added a `border` to every div instead of the overflow. When borders are added, the "Hello world" text is offset 30px from the top because the margins are no longer adjoining - they are separated by a border in this case. Again, only sibling margins collapse.

## Negative margins

Negative margins are barely mentioned in the spec, but they can have a significant impact on layout. Here's what the spec says:

> In the case of negative margins, the maximum of the absolute values of the negative adjoining margins is deducted from the maximum of the positive adjoining margins. If there are no positive margins, the maximum of the absolute values of the adjoining margins is deducted from zero.

Negative margins shift the position where rendering happens, which can be used to reposition content. They used to be the only way to accomplish certain results, such as centering in the bad old days. The problem is that negative margins do not propertly interact with the content they overlap, leading to hard-to-debug issues where content unexpectedly overlaps each other. Nowadays, using negative margins is much more rare thanks to better alternatives being developed. The example below illustrates:

```snippet
<div class="blue">In the case of negative margins, the maximum of the absolute values of the negative adjoining margins is deducted from the maximum of the positive adjoining margins.</div>
<div class="negative">If there are no positive margins, the maximum of the absolute values of the adjoining margins is deducted from zero.</div>
---
.negative {
  margin-top: -2em
  ;
  margin-left: 30px;
}
---
```


## Overflow

Overflow occurs when a child element is either positioned outside its parent element, or the child element does not fit inside the dimensions of its parent. The `overflow` property controls how the portion of the child that overflows is rendered:

> This property specifies whether content of a block container element is clipped when it overflows the element's box. It affects the clipping of all of the element's content except any descendant elements (and their respective content and descendants) whose containing block is the viewport or an ancestor of the element. [source](http://www.w3.org/TR/2011/REC-CSS2-20110607/visufx.html#overflow)

| Property | Default value | Purpose
|-----------|------------------------------------------------------------------
| overflow  | visible | Controls how child elements that are larger than their parent elements are handled. Not applicable to `display: inline` elements. Applying an `overflow` value other than `visible` creates a *block formatting context*.

The `overflow` property can take the following values. The default value is `visible`:

> - visible: This value indicates that content is not clipped, i.e., it may be rendered outside the block box.
- hidden: This value indicates that the content is clipped and that no scrolling user interface should be provided to view the content outside the clipping region.
- scroll: This value indicates that the content is clipped and that if the user agent uses a scrolling mechanism that is visible on the screen (such as a scroll bar or a panner), that mechanism should be displayed for a box whether or not any of its content is clipped. This avoids any problem with scrollbars appearing and disappearing in a dynamic environment. When this value is specified and the target medium is 'print', overflowing content may be printed.
- auto: The behavior of the 'auto' value is user agent-dependent, but should cause a scrolling mechanism to be provided for overflowing boxes.

## max-width, max-height, min-width and min-height

In addition to allowing you to set `width` and `height` explicitly, CSS 2.1 also allows you to add constraints to the `width` and `height` values via `max-width`, `max-height`, `min-width` and `min-height`.

These values can be specified either using explicit units like `px`, or as a percentage of the parent width or parent height:

| `max-` / `min-width`  | Description
|-------|----------------------------------------------------------------------
| `<length>` | Specifies a fixed minimum or maximum used width.
| `<percentage>` | Specifies a percentage for determining the used value. The percentage is calculated with respect to the width of the generated box's containing block. If the containing block's width is negative, the used value is zero. *If the containing block's width depends on this element's width*, then the resulting layout is undefined in CSS 2.1.
| `none` | (Only on 'max-width') No limit on the width of the box.

| `max-` / `min-height`  | Description
|-------|----------------------------------------------------------------------
| `<length>` | Specifies a fixed minimum or maximum used width.
| `<percentage>` | Specifies a percentage for determining the used value. The percentage is calculated with respect to the height of the generated box's containing block. **If the height of the containing block is not specified explicitly** (i.e., it depends on content height), and this element is not absolutely positioned, the percentage value is treated as '0' (for 'min-height') or 'none' (for 'max-height').
| `none` | (Only on 'max-height') No limit on the height of the box.

It is worth noting the special case on `max-height` / `min-height`: percentage values for these properties are only applied when the height of the containing block is set to a definite value (!). A similar restriction applies to `max-width` / `min-width`.

The properties are applied as follows:

> The following algorithm describes how the two properties influence the used value of the 'width' property:

> - The tentative used width is calculated (without 'min-width' and 'max-width') following the rules under "Calculating widths and margins" above.
- If the tentative used width is greater than 'max-width', the rules above are applied again, but this time using the computed value of 'max-width' as the computed value for 'width'.
- If the resulting width is smaller than 'min-width', the rules above are applied again, but this time using the value of 'min-width' as the computed value for 'width'. [source](http://www.w3.org/TR/CSS2/visudet.html#min-max-widths)

> The following algorithm describes how the two properties influence the used value of the 'height' property:

> - The tentative used height is calculated (without 'min-height' and 'max-height') following the rules under "Calculating heights and margins" above.
> - If this tentative height is greater than 'max-height', the rules above are applied again, but this time using the value of 'max-height' as the computed value for 'height'.
> - If the resulting height is smaller than 'min-height', the rules above are applied again, but this time using the value of 'min-height' as the computed value for 'height'. [source](http://www.w3.org/TR/2011/REC-CSS2-20110607/visudet.html#min-max-heights)

There is some subtlety to this description. For example, when the height of the parent div is less than the height of the content of the child div, then setting `height: 100%` will result in a rendering that's different from `min-height: 100%`. The examples below illustrate:

```snippet
<div class="height blue">
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam at orci ac libero euismod mollis et porta elit. Proin a ultricies turpis. Nam tortor risus, sodales non ultrices ac, interdum sed dui. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc at mollis elit. Proin at molestie diam. In ultrices erat nec ante eleifend, quis vestibulum ante elementum. Phasellus nec dapibus urna, ut sodales felis. Quisque dolor lectus, tincidunt vel augue ut, feugiat porttitor purus.

Praesent commodo blandit lacinia. Etiam mollis rutrum enim, non congue tortor semper in. Donec commodo metus id turpis dapibus, ut ultricies ante porta. Sed cursus dignissim eros cursus ullamcorper. Curabitur eleifend, turpis commodo tempus convallis, diam orci consequat velit, eu auctor mi felis eu elit. Sed lectus ipsum, hendrerit id dui eu, imperdiet dictum eros. Nullam tincidunt dignissim felis sit amet blandit.
</div>
---
html, body {
  height: 100%;
}
.height {
  height: 100%;
}
---
```

```snippet
<div class="min-height blue">
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam at orci ac libero euismod mollis et porta elit. Proin a ultricies turpis. Nam tortor risus, sodales non ultrices ac, interdum sed dui. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc at mollis elit. Proin at molestie diam. In ultrices erat nec ante eleifend, quis vestibulum ante elementum. Phasellus nec dapibus urna, ut sodales felis. Quisque dolor lectus, tincidunt vel augue ut, feugiat porttitor purus.

Praesent commodo blandit lacinia. Etiam mollis rutrum enim, non congue tortor semper in. Donec commodo metus id turpis dapibus, ut ultricies ante porta. Sed cursus dignissim eros cursus ullamcorper. Curabitur eleifend, turpis commodo tempus convallis, diam orci consequat velit, eu auctor mi felis eu elit. Sed lectus ipsum, hendrerit id dui eu, imperdiet dictum eros. Nullam tincidunt dignissim felis sit amet blandit.
</div>
---
html, body {
  height: 100%;
}
.min-height {
  min-height: 100%;
}
---
```

As you can see:

- if you scroll the first example, where `height: 100%` was set, you can see that the height of the div matches the parent's height and the content overflows the borders of the div.
- in the second example, where `min-height: 100%` is used, the height of the div matches its contents.

Why does this behavior occur? Because setting `min-height` leaves `height` to its default value - `height: auto`. Then, the regular box model calculations are applied, which for a block-level element cause the box to be sized based on its contents.

In contrast, setting `height: 100%` does not trigger any content-based sizing: it just sets the height of the box directly as if it was set using some other unit, such as `px` - which causes overflow in this case.

If you set the content to something that's too short to fill the full height, then `min-height` forces the height to be `100%` of the parent height, as shown below:

```snippet
<div class="min-height blue">
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam at orci ac libero euismod mollis et porta elit.
</div>
---
html, body {
  height: 100%;
}
.min-height {
  min-height: 100%;
}
---
```

# Pseudo-elements

Pseudo-elements are elements which are added into the markup by CSS. CSS 2.1 introduces two pseudo element selectors: `:before` and `:after`. CSS rules targeting these elements can insert content into HTML by specifying the value of the `content` property.

Here's what the spec says about pseudo-elements:

> In some cases, authors may want user agents to render content that does not come from the document tree. One familiar example of this is a numbered list; the author does not want to list the numbers explicitly, he or she wants the user agent to generate them automatically.

> In CSS 2.1, content may be generated by two mechanisms:

> - The 'content' property, in conjunction with the :before and :after pseudo-elements.
- Elements with a value of 'list-item' for the 'display' property.

> Authors specify the style and location of generated content with the :before and :after pseudo-elements.

The content generated by the pseudo-elements is placed *inside* the element, at the beginning or end of the contents of the element:

> [...] the :before and :after pseudo-elements specify the location of content before and after an element's document tree content. The 'content' property, in conjunction with these pseudo-elements, specifies what is inserted.

For example, given the following markup:

```snippet
<p class="example blue">world</p>
---
.example:before {
  content: 'Hello ';
}
.example:after {
  content: '!!!';
}
---
```

... the text "Hello " is inserted before "world" and "!!!" is inserted after "world".

The `content` property can accept additional types of values in addition to strings:

> - `none`: The pseudo-element is not generated.
> - `normal`: Computes to 'none' for the :before and :after pseudo-elements.
> - `<string>`: Text content (see the section on strings).
> - `<uri>`: The value is a URI that designates an external resource (such as an image). If the user agent cannot display the resource it must either leave it out as if it were not specified or display some indication that the resource cannot be displayed.
> - `<counter>`: Counters may be specified with two different functions: 'counter()' or 'counters()'. The former has two forms: 'counter(name)' or 'counter(name, style)'. The generated text is the value of the innermost counter of the given name in scope at this pseudo-element; it is formatted in the indicated style ('decimal' by default). The latter function also has two forms: 'counters(name, string)' or 'counters(name, string, style)'. The generated text is the value of all counters with the given name in scope at this pseudo-element, from outermost to innermost separated by the specified string. The counters are rendered in the indicated style ('decimal' by default). See the section on automatic counters and numbering for more information. The name must not be 'none', 'inherit' or 'initial'. Such a name causes the declaration to be ignored.
> - `open-quote` and `close-quote`: These values are replaced by the appropriate string from the 'quotes' property.
> - `no-open-quote` and `no-close-quote`: Introduces no content, but increments (decrements) the level of nesting for quotes.
> - `attr(X)`: This function returns as a string the value of attribute X for the subject of the selector. The string is not parsed by the CSS processor. If the subject of the selector does not have an attribute X, an empty string is returned. The case-sensitivity of attribute names depends on the document language.
>
> Note. In CSS 2.1, it is not possible to refer to attribute values for other elements than the subject of the selector. [source](http://www.w3.org/TR/CSS2/generate.html#content)

Out of these options, three types of properties are particularly interesting:

*content: url()*: Allows you insert media, such as images. The image in the example below [is from Wikipedia](http://commons.wikimedia.org/wiki/File:Cat_March_2010-1a.jpg).

```snippet
<p class="example blue">Cat</p>
---
.example:before {
  content: url(img/cat.jpg);
}
---
```

*content: counter()*: Allows you to make use of CSS counters. A realistic use case for this would be to implement chapter numbering, but the example below implements the [fizzbuzz](http://c2.com/cgi/wiki?FizzBuzzTest) programming  question instead.

```snippet
<p></p><p></p><p></p><p></p><p></p><p></p><p></p><p></p><p></p><p></p><p></p><p></p><p></p><p></p><p></p>
---
p:before {
  content: counter(foobar);
}
p {
  counter-increment: foobar;
  display: inline-block;
  padding: 4px;
}
p:nth-child(3n):before {
  content: 'fizz';
}
p:nth-child(5n):before {
  content: 'buzz';
}
p:nth-child(15n):before {
  content: 'fizzbuzz';
}
---
```

*content: attr()*: Allows you to access the attributes of the subject of the CSS selector, for example, the URL of a link.

```snippet
<p><a href="http://google.com">Google</a></p>
---
a:after {
  content: " (" attr(href) ")";
}
---
```

The pseudo-elements behave as follows:

> The 'display' property controls whether the content is placed in a block or inline box.
>
> The :before and :after pseudo-elements inherit any inheritable properties from the element in the document tree to which they are attached.
>
> In a :before or :after pseudo-element declaration, non-inherited properties take their initial values.
>
> The :before and :after pseudo-elements interact with other boxes as if they were real elements inserted just inside their associated element.

# `box-sizing` (CSS3)

By default, the on-screen width of a CSS box is computed by adding `padding` and `border` to the relevant `width` or `height` value. However, this makes it more difficult to specify a layout since changes to padding and borders affect the amount of the space an element takes.

CSS3 introduces the [`box-sizing` property](http://dev.w3.org/csswg/css-ui-3/#box-sizing), which allows you to specify whether you want the `width` and `height` values to take into account padding and borders. The table below lists the possible values. Note that `box-sizing: padding-box` is only supported by Firefox as of the current writing, but the other two values are supported in all major browsers.

| `box-sizing` value | Description
|-------|----------------------------------------------------------------------
| content-box | This is the behavior of width and height as specified by CSS2.1. The specified width and height (and respective min/max properties) apply to the width and height respectively of the content box of the element. The padding and border of the element are laid out and drawn outside the specified width and height.
| padding-box | Length and percentages values for width and height (and respective min/max properties) on this element determine the padding box of the element. That is, any padding specified on the element is laid out and drawn inside this specified width and height. The content width and height are calculated by subtracting the padding widths of the respective sides from the specified width and height properties.
| border-box | Length and percentages values for width and height (and respective min/max properties) on this element determine the border box of the element. That is, any padding or border specified on the element is laid out and drawn inside this specified width and height. The content width and height are calculated by subtracting the border and padding widths of the respective sides from the specified width and height properties.

The example below illustrates the difference between a box with a `400px` width and `10px` borders and `10px` padding when using `content-box` vs. `border-box` sizing:

```snippet
<div class="content-box blue">400px content-box, 10px padding, 10px border</div>
<div class="border-box green">400px border-box, 10px padding, 10px border</div>
<div class="red">400px</div>
---
.content-box {
    box-sizing: content-box;
    width: 400px;
}
.border-box {
    box-sizing: border-box;
    width: 400px;
}
.content-box, .border-box {
    border-width: 10px;
    padding: 10px;
}
.red {
    width: 400px;
    border-width: 0px;
}
.border-box, .red {
  position: relative;
  left: 20px;
}
---
```

As you can see, the `border-box` sized box is exactly 400px wide, while the content-box sized box takes up 440px on screen (`2 * 10 px borders + 2 * 10px padding`).

# Stacking and rendering order

Thus far I've discussed positioning on the x and y axis. Now, let's look at how z-axis positioning works. There are two aspects to z-axis positioning:

- First, at a detailed level, each box consists of several renderable parts, such as the box background, box borders and content. These have a defined (fixed) rendering order for each box.
- Second, as you have seen before, some elements - such as floats and absolutely positioned elements - can be rendered on top of boxes generated by other elements. The relative rendering order of boxes is influenced by the `z-index` property.

In order to render the view that you can see in your browser, the browser needs to first determine the relative positioning of boxes on the z-axis, and then render the various parts of the boxes in their expected order. Stacking and layered presentation are described in two parts of the spec: [Appendix E. Elaborate description of Stacking Contexts](http://www.w3.org/TR/2011/REC-CSS2-20110607/zindex.html) and [9.9 Layered presentation](http://www.w3.org/TR/2011/REC-CSS2-20110607/visuren.html#propdef-z-index)

### Rendering order

Let's start by looking at the various parts that make up a single box in CSS. Five properties cause various visual effects to be drawn as part of a box: `box-shadow`, `background-color`, `background-image`, `border` and `outline`.

The relative rendering order of these visual effects is fixed. The order is:

1. outer box shadows (CSS3)
2. render the background color of the element
3. render the background image of the element
4. inner box shadows (CSS3)
5. render the border of the element
6. render the content
7. render the outline of the element

According to the CSS3 Backgrounds and Borders Module, which adds support for multiple background images, the background images are drawn such that the first background image specified in CSS is rendered last and [may overlap the second background image](http://dev.w3.org/csswg/css-backgrounds-3/#layering).

The CSS3 `box-shadow` property produces shadows which are drawn partially before (outer shadow) the background and partially after (inner shadows), per the [spec](dev.w3.org/csswg/css-backgrounds-3/#shadow-layers).

### Stacking contexts and z-index

The z-axis positioning of elements in CSS is determined by their type (float, block-level, inline-level, absolutely positioned) and their z-index relative to the current stacking context.

Ignoring stacking context for a moment, elements are drawn in the following order:

- block-level descendants in the normal flow
- floats
- inline descendants in the normal flow
- positioned elements

That is, floats are drawn on top of block-level descendants, and positioned elements are drawn on top of inline elements.

Stacking contexts are less common than formatting contexts. A stacking context is a context formed by some elements which have specific properties set. The z-index of elements in the same stacking context influences their rendering order relative to other elements in the same stacking context.

| Attribute | Default value | Purpose
|-----------|------------------------------------------------------------------
| z-index   | auto     | Controls the relative positioning of of an element and its descendants on the z-axis relative to the parent *stacking context*.

The spec is a bit vague on what forms a stacking context, but the [MDN docs](https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Understanding_z_index/The_stacking_context) have the following list:

> A stacking context is formed, anywhere in the document, by any element which is either

> - the root element (HTML),
- positioned (absolutely or relatively) with a z-index value other than "auto",
- a flex item with a z-index value other than "auto",
- elements with an opacity value less than 1. (See the specification for opacity),
- elements with a transform value other than "none",
- elements with a mix-blend-mode value other than "normal",
- elements with isolation set to "isolate",
- on mobile WebKit and Chrome 22+, position: fixed always creates a new stacking context, even when z-index is "auto" (See this post)
- specifying any attribute above in will-change even if you don't specify values for these attributes directly (See this post)
- elements with -webkit-overflow-scrolling set to "touch"

In other words, stacking contexts are more rare than formatting contexts, since most elements do not form new stacking contexts.

> - Each box belongs to one stacking context.
> - Each positioned box in a given stacking context has an integer stack level, which is its position on the z-axis relative other stack levels within the same stacking context.
> - Boxes with greater stack levels are always formatted in front of boxes with lower stack levels.
> - Boxes may have negative stack levels.
> - Boxes with the same stack level in a stacking context are stacked back-to-front according to document tree order.

Note that the z-index is relative to the other elements in the same stacking context. That is, there is no global z-index and setting z-index to a very high value only ensures that the block is rendered above other elements in the same stacking context - not that it will be rendered on top of all elements globally.

Stacking contexts allow elements to be positioned either before or after the normal flow and floated elements. Specifically:

> Within each stacking context, the following layers are painted in back-to-front order:

> 1. the background and borders of the element forming the stacking context.
2. the child stacking contexts with negative stack levels (most negative first).
3. the in-flow, non-inline-level, non-positioned descendants.
4. the non-positioned floats.
5. the in-flow, inline-level, non-positioned descendants, including inline tables and inline blocks.
6. the child stacking contexts with stack level 0 and the positioned descendants with stack level 0.
7. the child stacking contexts with positive stack levels (least positive first).

That is, elements with a negative stacking context are drawn below the normal flow and floats and elements with a positive stacking context are drawn above the normal flow and floats. If two elements have the same z-index, then they are stacked back-to-front according to their order in the HTML markup.

Note that only positioned elements can have z-index, e.g. setting z-index for normal flow blocks or floats will have no effect on their rendering order.

Since most elements do not establish new stacking contexts, any positioned descendants of elements that do not establish new stacking contexts will take part in the parent (current) stacking context.
