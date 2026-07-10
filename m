Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA78A3F871A
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783690609; cv=none; b=GGL7abyLkHlwQPa2CyAjz8aIyntgKXVwljN9yaA1k60QwOb3RcKVOXeK33rPuFAty2aRzKSrLTj47wb2/oJB4AiDdeECHGI6iJ77Ts7dLWmYRyIGTaxq2eJFhFh2qocM4eHgBMrQKkqyInzQdPBisnyv3NyuCUK9pDFo706hiqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783690609; c=relaxed/simple;
	bh=M5j3ddcJCvAPLEqFS8nu3ZL6ANh9fd/36Tg+GQme178=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SRU8Aw2c8oNirvjLE+D7kEM4siiCY4o+yydciZjRBmSvXBti3BTD45T7KIVlZCrrARFnQRPVomHvR2xPqOeieHSxDm03fFOaIdV0WdIgfYcn+3d7s8ZUuEM1BghG7KIpjrb64HMWzYs3BJ3mfkJe9AMKFPwu1Kr4PJ8EQannkwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ugu+1yBO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ugu+1yBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F011F000E9;
	Fri, 10 Jul 2026 13:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783690607;
	bh=uO2gOo/dy3HjLUmN50hsKTkVkALIBu/Sq9siDylQAnY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ugu+1yBOXJbYT8C/Ofg2F9/hJ4i2qfA0GHwCoAOnAGejbjR6N7N1bwh/FygeTLkyQ
	 5WJDWd9NoW0Eop8MDbvIfMCXApmQfIlJ+PKe/EynWfwFAGlX/wW4dAbTYd0RKmpFKI
	 Ni446H2tjCOSAwbxgsOixRjMFNUBreEbXAzIQDiEEL5wj4WJdhdFvSAtpHxoRK7kJj
	 Vq4ajh3J7Y7Gfrgf5zLLhbcKGWLEc14J+gICLjzm7qPazS73bHA0ihlZWyd/ObwYR7
	 WW04ahuS0svW6gsY10ZBxbnGnP1X59SjDlo85okmCc3Iz8GV61AX2n6f2yAvd3CNtK
	 gEm2dGEMhetPg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/6] md/raid5: make the stripe batch size a module
 parameter
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hiroshi Nishida" <nishidafmly@gmail.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260710132346.7295-5-nishidafmly@gmail.com>
References: <20260710132346.7295-1-nishidafmly@gmail.com>
 <20260710132346.7295-5-nishidafmly@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 13:36:46 +0000
Message-Id: <20260710133647.43F011F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Large unsigned values of `max_stripe_batch` are incorrectly clamped=
 to 1 instead of 32.
--

--- Patch [4]: [PATCH 4/6] md/raid5: make the stripe batch size a module pa=
rameter ---
commit 5fef4dd203fcdfd7a223e9904fbea20f876f265b
Author: Hiroshi Nishida <nishidafmly@gmail.com>

md/raid5: make the stripe batch size a module parameter

This commit makes the stripe batch size a configurable module parameter to
allow tuning for busy multi-threaded arrays. It synchronizes the dequeue
cap and the spawn divisor by tying both to a single per-array variable.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c

[ ... ]

> @@ -7640,6 +7645,10 @@ static struct r5conf *setup_conf(struct mddev *mdd=
ev)
>  	    !conf->temp_inactive_list)
>  		goto abort;
> =20
> +	/* Resolve the stripe batch size (see STRIPE_BATCH_* in raid5.h). */
> +	conf->max_stripe_batch =3D clamp_t(int, max_stripe_batch,
> +					 1, STRIPE_BATCH_MAX);

[Severity: Low]
Does this code incorrectly clamp large unsigned values to 1 instead of 32?

Since max_stripe_batch is defined as an unsigned int, if an administrator
provides a value greater than INT_MAX, the clamp_t(int, ...) cast will treat
it as a negative number.

This will cause it to be clamped to the minimum bound of 1, rather than the
intended maximum bound of STRIPE_BATCH_MAX.

> +
>  #if PAGE_SIZE !=3D DEFAULT_STRIPE_SIZE
>  	conf->stripe_size =3D DEFAULT_STRIPE_SIZE;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710132346.7295=
-1-nishidafmly@gmail.com?part=3D4
