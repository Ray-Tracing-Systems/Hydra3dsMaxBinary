/*
Last change: 13/11/2019
Author: Ray Tracing Systems.
The conversion of materials and light sources from other renders in Hydra.
*/

clearListener()

global ConvertToHydra
try DestroyDialog ConvertToHydra catch()

(--start ms
local newmtl

----------------------------------------------------------------------------------
-- Convert Materials
----------------------------------------------------------------------------------


fn ConvertMtlToHydra mtl=
(	
	-- default to no change
	newmtl = mtl
	
	case classof mtl of
	(
		VRayMtl:
		(
			newmtl = hydraMaterial ()
			
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
			
			-- Anisotropy
			
			newmtl.mtl_reflect_anisotropy 			= mtl.anisotropy
			newmtl.mtl_reflect_rotation 				= mtl.anisotropy_rotation / 360.0
			newmtl.mtl_reflect_anisotropy_map 	= mtl.texmap_anisotropy
			newmtl.mtl_reflect_rotation_map		= mtl.texmap_anisotropy_rotation
			
			if (mtl.anisotropy > 0 or mtl.texmap_anisotropy != undefined) do
				newmtl.mtl_reflect_brdf = 4			
			
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
		
		--------------------------------------------------------------------------------------------
		
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
		
		--------------------------------------------------------------------------------------------
		
		VRayMtlWrapper: 
		(
			ConvertMtlToHydra mtl.BaseMtl				
		)
		
		--------------------------------------------------------------------------------------------
		--3ds max Architectural Materials
		
		Architectural: 
		(		
			newmtl = hydraMaterial ()
			-- keep the name
			newmtl.name = mtl.name
			
			-- Diffuse

			newmtl.mtl_diffuse_color = mtl.Diffuse			
			newmtl.mtl_diffuse_map  = mtl.diffuseMap
			newmtl.mtl_diffuse_mult  = mtl.diffuseMapAmount / 100

			-- Shininess
			
			newmtl.mtl_reflect_mult  = mtl.shininess / 100
			newmtl.mtl_reflect_map = mtl.shininessMap
			newmtl.mtl_refl_gloss = mtl.shininess / 100 + 0.5			
			
			-- ior	
					
			newmtl.mtl_reflect_ior = mtl.ior

			-- transparency	
			
			newmtl.mtl_transparency_color =  mtl.Diffuse
			newmtl.mtl_transparency_map  = mtl.filterMap
			newmtl.mtl_transparency_mult  = mtl.transparency / 100 
			
			newmtl.mtl_transparency_mult_on = on
		
			-- transluscency	
			
			newmtl.mtl_translucency_color =  mtl.Diffuse
			newmtl.mtl_translucency_map  = mtl.translucencyMap
			newmtl.mtl_translucency_mult  = mtl.Translucency / 100

			
			-- luminance
			
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
			
			-- cutout		
		
			newmtl.mtl_opacity_map = mtl.cutoutMap
					
		)--end ArchitecturalMaterial
		
		--------------------------------------------------------------------------------------------
		
		Standardmaterial:
		(				
			newmtl = hydraMaterial ()
			-- keep the name
			newmtl.name = mtl.name
			
			-- Diffuse
			
			newmtl.mtl_diffuse_color = mtl.Diffuse				
			newmtl.mtl_diffuse_map  = mtl.diffuseMap
			newmtl.mtl_diffuse_mult  = mtl.diffuseMapAmount / 100			
			if (newmtl.mtl_diffuse_map != undefined) do showTextureMap newmtl newmtl.mtl_diffuse_map on 
			
			-- Oren-Nayar
			
			if (mtl.shaderType == 4) do
			(
				newmtl.mtl_diffuse_mult  = mtl.diffuseLevel / 100 
				newmtl.mtl_roughness_mult = mtl.diffuseRoughness / 100
			)
				
			-- Specular color
			
			newmtl.mtl_reflect_color = mtl.Specular
			newmtl.mtl_reflect_map  = mtl.specularMap
			
			-- Specular level
			
			newmtl.mtl_reflect_mult = mtl.specularLevel / 500    
			newmtl.mtl_reflect_map = mtl.specularLevelMap
			newmtl.mtl_refl_fresnel_on = off

			-- Anisotropy
			
			if (mtl.shaderType = 0 or mtl.shaderType = 3) do
			(
			newmtl.mtl_reflect_anisotropy 			= mtl.anisotropy / 100.0
			newmtl.mtl_reflect_rotation 				= mtl.ORIENTATION / 360.0
			newmtl.mtl_reflect_anisotropy_map 	= mtl.anisotropyMap
			newmtl.mtl_reflect_rotation_map		= mtl.orientationMap
			
			if (mtl.anisotropy > 0 or mtl.anisotropyMap != undefined) do
				newmtl.mtl_reflect_brdf = 4			
			)
			
			-- Glossiness
			
			newmtl.mtl_refl_gloss 	= mtl.glossiness / 100
			newmtl.mtl_refl_gl_map = mtl.glossinessMap	
			newmtl.mtl_reflect_brdf = 0 -- phong
			
			-- Self-Illum
			
			newmtl.mtl_emission_color = mtl.selfIllumColor
			newmtl.mtl_emission_map  = mtl.selfillumMap
			newmtl.mtl_emission_mult  = mtl.selfillumMapAmount / 100

			-- Opacity 
			
			if (mtl.opacityMap == undefined) do				
				newmtl.mtl_transparency_mult = 1 - mtl.opacity / 100
				
			newmtl.mtl_opacity_map = mtl.opacityMap
			
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
				
		--------------------------------------------------------------------------------------------
		
		MultiMaterial: 
		(
			-- function call itself to harvest the materials inside the MultiMaterial
			local u
			orgMtl = mtl
			
			for u = 1 to mtl.numsubs do 
			(
				ConvertMtlToHydra mtl[u] 
				mtl[u] = newmtl
			)					
			
			-- set so parent knows what to set...
			newmtl = mtl					
		)
		
		--------------------------------------------------------------------------------------------
		
		Blend: 
		(
			ConvertMtlToHydra mtl.map1
			mtl.map1 = newmtl
			ConvertMtlToHydra mtl.map2					
			mtl.map2 = newmtl					
			-- set so parent knows what to set...
			newmtl = mtl
		)
		
		--------------------------------------------------------------------------------------------

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
			
			-- Anisotropy

			newmtl.mtl_reflect_anisotropy 			= mtl.anisotropy
			newmtl.mtl_reflect_rotation 				= mtl.anisoangle
			newmtl.mtl_reflect_anisotropy_map 	= mtl.anisotropy_map
			newmtl.mtl_reflect_rotation_map		= mtl.anisoangle_map
			
			if (mtl.anisotropy > 0 or mtl.anisotropy_map != undefined) do
				newmtl.mtl_reflect_brdf = 4			

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

		--------------------------------------------------------------------------------------------
		
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
			
			-- Translucency
											
			newmtl.mtl_translucency_color = mtl.colorTranslucency
			newmtl.mtl_translucency_map  = mtl.texmapTranslucency
			newmtl.mtl_translucency_mult  = mtl.levelTranslucency
			
			-- Reflect
			
			newmtl.mtl_reflect_color 			 		= mtl.colorReflect
			newmtl.mtl_reflect_map  					= mtl.texmapReflect
			newmtl.mtl_reflect_mult  					= mtl.levelReflect
			
			-- Anisotropy

			newmtl.mtl_reflect_anisotropy 			= mtl.anisotropy
			newmtl.mtl_reflect_rotation 				= mtl.anisotropyRotation / 360.0
			newmtl.mtl_reflect_anisotropy_map 	= mtl.texmapReflectAnisotropy
			newmtl.mtl_reflect_rotation_map		= mtl.texmapReflectAnisotropyRotation
			
			if (mtl.anisotropy > 0 or mtl.texmapReflectAnisotropy != undefined) do
				newmtl.mtl_reflect_brdf = 4
			
			newmtl.mtl_reflect_extrusion 		= 1
			
			-- Glossy reflect
			
			newmtl.mtl_refl_gloss 	= mtl.reflectGlossiness
			newmtl.mtl_refl_gl_map = mtl.texmapReflectGlossiness
			
			-- Fresnel
			
			newmtl.mtl_reflect_ior       = mtl.fresnelIor
										
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
		
		--------------------------------------------------------------------------------------------
		
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
		hydraMaterial:
		(	
			SetProperty mtl param val
		)
	
		MultiMaterial: 
			(                    
				local u
				orgMtl = mtl                    
				for u = 1 to mtl.numsubs do setMtlParam mtl[u] param val                                    
			)
	)
)



----------------------------------------------------------------------------------
-- Convert Lights
----------------------------------------------------------------------------------

--  Corona light 
fn convertFrom_CoronaLight_to_hydraLight cLt = 
(
	
	hLight = HydraLight on:cLt.on color:cLt.color targeted:cLt.targeted	
			
			
	if cLt.colorMode == 1 do
	(
		hLight.kelvin = on
		hLight.kelvinTemp = cLt.blackbodyTemp	
	)
		
-- 	if cLt.excludeList.count != 0 do
-- 	(
-- 		hydraLight.inclExclType = 1
-- 		if cLt.includeMod == false then hydraLight.excludeList = cLt.excludeList else hydraLight.includeList = cLt.excludeList
-- 	)
		
	--intensity
	cLt.intensityUnits = 0 -- image
	hLight.intensity = cLt.intensity 
	
	--shape
	case cLt.shape of 
	(
		0: ( -- sphere
				hLight.type = 3				
				hLight.radius = cLt.width
			)		
		1: ( -- rectangle
				hLight.type = 1				
				hLight.length = cLt.height
				hLight.width = cLt.width
				if cLt.iesOn == on and cLt.iesFile != undefined then
				(
					WEB_on = cLt.iesOn
					hLight.WEB_file = cLt.iesFile 
				)
			)
		2: ( -- disk
				hLight.type = 2				
				hLight.radius = cLt.width
				if cLt.iesOn == on and cLt.iesFile != undefined then
				(
					WEB_on = cLt.iesOn
					hLight.WEB_file = cLt.iesFile 
				)
			)		
		3: ( -- cylinder
				hLight.type = 4			
				hLight.length = cLt.height
				hLight.radius = cLt.width * 2
			)
	)

	hLight.visInRender = cLt.visibleDirectly 
	
hLight	

)--fn end

--  Corona sun 
fn convertFrom_CoronaSun_to_hydraLight cLt = 
(			
	hLight = HydraSunSky sun_on:cLt.on 
	hLight
)


--  VRay light 
fn convertFrom_VrayLight_to_hydraLight cLt = 
(			
	hLight = HydraLight on:cLt.on color:cLt.color targeted:cLt.targeted
	
-- 	if cLt.excludeList.count != 0 do
-- 	(
-- 		hydraLight.inclExclType = 1
-- 		if cLt.includeMod == false then hydraLight.excludeList = cLt.excludeList else hydraLight.includeList = cLt.excludeList
-- 	)
	
	--intensity
	cLt.normalizeColor = 0 -- image
	hLight.intensity = cLt.multiplier 

	if cLt.color_mode == 1 do
	(
		hLight.kelvin = on
		hLight.kelvinTemp = cLt.color_temperature	
	)
		
	--shape
	case cLt.type  of 
	(
		0: ( -- Rectangle 
				hLight.type = 1
				hLight.length = cLt.size1 * 2
				hLight.width = cLt.size0 * 2
			)
		2: ( -- Sphere
				hLight.type = 3
				hLight.radius = cLt.size0
			)				
		4: ( -- Disk
				hLight.type = 2
				hLight.radius = cLt.size0
			)					
	)

	hLight.visInRender != cLt.invisible
	
	if clt.skylightPortal == on and clt.type == 0 then
	(
		hLight.type = 5
		hLight.visInRender = off		
		hLight.lenght = cLt.size1 * 2
		hLight.width = cLt.size0 * 2
	)
	
	hLight	
	
)--fn end


--  VRay IES 
fn convertFrom_VrayIES_to_hydraLight cLt = 
(			
	hLight = HydraLight on:cLt.enabled targeted:cLt.targeted WEB_on:on color:cLt.color WEB_rotX:cLt.rotation_X WEB_rotY:cLt.rotation_Y WEB_rotZ:cLt.rotation_Z 
	
	if cLt.ies_file != undefined do hLight.WEB_file = cLt.ies_file
	
	if(cLt.intensity_type == 0) then hLight.intensityUnits = 1 -- cd
	if(cLt.intensity_type == 1) then hLight.intensityUnits = 2 -- lm

	hLight.intensity = cLt.power 
	
-- 	if cLt.excludeList.count != 0 do
-- 	(
-- 		hydraLight.inclExclType = 1
-- 		if cLt.includeMod == false then hydraLight.excludeList = cLt.excludeList else hydraLight.includeList = cLt.excludeList
-- 	)				
	
	if cLt.color_mode == 1 do
	(
		hLight.kelvin = on
		hLight.kelvinTemp = cLt.color_temperature	
	)
		
	--shape
	if cLt.override_shape == on do
	(
		case cLt.shape of 
		(
		3: ( -- sphere
				hLight.type = 2 -- disk, because sphere not support IES
				hLight.radius = cLt.diameter / 2				
			)			
		
		1: ( -- rectangle
				hLight.type = 1
				hLight.length = cLt.length
				hLight.width = cLt.width
			)
		2: ( -- disk
				hLight.type = 2
				hLight.radius = cLt.diameter / 2
			)
		)
	)			
	hLight
)

--  VRay sun 
fn convertFrom_VraySun_to_hydraLight cLt = 
(			
	hLight = HydraSunSky sun_on:cLt.enabled 				
	hLight
)

--  Photometric 
fn convertFrom_Photometric_to_hydraLight cLt = 
(
	hLight = HydraLight on:cLt.on color:cLt.rgbFilter 
	
-- 	if cLt.excludeList.count != 0 do
-- 	(
-- 		hydraLight.inclExclType = 1
-- 		if cLt.includeMod == false then hydraLight.excludeList = cLt.excludeList else hydraLight.includeList = cLt.excludeList
-- 	)	
				
	--intensity
	cLt.intensityType = 1 -- cd
	hLight.intensityUnits = 1 --cd
	hLight.intensity = cLt.intensity 

	if cLt.useKelvin == true do
	(
		hLight.kelvin = true
		hLight.kelvinTemp = cLt.kelvin	
	)
		
	--shape	
	case cLt.type  of 
	(
	#Free_Point: ( 
			hLight.type 		= 0
		)		
	#Free_Rectangle:(
			hLight.type 		= 1		
			hLight.length 	= cLt.light_length
			hLight.width 		= cLt.light_Width
		)
	#Free_Disc: (
			hLight.type 		= 2
			hLight.radius 	= cLt.light_Radius
		)		
	#Free_Sphere: ( 
			hLight.type 		= 3
			hLight.radius 	= cLt.light_Radius
		)				
	#Free_Cylinder: (
			hLight.type 		= 4
			hLight.length 	= cLt.light_length
			hLight.radius 	= cLt.light_Radius
		)	
	#Target_Point: ( 
			hLight.type 		= 0
			hLight.targeted 	= true
		)		
	#Target_Rectangle:(
			hLight.type 		= 1
			hLight.length 	= cLt.light_length
			hLight.width 		= cLt.light_Width
			hLight.targeted 	= true
		)
	#Target_Disc: (
			hLight.type 		= 2
			hLight.radius 	= cLt.light_Radius
			hLight.targeted 	= true
		)		
	#Target_Sphere: ( 
			hLight.type		= 3
			hLight.radius 	= cLt.light_Radius
			hLight.targeted	= true	
		)				
	#Target_Cylinder: (
			hLight.type 		= 4
			hLight.length 	= cLt.light_length
			hLight.radius 	= cLt.light_Radius
			hLight.targeted 	= true
		)				
	)
	
	hLight.visInRender = cLt.Area_Light_Sampling_Custom_Attribute.mr_EnableLightShapeRendering
	
	hLight		
)--fn end

--  mrSkyPortal 
fn convertFrom_mrSkyPortal_to_hydraLight cLt = 
(
	hLight = HydraLight on:cLt.on color:cLt.rgbFilter
	
-- 	if cLt.excludeList.count != 0 do
-- 	(
-- 		hydraLight.inclExclType = 1
-- 		if cLt.includeMod == false then hydraLight.excludeList = cLt.excludeList else hydraLight.includeList = cLt.excludeList
-- 	)
	
	hLight.type 			= 5
	hLight.intensity 		= cLt.multiplier 		
	hLight.length 		= cLt.light_length
	hLight.width 			= cLt.light_Width
	hLight.visInRender = cLt.Area_Visible
	
	hLight		
)--fn end

----------------------------------------------------------------------------------
-- Menu
----------------------------------------------------------------------------------

rollout ConvertToHydra "Converter tool to Hydra render" width:400 height:380
(
    local mtls = sceneMaterials
    local sel  
	local mtl
    
    GroupBox 'grp2' "Convert these materials as much as possible:" pos:[10,10] width:380 height:120 align:#left
	label 'lbl2' "Scanline:        Standard, Blend, Multi/Sub-Object, Architectural." pos:[30,40] width:340 height:20 align:#left
	label 'lbl3' "Mental ray:     Arch and Design." pos:[30,60] width:340 height:20 align:#left
	label 'lbl4' "V-Ray:           VRayMtl, VrayLightMtl." pos:[30,80] width:340 height:20 align:#left
	label 'lbl5' "Corona:          CoronaMtl, CoronaLightMtl." pos:[30,100] width:340 height:20 align:#left
	
    GroupBox 'grp5' "Convert these lights as much as possible::" pos:[10,140] width:380 height:120 align:#left
	label 'lbl15' "3ds Max:       hydraLight." pos:[30,170] width:340 height:20 align:#left
	label 'lbl16' "Mental ray:    mr Sky Portal." pos:[30,190] width:340 height:20 align:#left
	label 'lbl17' "V-Ray:          VRayLight, VRayIES, VRaySun." pos:[30,210] width:340 height:20 align:#left
	label 'lbl18' "Corona:         CoronaLight, CoronaSun." pos:[30,230] width:340 height:20 align:#left
	
	button 'btnConvert' "...to Hydra." pos:[90,290] width:220 height:50 align:#left	

	on btnConvert pressed do
	(	        
	    with undo on
	    (	
			-------------------------------------------			
			-- Convert materials
			-------------------------------------------
			
			local orgSceneMaterials = ConvertToHydra.mtls
	        
	        for i = 1 to orgSceneMaterials.count do 
	        (
	            local u
	            if (orgSceneMaterials[i] != undefined) do
				(				
					ConvertMtlToHydra orgSceneMaterials[i]
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
			
			-------------------------------------------
			-- Convert lights
			-------------------------------------------
			
			hasCoronaRender 		= false
			hasVRayRender 			= false
			hasMentalRayRender 	= false
			
			for i in RendererClass.classes where matchPattern (i as string) pattern:"CoronaRenderer*" do
				hasCoronaRender = true
			
			for i in RendererClass.classes where matchPattern (i as string) pattern:"V_Ray*" do
				hasVRayRender = true
			
			for i in RendererClass.classes where matchPattern (i as string) pattern:"mental_ray*" do
				hasMentalRayRender = true

			--Corona 
			if (hasCoronaRender) do
			(
				for i in (getClassInstances CoronaLight) do (replaceInstances i (convertFrom_CoronaLight_to_hydraLight i))
				try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()
				
				for i in (getClassInstances CoronaSun) do (replaceInstances i (convertFrom_CoronaSun_to_hydraLight i))
				try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()
			)	
			--Vray
			if(hasVRayRender) do
			(
				for i in (getClassInstances VrayLight) do (replaceInstances i (convertFrom_VrayLight_to_hydraLight i))
				try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()
					
				for i in (getClassInstances VrayIES) do (replaceInstances i (convertFrom_VrayIES_to_hydraLight i))
				try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()				
					
				for i in (getClassInstances VraySun) do (replaceInstances i (convertFrom_VraySun_to_hydraLight i))
				try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()			
			)
			-- Photometric
			for i in (getClassInstances Free_Light) do (replaceInstances i (convertFrom_Photometric_to_hydraLight i))
			try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()				
			for i in (getClassInstances Free_Area) do (replaceInstances i (convertFrom_Photometric_to_hydraLight i))
			try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()				
			for i in (getClassInstances Free_Disc) do (replaceInstances i (convertFrom_Photometric_to_hydraLight i))
			try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()				
			for i in (getClassInstances Free_Sphere) do (replaceInstances i (convertFrom_Photometric_to_hydraLight i))
			try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()				
			for i in (getClassInstances Free_Cylinder) do (replaceInstances i (convertFrom_Photometric_to_hydraLight i))
			try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()				
			
			for i in (getClassInstances Target_Light) do (replaceInstances i (convertFrom_Photometric_to_hydraLight i))
			try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()				
			for i in (getClassInstances Target_Area) do (replaceInstances i (convertFrom_Photometric_to_hydraLight i))
			try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()				
			for i in (getClassInstances Target_Disc) do (replaceInstances i (convertFrom_Photometric_to_hydraLight i))
			try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()				
			for i in (getClassInstances Target_Sphere) do (replaceInstances i (convertFrom_Photometric_to_hydraLight i))
			try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()				
			for i in (getClassInstances Target_Cylinder) do (replaceInstances i (convertFrom_Photometric_to_hydraLight i))
			try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()				

			-- mrSkyPortal
			if(hasMentalRayRender) do
			(
				for i in (getClassInstances mr_Sky_Portal) do (replaceInstances i (convertFrom_mrSkyPortal_to_hydraLight i))
				try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()				
			)
			
			print "Convert complete."
	    )	
	)
)
  

createDialog ConvertToHydra
)--end ms