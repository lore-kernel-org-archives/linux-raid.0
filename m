Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9AC1E1024
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 15:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784473229; cv=none; b=ZzvVLRftfF10KKMfEclB3N8JTHMPjR728Lk3cwgFabxGSA8n8SBSG4s9H0RMlcyWzgRufBLpIcbfFI9yEdFLMvjQYZgenu3ASxzyhnZ7m+fW0qGPUDjbcu7VB/plnaCVae2MSv49KD25fjthQVWROhXyl5rTHtqmMVFq7WUpBoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784473229; c=relaxed/simple;
	bh=5CEQmtRbSaq0plCFFZSrLEwfdn3X2jqyMGfWUsld7OM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dZ9n2Sal70WUlMUVxVpOgTkplBs2HXKahfSi553glUO8CkBpBcEZHok6pvmcl9pIl6qafSfO/q55D7Hq9MdYfzJAzln6NesPfafYKm5mbF3uZf2aUFR0sKcRB2+nxOE6Rn93ASgyWepDFtG7Bk1hD3dABCsLlTZNYhPdHeEgGzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iUZyuC0W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iUZyuC0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04B21F000E9;
	Sun, 19 Jul 2026 15:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784473228;
	bh=bl+SnW1fu5KM+2kVRIBmi9E/Cf3pkRl/hj3ZwgQG9Uc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iUZyuC0WHxehiMti+7RjZ7oP8yLx4YDRdr8Cip1F60fIJaHU+5Yx3UyngKjrf2Tjx
	 WkoSIpFMsjE+MpouwhzgpE8rfMWCE9Y70CyGgLCkPiXYT4G3UdUdAKqNoOSzf7Qd7P
	 kNjL+6PBmtVgTH2/XGBwTKbAL/HHwpnVbeZE6csF53lfrJ1ZPsgDH0MY7JNoBEwUNz
	 x9csdLjcsGvp7pLrSbVOUDrfd3Gbma/5DMWMRKB3CDpl+/UZjS+oEalwlnkGUHoS9E
	 lyOmRHwAlb06P1nv7Ek/nCaGqvtzlYCIRpvBQJ+iamHGegMRq+th/RF7pUoOEe2RtV
	 MO10CiSI7mtvQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/4] md/md-llbitmap: mask sb->state on load to drop
 runtime-only bits
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260719144409.940492-3-mykola@meshstor.io>
References: <20260719144409.940492-1-mykola@meshstor.io>
 <20260719144409.940492-3-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 19 Jul 2026 15:00:27 +0000
Message-Id: <20260719150027.D04B21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Teardown symmetry bug: `llbitmap_destroy()` deletes the daemon tim=
er and waits for the daemon work, but the work can re-arm the timer, leadin=
g to a use-after-free when the timer fires on the freed `llbitmap` object.
- [High] Preexisting UAF in llbitmap_create() error path due to clearing md=
dev->bitmap outside the mutex after kfree.
- [High] Preexisting race condition in llbitmap_write_page() iterating mdde=
v->disks without required locks.
- [High] A maliciously crafted `sectors_reserved` value in the llbitmap sup=
erblock can cause an integer overflow during a bitwise shift on 32-bit syst=
ems, resulting in a zero divisor and a kernel panic.
--

--- Patch [2]: [PATCH 2/4] md/md-llbitmap: mask sb->state on load to drop r=
untime-only bits ---
commit 48600506c718f0300f8ce2473c95dff7a9e47cc2
Author: Mykola Marzhan <mykola@meshstor.io>

md/md-llbitmap: mask sb->state on load to drop runtime-only bits

This commit masks the loaded superblock state in llbitmap_read_sb() to only
keep STALE, FIRST_USE, and CLEAN bits. It prevents runtime-only flags like
WRITE_ERROR from being loaded from disk and permanently disabling the bitma=
p.

Cc: stable@vger.kernel.org # v6.18+

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 5a4e2abaa7577..2d3de38f9b784 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -981,7 +981,15 @@ static int llbitmap_read_sb(struct llbitmap *llbitma=
p)
>  		else
>  			mddev->bitmap_info.space =3D mddev->bitmap_info.default_space;
>  	}

[Severity: High]
This isn't a bug introduced by this patch, but can this sectors_reserved
check lead to an integer overflow?

In llbitmap_read_sb(), we read the untrusted value:

    int room =3D le32_to_cpu(sb->sectors_reserved);
    if (room)
        mddev->bitmap_info.space =3D room;

Later in the same function:

    if (chunksize < DIV_ROUND_UP_SECTOR_T(mddev->resync_max_sectors,
                                          mddev->bitmap_info.space << SECTO=
R_SHIFT)) {

Could a crafted superblock with sectors_reserved =3D 0x00800000 cause
(mddev->bitmap_info.space << SECTOR_SHIFT) to wrap to 0 on 32-bit systems,
resulting in a division by zero panic?

> -	llbitmap->flags =3D le32_to_cpu(sb->state);
> +	/*
> +	 * Mask the loaded state to the bits this loader consumes.
[ ... ]

[Severity: High]
This is a pre-existing issue, but does the teardown path have a symmetry
issue?

In llbitmap_destroy():

    timer_delete_sync(&llbitmap->pending_timer);
    flush_workqueue(md_llbitmap_io_wq);

If md_llbitmap_daemon_fn() is actively running and finds unexpired pages:

    if (restart)
        mod_timer(&llbitmap->pending_timer, ...);

Does this allow the daemon to blindly re-arm the timer after
timer_delete_sync() has finished, leading to a use-after-free when the timer
fires on the freed llbitmap object?

[Severity: High]
This is a pre-existing issue, but is there a use-after-free in the
llbitmap_create() error path?

When llbitmap_create() fails, it does this:

    mutex_unlock(&mddev->bitmap_info.mutex);
    if (ret) {
        kfree(llbitmap);
        mddev->bitmap =3D NULL;
    }

Can a concurrent reader like metadata_show() acquire the lock and dereferen=
ce
the freed object?

metadata_show() does:

    mutex_lock(&mddev->bitmap_info.mutex);
    llbitmap =3D mddev->bitmap;
    if (!llbitmap) {
    ...

[Severity: High]
This isn't a bug introduced by this patch, but does llbitmap_write_page()
iterate the disks without required locks?

In llbitmap_write_page(), executed from workqueues:

        rdev_for_each(rdev, mddev) {
            sector_t sector;

This iterates a dynamic, RCU-protected linked list without taking
rcu_read_lock() or reconfig_mutex.

If a disk is concurrently hot-removed, can list_del_rcu() and
synchronize_rcu() free the element while llbitmap_write_page() is traversing
it?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260719144409.9404=
92-1-mykola@meshstor.io?part=3D2
