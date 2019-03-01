/*
Created:  2018.12
Autor: Ray Tracing Systems.
Based on Arch&Design AO/RC Option and conversion tool. PF Breton, Zap Andersson).
Hydra render convert materials to V-Ray.
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
fn convert_Hydra_to_VRay mtl=
    (	
        -- default to no change
        newmtl = mtl
        
        case classof mtl of
        (            
            hydraMaterial:
            (
                newmtl = VRayMtl()
                -- keep the name
                newmtl.name = mtl.name
				
				-------------------------------------------------------------------------------------------------------
				-- Diffuse                
				-------------------------------------------------------------------------------------------------------
				
                newmtl.Diffuse = color (mtl.mtl_diffuse_color.r * mtl.mtl_diffuse_mult) (mtl.mtl_diffuse_color.g * mtl.mtl_diffuse_mult) (mtl.mtl_diffuse_color.b * mtl.mtl_diffuse_mult)    
				
				diffTint = false					
				if (mtl.mtl_diffuse_mult_on == on) then	diffTint = true

				if (mtl.mtl_diffuse_map != undefined) do
				(					
					if (mtl.mtl_diffuse_mult != 1) then
					(	
						newmtl.texmap_diffuse 						  =  output()  
						newmtl.texmap_diffuse.output.rgb_level = mtl.mtl_diffuse_mult						

						if (diffTint) then
						(
							newmtl.texmap_diffuse.MAP1         = RGB_Tint()													
							newmtl.texmap_diffuse.MAP1.red    = color (mtl.mtl_diffuse_color.r) (0) (0)
							newmtl.texmap_diffuse.MAP1.green = color (0) (mtl.mtl_diffuse_color.g) (0)
							newmtl.texmap_diffuse.MAP1.blue   = color (0) (0) (mtl.mtl_diffuse_color.b)									
							newmtl.texmap_diffuse.MAP1.MAP1 = mtl.mtl_diffuse_map  					
						)
						else
							newmtl.texmap_diffuse.MAP1 =  mtl.mtl_diffuse_map  					
					)
					else			
					(				
						if (diffTint) then
						(
							newmtl.texmap_diffuse         = RGB_Tint()													
							newmtl.texmap_diffuse.red    = color (mtl.mtl_diffuse_color.r) (0) (0)
							newmtl.texmap_diffuse.green = color (0) (mtl.mtl_diffuse_color.g) (0)
							newmtl.texmap_diffuse.blue   = color (0) (0) (mtl.mtl_diffuse_color.b)						
							newmtl.texmap_diffuse.MAP1 = mtl.mtl_diffuse_map  					
						)
						else
							newmtl.texmap_diffuse =  mtl.mtl_diffuse_map  					
					)
				)
				
				newmtl.diffuse_roughness = mtl.mtl_roughness_mult 
                         
				-------------------------------------------------------------------------------------------------------				
				-- Reflectivity
				-------------------------------------------------------------------------------------------------------
				
				newmtl.Reflection = color (mtl.mtl_reflect_color.r * mtl.mtl_reflect_mult) (mtl.mtl_reflect_color.g * mtl.mtl_reflect_mult) (mtl.mtl_reflect_color.b * mtl.mtl_reflect_mult)
				
				reflTint = false					
				if (mtl.mtl_reflect_mult_on == on) then	reflTint = true
                				
				if (mtl.mtl_reflect_map != undefined) do
				(					
					if (mtl.mtl_reflect_mult != 1) then
					(	
						newmtl.texmap_reflection                        =  output()  
						newmtl.texmap_reflection.output.rgb_level = mtl.mtl_reflect_mult						

						if (reflTint) then
						(
							newmtl.texmap_reflection.MAP1         = RGB_Tint()													
							newmtl.texmap_reflection.MAP1.red    = color (mtl.mtl_reflect_color.r) (0) (0)
							newmtl.texmap_reflection.MAP1.green = color (0) (mtl.mtl_reflect_color.g) (0)
							newmtl.texmap_reflection.MAP1.blue   = color (0) (0) (mtl.mtl_reflect_color.b)									
							newmtl.texmap_reflection.MAP1.MAP1 = mtl.mtl_reflect_map  					
						)
						else
							newmtl.texmap_reflection.MAP1 =  mtl.mtl_reflect_map  					
					)
					else			
					(				
						if (reflTint) then
						(
							newmtl.texmap_reflection                 = RGB_Tint()													
							newmtl.texmap_reflection.red    = color (mtl.mtl_reflect_color.r) (0) (0)
							newmtl.texmap_reflection.green = color (0) (mtl.mtl_reflect_color.g) (0)
							newmtl.texmap_reflection.blue   = color (0) (0) (mtl.mtl_reflect_color.b)						
							newmtl.texmap_reflection.MAP1         = mtl.mtl_reflect_map  					
						)
						else
							newmtl.texmap_reflection =  mtl.mtl_reflect_map  					
					)
				)
				    
				-- Glossiness reflectivity				
				
				newmtl.reflection_glossiness           = mtl.mtl_refl_gloss
				
				if (mtl.mtl_refl_gl_map != undefined) do
				(					
					if (mtl.mtl_refl_gloss != 1) then
					(	
						newmtl.texmap_reflectionGlossiness                        =  output()  
						newmtl.texmap_reflectionGlossiness.output.rgb_level = mtl.mtl_refl_gloss				
						newmtl.texmap_reflectionGlossiness.MAP1 =  mtl.mtl_refl_gl_map  					
					)
					else			
						newmtl.texmap_reflectionGlossiness =  mtl.mtl_refl_gl_map  					
				)

                
				-- Fresnel				
				
				newmtl.reflection_fresnel = mtl.mtl_refl_fresnel_on				
				newmtl.reflection_ior        = mtl.mtl_reflect_ior

				if (mtl.mtl_reflect_ior == mtl.mtl_ior) then
					newmtl.refraction_ior = mtl.mtl_reflect_ior
				else
					newmtl.reflection_lockIOR = off
				
				
				-- BRDF				
				
				newmtl.brdf_type = 4 -- hard code GGX

				-------------------------------------------------------------------------------------------------------
				-- Transparency
                -------------------------------------------------------------------------------------------------------
				
				newmtl.Refraction = color (mtl.mtl_transparency_color.r * mtl.mtl_transparency_mult) (mtl.mtl_transparency_color.g * mtl.mtl_transparency_mult) (mtl.mtl_transparency_color.b * mtl.mtl_transparency_mult)
				
				refrTint = false					
				if (mtl.mtl_transparency_mult_on == on) then	refrTint = true
                				
				if (mtl.mtl_transparency_map != undefined) do
				(					
					if (mtl.mtl_transparency_mult != 1) then
					(	
						newmtl.texmap_refraction                        =  output()  
						newmtl.texmap_refraction.output.rgb_level = mtl.mtl_transparency_mult						

						if (refrTint) then
						(
							newmtl.texmap_refraction.MAP1         = RGB_Tint()													
							newmtl.texmap_refraction.MAP1.red    = color (mtl.mtl_transparency_color.r) (0) (0)
							newmtl.texmap_refraction.MAP1.green = color (0) (mtl.mtl_transparency_color.g) (0)
							newmtl.texmap_refraction.MAP1.blue   = color (0) (0) (mtl.mtl_transparency_color.b)									
							newmtl.texmap_refraction.MAP1.MAP1 = mtl.mtl_transparency_map  					
						)
						else
							newmtl.texmap_refraction.MAP1 =  mtl.mtl_transparency_map  					
					)
					else			
					(				
						if (refrTint) then
						(
							newmtl.texmap_refraction         = RGB_Tint()													
							newmtl.texmap_refraction.red    = color (mtl.mtl_transparency_color.r) (0) (0)
							newmtl.texmap_refraction.green = color (0) (mtl.mtl_transparency_color.g) (0)
							newmtl.texmap_refraction.blue   = color (0) (0) (mtl.mtl_transparency_color.b)						
							newmtl.texmap_refraction.MAP1 = mtl.mtl_transparency_map  					
						)
						else
							newmtl.texmap_refraction =  mtl.mtl_transparency_map  					
					)
				)
				
				-- Glossy transparency

				newmtl.refraction_glossiness = mtl.mtl_transp_gloss
				
				if (mtl.mtl_transp_gl_map != undefined) do
				(					
					if (mtl.mtl_transp_gloss != 1) then
					(	
						newmtl.texmap_refractionGlossiness                        =  output()  
						newmtl.texmap_refractionGlossiness.output.rgb_level = mtl.mtl_transp_gloss				
						newmtl.texmap_refractionGlossiness.MAP1                =  mtl.mtl_transp_gl_map  					
					)
					else			
						newmtl.texmap_refractionGlossiness = mtl.mtl_transp_gl_map  					
				)
				
				newmtl.refraction_ior = mtl.mtl_ior

				-- Fog			
				
				newmtl.refraction_fogColor = mtl.mtl_fog_color
				newmtl.refraction_fogMult  = mtl.mtl_fog_multiplier / 130
				
				-- Thin (no refract)
				
				if (mtl.mtl_transparency_thin_on == on) do
 					newmtl.option_traceRefraction = off
				
			
				-------------------------------------------------------------------------------------------------------
				-- Opacity
				-------------------------------------------------------------------------------------------------------

				newmtl.texmap_opacity = mtl.mtl_opacity_map		
				
				-------------------------------------------------------------------------------------------------------
				-- Translucency
				-------------------------------------------------------------------------------------------------------
				
				if (mtl.mtl_translucency_mult > 0) then
					newmtl.translucency_on = 3
				
				newmtl.translucency_scatterCoeff = 0.5
				newmtl.translucency_fbCoeff        = 0.5
				
				newmtl.translucency_color = color (mtl.mtl_translucency_color.r * mtl.mtl_translucency_mult) (mtl.mtl_translucency_color.g * mtl.mtl_translucency_mult) (mtl.mtl_translucency_color.b * mtl.mtl_translucency_mult)
				
				translTint = false					
				if (mtl.mtl_translucency_mult_on == on) then	translTint = true
                				
				if (mtl.mtl_translucency_map != undefined) do
				(					
					if (mtl.mtl_translucency_mult != 1) then
					(	
						newmtl.texmap_translucent                        =  output()  
						newmtl.texmap_translucent.output.rgb_level = mtl.mtl_translucency_mult						

						if (translTint) then
						(
							newmtl.texmap_translucent.MAP1         = RGB_Tint()													
							newmtl.texmap_translucent.MAP1.red    = color (mtl.mtl_translucency_color.r) (0) (0)
							newmtl.texmap_translucent.MAP1.green = color (0) (mtl.mtl_translucency_color.g) (0)
							newmtl.texmap_translucent.MAP1.blue   = color (0) (0) (mtl.mtl_translucency_color.b)									
							newmtl.texmap_translucent.MAP1.MAP1 = mtl.mtl_translucency_map  					
						)
						else
							newmtl.texmap_translucent.MAP1 =  mtl.mtl_translucency_map  					
					)
					else			
					(				
						if (translTint) then
						(
							newmtl.texmap_translucent         = RGB_Tint()													
							newmtl.texmap_translucent.red    = color (mtl.mtl_translucency_color.r) (0) (0)
							newmtl.texmap_translucent.green = color (0) (mtl.mtl_translucency_color.g) (0)
							newmtl.texmap_translucent.blue   = color (0) (0) (mtl.mtl_translucency_color.b)						
							newmtl.texmap_translucent.MAP1 = mtl.mtl_translucency_map  					
						)
						else
							newmtl.texmap_translucent =  mtl.mtl_translucency_map  					
					)
				)

				-------------------------------------------------------------------------------------------------------
				-- Emission
				-------------------------------------------------------------------------------------------------------

				newmtl. selfIllumination_multiplier = mtl.mtl_emission_mult				
				newmtl.selfIllumination = mtl.mtl_emission_color
				
				emissTint = false					
				if (mtl.mtl_emission_mult_on == on) then emissTint = true
                				
				if (mtl.mtl_emission_map != undefined) do
				(					
					if (emissTint) then
					(
						newmtl.texmap_self_illumination         = RGB_Tint()													
						newmtl.texmap_self_illumination.red    = color (mtl.mtl_emission_color.r) (0) (0)
						newmtl.texmap_self_illumination.green = color (0) (mtl.mtl_emission_color.g) (0)
						newmtl.texmap_self_illumination.blue   = color (0) (0) (mtl.mtl_emission_color.b)						
						newmtl.texmap_self_illumination.MAP1 = mtl.mtl_emission_map  					
					)
					else
						newmtl.texmap_self_illumination =  mtl.mtl_emission_map  					
				)
				
				newmtl.selfIllumination_gi = mtl.mtl_emission_gi				
				
				-------------------------------------------------------------------------------------------------------
				-- Relief
				-------------------------------------------------------------------------------------------------------
				
				newmtl.texmap_bump_multiplier = mtl.mtl_bump_amount * 100
                newmtl.texmap_bump              = mtl.mtl_normal_map
				
                
            )--end hydraMaterial			

            MultiMaterial: 
			(
				-- function call itself to harvest the materials inside the MultiMaterial
				local u
				orgMtl = mtl
				
				for u = 1 to mtl.numsubs do 
				(
					convert_Hydra_to_VRay mtl[u] 
					mtl[u] = newmtl
				)					
				
				-- set so parent knows what to set...
				newmtl = mtl					
			)

            Blend: 
			(
				convert_Hydra_to_VRay mtl.map1
				mtl.map1 = newmtl
				convert_Hydra_to_VRay mtl.map2					
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
	

	button 'btnConvert' "... to V-Ray materials" pos:[88,217] width:220 height:50 align:#left
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
	                    
	            convert_Hydra_to_VRay orgSceneMaterials[i]
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