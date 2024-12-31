Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B134ACA4B
	for <linux-raid@vger.kernel.org>; Tue, 31 Dec 2024 14:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735654988; cv=none; b=vFjCu4rWT7U8PMzBe275x474+mqWbQR1A0LHJr9zaYExtCgt0nvgigdbDU5335pJnL0I0doYqyU1qCb0mbwhLTFS2M6n5HNAf0SI1UngtFUj7XytkHvlqtu+PIjJYoXIm3vPze86oUS44TEc1+KP4swJaDe+2VQIJaHvMcKKPXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735654988; c=relaxed/simple;
	bh=9tAb4UaLbZDrDvfTfSPDaqKac6tsmxJ0dojA+Y/D8wU=;
	h=Date:From:To:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MXQYKG5EwizWRKAuR4e6PZWlCtW0efmYenKLmmSOcVKDFNTr6lpbkPM1EGpV0uRrZmYno0FTeXltulAFkcBxEtKx+jz4r7yyALs/hJ2W/z3R0m3SOW1V9NCp/am4zPX1GZEtwzESqjufV+oRNciGbZFrTPCmciapj8fMESNfMWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: from mtkaczyk-private-dev (unknown [31.7.42.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPSA id 5E0DCC4CED2;
	Tue, 31 Dec 2024 14:23:06 +0000 (UTC)
Date: Tue, 31 Dec 2024 15:23:02 +0100
From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
To: =?UTF-8?B?VG9tw6HFoSBNdWRydcWIa2E=?= <tomas.mudrunka@gmail.com>,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, <yukuai@kernel.org>
Subject: Re: [PATCH] Export MDRAID bitmap on disk structure in UAPI header
 file
Message-ID: <20241231152302.3dc7a710@mtkaczyk-private-dev>
In-Reply-To: <20241231123108.215cc05e@mtkaczyk-private-dev>
References: <20241231030929.246059-1-tomas.mudrunka@gmail.com>
	<ebbec264-7669-03fd-7ffd-3c728168cdd5@huaweicloud.com>
	<20241231095942.446f4d4a@mtkaczyk-private-dev>
	<CAH2-hc+QK0SZgDjOScegsDk8R8gQEZgJ5Vg1M1J_v-yDEym=Dw@mail.gmail.com>
	<20241231123108.215cc05e@mtkaczyk-private-dev>
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

Sorry missclick, adding linux-raid now.
I think we don't need to spam on linux-kernel as these are MD internals.

Kuai please take a look again.

Thanks,
Mariusz

On Tue, 31 Dec 2024 12:31:08 +0100
Mariusz Tkaczyk <mtkaczyk@kernel.org> wrote:

> On Tue, 31 Dec 2024 12:00:31 +0100
> Tom=C3=A1=C5=A1 Mudru=C5=88ka <tomas.mudrunka@gmail.com> wrote:
>=20
> > > > Thanks for the patch, however, Why do you want to directly
> > > > manipulate the metadata instead of using mdadm? You must first
> > > > provide an explanation to convince us that what you're doing
> > > > makes sense, and it's best to show your work. =20
> >=20
> > I am adding MD RAID support to genimage tool:
> > https://github.com/pengutronix/genimage/
> >=20
> > It is used to generate firmware/disk images. Without such a tool it
> > is impossible to build disk image containing md raid metadata
> > without actually assembling it in the kernel via losetup or
> > something...
> >=20
> > I am already using #include <linux/raid/md_p.h> which includes
> > references to bitmap structures:
> >=20
> > $ grep -ri bitmap /usr/include/linux/raid/md_p.h
> > #define    MD_SB_BITMAP_PRESENT    8 /* bitmap may be present nearby
> > */ __le32    feature_map;    /* bit 0 set if 'bitmap_offset' is
> > meaningful */ __le32    bitmap_offset;    /* sectors after start of
> > superblock that bitmap starts
> >                      * NOTE: signed, so bitmap can be before
> > superblock #define MD_FEATURE_BITMAP_OFFSET    1
> > #define    MD_FEATURE_RECOVERY_BITMAP    128 /* recovery that is
> > happening
> >                          * is guided by bitmap.
> > #define    MD_FEATURE_ALL            (MD_FEATURE_BITMAP_OFFSET    \
> >                     |MD_FEATURE_RECOVERY_BITMAP    \
> >=20
> > But when i use those, the resulting metadata is invalid, unless i
> > populate the structures from drivers/md/md-bitmap.h so i had to
> > copypaste its contents to my code, but i am not happy about it
> > (including half and copypasting half):
>=20
> https://github.com/md-raid-utilities/mdadm/blob/main/bitmap.h
>=20
> Correct me if I'm wrong but looks like it is what we did in mdadm.
> Well, If you don't want to care about it, you can consider adding
> mdadm as submodule in your application and use mdadm's headers.
>=20
> Just an option, I have no hard feelings here.
>=20
> Looking into that now make me more feeling that we should export this
> header long time ago instead of reimplementing it in mdadm. Kuai, what
> do you think?
>=20
> >=20
> > https://github.com/Harvie/genimage/blob/master/image-mdraid.c
> >=20
> > > I'm with Kuai here. I would also add that for such purposes you
> > > can use externally managed metadata, not native. External
> > > management was proposed to address your problem however over the
> > > years it turned out to not be good conception (kernel driver
> > > relies on userspace daemon which is not secure).
> > >
> > > Thanks,
> > > Mariusz =20
> >=20
> > Hope my reply is sufficient.
> >=20
> > Thank you guys!
> > Tom
>=20
> Looks like old problem we get used to. If Kuai agrees too, I'm open to
> add this but.. as a mdadm maintainer (primary tool to manipulate
> mdraid) I would like you to handle this on mdadm site too to make sure
> we have it consistent and we exported exactly what is needed.
>=20
> Hope, it has some sense now!
> Thanks,
> Mariusz

