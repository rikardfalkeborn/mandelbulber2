/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2017 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Adds Cpixel constant to z vector
 */

/* ### This file has been autogenerated. Remove this line, to prevent override. ### */

#include "cl_kernel_include_headers.h"

REAL4 TransfAddCpixelIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	z += aux->const_c * fractal->transformCommon.constantMultiplier111;
	return z;
}