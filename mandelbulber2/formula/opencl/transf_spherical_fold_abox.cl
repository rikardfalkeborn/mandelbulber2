/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2017 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * spherical fold ABox
 * from Fractal Forums and M3D
 * @reference
 * http://www.fractalforums.com/mandelbulb-3d/custom-formulas-and-transforms-release-t17106/
 */

/* ### This file has been autogenerated. Remove this line, to prevent override. ### */

#include "cl_kernel_include_headers.h"

REAL4 TransfSphericalFoldAboxIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL r2 = dot(z, z);
	z += fractal->mandelbox.offset;
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
	z -= fractal->mandelbox.offset;
	return z;
}