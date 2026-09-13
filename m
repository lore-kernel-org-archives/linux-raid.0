Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8106379993
	for <linux-raid@vger.kernel.org>; Sun, 13 Sep 2026 23:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789343520; cv=none; b=lnTi5IsFSMhdgj0q0rdUcXSHF6SA14tFpfSuB+DyweiXyMtO87+QFg2ekRcAtxBBS0iDiaj21ocuBB/4ywC6mF2kUVL7BHD6QqEs6/7FNr73rFw+KzYKMRAnOs6JDqC/HoAOq1BTO1O9AaJsh8CdgQKwxsNhGbpTyhVf0zgfXho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789343520; c=relaxed/simple;
	bh=4SkibaXj3C9G81Wjj2aCFkbxOzLJ/YybY7cvQFTcDeQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aQVcXVnZIhyidlWm+ASEaalumZZ4CBRTRHNGVfLcc8rRxULc9/JAkk29BdbYsYHhZ77LI17Qav5QhJ4OSKZVsaVSbbAvRzGbXgmL0JNC4EyDyhY1/SvvY/wKlmFH+s3u9CjqLsxTTk+p7W5x4ObMsHiPps87HHSJnZ+UsUN00Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K9j+b4MP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K9j+b4MP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D681F000FF;
	Sun, 13 Sep 2026 23:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789343516;
	bh=vgFuNN5vy7BxMbuWJkgEPamACOKnRRLP6Sk+ueNFuE4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K9j+b4MPkav0BI7qs4F89FJ4TuQ+hEacqSAtEU4hNcNrPHsbdrNev/Rz3Zax+KXbz
	 vngAjEFLXwwULvPkAV6RD866S7XREEY7c68PnjUzPeC8e2QmoclrE6mvKHNuWMjtjj
	 /t9wwNA6pOua1qtd3EoCeO+eKPNZoaaTiNsJOMYpFY5RjSDaBbSPcQf8Iap+gI8y34
	 tB7TTDIMcSVpyQ7ZAud3ghYDpAOz8Lap7+mM7oe4BBzVB/u8WnWr+FO8kTJJgT+cFV
	 Oq5hq091e4TM2NfWXqe6XjeHQpsWs+01yVIVY26Xsus7xG3t8BSqH2jhyvb8ftDLPP
	 iIxixXdSnQv/A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: add max_disks bound check in older version
Reply-To: sashiko-reviews@lists.linux.dev
To: "Aaditya Kansal" <aadityakansal390@gmail.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260913233717.464321-1-aadityakansal390@gmail.com>
References: <6aa6deac.f670cee1.72fc4.0013.GAE@google.com>
 <20260913233717.464321-1-aadityakansal390@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 13 Sep 2026 23:51:55 +0000
Message-Id: <20260913235156.20D681F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] The patch prevents an out-of-bounds write in `super_90_sync()`=
 by adding a bounds check, but leaves an out-of-bounds read unhandled at th=
e end of the function, which can be exploited as a kernel information leak.
- [High] A maliciously crafted version 0.90 superblock on disk can trigger =
an out-of-bounds read in `super_90_validate()` due to completely missing bo=
unds validation of `this_disk.number` when the superblock is loaded.
--

commit bca793f34834f5048d928e016591b4ea5cf035dc
Author: Aaditya Kansal <aadityakansal390@gmail.com>

md: add max_disks bound check in older version

This commit adds bounds checking for raid_disks in super_90_sync() to preve=
nt
an array-index-out-of-bounds access. It addresses a syzbot report where
a high value written to the raid_disks sysfs attribute triggered the bug.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1693,6 +1693,12 @@ static void super_90_sync(struct mddev *mddev, str=
uct md_rdev *rdev)
>  			desc_nr =3D rdev2->raid_disk;
>  		else
>  			desc_nr =3D next_spare++;
> +
> +		if (desc_nr >=3D MD_SB_DISKS) {
> +			pr_warn("md: raid_disks =3D %d exceeds max_disks =3D %d for version 0=
.90\n",
> +					desc_nr, MD_SB_DISKS);
> +			continue;
> +		}

[Severity: Critical]
This isn't a bug introduced by this patch, but could this continue statement
leave rdev->desc_nr unvalidated, leading to an out-of-bounds read later?

If an attacker provides a malicious block device with a version 0.90
superblock containing a large this_disk.number, super_90_load() assigns
this to rdev->desc_nr. Later, when md_update_sb() calls super_90_sync(),
the newly added bounds check skips updating rdev2->desc_nr because of the
continue statement.

At the end of super_90_sync(), the unvalidated rdev->desc_nr is then
unconditionally used to index into the array:

drivers/md/md.c:super_90_sync() {
    ...
    sb->this_disk =3D sb->disks[rdev->desc_nr];
    sb->sb_csum =3D calc_sb_csum(sb);
}

This copies 128 bytes from memory far past the 4KB superblock page into
sb->this_disk. The updated superblock is then written back to disk, which
can persistently leak out-of-bounds kernel memory to the attacker.
Alternatively, if raid_disks is manipulated via sysfs for a new disk,
rdev->desc_nr could remain -1, triggering a UBSAN out-of-bounds read.

[Severity: High]
This is a pre-existing issue, but does super_90_load() completely miss
bounds validation of this_disk.number when the superblock is loaded?

drivers/md/md.c:super_90_load() {
    ...
    rdev->desc_nr =3D sb->this_disk.number;
    ...
}

When a block device with a crafted version 0.90 superblock is discovered
and assembled, super_90_load() blindly assigns this field without ensuring
it is less than MD_SB_DISKS. Subsequently, super_90_validate() computes
and dereferences an out-of-bounds pointer:

drivers/md/md.c:super_90_validate() {
    ...
    if (sb->disks[rdev->desc_nr].state & (
                (1<<MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE)))
        ...
    desc =3D sb->disks + rdev->desc_nr;
    if (desc->state & (1<<MD_DISK_FAULTY))
        ...
}

For large values, this dereferences a pointer significantly past the
allocated 4KB superblock page, hitting unmapped memory and causing a kernel
panic. Can bounds validation be added to super_90_load() to prevent this
denial-of-service vector?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260913233717.4643=
21-1-aadityakansal390@gmail.com?part=3D1
