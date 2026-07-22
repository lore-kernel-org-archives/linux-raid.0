Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59136470E8B;
	Wed, 22 Jul 2026 19:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784747147; cv=none; b=deLBKyyjpFxtAX5BpFzBk6QkJHP26Dsn9kuELnjtRQmTLtTSfRkrbSXTevzOEHhjcCgx7TNPRay+1olYZc7oMsM2s+YP+EkHYbTNweJoyz9pLeu4ojFK0+3XqtRbyJ5S4Wk6+JXZVMuY1gXjBBwjV8l/WOGpQt6wNfmULBmrb7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784747147; c=relaxed/simple;
	bh=5zHhL/GTKl6/tuHAxlRNGG3pDyMAnSavcqnSvY+Q+lU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=feOB/V0N9rhRmYs5zXVb95dKHRlvdEgtQ6T0rzrnoQGdzbMhAX6M1ljhxdceiMAOfTjTciMcfjC6SAM4i4iAkgItCU0YCn7loQJc5RbkAdiDVpNmB8ddqL/I+k2zV9Cqdah65sqMHynwQQQdU1lWOj3OWZedmZCIKo91dQfSk+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AarEnpwm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AarEnpwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA951F000E9;
	Wed, 22 Jul 2026 19:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784747142;
	bh=5zHhL/GTKl6/tuHAxlRNGG3pDyMAnSavcqnSvY+Q+lU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AarEnpwmXIulE1TU5TH9hic2RdKg6VJyOSVS2jOqd3rbyZ0HjGCVJcyOi/sAug6xo
	 3/6a6KGmu0nK+Q1vedZDIptIQwAW/EPv6G2GmGjV695L/rSEq2fV1G+DchmfD1pj5Q
	 hMSwHC2xhc+BaKrD6GcC9/ZzJtDkBHjNsSK7mFbuXb9oWghRknDi+Lt8FjB4hxIC+E
	 xxID2woWShph9z3g71+sOvIMvjybmxmavrRF0xN9dindWv/Sh5rhAhzDrkYBeMq96G
	 ubV7RLksY1nSlXBTIvQytwbDxFF2N2UX2izWcCqLONFTP+0Eq8rpZdqJ0VQQHag7v1
	 +6rW1voGupRWg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 5/9] md/raid1,raid10: factor out raid1_write_error()
 helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-pci@vger.kernel.org, linux-raid@vger.kernel.org
In-Reply-To: <20260722185841.449934-6-mykola@meshstor.io>
References: <20260722185841.449934-1-mykola@meshstor.io>
 <20260722185841.449934-6-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 19:05:41 +0000
Message-Id: <20260722190542.2DA951F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

> From: Logan Gunthorpe <logang@deltatee.com>
>=20
> Factor out a common raid1_write_error() helper from raid1.c and
> raid10.c.
>=20
> This will help reduce code duplication in subsequent patches.
>=20
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722185841.4499=
34-1-mykola@meshstor.io?part=3D5

