--[[
  Original Timber mod will be found at: http://forum.minetest.net/viewtopic.php?id=1590

  10/04/2013 - After many problems I rewrite the code do make this effective with more types of plants.

]]--
local nt={}
--nt.limit=2  --Range from the last cut node to search nodes do cut, 1 is good, 2 is optimal to servers with growing trees.

local nt_nodenames={
  "default:jungletree",
  "default:papyrus",
  "default:cactus",
  "default:tree",
  "irontrees:irontree",
  "bamboo:bamboo",
  "bamboo:bamboo_dry",
  "vines:vine",
  "vines:vine_rotten",
  "vines:root",
  "vines:side",
  "rubber:rubber_tree_full",
  "rubber:rubber_tree_empty",
  "technic:rubber_tree_full",
  "technic:rubber_tree_empty",
  "growing_trees:branch",
  "growing_trees:branch_xmzm",
  "growing_trees:branch_xx",
  "growing_trees:branch_zz",
  "growing_trees:branch_xpzp",
  "growing_trees:branch_xmzp",
  "growing_trees:branch_xpzm",
  "growing_trees:trunk",
  "moretrees:beech_trunk",
  "moretrees:apple_tree_trunk",
  "moretrees:oak_trunk",
  "moretrees:sequoia_trunk",
  "moretrees:birch_trunk",
  "moretrees:palm_trunk",
  "moretrees:spruce_trunk",
  "moretrees:pine_trunk",
  "moretrees:willow_trunk",
  "moretrees:rubber_tree_trunk",
  "moretrees:jungletree_trunk",
  "moretrees:fir_trunk",
}

minetest.register_on_dignode(function(pos, node, digger)
  local idx = digger:get_wield_index()
  local inv = digger:get_inventory()
  local stack = inv:get_stack("main", idx):get_name()
  print(stack)
  list_of_axes = {
  "default:axe_stone",
  "default:axe_bronze",
  "default:axe_steel",
  "default:axe_mese",
  "default:axe_stone"
  }
  for _,v in pairs(list_of_axes) do
	if v == stack then
		-- do something
		--if stack == "default:axe_stone" then
			local i=1
			while nt_nodenames[i]~=nil do
				nm = node.name

				if nm==nt_nodenames[i] then
					nt_primary(pos,node,digger,0)
					return false
				end

				i = i + 1
			end
		--end
      break
  end
end
end)


function nt_primary(pos,node,digger,level)
  np={x=pos.x, y=pos.y+1, z=pos.z}
  local level2={}
  nm = node.name

  if level==0 then
    table.insert(level2,{x=pos.x, y=pos.y, z=pos.z})
  end

--  while minetest.env:get_node(np).name==nm do
  npn=minetest.env:get_node(np).name

  while npn==nm or (string.sub(nm,1,14)=="growing_trees:" and string.sub(npn,1,14)=="growing_trees:" and npn ~= "growing_trees:leaves") do
    result = nm
    r=minetest.get_node_drops(nm)

   for _,name in ipairs(r) do
      if name ~= nill then
        result = name
     end
    end

    minetest.env:remove_node(np)
    minetest.env:add_item(np, result)
    table.insert(level2,np)

    np={x=np.x, y=np.y+1, z=np.z}
    npn=minetest.env:get_node(np).name
  end

  for _,p in pairs(level2) do
    nt_secundary(p,node,digger)
  end
end

--Search for nodes close to the dug node and mark to dig.
function nt_secundary(pos, node, digger)
  local np={x=pos.x, y=pos.y, z=pos.z}
  local level1={}

  result = model
  local x_,y_,z_
  local nm = node.name

  for y_=0,2 do
    local v_min=-1 * (y_+1)
    local v_max=y_ +1
    for x_=v_min,v_max do
      for z_=v_min,v_max do
        p={x=np.x+x_, y=np.y+y_, z=np.z+z_}
        p_ref={x=np.x+x_, y=np.y+y_-1, z=np.z+z_}

        p_nm = minetest.env:get_node(p).name
        p_ref_nm = minetest.env:get_node(p_ref).name

        if (p_nm==nm and p_ref_nm ~= nm) or (string.sub(p_nm,1,14)=="growing_trees:" and string.sub(nm,1,14)=="growing_trees:" and p_nm ~= "growing_trees:leaves") then
          table.insert(level1,p_ref)
        end
      end
    end
  end

  for _,p in pairs(level1) do
    nt_primary(p,node,digger,1)
  end
end


-- Apenas para indicar que este módulo foi completamente carregado.
DOM_mb(minetest.get_current_modname(),minetest.get_modpath(minetest.get_current_modname()))
