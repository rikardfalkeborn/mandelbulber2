/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2017 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * multiple angle
 */

/* ### This file has been autogenerated. Remove this line, to prevent override. ### */

#include "cl_kernel_include_headers.h"

REAL4 TransfMultipleAngleIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL th0 = asin(native_divide(z.z, aux->r));
	REAL ph0 = atan2(z.y, z.x);
	REAL th = th0 * fractal->transformCommon.multiplication;
	REAL ph = ph0 * fractal->transformCommon.multiplication;
	REAL cth = native_cos(th);
	z = (REAL4){cth * native_cos(ph), cth * native_sin(ph), native_sin(th), 0.0f} * aux->r;
	return z;
}