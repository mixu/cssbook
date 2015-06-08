home: index.html
next: 1-positioning.html
title: Learn CSS Layout The Pedantic Way
isIndex: true
---

> Bureaucrat Conrad, you are technically correct - the best kind of correct. I hereby promote you to grade 37. - Number 1.0 (Futurama, [S2E15](http://en.wikipedia.org/wiki/How_Hermes_Requisitioned_His_Groove_Back))

> I won't lie to you, Neo. Every single man or woman who has fought an agent has died. But where they have failed, you will succeed.
>
> Why?
>
> I've seen an agent punch through a concrete wall; men have emptied entire clips at them and hit nothing but air; yet, their strength, and their speed, are still based in a world that is built on rules. Because of that, they will never be as strong, or as fast, as *you* can be.
>
> What are you trying to tell me? That I can dodge bullets?
>
> No, Neo. I'm trying to tell you that when you're ready ... you won't have to.
> - Morpheus (The Matrix, 1999)

CSS, like the Matrix, is a system based on rules.

I wrote this set of chapters to describe those rules. It's long-form writing, but not book-length. I don't think I'd want to write a full book about CSS, but writing about CSS layout has been useful. My approach is pedantic:

> *pedantic*: adjective. (2): overly concerned with minute details or formalisms, especially in teaching.

I mean it in a good way, though obviously the word has a negative connotation. Is technically correct the best kind of correct? No, it's not. But for this topic, there are enough resources that aren't technically correct.

You may have heard that there are `inline` and `block` elements in CSS normal flow. But did you know that in CSS, the relative positioning of block and inline elements is not actually determined by the element's `display` property? It's actually determined by the formatting context, which is influenced by the siblings of the element.

You may have used `z-index` to "fix" the relative stacking order of content. But did you know that `z-index` is not absolute across the document, but rather relative to a stacking context?

You may have heard about the box model. But did you know that there are in fact at least five different box models, with subtle differences in how content dimensions and `margin: auto` are treated? You will, if you read this.

This is a set of chapters about CSS layout for people who already know CSS. Which seems like a small market, I admit. I took a look around for good resources for learning CSS layout, but I found that most of them weren't pedantic enough.

CSS layout can be difficult to learn, because websites usually evolve incrementally. This means that you end up learning small tips and tricks here and there, and never learn the underlying layout algorithm.

This set of chapters walks you through every major concept in CSS layout, and includes dozens of applied examples that illustrate the various concepts.

[Chapter 1: Box positioning in CSS](./1-positioning.html) covers how the boxes that HTML elements generate are positioned relative to each other:

- the three main positioning schemes in CSS: normal flow, floats and absolute positioning
- normal flow concepts, such as anonymous box generation, formatting context, line boxes and alignment within line boxes
- float concepts, such as float order, clearfix and float interactions with parent height

[Chapter 2: Box sizing in CSS](./2-box-model.html) discusses the box model, but more importantly how the box model varies across the different positioning schemes in CSS. Concretely, height, width and margins are calculated using completely different mechanisms, and you can only understand these calculations by knowing the positioning scheme and calculation mechanism in use.

[Chapter 3: Additional properties that influence positioning](./3-additional.html) covers additional mechanisms that influence box positioning, such as:

- margin collapsing
- negative margins
- overflow
- max-width, max-height, min-width, min-height
- stacking contexts and the z-index property
- how pseudo elements impact layout
- the CSS3 box-sizing property

[Chapter 4: Flexbox](./4-flexbox.html) discusses the CSS 3 flexbox layout mode.

[Chapter 5: CSS layout - tricks and layout techniques](./5-tricks.html) takes what we have learned and applies it to several practical problems. It also contains small quiz-like questions to test you understanding of layout in contexts such as:

- horizontal and vertical centering
- how CSS grid frameworks work
- multicolumn layout
- common gotchas and layout tricks.

[If you need to lookup a specific concept or property, take a look at the  reference index](./reference.html) which provides an easy way to find the right chapter and section across the set of chapters.
