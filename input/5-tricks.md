home: index.html
prev: 4-flexbox.html
next: reference.html
---
# 5. CSS layout: tricks and layout techniques

In this chapter, we'll take a look at how the various CSS layout properties can be used to influence the sizing, positioning and overall layout of a page. I have also included a number of puzzles to help you review the things you have learned in the previous chapters.

This chapter is organized by use case rather than by property or feature. First, I'll talk about sizing and positioning, then I'll focus on two specific use cases: grid-based layouts and horizontal and vertical centering.

## CSS layout tricks and techniques used for sizing

Sizing-related techniques allow you to define how a particular element should be sized; how it should grow and how it should shrink as the viewport size changes.

- Height transfer
- Forced min-height
- Combining flex and non-flex items
- Sizing with constraints

*Height transfer*. Unlike basic HTML documents, web applications often want to make use of all of the available space in the viewport while avoiding scrolling. However, a typical HTML document contains several root elements that are `display: block` by default. If those blocks do not have a specified height, they will simply use the height of their content rather than the height of the viewport. The following snippet forces the `html` and `body` tags to take up `100%` of the viewport height, which then lets you use percentages in subsequent markup to refer to viewport height:

```css
html, body {
  height: 100%;
}
```

CSS3 adds the new `vh` and `vw` units, which are always relative to viewport height and viewport width, which makes it much easier to size elements relative to viewport size since you no longer need to make every parent in the tree transfer the height of the viewport.

*min-height: 100%*. It is hard to align something to the bottom of the parent box in CSS 2.1, since boxes are either stacked horizontally left-to-right or vertically top-to-bottom. Setting `min-height` can ensure that a div that is normally positioned (e.g. that still reacts to normal flow content changes, unlike, say, an absolutely positioned element) is flushed to the bottom of the page.

*Combining flex-grow: 0 and flex-grow: 1*. Flexbox provides a powerful toolkit for controlling how elements are sized. Philip Walton's [Solved by Flexbox](http://philipwalton.github.io/solved-by-flexbox/) covers several additional layouts, but one particular technique I'd like to highlight is using a combination of `flex-grow: 0` and `flex-grow: 1` to produce a bottom or top aligned box, such as a footer or a header. The trick is simple: place the main content inside a `flex-grow: 1` flex item, and place the footer or header in a `flex-grow: 0` flex item. Assuming the flex parent is sized as a percentage of its parent, the main content container will take up all the space that is left over, pushing the footer to the bottom or leaving the header at the top.

*Sizing with contraints*. You can make use of the fact that you can fill in a missing value through the constraint-based sizing algorithm for `position: absolute` elements; this also works for `display: block` but only for width.

If you leave the `width` (and/or `height` for absolutely positioned elements) property to `auto`, but set the values for `margin` explicitly, then the absolutely positioned block will be sized such that it takes up all of the available space except for the space left over for margins.

## CSS layout tricks and techniques used for positioning

Positioning is at the heart of layout: perhaps the most important task is to place elements in the correct relative positions across all screen sizes. The techniques in this section allow you to accomplish that.

- Relative + absolute positioning
- Negative margins
- Transforms
- `margin: auto`
- Positioning with constraints

*Relative + absolute positioning*. `position: absolute` is powerful because you can align elements at an offset from the top, bottom, left or right sides of their parent box. However, in most cases, you don't actually want to  position a div relative to the viewport - you want it to be positioned relative to particular parent.

You can use a combination of `position: relative` and `position: absolute` to accomplish this. Set the parent to `position: relative`, and then use `position: absolute` for the child element.

Setting `position: relative` does not affect the positioning of elements in normal flow unless you add offsets, but does cause those elements to be considered to be positioned. As you may remember, absolutely positioned elements are positioned relative to their first positioned ancestor in the HTML markup, so this in effect creates a new top / bottom / left / right zero point for the absolutely positioned box.

*Negative margins*. Margins in CSS can be negative; typically this feature is not very useful because it is hard to use correctly when the elements in question have a size that is not fixed. However, it can be useful for doing things that would otherwise be difficult. For example, if you actually want an element to overflow - such as the image carousel navigation buttons - setting a fixed negative margin can be used to intentionally cause overflow. Another prominent use case is for centering in old versions of IE, as you will see later in this chapter.

*Transforms*. CSS 3 introduces a `transform: translate()` method which allows elements to be positioned using units that are relative to their own width and height. This can be a viable alternative to using negative margins. While I haven't discussed it here, it worth learning a bit about `transform: translate()`: specifically, it allows for translations to be expressed *as a percentage of the current box* - rather than as a percentage of the parent box as is typical in CSS. For example, `transform: translateX(-50%)` will move the current box to the left by half of it's width - something that would be impossible to do with negative margins for boxes that do not have a fixed, predetermined width.

*margin: auto*. Knowing the two cases where setting `margin: auto` works is useful, since this allows you to make use of the builtin layouting algorithms for centering. Do you remember what the two cases are where `margin: auto` causes centering and what their prerequisites are?

```spoiler
- `margin-left: auto` and `margin-right: auto` on a block-level element causes it be horizontally centered within a block formatting context. You need to set the `width` of the element for this to work.
- `margin: auto` on a `position: absolute` box will center it horizontally and vertically. You need to set both `width` and `height` as well as set all the offsets (`top`, `left`, `bottom`, `right`) to `0` for this to work.
```

*Positioning with constraints*. There are many interesting things that you can do with `position: absolute` elements as well as the `width` of `display: block` elements. For absolutely positioned elements, it is possible to trigger a contraint-based size calculation in both the horizontal and vertical axes; for `display: block` elements this only works for horizontal sizing.

For example, let's say you want to position a box in on the left or right side of a parent box while keeping it centered vertically. This could, for example, be the left and right navigation buttons on a image carousel. To accomplish this, you could set the parent to `position: relative`, and then use something like this:

```snippet
<div class="parent blue">
  <div class="previous green">prev</div>
  <div class="next red">next</div>
</div>
---
.parent {
  position: absolute;
  width: 80%;
  height: 80%;
  margin: 0 40px;
}
.previous, .next {
  position: absolute;
  width: 30px;
  height: 20px;
  top: 0;
  bottom: 0;
  margin: auto;
}
.previous {
  left: 0;
  margin-left: -15px;
}
.next {
  right: 0;
  margin-right: -15px;
}
---
```

On the horizontal axis, `top: 0`, `bottom: 0`, `margin-top: auto`, `margin-bottom: auto` combine to trigger centering (as described in the box model chapter). On the vertical axis, for the `.previous` div, `left: 0`, `right: auto`, `margin-right: auto` and `margin-right: -15px` (or `auto`) cause the box to be positioned at the left edge of the parent. The `-15px` negative margin (half the width) places the box neatly on top of the box. The same rules apply to the `.next` div (using `right: 0` instead).

## Float-based grids: how CSS grid frameworks work

Grid layout frameworks are a versatile tool for modern layout. They allow you to split any content area into a set of columns while allowing the layout to adapt to mobile viewport sizes.

Rather than using floats to position elements to the left or right of a single column, grid frameworks use multiple floats that are sized appropriately to subdivide a space into columns.

Columns based on floats have many good properties:

- they work as expected for left and right aligned content, that is, columns align with each other and right-aligned columns are aligned to the right side
- using a fixed set of percentage widths, any available space can be divided into subcolumns

Grid frameworks like Bootstrap typically use a couple of key properties and techniques. First, setting `box-sizing: border-box` makes accounting for padding much easier.

Next, grid frameworks use four techniques to achieve their behavior:

*Floats* The columns themselves are simply `float: left` divs. Floats can be used to position boxes to the left and right edges of their container box. For grid frameworks, they are useful since floats are always stacked on the left side and can be set to have to occupy a particular percentage of the parent width.

*Percentage-based width*. The grid columns have a `width` value defined as a percentage of the parent box. The framework ensures that the widths add up to `100%`, taking into account issues that can arise with rounding. This means that the columns will always fit onto a single row of in the grid framework and take up some divisor of the total width.

For example, in a 12-column layout, a 1-column float will have `1/12` of the available width (as a percentage) assigned to it. Placing a 4-column float with a 8-column float allows for a 33%:66% split of the available space.

*Relative positioning*. The grid columns typically have `position: relative` as a default to make them act as the reference point for any absolutely positioned content.

*Grid row clearing*. In order to contain and clear floats, grid rows either establish a new formatting context, or alternatively use a clearfix.

*Clearfix*. Do you remember what a clearfix is, and why the clearfix technique is necessary?

```spoiler
The clearfix is a small piece of CSS that is used by many developers who work with floats. Over the years, there have been several different versions of the clearfix - the modern versions are less terrible since they contain fewer old, IE-specific fixes.

A clearfix combines several desirable properties into one class:

- it prevents the floats within the clearfixed parent element from affecting line boxes in other elements that follow the clearfixed element
- it causes the floats within the clearfixed parent element to be taken into account when calculating that element's height
```

Can you describe one method for clearfix? If not, make sure you [review the section on clearfix in chapter 1](1-positioning.html#the-clearfix).

*Creating formatting contexts*. Creating a new formatting context can be a powerful way to control how floats interact with the rest of the page. Do you remember what a formatting context does?

```spoiler
A new formatting context:

- contains floats: floats only interact with elements in the same formatting context
- interacts with floats as a unit: that is, a block that establishes a formatting context is placed either adjacent to floating boxes, or cleared below them if it does not fit; the floats outside the formatting context cannot affect the content of the box that establishes a new formatting context
- prevents margins from collapsing between the box establishing a formatting context and it's parent
```

Can you describe one method for establishing a new formatting context? If not, review [this page on formatting context in MDN](https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Block_formatting_context), and consider taking another look at [chapter 1](1-positioning.html).

Let's create our own rudimentary grid framework to demonstrate how these techniques work together. The example below illustrates:

```snippet
<div class="row">
  <div class="column-4 blue">4-col</div>
  <div class="column-8 green">8-col</div>
</div>
<div class="row">
  <div class="column-4 blue">4-col</div>
  <div class="column-4 green">4-col</div>
  <div class="column-4 orange">4-col</div>
</div>
---
* { box-sizing: border-box; }
.row:after {
  content: "";
  display: table;
  clear: both;
}
.column-4, .column-8 {
  float: left;
  position: relative;
}
.column-4 {
  width: 33.3333%;
}
.column-8 {
  width: 66.6667%;
}
---
```

In order to make this adaptive to different sizes, the rows can have defined transition points where they switch to a different size using media queries. For small screen sizes, you'd want to change the columns to a more basic sequential `display: block` layout with `float: none`.

Of course, I would recommend using a more battle-tested grid framework, but this basic functionality covers the core of what a grid framework does. It might be informative to take a look at how a framework like [Bootstrap](http://getbootstrap.com/) implements grids for more details.

## Techniques for horizontal and vertical centering in CSS

Horizontal and vertical centering in CSS is somewhat complicated. There are many different techniques which have different requirements and tradeoffs. Take a look at shshaw's [codepen resource on centering](http://codepen.io/shshaw/full/gEiDt) for additional examples (although his explanation of why his preferred technique works is overly complicated, since `position: absolute` boxes are simply [sized in one step using the constraint-based algorithm](2-box-model.html#absolutely-positioned-non-replaced-elements) depending on on whether offsets, dimensions and margins are defined; there is no five step process here).

In this section, I will demonstrate techniques for horizontal and vertical centering and ask you to think about how they work and what their benefits and disadvantages are.

I'll start by covering three techniques that allow you to center items on either the horizontal or vertical axis, but not both.

*Horizontally centering block-level elements in normal flow*. You can trigger horizontal centering on block-level elements like this:

```snippet
<div class="blue">
  <div class="block-center green">Centered</div>
</div>
---
.block-center {
  display: block;
  width: 30px;
  margin-left: auto;
  margin-right: auto;
}
---
```

Can you name a potential disadvantage to this approach?

```spoiler
You need to specify the width of the block explicitly for the centering to take place. For example, in the example above, the text overflows a little since I didn't get the width exactly correct.
```

*Horizontally centering inline-level elements within line boxes*. The `text-align` property allows inline-level elements to be centered horizontally.

```snippet
<div class="text-align-center blue">
  <span class="green">Centered</span>
</div>
---
.text-align-center {
  text-align: center;
}
---
```

What are some potential caveats to this approach?

```spoiler
Long lines of text will wrap onto multiple line boxes in an inline formatting context, and centering is only applied after the lines have been broken up. This is the desired behavior for text, but if you are centering non-text items you may see undesired behavior when the containing element is very small and items are broken up onto multiple line boxes.
```

*Vertically centering inline-block elements* The `vertical-align` property applies to inline-level elements and allows you to control the vertical alignment within the inline formatting context.

```snippet
<div class="valign-center blue">
  <span class="green">Centered</span>
</div>
---
.valign-center {
  vertical-align: middle;
  height: 100px;
}
---
```

Why does setting `vertical-align: middle` not cause the single inline-level element to be vertically centered (as shown above)?

```spoiler
Inline-level content is first split onto line boxes, which are positioned simply starting from the top of the container that establishes the formatting context.

`vertical-align: middle` only affects the relative alignment of inline-level blocks within the same line box. The height of the line box is determined by its contents. Since there is only one item, the height of the line box and the height of the item match exactly. The end result is that the line box is positioned at the top of the parent container.

In flexbox, you can separately control the alignment of flex lines (which are conceptually very similar to line boxes); but for inline formatting contexts you can only control the alignment of the items and not the alignment of lines.
```

Can you think of two ways to solve the problem mentioned in the answer above?

```spoiler
Here are two ways to make the example above work:

1. explicitly set `line-height` to an absolute value in pixels
2. use a small inline-block pseudo-element to force the current line box to expand to 100% of the parent height

For solution 1, you cannot set `line-height` to `100%`, because line height is relative to parent font height, not parent container height.

For solution 2, you need to use a inline-block because normal inline-level boxes do not have a `height` property and hence cannot reference the parent height. A pseudo-element is preferable to a real element because it requires fewer changes in markup.
```

## Horizontal and vertical centering

The only problem with the techniques above - which rely on normal flow - is that they cannot be easily extended to also enable vertical centering.

In this section, I'll discuss a couple of techniques that allow you to achieve both vertical and horizontal centering:

- `position: absolute` constraint based centering (IE8+)
- `position: absolute` negative margin based centering (all browsers)
- flexbox centering (IE10+)

These cover the gamut of techniques that work on all browsers--even on IE.shshaw's [codepen resource on centering](http://codepen.io/shshaw/full/gEiDt) covers several additional techniques.

*position: absolute constraint based centering*: First, a technique that works on all modern browsers (IE8+), and one that is probably a reasonable default approach unless you need to support ancient IE.

```snippet
<div class="center-container blue">
  <div class="dialog absolute-center green">Centered</div>
</div>
---
* { box-sizing: border-box; }
.center-container {
  position: relative;
  height: 100px;
  width: 200px;
}
.dialog {
  height: 40%;
  width: 50%;
}
.absolute-center {
  margin: auto;
  position: absolute;
  top: 0; left: 0; bottom: 0; right: 0;
}
---
```

How does the absolute centering technique work?

```spoiler
`position: relative` on the parent container causes it to be considered to be explicitly positioned, but since no offsets are specified, it is positioned just like it would be in normal flow.

Setting `position: absolute` on the dialog causes it to be taken out of normal flow and positioned absolutely.

Normally, in the absolute positioning scheme, `margin: auto` is interpreted as `0`. However, when the content dimensions and the offsets are defined, `margin: auto` uses the constraint-based approach to allocate the remaining space to the margins (with the added constraint that the margins have the same value), causing the block to be centered. This is done for both the horizontal and vertical margins.
```

What are some potential disadvantages to this approach?

```spoiler
You need to specify both the width and the height in order to center both vertically and horizontally. You may be able to work around those issues using max-width/min-width/max-height/min-height and using percentage-based dimensions. Also, this only works on IE8 and up.
```

If you wanted to align the layer to one of the corners (e.g. top, left, bottom, right), how would you change the markup?

```spoiler
Setting one of the offsets to `auto` will cause that value to be calculated based on the box model constraints.
```

*position: absolute negative margin based centering*. The only good thing about the negative margins centering technique is that it works on ancient versions of IE.

```snippet
<div class="center-container blue">
  <div class="absolute-center-negative green">Centered</div>
</div>
---
* { box-sizing: border-box; }
.center-container {
  position: relative;
  height: 100px;
  width: 200px;
}
.absolute-center-negative {
  position: absolute;
  top: 50%; left: 50%;
  width: 100px;
  margin-left: -50px; /* (width + padding)/2 */
  height: 50px;
  margin-top: -25px; /* (height + padding)/2 */
}
---
```

How does the negative margins technique work?

```spoiler
`position: relative` on the parent container causes it to be considered to be explicitly positioned, but since no offsets are specified, it is positioned just like it would be in normal flow.

Setting `position: absolute` on the dialog causes it to be taken out of normal flow and positioned absolutely.

Setting `top: 50%` and `left: 50%` causes the absolutely positioned box to be offset 50% of the containing block's height and width (respectively).

This would merely place the top left corner of the dialog at the center. To move the center of the dialog box to the center of the parent container, negative margins which are half the width/height of the dialog are used.
```

What are some potential disadvantages to this approach?

```spoiler
You need to specify both the width and the height in order to center both vertically and horizontally.

Adjusting the negative margins manually can be painful. However, this is the only `position: absolute` based technique that works in IE6.
```

*flexbox based centering*: Flexbox based centering is the least surpising way to center items; the properties work as described.

```snippet
<div class="flexbox-center blue">
  <div class="green">Centered</div>
</div>
---
.flexbox-center {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100px;
  width: 200px;
}
---
```

What are some things to keep in mind when using flexbox?

```spoiler
First, flexbox is not supported on every browser; and on some older versions it may still require browser-specific prefixes (e.g. `display: -webkit-flex;`, `display: -ms-flexbox`).

Second, the flexbox centering is still line-based. You may want to set `flex-wrap: nowrap` to avoid issues if you have multiple centered items.
```

## Box rendering and stacking context

Finally, to test your knowledge of stacking contexts, I'll ask you to solve this puzzle posed on [Philip Walton's blog](http://philipwalton.com/articles/what-no-one-told-you-about-z-index/). Given the markup below:

```snippet
<div>
  <div class="red">Red</div>
</div>
<div>
  <div class="green">Green</div>
</div>
<div>
  <div class="blue">Blue</div>
</div>
---
.red, .green, .blue {
  position: absolute;
  width: 200px;
  height: 50px;
}
.red {
  z-index: 1;
}
.green {
  top: 20px;
  left: 20px;
}
.blue {
  top: 40px;
  left: 40px;
}
---
```

Change the CSS to show the red div behind the green and blue divs. You may NOT alter:

1. the HTML,
2. the z-index property of any element or
3. the position property of any element

Can you figure out a way to solve this, based on what you know about stacking contexts?

```spoiler
Force the divs to create new stacking contexts.

`z-index` values only affect relative stacking order within a single stacking context. If the spans are in different stacking contexts, and the z-index order is not specified, the divs (and spans within their stacking contexts) are rendered in markup order from back to front, so that red is behind green and green is behind blue.

You can do this by adding one of several properties that trigger a new stacking context, such as `div { opacity: 0.99; }` or `div {transform: translateX(0); }`.
```

## Thanks!

Thank you for reading this far!

If you liked the book, follow me on [Github](https://github.com/mixu/) (or [Twitter](http://twitter.com/mikitotakada)). I love seeing that I've had some kind of positive impact. And if you end up writing about CSS in a blog post or elsewhere, feel free to link back - every link helps :).

If you notice that a layout-related technique that you would like to see covered is missing from the book, feel free to [file an issue on Github](https://github.com/mixu/cssbook/issues). It may take me a while to get back to writing a second edition, but in the meanwhile having someone mention additional techniques in the form of an issue can be helpful for other readers of the book and I will make use the issues to improve the book further the next time I am working on it.

Similarly, if you have experienced an edge case, bug or interaction between different CSS properties that you feel is worth knowing about, feel free to [file an issue on Github](https://github.com/mixu/cssbook/issues). Many of the examples in the book come from my own work and having additional real-world issues listed will help other readers and will let me find more interesting topics to cover in a future edition. There are many practical pitfalls with CSS, and while I can teach you how the spec says things should work, there is no central repository for the problems that real browsers - sometimes even working as the spec intended - can cause in the real world.

Also, check out the next chapter - it contains an index to the topics covered in here, which can be helpful when you need to brush up on a specific property or concept.

I've also written about a bunch of other topics such as distributed systems and Node.js; you can find my long form writing at [book.mixu.net](http://book.mixu.net).

