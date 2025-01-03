Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434781E8854
	for <linux-raid@vger.kernel.org>; Fri,  3 Jan 2025 09:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735897095; cv=none; b=WU6eksmc0I1mpYO19wIUILsU9nJgGJy6uAPMH5U2Bn6t4Z9OIhyaJ68T+cFczdDb0RTuZ2qtmOeJWPwuZ9T6fIp0q4K7gwsE4vRnvEjbrsa8ad4Y4eyOjpyjK7D3BAE8WjGqKT1hIa2EDx4A7jjcACOZSVc5CVRtFm0ZHDbw+n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735897095; c=relaxed/simple;
	bh=GonngvUv0gWzV4GI2DnwJvANzbFZMyap9oHjOlLe8eI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I1n9O25w4Bsx9A4KQkqhK+8RqlbNF9Iu/VAHKixie7yWjGhOKixp5V8nGsEL79WxhfQqypxMUht1vCqYOmMv+x8N/neo/SUY5odCr9/saqiACgIU4vruIKolf7UpiH/LPgpECEnyvjcBMCUlONy0Rg5R5pmD539JKYWuoeYUdO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: from mtkaczyk-private-dev (unknown [31.7.42.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPSA id AD779C4CECE;
	Fri,  3 Jan 2025 09:38:12 +0000 (UTC)
Date: Fri, 3 Jan 2025 10:38:01 +0100
From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Tomas Mudrunka <tomas.mudrunka@gmail.com>, linux-raid@vger.kernel.org,
 song@kernel.org, yukuai@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH] Export MDRAID bitmap on disk structure in UAPI header
 file
Message-ID: <20250103103801.1420d5d5@mtkaczyk-private-dev>
In-Reply-To: <65347b89-a7ef-927f-c6e7-0a1a08971248@huaweicloud.com>
References: <b541044b-7550-313d-4252-1a13068c2fd7@huaweicloud.com>
	<20250102114844.633313-1-tomas.mudrunka@gmail.com>
	<65347b89-a7ef-927f-c6e7-0a1a08971248@huaweicloud.com>
Organization: Linux development
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.34; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 3 Jan 2025 09:14:30 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> Hi,
>=20
> =E5=9C=A8 2025/01/02 19:48, Tomas Mudrunka =E5=86=99=E9=81=93:
> >> Just curious, what you guys do for filesystems like ext4/xfs, and
> >> they just define the same structure in user-space tools.
> >>
> >> looks like your tool do support to create ext4 images, and it's
> >> using ext4's use-space tools directly. If it's true, do you
> >> consider to use mdadm directly?
> >>
> >> Thanks,
> >> Kuai =20
> >=20
> > Yes, we do use external tools when possible. It is not possible
> > with mdadm. Mdadm cannot create disk image of MD RAID array. Kernel
> > does this. =20
>=20
> I'm a bit confused here, if you mean metadata, I think it's mdadm that
> write init metadata to disk, the only exception is dm-raid.

I think it means that currently you have to create kernel (MD) raid
device (assemble using metadata) to have a chance creating image.
>=20
> > We want/need purely userspace generator, so we don't have to care
> > about permissions, losetup, kernel-side mdraid runtime, etc... We
> > just want to generate valid image without involving kernel in any
> > way. =20
>=20
> I believe mdadm can do this, Mtkaczyk what do you think?

I agree. The right way is to incorporate it with mdadm.
We should create a volume image (data) without MD internals.

With that, we will have control on this functionality. Also, we will be
able to provide support for every metadata format.
>=20
> The problem is that system service will recognize raid disks and
> assemble the array automatically, you might what to disable them.

I don't think we need to care. They goal is to not have and use MD
module so mdadm will fail to load personalities.
>=20
> Thanks,
> Kuai
>=20
> > I was using mdadm before switching to genimage and it adds
> > complexity of handling all the edge cases of kernel states.
> > Mkfs.ext4 can create image without involving kernel, mdadm cannot,
> > it always instructs kernel to create the metadata for it when
> > creating array.
> >=20
> > In my opinion we should decide whether it makes sense for kernel to
> > export the structures in header file and either provide all of
> > them, or provide none. That might be valid reasoning to say every
> > userspace program should include its own definitions of structures.
> > But providing half does not make any sense.

Sorry, This is old application and some solutions are here for years-
they are working so nobody tried to change them. If you are looking for
challenges this software is full of them!

Thanks,
Mariusz
