/*
Last change: 13/11/2019
Author: Ray Tracing Systems.
Conversion of materials and light sources from Hydra to other renders.
*/

global ConvertFromHydra
try DestroyDialog ConvertFromHydra catch()

(--start ms
	
local newmtl

----------------------------------------------------------------------------------
-- Convert materials functions
----------------------------------------------------------------------------------
fn ConvertHydraMatToCorona mtl=
(
	newmtl = mtl
	
	case classof mtl of
	(            
		hydraMaterial:
		(
			newmtl = CoronaMtl()
			-- keep the name
			newmtl.name = mtl.name
			
			-------------------------------------------------------------------------------------------------------
			-- Diffuse                
			-------------------------------------------------------------------------------------------------------
			newmtl.levelDiffuse = mtl.mtl_diffuse_mult
			newmtl.colorDiffuse = mtl.mtl_diffuse_color
			
			diffTint = false					
			if (mtl.mtl_diffuse_mult_on == on) then	diffTint = true

			if (mtl.mtl_diffuse_map != undefined) do
			(					
				if (mtl.mtl_diffuse_mult != 1) then
				(	
					newmtl.texmapDiffuse 						  	=  output()  
					newmtl.texmapDiffuse.output.rgb_level	= mtl.mtl_diffuse_mult						

					if (diffTint) then
					(
						newmtl.texmapDiffuse.MAP1         	= RGB_Tint()													
						newmtl.texmapDiffuse.MAP1.red    	= color (mtl.mtl_diffuse_color.r) (0) (0)
						newmtl.texmapDiffuse.MAP1.green 	= color (0) (mtl.mtl_diffuse_color.g) (0)
						newmtl.texmapDiffuse.MAP1.blue   	= color (0) (0) (mtl.mtl_diffuse_color.b)									
						newmtl.texmapDiffuse.MAP1.MAP1	= mtl.mtl_diffuse_map  					
					)
					else
						newmtl.texmapDiffuse.MAP1 =  mtl.mtl_diffuse_map  					
				)
				else			
				(				
					if (diffTint) then
					(
						newmtl.texmapDiffuse         	= RGB_Tint()													
						newmtl.texmapDiffuse.red    	= color (mtl.mtl_diffuse_color.r) (0) (0)
						newmtl.texmapDiffuse.green 	= color (0) (mtl.mtl_diffuse_color.g) (0)
						newmtl.texmapDiffuse.blue   	= color (0) (0) (mtl.mtl_diffuse_color.b)						
						newmtl.texmapDiffuse.MAP1	= mtl.mtl_diffuse_map  					
					)
					else
						newmtl.texmapDiffuse 			=  mtl.mtl_diffuse_map  					
				)
			)
			
			--newmtl.diffuse_roughness = mtl.mtl_roughness_mult 
					 
			-------------------------------------------------------------------------------------------------------				
			-- Reflectivity
			-------------------------------------------------------------------------------------------------------
			newmtl.levelReflect = mtl.mtl_reflect_mult
			newmtl.colorReflect = mtl.mtl_reflect_color 
			
			reflTint = false					
			if (mtl.mtl_reflect_mult_on == on) then reflTint = true
							
			if (mtl.mtl_reflect_map != undefined) do
			(					
				if (mtl.mtl_reflect_mult != 1) then
				(	
					newmtl.texmapReflect                        	=  output()  
					newmtl.texmapReflect.output.rgb_level	= mtl.mtl_reflect_mult						

					if (reflTint) then
					(
						newmtl.texmapReflect.MAP1         	= RGB_Tint()													
						newmtl.texmapReflect.MAP1.red   	= color (mtl.mtl_reflect_color.r) (0) (0)
						newmtl.texmapReflect.MAP1.green 	= color (0) (mtl.mtl_reflect_color.g) (0)
						newmtl.texmapReflect.MAP1.blue   	= color (0) (0) (mtl.mtl_reflect_color.b)									
						newmtl.texmapReflect.MAP1.MAP1	= mtl.mtl_reflect_map  					
					)
					else
						newmtl.texmapReflect.MAP1 =  mtl.mtl_reflect_map  					
				)
				else			
				(				
					if (reflTint) then
					(
						newmtl.texmapReflect            = RGB_Tint()													
						newmtl.texmapReflect.red    	= color (mtl.mtl_reflect_color.r) (0) (0)
						newmtl.texmapReflect.green 	= color (0) (mtl.mtl_reflect_color.g) (0)
						newmtl.texmapReflect.blue   	= color (0) (0) (mtl.mtl_reflect_color.b)						
						newmtl.texmapReflect.MAP1	= mtl.mtl_reflect_map  					
					)
					else
						newmtl.texmapReflect 			=  mtl.mtl_reflect_map  					
				)
			)
			
			newmtl.anisotropy 								= mtl.mtl_reflect_anisotropy 		
			newmtl.anisotropyRotation 					= mtl.mtl_reflect_rotation * 360.0
			newmtl.texmapReflectAnisotropy 			= mtl.mtl_reflect_anisotropy_map 			
			newmtl.texmapReflectAnisotropyRotation 	= mtl.mtl_reflect_rotation_map				
			
			-- Glossiness reflectivity				
			
			newmtl.reflectGlossiness = mtl.mtl_refl_gloss
			
			if (mtl.mtl_refl_gl_map != undefined) do
			(					
				if (mtl.mtl_refl_gloss != 1) then
				(	
					newmtl.texmapReflectGlossiness                        		=  output()  
					newmtl.texmapReflectGlossiness.output.rgb_level 	= mtl.mtl_refl_gloss				
					newmtl.texmapReflectGlossiness.MAP1 					=  mtl.mtl_refl_gl_map  					
				)
				else			
					newmtl.texmapReflectGlossiness 							=  mtl.mtl_refl_gl_map  					
			)

			
			-- Fresnel			
			if (mtl.mtl_refl_fresnel_on == false) then	newmtl.fresnelIor = 999	
			else 															newmtl.fresnelIor = mtl.mtl_reflect_ior
			
			newmtl.ior 			= mtl.mtl_ior						
			
			-------------------------------------------------------------------------------------------------------
			-- Transparency
			-------------------------------------------------------------------------------------------------------
			newmtl.levelRefract = mtl.mtl_transparency_mult
			newmtl.colorRefract = mtl.mtl_transparency_color
			
			newmtl.caustics = true
			
			refrTint = false					
			if (mtl.mtl_transparency_mult_on == on) then	refrTint = true
							
			if (mtl.mtl_transparency_map != undefined) do
			(					
				if (mtl.mtl_transparency_mult != 1) then
				(	
					newmtl.texmapRefract                        	=  output()  
					newmtl.texmapRefract.output.rgb_level	= mtl.mtl_transparency_mult						

					if (refrTint) then
					(
						newmtl.texmapRefract.MAP1         	= RGB_Tint()													
						newmtl.texmapRefract.MAP1.red   	= color (mtl.mtl_transparency_color.r) (0) (0)
						newmtl.texmapRefract.MAP1.green	= color (0) (mtl.mtl_transparency_color.g) (0)
						newmtl.texmapRefract.MAP1.blue	= color (0) (0) (mtl.mtl_transparency_color.b)									
						newmtl.texmapRefract.MAP1.MAP1	= mtl.mtl_transparency_map  					
					)
					else
						newmtl.texmapRefract.MAP1			=  mtl.mtl_transparency_map  					
				)
				else			
				(				
					if (refrTint) then
					(
						newmtl.texmapRefract         	= RGB_Tint()													
						newmtl.texmapRefract.red    	= color (mtl.mtl_transparency_color.r) (0) (0)
						newmtl.texmapRefract.green	= color (0) (mtl.mtl_transparency_color.g) (0)
						newmtl.texmapRefract.blue   	= color (0) (0) (mtl.mtl_transparency_color.b)						
						newmtl.texmapRefract.MAP1 	= mtl.mtl_transparency_map  					
					)
					else
						newmtl.texmapRefract 			=  mtl.mtl_transparency_map  					
				)
			)
			
			-- Glossy transparency

			newmtl.refractGlossiness = mtl.mtl_transp_gloss
			
			if (mtl.mtl_transp_gl_map != undefined) do
			(					
				if (mtl.mtl_transp_gloss != 1) then
				(	
					newmtl.texmapRefractGlossiness                        	=  output()  
					newmtl.texmapRefractGlossiness.output.rgb_level	= mtl.mtl_transp_gloss				
					newmtl.texmapRefractGlossiness.MAP1                	=  mtl.mtl_transp_gl_map  					
				)
				else			
					newmtl.texmapRefractGlossiness 							= mtl.mtl_transp_gl_map  					
			)
			
			newmtl.ior = mtl.mtl_ior

			-- Fog			
			
			newmtl.absorptionColor 		= mtl.mtl_fog_color
			newmtl.absorptionDistance	= mtl.mtl_fog_multiplier
			
			-- Thin (no refract)
			
			newmtl.thin = mtl.mtl_transparency_thin_on			
		
			-------------------------------------------------------------------------------------------------------
			-- Opacity
			-------------------------------------------------------------------------------------------------------

			newmtl.texmapOpacity = mtl.mtl_opacity_map		
			newmtl.opacityCutout != mtl.mtl_opacity_smooth
			
			-------------------------------------------------------------------------------------------------------
			-- Translucency
			-------------------------------------------------------------------------------------------------------			
			
			newmtl.levelTranslucency	= mtl.mtl_translucency_mult
			newmtl.colorTranslucency	= mtl.mtl_translucency_color


			translTint = false					
			if (mtl.mtl_translucency_mult_on == on) then	translTint = true
							
			if (mtl.mtl_translucency_map != undefined) do
			(					
				if (mtl.mtl_translucency_mult != 1) then
				(	
					newmtl.texmapTranslucency                        	=  output()  
					newmtl.texmapTranslucency.output.rgb_level	= mtl.mtl_translucency_mult						

					if (translTint) then
					(
						newmtl.texmapTranslucency.MAP1    		= RGB_Tint()													
						newmtl.texmapTranslucency.MAP1.red	= color (mtl.mtl_translucency_color.r) (0) (0)
						newmtl.texmapTranslucency.MAP1.green	= color (0) (mtl.mtl_translucency_color.g) (0)
						newmtl.texmapTranslucency.MAP1.blue	= color (0) (0) (mtl.mtl_translucency_color.b)									
						newmtl.texmapTranslucency.MAP1.MAP1	= mtl.mtl_translucency_map  					
					)
					else
						newmtl.texmapTranslucency.MAP1 			=  mtl.mtl_translucency_map  					
				)
				else			
				(				
					if (translTint) then
					(
						newmtl.texmapTranslucency         	= RGB_Tint()													
						newmtl.texmapTranslucency.red    	= color (mtl.mtl_translucency_color.r) (0) (0)
						newmtl.texmapTranslucency.green	= color (0) (mtl.mtl_translucency_color.g) (0)
						newmtl.texmapTranslucency.blue  	= color (0) (0) (mtl.mtl_translucency_color.b)						
						newmtl.texmapTranslucency.MAP1	= mtl.mtl_translucency_map  					
					)
					else
						newmtl.texmapTranslucency			=  mtl.mtl_translucency_map  					
				)
			)

			-------------------------------------------------------------------------------------------------------
			-- Emission
			-------------------------------------------------------------------------------------------------------

			newmtl.levelSelfIllum = mtl.mtl_emission_mult				
			newmtl.colorSelfIllum = mtl.mtl_emission_color
			
			emissTint = false					
			if (mtl.mtl_emission_mult_on == on) then emissTint = true
							
			if (mtl.mtl_emission_map != undefined) do
			(					
				if (emissTint) then
				(
					newmtl.texmapSelfIllum         	= RGB_Tint()													
					newmtl.texmapSelfIllum.red    	= color (mtl.mtl_emission_color.r) (0) (0)
					newmtl.texmapSelfIllum.green 	= color (0) (mtl.mtl_emission_color.g) (0)
					newmtl.texmapSelfIllum.blue   	= color (0) (0) (mtl.mtl_emission_color.b)						
					newmtl.texmapSelfIllum.MAP1	= mtl.mtl_emission_map  					
				)
				else
					newmtl.texmapSelfIllum			=  mtl.mtl_emission_map  					
			)			
			
			-------------------------------------------------------------------------------------------------------
			-- Relief
			-------------------------------------------------------------------------------------------------------
			
			newmtl.mapamountBump	= mtl.mtl_bump_amount
			newmtl.texmapBump       	= mtl.mtl_normal_map
			

		)--end hydraMaterial			

		MultiMaterial: 
		(
			-- function call itself to harvest the materials inside the MultiMaterial
			local u
			orgMtl = mtl
			
			for u = 1 to mtl.numsubs do 
			(
				ConvertHydraMatToCorona mtl[u] 
				mtl[u] = newmtl
			)					
			
			-- set so parent knows what to set...
			newmtl = mtl					
		)

		Blend: 
		(
			ConvertHydraMatToCorona mtl.map1
			mtl.map1 = newmtl
			ConvertHydraMatToCorona mtl.map2					
			mtl.map2 = newmtl					
			-- set so parent knows what to set...
			newmtl = mtl
		)
	)	 
)
	

fn ConvertHydraMatToVRay mtl=
(	
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
			
			newmtl.anisotropy 						= mtl.mtl_reflect_anisotropy 		
			newmtl.anisotropy_rotation 			= mtl.mtl_reflect_rotation * 360.0
			newmtl.texmap_anisotropy 			= mtl.mtl_reflect_anisotropy_map 			
			newmtl.texmap_anisotropy_rotation = mtl.mtl_reflect_rotation_map				
			
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
			case mtl.mtl_reflect_brdf of
			(            
				0: newmtl.brdf_type = 0 -- Phong
				1: newmtl.brdf_type = 1 -- Blinn
			)
			
			-------------------------------------------------------------------------------------------------------
			-- Transparency
			-------------------------------------------------------------------------------------------------------
			
			newmtl.Refraction = color (mtl.mtl_transparency_color.r * mtl.mtl_transparency_mult) (mtl.mtl_transparency_color.g * mtl.mtl_transparency_mult) (mtl.mtl_transparency_color.b * mtl.mtl_transparency_mult)
			
			newmtl.refraction_affectShadows = off
			
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
				ConvertHydraMatToVRay mtl[u] 
				mtl[u] = newmtl
			)					
			
			-- set so parent knows what to set...
			newmtl = mtl					
		)

		Blend: 
		(
			ConvertHydraMatToVRay mtl.map1
			mtl.map1 = newmtl
			ConvertHydraMatToVRay mtl.map2					
			mtl.map2 = newmtl					
			-- set so parent knows what to set...
			newmtl = mtl
		)
	)	 
) -- end fn  

	
fn ConvertHydraMatToOctane mtl=
(	
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
				ConvertHydraMatToOctane mtl[u] 
				mtl[u] = newmtl
			)					
			
			-- set so parent knows what to set...
			newmtl = mtl					
		)

		Blend: 
		(
			ConvertHydraMatToOctane mtl.map1
			mtl.map1 = newmtl
			ConvertHydraMatToOctane mtl.map2					
			mtl.map2 = newmtl					
			-- set so parent knows what to set...
			newmtl = mtl
		)
	)	 
) -- end fn  


-------------------------------------------
-- Convert lights functions
-------------------------------------------
fn ConvertIntensityToCd cLt = 
(
	local intensCd = cLt.intensity
	local sevenPI = 7.0 * PI
		
	case cLt.intensityUnits of
    (
	0: --INTENS_UNIT_IMAGE:
		(
			case cLt.type of
			(
				0: intensCd = cLt.intensity /  7.0														--TYPE_POINT
				1: intensCd = cLt.intensity / sevenPI * (       cLt.length * cLt.width) 	--TYPE_RECTANGLE
				2: intensCd = cLt.intensity / sevenPI * (PI * cLt.radius * cLt.radius) 	--TYPE_DISK
				3: intensCd = cLt.intensity / sevenPI * (PI * cLt.radius * cLt.radius) 	--TYPE_SPHERE
				4: intensCd = cLt.intensity / sevenPI * (PI * cLt.radius * cLt.length)  	--TYPE_CYLINDER
				5: intensCd = cLt.intensity / sevenPI * (       cLt.length * cLt.width) 	--TYPE_PORTAL:
			)
		)
	2: --INTENS_UNIT_LM:
		(
			if (cLt.type == 0 or cLt.type == 3 or cLt.type == 4) 	then intensCd = cLt.intensity / (4.0 * PI)
			else 																				 	intensCd = cLt.intensity / PI
		)
	)
	intensCd --return intensCd
)

fn ConvertCdToLm cLt cd =
(
	local lm = 0
	
	if (cLt.type == 0 or cLt.type == 4 or cLt.type == 5) then 	lm = cd * 4.0 * PI -- point, sphere and cylinder
    else      																			lm = cd * PI

	lm --return Lm
)

fn ConvertHydraLightToCorona cLt = 
(		
	newLight = CoronaLight on:cLt.on color:cLt.color targeted:cLt.targeted
			
	--intensity
	newLight.intensityUnits = 2 -- cd
	newLight.intensity = ConvertIntensityToCd cLt
	
	newLight.colorMode 			= 0
	newLight.blackbodyTemp	= cLt.kelvinTemp	
	
	--shape
	case cLt.type of 
	(
	0: ( -- point
		newLight.shape	= 0 -- sphere		
		newLight.width	= 0.0001
		)
	1: ( -- rectangle
			newLight.shape  			= 1		
			newLight.width 				= cLt.width
			newLight.height				= cLt.length
		)			
	2: ( --disk
			newLight.shape  			= 2	
			newLight.width 				= cLt.radius 
		)		
	3: ( --sphere
			newLight.shape 				= 0		
			newLight.width  	 		= cLt.radius
		)
	4: ( -- cylinder
			newLight.shape  			= 3		
			newLight.width 				= cLt.width
			newLight.height 			= cLt.length
		)			
	5:( --sky portal
			newLight.shape  			= 0		
			newLight.size0 				= cLt.width / 2
			newLight.size1 				= cLt.length / 2
			newLight.skylightPortal 	= on
		)
	)

	newLight.visibleDirectly = cLt.visInRender	
	
	newLight.iesOn 	= cLt.WEB_on
	if (cLt.WEB_file != undefined) then newLight.iesFile = cLt.WEB_file
	
	newLight
)

fn ConvertHydraSunSkyToCorona cLt = 
(		
	newLight = CoronaSun on:cLt.sun_on 		
	newLight
)

fn ConvertHydraLightToVRayIES cLt = 
(
	vLightIes = VRayIES enabled:cLt.on color:cLt.color targeted:cLt.targeted rotation_X:cLt.WEB_rotX rotation_Y:cLt.WEB_rotY rotation_Z:cLt.WEB_rotZ ies_file:cLt.WEB_file				
	
	case cLt.type of 
	(
	1: ( -- rectangle
			vLightIes.override_shape = on
			vLightIes.shape = 1				
			vLightIes.width 	= cLt.width 
			vLightIes.length	= cLt.length		
		)			
	2: ( --disk
			vLightIes.override_shape = on
			vLightIes.shape = 2				
			vLightIes.diameter = cLt.radius * 2
		)
	)	
				
	vLightIes.intensity_type = 1 -- cd	
	vLightIes.power = ConvertIntensityToCd cLt
	vLightIes
)
	
fn ConvertHydraLightToVRay cLt = 
(		
	newLight = VRayLight on:cLt.on color:cLt.color targeted:cLt.targeted
	newLight.invisible != cLt.visInRender				
	
	--intensity			
	newLight.normalizeColor = 1 -- lm
	cd = ConvertIntensityToCd cLt
	newLight.multiplier = ConvertCdToLm cLt cd			


	--shape
	case cLt.type of 
	(
	0: ( -- point
		newLight.type = 2 -- sphere		
		newLight.sizeLength = 0.0001
		
		if (cLt.WEB_on == on) do
			newLight = ConvertHydraLightToVRayIES cLt				
		)
	1: ( -- rectangle
			newLight.type  				= 0		
			newLight.size0 				= cLt.width / 2
			newLight.size1 				= cLt.length / 2

			if (cLt.WEB_on == on) do
				newLight = ConvertHydraLightToVRayIES cLt			
		)			
	2: ( --disk
			newLight.type  				= 4	
			newLight.sizeLength 		= cLt.radius 
		
			if (cLt.WEB_on == on) do
				newLight = ConvertHydraLightToVRayIES cLt				
		)		
	3: ( --sphere
			newLight.type 				= 2		
			newLight.sizeLength  	 	= cLt.radius
		)
	4: ( -- cylinder convert to rectangle
			newLight.type  				= 0		
			newLight.size0 				= cLt.width / 2
			newLight.size1 				= cLt.length / 2
		)			
	5:( --sky portal
			newLight.type  				= 0		
			newLight.size0 				= cLt.width / 2
			newLight.size1 				= cLt.length / 2
			newLight.skylightPortal 	= on
		)
	)
	
	newLight
)

fn ConvertHydraSunSkyToVRay cLt = 
(		
	newLight = VRaySun enabled:cLt.sun_on 		
	newLight
)

fn ConvertHydraLightToOctane cLt = 
(		
	newLight = OctaneLight enabled:cLt.on color:cLt.color
			
	newLight.Color_Type = 1
	newLight.temperature = cLt.kelvinTemp
	
	--intensity			
	newLight.power 	= ConvertIntensityToCd cLt * 0.001464128843338 -- cd to watt					

	--shape
	case cLt.type of 
	(
		0: ( -- point
			newLight.Geometry_Type 	= 1		
			newLight.size[1] 				= 0.0001
			newLight.size[2] 				= 0.0001
		)

	1: ( -- rectangle
			newLight.Geometry_Type 	= 0		
			newLight.size[1] 				= cLt.width
			newLight.size[2] 				=  cLt.length
		)			
	2: ( --disk
			newLight.Geometry_Type	= 2		
			newLight.size[1] 				= cLt.radius * 2
			newLight.size[2]				= cLt.radius * 2
		)		
	3: ( --sphere
			newLight.Geometry_Type 	= 1		
			newLight.size[1] 				= cLt.radius * 2
		)
	4: ( -- cylinder convert to rectangle
			newLight.Geometry_Type 	= 0		
			newLight.size[1] 				= cLt.width
			newLight.size[2] 				= cLt.length
		)			
	)

	newLight.visible = cLt.visInRender	
	newLight.FlipDir = on
	
	newLight
)


----------------------------------------------------------------------------------
-- Menu
----------------------------------------------------------------------------------

rollout ConvertFromHydra "Converter tool from Hydra to over render" width:400 height:380
(
    local mtls = sceneMaterials
    local sel  
	local mtl
	
	label 'lbl26' "Select output renderer:" pos:[80,10] width:120 height:20 align:#left    
    
    
	dropdownList 'selRender' "" pos:[210,10] width:100 height:21 items:#("Corona", "Octane", "V-Ray") align:#left
	
	GroupBox 'grp2' "Convert these materials as much as possible:" pos:[10,50] width:380 height:100 align:#left
	label 'lbl5' "Corona:   CoronaMtl, CoronaLightMtl." pos:[30,80] width:200 height:20 align:#left
	label 'lbl3' "Octane:   UniversalMtl" pos:[30,100] width:160 height:20 align:#left
	label 'lbl4' "V-Ray:    VRayMtl, VrayLightMtl." pos:[30,120] width:180 height:20 align:#left	
	
	GroupBox 'grp5' "Convert these lights as much as possible:" pos:[10,160] width:380 height:100 align:#left
	label 'lbl18' "Corona:   CoronaLight." pos:[30,190] width:150 height:20 align:#left
	label 'lbl16' "Octane:   OctaneLight" pos:[30,210] width:140 height:20 align:#left
	label 'lbl17' "V-Ray:    VRayLight, VRayIES." pos:[30,230] width:170 height:20 align:#left
	
	label 'lbl19' "WARNING! OPERATION NOT UNDO!" offset:[0, 20] align:#center

	button 'btnConvert' "Go!"  width:220 height:50 offset:[0, 10] align:#center	
	
	local currRender = 1
	on selRender selected i do currRender = i
	
	
	on btnConvert pressed do
	(	        
	    with undo on
	    (	
			-------------------------------------------			
			-- Convert materials
			-------------------------------------------
			
			local orgSceneMaterials = ConvertFromHydra.mtls
	        
	        for i = 1 to orgSceneMaterials.count do 
	        (
	            local u
	            
				if        (currRender == 1)	then ConvertHydraMatToCorona	orgSceneMaterials[i]  -- Corona
				else if (currRender == 2)	then ConvertHydraMatToOctane	orgSceneMaterials[i]  -- Octane
				else if (currRender == 3)	then ConvertHydraMatToVRay	orgSceneMaterials[i]  -- V-Ray
			
				print ("converted " + orgSceneMaterials[i].name)
				
				for u = 1 to objects.count do
				(
					if (objects[u].material == orgSceneMaterials[i]) do objects[u].material = newmtl							
				)	               
	        )	
			
			-------------------------------------------
			-- Convert lights
			-------------------------------------------
			if (currRender == 1) then --Corona 
			(							
				for i in (getClassInstances HydraLight) do (replaceInstances i (ConvertHydraLightToCorona i))
				try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()
					
				--for i in (getClassInstances HydraSunSky) do (replaceInstances i (ConvertHydraSunSkyToCorona i)) -- not work. what's wrong?
				--try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()
			)
			else if (currRender == 2) then --Octane
			(				
				for i in (getClassInstances HydraLight ) do (replaceInstances i (ConvertHydraLightToOctane i))
				try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()			
			)
			else if (currRender == 3) then  --Vray light
			(					
				for i in (getClassInstances HydraLight ) do (replaceInstances i (ConvertHydraLightToVRay i))
				try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()
					
				--for i in (getClassInstances HydraSunSky ) do (replaceInstances i (ConvertHydraSunSkyToVRay i)) -- not work. what's wrong?
				--try (delete (for i in lights where i.pos == [0,0,0] collect i)) catch()				
			)			
	    )	
	)
)
  

createDialog ConvertFromHydra
)--end ms