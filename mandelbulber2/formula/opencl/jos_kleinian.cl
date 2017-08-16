/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2017 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * JosLeys-Kleinian formula
 * @reference
 * http://www.fractalforums.com/3d-fractal-generation/an-escape-tim-algorithm-for-kleinian-group-limit-sets/msg98248/#msg98248
 */

/* ### This file has been autogenerated. Remove this line, to prevent override. ### */

#include "cl_kernel_include_headers.h"

REAL4 JosKleinianIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL a = fractal->transformCommon.foldingValue;
	REAL b = fractal->transformCommon.offset;
	REAL f = sign(b);

	REAL4 box_size = fractal->transformCommon.offset111;

	REAL3 box1 = (REAL3){2.0f * box_size.x, a * box_size.y, 2.0f * box_size.z};
	REAL3 box2 = (REAL3){-box_size.x, -box_size.y + 1.0f, -box_size.z};
	REAL3 wrapped = wrap(z.xyz, box1, box2);

	z = (REAL4){wrapped.x, wrapped.y, wrapped.z, z.w};

	// If above the separation line, rotate by 180deg about (-b/2, a/2)
	if (z.y
			>= a * (0.5f
							 + 0.2f * native_sin(f * M_PI_F * native_divide((mad(b, 0.5f, z.x)), box_size.x))))
		z = (REAL4){-b, a, 0.f, z.w} - z; // z.xy = vec2(-b, a) - z.xy;

	REAL z2 = dot(z, z);

	REAL4 colorVector = (REAL4){z.x, z.y, z.z, z2};
	aux->color = min(aux->color, length(colorVector)); // For coloring

	REAL iR = native_recip(z2);
	z *= -iR;
	z.x = -b - z.x;
	z.y = a + z.y;
	aux->pseudoKleinianDE *= iR;
	return z;
}