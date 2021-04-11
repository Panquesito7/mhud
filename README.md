# MHud
A wrapper for more easily managing Minetest HUDs

# API
You can add this mod as a dependency in your mod.conf, or you can copy the `mhud.lua` file into your mod and use it that way

## Mod-Specific Functions

* `mhud.init()`
  Returns a hud wrapper you can use in your mod

## Hud Wrapper Functions

* `wrapper:add(<player>, [hud name], <def>)` -> `hud id`
  * *player*: ObjectRef or PlayerName
  * *hud name*: Name of hud. Useful if you plan on changing the hud later
  * *def*: [Hud Definition]

* `wrapper:[get | exists](<player>, <name>)` -> `{id = hud id, def = [Hud Definition]}` or `nil` if nonexistent
  * *player*: ObjectRef or PlayerName
  * *name*: Name (or id!) of the hud you want to get

* `wrapper:change(<player>, <name>, <def>)`
  * *player*: ObjectRef or PlayerName
  * *name*: Name (or id!) of the hud you want to change
  * *def*: [Hud Definition]

* `wrapper:[remove|clear](<player>, [name])`
  * *player*: ObjectRef or PlayerName
  * *name*: Name (or id!) of the hud you want to remove. Leave out to remove all player's huds

## [Hud Definition]
MHud definitions are pretty much exactly the same as Minetest's. With some exceptions:

### **Element Aliases**
### text
  * `color` -> `number`
  * `text_scale` -> `def.size {x = def.text_scale}`
### image
  * `texture` -> `text`
  * `image_scale` -> `def.size {x = def.image_scale}`
### statbar
  * `texture` -> `text`
  * `textures {t1, t2}` -> `text`, `text2`
  * `length` -> `number`
  * `lengths {l1, l2}` -> `number`, `item`
  * `force_image_size` -> `size`
### inventory
  * `listname` -> `text`
  * `size` -> `number`
  * `selected` -> `item`
### waypoint
  * `waypoint_text` -> `name`
  * `suffix` -> `text`
  * `color` -> `number`
### image_waypoint
  * `texture` -> `text`
  * `image_scale` -> `def.size {x = def.image_scale}`

### **Misc**

* for `alignment` and `direction` you can use up/left/right/down/center instead of the numbers used by the Minetest API
