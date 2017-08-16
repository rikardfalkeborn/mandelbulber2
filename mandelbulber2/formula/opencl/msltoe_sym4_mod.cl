/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2017 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * MsltoeSym4Mod  Based on the formula from Mandelbulb3D
 * @reference http://www.fractalforums.com/theory/choosing-the-squaring-formula-by-location/15/
 */

/* ### This file has been autogenerated. Remove this line, to prevent override. ### */

#include "cl_kernel_include_headers.h"

REAL4 MsltoeSym4ModIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 c = aux->const_c;

	aux->r_dz = aux->r_dz * 2.0f * aux->r;
	REAL4 temp = z;
	REAL tempL = length(temp);
	// if (tempL < 1e-21f)
	//	tempL = 1e-21f;
	z *= fractal->transformCommon.scale3D111;

	aux->r_dz *= fabs(native_divide(length(z), tempL));

	if (fabs(z.x) < fabs(z.z))
	{
		REAL temp = z.x;
		z.x = z.z;
		z.z = temp;
	}
	if (fabs(z.x) < fabs(z.y))
	{
		REAL temp = z.x;
		z.x = z.y;
		z.y = temp;
	}
	if (fabs(z.y) < fabs(z.z))
	{
		REAL temp = z.y;
		z.y = z.z;
		z.z = temp;
	}

	if (z.x * z.z < 0.0f) z.z = -z.z;
	if (z.x * z.y < 0.0f) z.y = -z.y;

	temp.x = mad(-z.z, z.z, mad(z.x, z.x, -z.y * z.y));
	temp.y = 2.0f * z.x * z.y;
	temp.z = 2.0f * z.x * z.z;

	z = temp + fractal->transformCommon.additionConstant000;

	if (fractal->transformCommon.rotationEnabled)
	{
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);
	}

	if (fractal->transformCommon.addCpixelEnabledFalse)
	{
		REAL4 tempFAB = c;
		if (fractal->transformCommon.functionEnabledx) tempFAB.x = fabs(tempFAB.x);
		if (fractal->transformCommon.functionEnabledy) tempFAB.y = fabs(tempFAB.y);
		if (fractal->transformCommon.functionEnabledz) tempFAB.z = fabs(tempFAB.z);

		tempFAB *= fractal->transformCommon.constantMultiplier000;
		z.x += sign(z.x) * tempFAB.x;
		z.y += sign(z.y) * tempFAB.y;
		z.z += sign(z.z) * tempFAB.z;
	}
	REAL lengthTempZ = length(-z);
	// if (lengthTempZ > -1e-21f)
	//	lengthTempZ = -1e-21f;   //  z is neg.)
	z *= 1.0f + native_divide(fractal->transformCommon.offset, lengthTempZ);
	z *= fractal->transformCommon.scale1;
	aux->r_dz *= fabs(fractal->transformCommon.scale1);
	return z;
}