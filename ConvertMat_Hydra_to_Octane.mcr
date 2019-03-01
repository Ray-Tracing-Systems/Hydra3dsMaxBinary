/*
Created:  2018.12
Autor: Ray Tracing Systems.
Based on Arch&Design AO/RC Option and conversion tool. PF Breton, Zap Andersson).
Hydra render convert materials to Octane.
*/

global ConvertMat
try DestroyDialog ConvertMat catch()

(--start ms

local i
local newmtl

fn isTrue theValue =
(
    if classof theValue == BooleanClass then
        theValue
    else     if superclassof theValue == Number     then
        theValue != 0.0
    else     
        false    
)

--------------------------------------------------------------
---  Convert Material Function
---------------------------------------------------------------
fn convert_Hydra_to_Octane mtl=
    (	
        -- default to no change
        newmtl = mtl
        
        case classof mtl of
        (            
            hydraMaterial:
            (
                newmtl = Universal_material()
                newmtl.name = mtl.name
				
				-------------------------------------------------------------------------------------------------------
				-- Transparency
                -------------------------------------------------------------------------------------------------------
				
				newmtl.transmission_input_type = 1
                newmtl.transmission_color = color (mtl.mtl_transparency_color.r * mtl.mtl_transparency_mult) (mtl.mtl_transparency_color.g * mtl.mtl_transparency_mult) (mtl.mtl_transparency_color.b * mtl.mtl_transparency_mult)    
				
				if (mtl.mtl_transparency_map != undefined) do
				(					
					newmtl.transmission_input_type = 2
					newmtl.transmission_tex = RGB_image ()					
					newmtl.transmission_tex.filename_bitmaptex = mtl.mtl_transparency_map		

					-- 2D transformation
					if (classof mtl.mtl_transparency_map == Bitmaptexture) do
					(
						newmtl.transmission_tex.transform.rotation = -mtl.mtl_transparency_map.coords.W_angle					
						scaleArray = #(1 / mtl.mtl_transparency_map.coords.U_Tiling, 1 / mtl.mtl_transparency_map.coords.V_Tiling)
						newmtl.transmission_tex.transform.scale = scaleArray 
						transArray = #(mtl.mtl_transparency_map.coords.U_Offset, mtl.mtl_transparency_map.coords.V_Offset)
						newmtl.transmission_tex.transform.translation = transArray 
					)
					
					if (mtl.mtl_transparency_mult_on == on) then
					(
						newmtl.transmission_tex.power_input_type = 1
						newmtl.transmission_tex.power_color = newmtl.transmission_color
					)
					else
						newmtl.transmission_tex.power_value = mtl.mtl_transparency_mult
				)
				
-- 				Not support Octane:
				-- Glossy transparency. (see Glossiness reflectivity)
 				-- Fog. 
				-- Thin (no refract).
				

				-------------------------------------------------------------------------------------------------------
				-- Diffuse                
				-------------------------------------------------------------------------------------------------------
				
				transMult = 1 - (newmtl.transmission_color.r + newmtl.transmission_color.g + newmtl.transmission_color.b) / 3
				if(transMult < 0) do transMult = 0

                newmtl.albedo_color = color (mtl.mtl_diffuse_color.r * mtl.mtl_diffuse_mult * transMult) (mtl.mtl_diffuse_color.g * mtl.mtl_diffuse_mult * transMult) (mtl.mtl_diffuse_color.b * mtl.mtl_diffuse_mult * transMult)    
				
				if (mtl.mtl_diffuse_map != undefined) do
				(					
					newmtl.albedo_input_type = 2
					newmtl.albedo_tex = RGB_image ()					
					newmtl.albedo_tex.filename_bitmaptex = mtl.mtl_diffuse_map		
                    
					-- 2D transformation
					if (classof mtl.mtl_diffuse_map == Bitmaptexture) do
					(
						newmtl.albedo_tex.transform.rotation = -mtl.mtl_diffuse_map.coords.W_angle					
						scaleArray = #(1 / mtl.mtl_diffuse_map.coords.U_Tiling, 1 / mtl.mtl_diffuse_map.coords.V_Tiling)
						newmtl.albedo_tex.transform.scale = scaleArray 
						transArray = #(mtl.mtl_diffuse_map.coords.U_Offset, mtl.mtl_diffuse_map.coords.V_Offset)
						newmtl.albedo_tex.transform.translation = transArray 					
					)
					
					if (mtl.mtl_diffuse_mult_on == on) then
					(
						newmtl.albedo_tex.power_input_type = 1
						newmtl.albedo_tex.power_color = color (newmtl.albedo_color.r * transMult)(newmtl.albedo_color.g * transMult)(newmtl.albedo_color.b * transMult)
					)
					else
						newmtl.albedo_tex.power_value = mtl.mtl_diffuse_mult * transMult
				)
                          
 				-------------------------------------------------------------------------------------------------------				
 				-- Reflectivity
				-------------------------------------------------------------------------------------------------------
				
				newmtl.specular_input_type = 1
			    newmtl.specular_color = color (mtl.mtl_reflect_color.r * mtl.mtl_reflect_mult) (mtl.mtl_reflect_color.g * mtl.mtl_reflect_mult) (mtl.mtl_reflect_color.b * mtl.mtl_reflect_mult)    
				
				if (mtl.mtl_reflect_map != undefined) do
				(					
					newmtl.specular_input_type = 2
					newmtl.specular_tex = RGB_image ()					
					newmtl.specular_tex.filename_bitmaptex = mtl.mtl_reflect_map		
					
					-- 2D transformation
					if (classof mtl.mtl_reflect_map == Bitmaptexture) do
					(
						newmtl.specular_tex.transform.rotation = -mtl.mtl_reflect_map.coords.W_angle					
						scaleArray = #(1 / mtl.mtl_reflect_map.coords.U_Tiling, 1 / mtl.mtl_reflect_map.coords.V_Tiling)
						newmtl.specular_tex.transform.scale = scaleArray 
						transArray = #(mtl.mtl_reflect_map.coords.U_Offset, mtl.mtl_reflect_map.coords.V_Offset)
						newmtl.specular_tex.transform.translation = transArray 
					)

					if (mtl.mtl_reflect_mult_on == on) then
					(
						newmtl.specular_tex.power_input_type = 1
						newmtl.specular_tex.power_color = newmtl.specular_color
					)
					else
						newmtl.specular_tex.power_value = mtl.mtl_reflect_mult
				)
 				    
 				-- Glossiness reflectivity		
				
				roughness = 1 - mtl.mtl_refl_gloss 
				if (roughness < 0) then roughness = 0
				
				newmtl.roughness_value = roughness 				
				
				if (mtl.mtl_refl_gl_map != undefined) do
				(					
					newmtl.roughness_input_type = 2
					newmtl.roughness_tex = RGB_image ()					
					newmtl.roughness_tex.filename_bitmaptex = mtl.mtl_refl_gl_map		
					newmtl.roughness_tex.power_value = mtl.mtl_refl_gloss 
											
					-- 2D transformation
					if (classof mtl.mtl_refl_gl_map == Bitmaptexture) do
					(
						newmtl.roughness_tex.transform.rotation = -mtl.mtl_refl_gl_map.coords.W_angle					
						scaleArray = #(1 / mtl.mtl_refl_gl_map.coords.U_Tiling, 1 / mtl.mtl_refl_gl_map.coords.V_Tiling)
						newmtl.roughness_tex.transform.scale = scaleArray 
						transArray = #(mtl.mtl_refl_gl_map.coords.U_Offset, mtl.mtl_refl_gl_map.coords.V_Offset)
						newmtl.roughness_tex.transform.translation = transArray 
					)
					
					newmtl.roughness_tex = Invert_texture texture_tex:(newmtl.roughness_tex)
					newmtl.roughness_tex.texture_input_type = 2
				)
				
 				-- Fresnel				
				
				if (mtl.mtl_refl_fresnel_on == off) then
					newmtl.index4 = 100
				else
				(
					if (mtl.mtl_transparency_mult > 0) then
						newmtl.index4 = (mtl.mtl_reflect_ior + mtl.mtl_ior) / 2
					else
						newmtl.index4 = mtl.mtl_reflect_ior
				)

				-------------------------------------------------------------------------------------------------------
				-- Opacity
				-------------------------------------------------------------------------------------------------------

				if (mtl.mtl_opacity_map != undefined) do
				(
					newmtl.opacity_input_type = 2
					newmtl.opacity_tex = RGB_image ()				
					newmtl.opacity_tex.filename_bitmaptex = mtl.mtl_opacity_map	

					-- 2D transformation
					if (classof mtl.mtl_opacity_map == Bitmaptexture) do
					(
						newmtl.opacity_tex.transform.rotation = -mtl.mtl_opacity_map.coords.W_angle					
						scaleArray = #(1 / mtl.mtl_opacity_map.coords.U_Tiling, 1 / mtl.mtl_opacity_map.coords.V_Tiling)
						newmtl.opacity_tex.transform.scale = scaleArray 
						transArray = #(mtl.mtl_opacity_map.coords.U_Offset, mtl.mtl_opacity_map.coords.V_Offset)
						newmtl.opacity_tex.transform.translation = transArray 			
					)						
				)
				
				-------------------------------------------------------------------------------------------------------
				-- Translucency (Not support Octane)
				-------------------------------------------------------------------------------------------------------

				-------------------------------------------------------------------------------------------------------
				-- Emission
				-------------------------------------------------------------------------------------------------------
				
				if (mtl.mtl_emission_mult > 0 or mtl.mtl_emission_map != undefined) do
				(
					if (mtl.mtl_emission_color != color(0)(0)(0)) do
					(
						newmtl.emission = Texture_emission ()				
						newmtl.emission.efficiency_or_texture_color = mtl.mtl_emission_color
						newmtl.emission.surfaceBrightness = true
						newmtl.emission.power = mtl.mtl_emission_mult	
					)
						
					if (mtl.mtl_emission_map != undefined) do
					(
						newmtl.emission = Texture_emission ()	
						newmtl.emission.surfaceBrightness = true
						newmtl.emission.power = mtl.mtl_emission_mult	
						newmtl.emission.efficiency_or_texture_input_type = 2
						newmtl.emission.efficiency_or_texture_tex = RGB_image ()
						newmtl.emission.efficiency_or_texture_tex.filename_bitmaptex = mtl.mtl_emission_map
						
						-- 2D transformation
						if (classof mtl.mtl_emission_map == Bitmaptexture) do
						(
							newmtl.emission.transform.rotation = -mtl.mtl_emission_map.coords.W_angle					
							scaleArray = #(1 / mtl.mtl_emission_map.coords.U_Tiling, 1 / mtl.mtl_emission_map.coords.V_Tiling)
							newmtl.emission.transform.scale = scaleArray 
							transArray = #(mtl.mtl_emission_map.coords.U_Offset, mtl.mtl_emission_map.coords.V_Offset)
							newmtl.emission.transform.translation = transArray 	
						)
						
						if (mtl.mtl_emission_mult_on == on) do
						(
							newmtl.emission.efficiency_or_texture_tex.power_input_type = 1
							newmtl.emission.efficiency_or_texture_tex.power_color = mtl.mtl_emission_color
						)
					)
				)
				
-- 				Cast GI (Not support Octane)
-- 				newmtl.??? = mtl.mtl_emission_gi				
				
				-------------------------------------------------------------------------------------------------------
				-- Relief
				-------------------------------------------------------------------------------------------------------
				
				if (mtl.mtl_normal_map != undefined) do
				(					
					if (classof mtl.mtl_normal_map != Normal_Bump) then
					(
						newmtl.bump_input_type = 2
						newmtl.bump_tex = RGB_image ()
						newmtl.bump_tex.filename_bitmaptex = mtl.mtl_normal_map
						newmtl.bump_tex.power_value = mtl.mtl_bump_amount
						
						-- 2D transformation
						if (classof mtl.mtl_normal_map == Bitmaptexture) do
						(
							newmtl.bump_tex.transform.rotation = -mtl.mtl_normal_map.coords.W_angle					
							scaleArray = #(1 / mtl.mtl_normal_map.coords.U_Tiling, 1 / mtl.mtl_normal_map.coords.V_Tiling)
							newmtl.bump_tex.transform.scale = scaleArray 
							transArray = #(mtl.mtl_normal_map.coords.U_Offset, mtl.mtl_normal_map.coords.V_Offset)
							newmtl.bump_tex.transform.translation = transArray 	
						)
					)
					else 
					(
						newmtl.normal_input_type = 2
						newmtl.normal_tex = RGB_image ()
						newmtl.normal_tex.filename_bitmaptex = mtl.mtl_normal_map
						newmtl.normal_tex.power_value = mtl.mtl_bump_amount

						-- 2D transformation
						if (classof mtl.mtl_normal_map.normal_map == Bitmaptexture) do
						(
							newmtl.normal_tex.transform.rotation = -mtl.mtl_normal_map.normal_map.coords.W_angle					
							scaleArray = #(1 / mtl.mtl_normal_map.normal_map.coords.U_Tiling, 1 / mtl.mtl_normal_map.normal_map.coords.V_Tiling)
							newmtl.normal_tex.transform.scale = scaleArray 
							transArray = #(mtl.mtl_normal_map.normal_map.coords.U_Offset, mtl.mtl_normal_map.normal_map.coords.V_Offset)
							newmtl.normal_tex.transform.translation = transArray 	
						)
					)						
				)				
                
            )--end hydraMaterial			

            MultiMaterial: 
			(
				-- function call itself to harvest the materials inside the MultiMaterial
				local u
				orgMtl = mtl
				
				for u = 1 to mtl.numsubs do 
				(
					convert_Hydra_to_Octane mtl[u] 
					mtl[u] = newmtl
				)					
				
				-- set so parent knows what to set...
				newmtl = mtl					
			)

            Blend: 
			(
				convert_Hydra_to_Octane mtl.map1
				mtl.map1 = newmtl
				convert_Hydra_to_Octane mtl.map2					
				mtl.map2 = newmtl					
				-- set so parent knows what to set...
				newmtl = mtl
			)
        )	 
    ) -- end fn  

----------------------------------------------------------------
--  Set Parameter Function
-----------------------------------------------------------------
    fn setMtlParam mtl param val =
    (	
    
        case classof mtl of
        (
            VRayMtl:
            (	
                SetProperty mtl param val
            )
			
            MultiMaterial: 
			(
				local u
				orgMtl = mtl
				
				for u = 1 to mtl.numsubs do 
				(
					setMtlParam mtl[u] param val
				)				
			)
        )--end case classof
    )--end fn 

rollout ConvertMat "Convert materials tool" width:400 height:324
(
    local mtls = sceneMaterials
    local sel
    
	radiobuttons 'only_medit' "" pos:[66,40] width:267 height:16 labels:#("...in scene", "...in material editor only") columns:2 align:#left
		
	local mtl

	label 'lbl6' "WARNING: OPERATION NOT UNDO!" pos:[112,184] width:176 height:16 align:#left
	

	button 'btnConvert' "... to Octane materials" pos:[88,217] width:220 height:50 align:#left
	GroupBox 'grp1' "Affect materials..." pos:[10,10] width:380 height:70 align:#left
	GroupBox 'grp2' "Convert Hydra materials as posible..." pos:[10,90] width:380 height:230 align:#left
	
        
    --perform changes in the materials

	on only_medit changed sel do
	(
	        mtls = sceneMaterials
	        
	        if sel == 2 do (
	            mtls = meditMaterials
	        )
	)
	on btnConvert pressed do
	(	        
	    with undo on
	    (
	            
			local orgSceneMaterials = ConvertMat.mtls
	        
	        for i = 1 to orgSceneMaterials.count do 
	        (
	            local u
	                    
	            convert_Hydra_to_Octane orgSceneMaterials[i]
	            print ("converted " + orgSceneMaterials[i].name)
	            for u = 1 to objects.count do
	            (
	                if (objects[u].material == orgSceneMaterials[i]) do
	                (
	                    objects[u].material = newmtl
	                )
	            )	                
	        )	            	    
	    )
	)
)
  
createDialog ConvertMat width:400 height:330

)--end scri