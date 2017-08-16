/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2017 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Based on Amazing Surf Mod 1 from Mandelbulber3D, a formula proposed by Kali,
 * with features added by Darkbeam
 * @reference
 * http://www.fractalforums.com/mandelbulb-3d/custom-formulas-and-transforms-release-t17106/
 */

/* ### This file has been autogenerated. Remove this line, to prevent override. ### */

#include "cl_kernel_include_headers.h"

REAL4 AmazingSurfMod1Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	aux->actualScale = mad(
		(fabs(aux->actualScale) - 1.0f), fractal->mandelboxVary4D.scaleVary, fractal->mandelbox.scale);
	if (fractal->transformCommon.functionEnabledAx)
	{
		z.x = fabs(z.x + fractal->transformCommon.additionConstant111.x)
					- fabs(z.x - fractal->transformCommon.additionConstant111.x) - z.x;
		z.y = fabs(z.y + fractal->transformCommon.additionConstant111.y)
					- fabs(z.y - fractal->transformCommon.additionConstant111.y) - z.y;
	}

	// z = fold - fabs( fabs(z) - fold)
	if (fractal->transformCommon.functionEnabledAyFalse)
	{
		z.x = fractal->transformCommon.additionConstant111.x
					- fabs(fabs(z.x) - fractal->transformCommon.additionConstant111.x);
		z.y = fractal->transformCommon.additionConstant111.y
					- fabs(fabs(z.y) - fractal->transformCommon.additionConstant111.y);
	}

	if (fractal->transformCommon.functionEnabledAzFalse)
	{
		z.x = fabs(z.x + fractal->transformCommon.additionConstant111.x);
		z.y = fabs(z.y + fractal->transformCommon.additionConstant111.y);
	}

	// if z > limit) z =  Value -z,   else if z < limit) z = - Value - z,
	if (fractal->transformCommon.functionEnabledxFalse)
	{
		if (fabs(z.x) > fractal->transformCommon.additionConstant111.x)
		{
			z.x = mad(sign(z.x), fractal->mandelbox.foldingValue, -z.x);
		}
		if (fabs(z.y) > fractal->transformCommon.additionConstant111.y)
		{
			z.y = mad(sign(z.y), fractal->mandelbox.foldingValue, -z.y);
		}
	}

	// z = fold2 - fabs( fabs(z + fold) - fold2) - fabs(fold)
	if (fractal->transformCommon.functionEnabledyFalse)
	{
		z.x = fractal->transformCommon.offset2
					- fabs(fabs(z.x + fractal->transformCommon.additionConstant111.x)
								 - fractal->transformCommon.offset2)
					- fractal->transformCommon.additionConstant111.x;
		z.y = fractal->transformCommon.offset2
					- fabs(fabs(z.y + fractal->transformCommon.additionConstant111.y)
								 - fractal->transformCommon.offset2)
					- fractal->transformCommon.additionConstant111.y;
	}

	z += fractal->transformCommon.additionConstant000;

	REAL r2;
	r2 = dot(z, z);
	if (fractal->transformCommon.functionEnabledFalse) // force cylinder fold
		r2 -= z.z * z.z;

	// if (r2 < 1e-21f)
	//	r2 = 1e-21f;

	REAL sqrtMinR = fractal->transformCommon.sqtR;
	if (r2 < sqrtMinR)
	{
		z *= fractal->transformCommon.mboxFactor1;
		aux->DE *= fractal->transformCommon.mboxFactor1;
		aux->color += fractal->mandelbox.color.factorSp1;
	}
	else if (r2 < 1.0f)
	{
		z *= native_recip(r2);
		aux->DE *= native_recip(r2);
		aux->color += fractal->mandelbox.color.factorSp2;
	}

	z *= mad(aux->actualScale, fractal->transformCommon.scale1,
		1.0f * (1.0f - fractal->transformCommon.scale1));
	aux->DE = mad(aux->DE, fabs(aux->actualScale), 1.0f);

	z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);

	aux->foldFactor = fractal->foldColor.compFold0; // fold group weight
	aux->minRFactor = fractal->foldColor.compMinR;	// orbit trap weight

	REAL scaleColor = fractal->foldColor.colorMin + fabs(fractal->mandelbox.scale);
	// scaleColor += fabs(fractal->mandelbox.scale);
	aux->scaleFactor = scaleColor * fractal->foldColor.compScale;
	return z;
}