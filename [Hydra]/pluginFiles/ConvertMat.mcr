/*
Created:  2016.09
Autor: Ray Tracing Systems.
Based on Arch&Design AO/RC Option and conversion tool. PF Breton, Zap Andersson).
Hydra render convert materials.
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
fn convert_Mtl_to_Hydra mtl=
    (	
        -- default to no change
        newmtl = mtl
        
        case classof mtl of
        (
            
            ------------------------------------------------------------------------------------------------------------------
            --Vray Materials
            ------------------------------------------------------------------------------------------------------------------
            VRayMtl:
            (
                newmtl = hydraMaterial ()
                -- keep the name
                newmtl.name = mtl.name
				
				-- Diffuse
                
                newmtl.mtl_diffuse_color = mtl.Diffuse
                newmtl.mtl_diffuse_map  = mtl.texmap_diffuse
				newmtl.mtl_diffuse_mult  = mtl.texmap_diffuse_multiplier / 100
				newmtl.mtl_roughness_mult = mtl.diffuse_roughness
                
				-- Reflect
				
                newmtl.mtl_reflect_color = mtl.Reflection
                newmtl.mtl_reflect_map  = mtl.texmap_reflection
                newmtl.mtl_reflect_mult  = mtl.texmap_reflection_multiplier / 100
				
				newmtl.mtl_reflect_extrusion = 0
                
				-- Glossy reflect
				
                newmtl.mtl_refl_gloss 	= mtl.reflection_glossiness
                newmtl.mtl_refl_gl_map = mtl.texmap_reflectionGlossiness
                
				-- Fresnel
				
                newmtl.mtl_refl_fresnel_on = mtl.reflection_fresnel
				newmtl.mtl_reflect_ior       = mtl.refraction_ior
				
				if (not mtl.reflection_lockIOR) do
                (
					newmtl.mtl_reflect_ior = mtl.reflection_ior
                )
				
				-- Refract
                            
                newmtl.mtl_transparency_color = mtl.Refraction
                newmtl.mtl_transparency_map  = mtl.texmap_refraction
                newmtl.mtl_transparency_mult  = mtl.texmap_refraction_multiplier / 100
                    
                newmtl.mtl_transp_gloss    = mtl.refraction_glossiness
                newmtl.mtl_transp_gl_map = mtl.texmap_refractionGlossiness
				newmtl.mtl_ior 				= mtl.refraction_ior
				
				-- Opacity
				
				newmtl.mtl_opacity_map = mtl.texmap_opacity
				
				-- Fog
				
                newmtl.mtl_fog_color 		= mtl.refraction_fogColor
                newmtl.mtl_fog_multiplier 	= mtl.refraction_fogMult * 130
				
				-- Translucency
				
				if (mtl.translucency_on != 0) do
				(
				                
					newmtl.mtl_translucency_color = mtl.translucency_color
					newmtl.mtl_translucency_map  = mtl.texmap_translucent
					newmtl.mtl_translucency_mult  = mtl.translucency_fbCoeff
				)
				
				-- Self-Illum
				
				newmtl.mtl_emission_color = mtl.selfIllumination
                newmtl.mtl_emission_mult  = mtl.selfIllumination_multiplier
				newmtl.mtl_emission_map  = mtl.texmap_self_illumination
                newmtl.mtl_emission_gi		= mtl.selfIllumination_gi
				
				-- anisotropy
				/*
				newmtl.anisotropy    = 1.0 - mtl.anisotropy
				newmtl.anisoangle    = mtl.anisotropy_rotation / 360
                
				newmtl.aniso_mode    = mtl.anisotropy_derivation
				newmtl.aniso_channel = mtl.anisotropy_channel
				*/
				
				-- Options
				
				if (mtl.option_traceRefraction == off) do
				(
					newmtl.mtl_transparency_thin_on = on
				)
				
				-- bump

                newmtl.mtl_normal_map    = mtl.texmap_bump
                newmtl.mtl_bump_amount = mtl.texmap_bump_multiplier / 100
				
				-- displacement
				
                --newmtl.displacement_map     = mtl.texmap_displacement
                newmtl.mtl_displacement_height = mtl.texmap_displacement_multiplier / 100
                
				if (mtl.texmap_displacement != undefined) do
				(
					newmtl.mtl_displacement_on = on
				)
                
            )--end VrayMtl
			
			VrayLightMtl:
			(
                newmtl = hydraMaterial ()
                -- keep the name
                newmtl.name = mtl.name
				
				newmtl.mtl_diffuse_mult = 0
				
				-- Color
				
				newmtl.mtl_emission_color = mtl.color
                newmtl.mtl_emission_mult  = mtl.multiplier
				newmtl.mtl_emission_map  = mtl.texmap
				
				-- Opacity
				
				newmtl.mtl_opacity_map = mtl.opacity_texmap
				
			) --end VrayLightMtl
			
            VRayMtlWrapper: 
            (
                convert_Mtl_to_Hydra mtl.BaseMtl				
            )
            
            ------------------------------------------------------------------------------------------------------------------
            --3ds max Architectural Materials
            ------------------------------------------------------------------------------------------------------------------
            Architectural: 
            (		
                newmtl = hydraMaterial ()
                -- keep the name
                newmtl.name = mtl.name
                
                --- Diffuse

                newmtl.mtl_diffuse_color = mtl.Diffuse			
                newmtl.mtl_diffuse_map  = mtl.diffuseMap
                newmtl.mtl_diffuse_mult  = mtl.diffuseMapAmount / 100

                -- Shininess
				
				newmtl.mtl_reflect_mult  = mtl.shininess / 100
                newmtl.mtl_reflect_map = mtl.shininessMap
                newmtl.mtl_refl_gloss = mtl.shininess / 100 + 0.5			
                
                --- ior	
						
                newmtl.mtl_reflect_ior = mtl.ior

                --- transparency	
				
                newmtl.mtl_transparency_color =  mtl.Diffuse
                newmtl.mtl_transparency_map  = mtl.filterMap
                newmtl.mtl_transparency_mult  = mtl.transparency / 100 
				
				newmtl.mtl_transparency_mult_on = on
            
                --- transluscency	
				
                newmtl.mtl_translucency_color =  mtl.Diffuse
                newmtl.mtl_translucency_map  = mtl.translucencyMap
                newmtl.mtl_translucency_mult  = mtl.Translucency / 100

                
                --- luminance
				
                newmtl.mtl_emission_color = mtl.Diffuse
                newmtl.mtl_emission_mult  = mtl.luminance / 1000
				newmtl.mtl_emission_map  = mtl.luminanceMap
                
				-- bump

                newmtl.mtl_normal_map    = mtl.bumpMap
                newmtl.mtl_bump_amount = mtl.bumpMapAmount / 100
				
				-- displacement
				
                --newmtl.displacement_map     = mtl.texmap_displacement
                newmtl.mtl_displacement_height = mtl.displacementMapAmount / 100
                if (mtl.displacementMap != undefined) do
				(
					newmtl.mtl_displacement_on = on
				)
                
                --- cutout		
            
                newmtl.mtl_opacity_map = mtl.cutoutMap
                        
            )--end ArchitecturalMaterial
            

            ------------------------------------------------------------------------------------------------------------------
            -- 3ds max Standard Materials
            ------------------------------------------------------------------------------------------------------------------
            Standardmaterial:
            (				
                newmtl = hydraMaterial ()
                -- keep the name
                newmtl.name = mtl.name
                
                --- Diffuse
				
                newmtl.mtl_diffuse_color = mtl.Diffuse				
                newmtl.mtl_diffuse_map  = mtl.diffuseMap
                newmtl.mtl_diffuse_mult  = mtl.diffuseMapAmount / 100
				
				-- Oren-Nayar
				
				if (mtl.shaderType == 4) do
				(
					newmtl.mtl_diffuse_mult  = mtl.diffuseLevel / 100 
					newmtl.mtl_roughness_mult = mtl.diffuseRoughness / 100
				)
					
                --- Specular color
				
                newmtl.mtl_reflect_color = mtl.Specular
                newmtl.mtl_reflect_map  = mtl.specularMap
                
                --- Specular level
				
                newmtl.mtl_reflect_mult = mtl.specularLevel / 100
                
                --- Glossiness
				
                newmtl.mtl_refl_gloss 	= mtl.glossiness / 100
                newmtl.mtl_refl_gl_map = mtl.glossinessMap	
				
				-- Fresnel
				
				newmtl.mtl_refl_fresnel_on = off
				
                --- Self-Illum
				
                newmtl.mtl_emission_color = mtl.selfIllumColor
                newmtl.mtl_emission_map  = mtl.selfillumMap
                newmtl.mtl_emission_mult  = mtl.selfillumMapAmount / 100

                --- Opacity (like refract)
				
                newmtl.mtl_transparency_mult = 1 - mtl.opacity / 100
				newmtl.mtl_transparency_map = mtl.opacityMap
				
				-- Translucent
				
				if (mtl.shaderType == 7) do
				(
					newmtl.mtl_translucency_color = mtl.translucentColor
					newmtl.mtl_translucency_map  = mtl.translucentColorMap
					newmtl.mtl_translucency_mult  = mtl.translucentColorMapAmount
				)

				-- bump

                newmtl.mtl_normal_map    = mtl.bumpMap
                newmtl.mtl_bump_amount = mtl.bumpMapAmount / 100
				
				-- displacement
				
                --newmtl.displacement_map     = mtl.texmap_displacement
                newmtl.mtl_displacement_height = mtl.displacementMapAmount / 100
                if (mtl.displacementMap != undefined) do
				(
					newmtl.mtl_displacement_on = on
				)

            )--end Standard Material
                    

            ------------------------------------------------------------------------------------------------------------------
            -- Multimaterials
            ------------------------------------------------------------------------------------------------------------------
            MultiMaterial: 
                (
                    -- function call itself to harvest the materials inside the MultiMaterial
                    local u
                    orgMtl = mtl
                    
                    for u = 1 to mtl.numsubs do 
                    (
                        convert_Mtl_to_Hydra mtl[u] 
                        mtl[u] = newmtl
                    )					
                    
                    -- set so parent knows what to set...
                    newmtl = mtl					
                )

            Blend: 
                (
                    convert_Mtl_to_Hydra mtl.map1
                    mtl.map1 = newmtl
                    convert_Mtl_to_Hydra mtl.map2					
                    mtl.map2 = newmtl					
                    -- set so parent knows what to set...
                    newmtl = mtl
                )

            ------------------------------------------------------------------------------------------------------------------
            -- Arch & Design Materials
            ------------------------------------------------------------------------------------------------------------------
            Arch___Design__mi:
            (			
                newmtl = hydraMaterial ()
                -- keep the name
                newmtl.name = mtl.name
				
				-- Diffuse
                
                newmtl.mtl_diffuse_color = mtl.diff_color
                newmtl.mtl_diffuse_map  = mtl.diff_color_map
				newmtl.mtl_diffuse_mult  = mtl.diff_weight
				newmtl.mtl_roughness_mult = mtl.diff_rough
                
				-- Reflect
				
                newmtl.mtl_reflect_color = mtl.refl_color
                newmtl.mtl_reflect_map  = mtl.refl_color_map
                newmtl.mtl_reflect_mult  = mtl.refl_weight
				
				newmtl.mtl_reflect_extrusion = 1
                
				-- Glossy reflect
				
                newmtl.mtl_refl_gloss 	= mtl.refl_gloss
                newmtl.mtl_refl_gl_map = mtl.refl_gloss_map
                
				-- Fresnel
				
				newmtl.mtl_reflect_ior = mtl.refr_ior
				
				if (mtl.refl_func_fresnel == off) do
                (
					newmtl.mtl_reflect_ior = mtl.refl_func_low * 50
					
					if (mtl.refl_func_low ==1 and mtl.refl_func_high == 1) then
					(
						newmtl.mtl_refl_fresnel_on = off
					)
					else newmtl.mtl_reflect_ior = mtl.refl_func_low * 50
                )
				
				-- Refract
                            
                newmtl.mtl_transparency_color = mtl.refr_color
                newmtl.mtl_transparency_map  = mtl.refr_color_map
                newmtl.mtl_transparency_mult  = mtl.refr_weight
                    
                newmtl.mtl_transp_gloss    = mtl.refr_gloss
                newmtl.mtl_transp_gl_map = mtl.refr_gloss_map
				
				newmtl.mtl_ior 		      = mtl.refr_ior
				
				-- Translucency
				
				if (mtl.refr_trans_on == on) do
				(
					newmtl.mtl_translucency_mult  = mtl.refr_transw
				)
				
				newmtl.mtl_translucency_color = mtl.refr_transc
				newmtl.mtl_translucency_map  = mtl.refr_transc_map
				
				-- anisotropy
				/*
				newmtl.anisotropy    = 1.0 - mtl.anisotropy
				newmtl.anisoangle    = mtl.anisotropy_rotation / 360
                
				newmtl.aniso_mode    = mtl.anisotropy_derivation
				newmtl.aniso_channel = mtl.anisotropy_channel
				*/
				
				-- Self-Illum
				
				if (mtl.self_illum_on == on) do
				(
					newmtl.mtl_emission_mult  = mtl.self_illum_int_arbitrary
				)
				
				newmtl.mtl_emission_color = mtl.self_illum_color_filter
				newmtl.mtl_emission_map  = mtl.self_illum_map
				
				if ( mtl.self_illum_in_fg == off) do
				(
					newmtl.mtl_emission_gi	= off
				)
				
				-- Options
				
				------ Fog
				
				if (mtl.refr_falloff_on == on ) do
				(
					
					newmtl.mtl_fog_multiplier = 200 / mtl.refr_falloff_dist
					
					if (mtl.refr_falloff_color_on == on) then
					(
						newmtl.mtl_fog_color = mtl.refr_falloff_color
					)
					else newmtl.mtl_fog_color = color 0 0 0
					
				)
				
				------ Thin
				
				if (mtl.opts_1sided == on) do
				(
					newmtl.mtl_transparency_thin_on = on
				)
				
				-- bump

                newmtl.mtl_normal_map    = mtl.bump_map
                newmtl.mtl_bump_amount = mtl.bump_map_amt
				
				-- displacement
				
                --newmtl.displacement_map     = mtl.texmap_displacement
                newmtl.mtl_displacement_height = mtl.displacement_map_amt
                
				if (mtl.displacement_map != undefined) do
				(
					newmtl.mtl_displacement_on = on
				)
				
				-- Opacity
				
				newmtl.mtl_opacity_map = mtl.cutout_map
				
            )--end Arch & Design Materials

			------------------------------------------------------------------------------------------------------------------
            -- Corona Materials
            ------------------------------------------------------------------------------------------------------------------
			
			CoronaMtl:
            (
                newmtl = hydraMaterial ()
                -- keep the name
                newmtl.name = mtl.name
				
				-- Diffuse
                
                newmtl.mtl_diffuse_color = mtl.colorDiffuse
                newmtl.mtl_diffuse_map  = mtl.texmapDiffuse
				newmtl.mtl_diffuse_mult  = mtl.levelDiffuse
				
				--newmtl.mtl_roughness_mult = mtl.diffuse_roughness
				
				------ Translucency
								                
				newmtl.mtl_translucency_color = mtl.colorTranslucency
				newmtl.mtl_translucency_map  = mtl.texmapTranslucency
				newmtl.mtl_translucency_mult  = mtl.levelTranslucency
                
				-- Reflect
				
                newmtl.mtl_reflect_color = mtl.colorReflect
                newmtl.mtl_reflect_map  = mtl.texmapReflect
                newmtl.mtl_reflect_mult  = mtl.levelReflect
				
				--newmtl.mtl_reflect_extrusion = 0
                
				-- Glossy reflect
				
                newmtl.mtl_refl_gloss 	= mtl.reflectGlossiness
                newmtl.mtl_refl_gl_map = mtl.texmapReflectGlossiness
                
				-- Fresnel
				
				newmtl.mtl_reflect_ior       = mtl.fresnelIor
				
				-- Anisotropy
				/*
				newmtl.anisotropy    = 1.0 - mtl.anisotropy
				newmtl.anisoangle    = mtl.anisotropy_rotation / 360
                
				newmtl.aniso_mode    = mtl.anisotropy_derivation
				newmtl.aniso_channel = mtl.anisotropy_channel
				*/
								
				-- Refract
                            
                newmtl.mtl_transparency_color = mtl.colorRefract
                newmtl.mtl_transparency_map  = mtl.texmapRefract
                newmtl.mtl_transparency_mult  = mtl.levelRefract
				
				-- Glossy refract
				
                newmtl.mtl_transp_gloss    = mtl.refractGlossiness
                newmtl.mtl_transp_gl_map = mtl.texmapRefractGlossiness
				newmtl.mtl_ior 				= mtl.ior
				
				newmtl.mtl_transparency_thin_on = mtl.thin
				
				-- Opacity
				
				newmtl.mtl_opacity_map = mtl.texmapOpacity
				
				-- Absorption
				
                newmtl.mtl_fog_color 		= mtl.absorptionColor
                newmtl.mtl_fog_multiplier 	= mtl.absorptionDistance / 100
			
				-- Bump

                newmtl.mtl_normal_map    = mtl.texmapBump
                newmtl.mtl_bump_amount = mtl.mapamountBump
				
				-- Displacement
				
                --newmtl.displacement_map     = mtl.texmap_displacement
                newmtl.mtl_displacement_height = mtl.displacementMinimum + mtl.displacementMaximum
                
				if (mtl.texmapDisplace != undefined) do
				(
					newmtl.mtl_displacement_on = on
				)
				
				-- Self-Illum
				
				newmtl.mtl_emission_color = mtl.colorSelfIllum
                newmtl.mtl_emission_mult  = mtl.levelSelfIllum
				newmtl.mtl_emission_map  = mtl.texmapSelfIllum
                
            )--end CoronaMtl
			
			CoronaLightMtl:
			(
                newmtl = hydraMaterial ()
                -- keep the name
                newmtl.name = mtl.name
				
				newmtl.mtl_diffuse_mult = 0
				
				-- Color
				
				newmtl.mtl_emission_color = mtl.color
                newmtl.mtl_emission_mult  = mtl.intensity
				newmtl.mtl_emission_map  = mtl.texmap
				
				newmtl.mtl_emission_gi = mtl.emitLight
				
				-- Opacity
				
				newmtl.mtl_opacity_map = mtl.opacityTexmap
				
			) --end CoronaLightMtl
        )	 
    ) -- end fn  

----------------------------------------------------------------
--  Set Parameter Function
-----------------------------------------------------------------
    fn setMtlParam mtl param val =
    (	
    
        case classof mtl of
        (
            
            ------------------------------------------------------------------------------------------------------------------
            --hydraMaterial
            ------------------------------------------------------------------------------------------------------------------
            hydraMaterial:
            (	
                SetProperty mtl param val
            )
        
            ------------------------------------------------------------------------------------------------------------------
            -- Multimaterials
            -- function call itself to harvest the materials inside the MultiMaterial
            ------------------------------------------------------------------------------------------------------------------
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

rollout ConvertMat "Convert materials tool" width:400 height:328
(
    local mtls = sceneMaterials
    local sel
    
	radiobuttons 'only_medit' "" pos:[66,40] width:267 height:16 labels:#("...in scene", "...in material editor only") columns:2 align:#left
    
		
	    local mtl
    

	label 'lbl2' "Scanline: Standart, Blend, Multi/Sub-Object, Architectural." pos:[20,120] width:360 height:20 align:#left
	label 'lbl3' "Mental ray: Arch and Design." pos:[20,140] width:360 height:20 align:#left
	label 'lbl4' "V-Ray v3.2: VRayMtl, VrayLightMtl." pos:[20,160] width:360 height:20 align:#left
	label 'lbl5' "Corona v1.3: CoronaMtl, CoronaLightMtl." pos:[20,180] width:360 height:20 align:#left
	label 'lbl6' "WARNING: OPERATION NOT UNDO!" pos:[112,216] width:176 height:16 align:#left
	

	button 'btnConvert' "... to Hydra materials" pos:[90,240] width:220 height:50 align:#left
	GroupBox 'grp1' "Affect materials..." pos:[10,10] width:380 height:70 align:#left
	GroupBox 'grp2' "Convert materials as posible..." pos:[10,90] width:380 height:230 align:#left
	
	
    
        
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
	                    
	            convert_Mtl_to_Hydra orgSceneMaterials[i]
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

)--end script