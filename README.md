# Glitch Community Projects

Discover new reasons to code, remix cool and helpful projects made with Glitch.

Philosophically, a little bit `Youtube`, some `Spotify`, with a sprinkle of `app store`.

Getting Started
-----------------

[Contribution Guidelines and Process](https://docs.google.com/document/d/11xNX1SnAfnhUJZcE6jx_ic4QQUGtThv1CpvBprtB4Wo/edit)

Architecture: 

- the app starts at `server.coffee`
- `client.coffee` is compiled and served as /client.js
- view templates start at `templates/hello.jadelet`
- stylus files like `public/style.styl` is compiled and served directly as `public/style.css`
- Files in `public/` are served directly
- drag in `assets`, like images or music, to add them to your project

application models -> presenter -> DOM

```
  ___     ___      ___
 {o,o}   {o.o}    {o,o}
 |)__)   |)_(|    (__(|
--"-"-----"-"------"-"--
O RLY?  YA RLY   NO WAI!
```

Why is this in [Jadelet](https://jadelet.com/)?
-----------------------
- The Glitch editor is also written in jadelet, so it reduces switching cost
- A nice Models, Presenters and Templates architecture
- Unit testable (eventually!)
- Can render views based on cached localstorage values, then update them with API based values
