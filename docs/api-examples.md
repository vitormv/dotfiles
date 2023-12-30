---
outline: deep
aside: true
---

# Start here

A couple of preliminary things to get out of the way:

* Everything is driven by setup.sh. When in doubt, consult that file.
* Everything here is simply a convenience to make life easier setting up a new machine. Since I spent the work figuring this out, I might as well make it available to others.
* All steps are optional though there are some dependencies and assumptions which are noted as they come up.


::: details Click me to view the code
  Download the latest zip file

  Unzip it and go to the unzipped directory in your terminal

  Run `./setup.sh` to see the help.
:::

## 0: Download and check

* Download the latest zip file
* Unzip it and go to the unzipped directory in your terminal
* Run `./setup.sh` to see the help.


# Runtime API Examples

This page demonstrates usage of some of the runtime APIs provided by VitePress.

The main `useData()` API can be used to access site, theme, and page data for the current page. It works in both `.md` and `.vue` files:

```md
<script setup>
import { useData } from 'vitepress'

const { theme, page, frontmatter } = useData()
</script>

## Results

### Theme Data
<pre>{{ theme }}</pre>

### Page Data
<pre>{{ page }}</pre>

### Page Frontmatter
<pre>{{ frontmatter }}</pre>
```

<script setup>
import { useData } from 'vitepress'

const { site, theme, page, frontmatter } = useData()
</script>

## Results

### Theme Data
<pre>{{ theme }}</pre>

### Page Data
<pre>{{ page }}</pre>

### Page Frontmatter
<pre>{{ frontmatter }}</pre>

## More

Check out the documentation for the [full list of runtime APIs](https://vitepress.dev/reference/runtime-api#usedata).
