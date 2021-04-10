local hud = {
	huds = {}
}

local function Obj(player)
	if type(player) == "string" then
		return minetest.get_player_by_name(player)
	else
		return player
	end
end

local function convert_def(def, type)
	if type == "text" then
		def.number = def.number or      def.color
		def.size   = def.size   or {x = def.text_scale}
	elseif type == "image" then
		def.text  = def.text  or      def.texture
		def.scale = def.scale or {x = def.image_scale}
	elseif type == "statbar" then
		if def.textures then
			def.text  = def.textures[1]
			def.text2 = def.textures[2]
		else
			def.text = def.text or def.texture
		end

		if def.lengths then
			def.number = def.lengths[1]
			def.item   = def.lengths[2]
		else
			def.number = def.number or def.length
		end

		def.size = def.size or def.force_image_size
	elseif type == "inventory" then
		def.text   = def.text   or def.listname
		def.number = def.number or def.size
		def.item   = def.item   or def.selected
	elseif type == "waypoint" then
		def.name   = def.name   or def.waypoint_text
		def.text   = def.text   or def.suffix
		def.number = def.number or def.color
	elseif type == "image_waypoint" then
		def.text  = def.text  or      def.texture
		def.scale = def.scale or {x = def.image_scale}
	end

	return def
end

function hud.add(self, player, name, def)
	player = Obj(player)
	local pname = player:get_player_name()

	if not def then
		def, name = name, false
	end

	if not self.huds[pname] then
		self.huds[pname] = {}
	end

	def = convert_def(def, def.hud_elem_type)

	local id = player:hud_add(def)

	if name then
		self.huds[pname][name] = {id = id, def = def}
	else
		self.huds[pname][id] = {id = id, def = def}
	end

	return id
end

function hud.get(self, player, name)
	player = Obj(player)
	local pname = player:get_player_name()

	return assert(self.huds[pname][name], "Attempt to get hud that doesn't exist!")
end

function hud.change(self, player, name, def)
	player = Obj(player)
	local pname = player:get_player_name()

	assert(self.huds[pname][name], "Attempt to change hud that doesn't exist!")

	def = convert_def(def, def.hud_elem_type or self.huds[pname][name].def.hud_elem_type)

	for stat, val in pairs(def) do
		player:hud_change(self.huds[pname][name].id, stat, val)
		self.huds[pname][name].def[stat] = val
	end
end

function hud.remove(self, player, name)
	player = Obj(player)
	local pname = player:get_player_name()

	if name then
		assert(self.huds[pname][name], "Attempt to remove hud that doesn't exist!")

		player:hud_remove(self.huds[pname][name].id)
		self.huds[pname][name] = nil
	elseif self.huds[pname] then
		for _, def in pairs(self.huds[pname]) do
			player:hud_remove(def.id)
		end

		self.huds[pname] = nil
	end
end

hud.clear = hud.remove

minetest.register_on_leaveplayer(function(player)
	hud:remove(player)
end)

return hud
