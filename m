Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12478348C5C
	for <linux-raid@vger.kernel.org>; Fri, 17 Jul 2026 05:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784265939; cv=none; b=VXwk7MmN9+4zI56ApR/cbKuXKFErD/aAYPM5D63aE2FivV2CaJFZ5wN9t3XfboAMBGwsL7noOCvgZesx3E7O42Cnf2EYuS0xDbSBcweQxJdQiGxqWE9KbZ4xdEARS21uMqUg4ffKktahymiHZidQduV7n4bxauZ33yw0XbWxRgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784265939; c=relaxed/simple;
	bh=PoOSjV6DYHOJc8WpAFMO46yWbNpxWsKpDR5/ivpazEI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Yd0C5OxFtE1KxJzo84u2Y6zb/nyhPNlUa9YYg0Zc0wsXoGj19F7n4kXyxVDxulWOsYFy+tWzvCMBKHHYrpYYZIxwqTgatsegaYBEjdPQr9nthOeVUZMd7tTm2q7Pn4ADsWRIiwYCzsMCEIwSzyhK7oFF6H+zG1pKBAryoNJJZeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rg86zYHs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rg86zYHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611431F000E9;
	Fri, 17 Jul 2026 05:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784265937;
	bh=LlSBDJaK3yuXdd+iIuqR75/JdLwT2ZzWv+y3sk02AWw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Rg86zYHsFe6O/c5+MZE8Ii4WVtnhR8ZYyJ+bEpZ/b/VHnRWUVFIMnLWLZOFkUk7sW
	 uqJXKCj24VrHG6GboPJhdUBPyeCEcHyaWcahAb2hDS5vvzO6hAYPx0P0T/508dkRMd
	 01rf/z71Np3p+mVv5mfpDdDs07BnSKMoGK4YRCC0QWkHjPSJDqSBB9glERYNgqNAKY
	 kc25pvXFk8cVW0/8XHPX1A4Ipyjl4fzrZ4SJyFzLbCkQtKCPWMe5aI01xvANauEg1S
	 RPe41pxuJxRTDVOuskVSe5NnStzjREM+f9lLNWARZu6LhnIKzgaST2uRjgG9G35kGd
	 Qg5Nw/UO+bBNQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCHv2] md: clear MD_CLOSING when array_state_store() bails
 on interrupted lock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jack Wang" <jinpu.wang@ionos.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260717051233.383373-1-jinpu.wang@ionos.com>
References: <20260717051233.383373-1-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 05:25:37 +0000
Message-Id: <20260717052537.611431F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Calling `restart_array()` with the `mddev->lock` spinlock held can=
 sleep because it clears the disk read-only flag, which triggers a `GFP_KER=
NEL` memory allocation for a uevent.
--

--- Patch [1]: [PATCHv2] md: clear MD_CLOSING when array_state_store() bail=
s on interrupted lock ---
commit 3ae9b81fbeee45b412994652c2c3b3ac1b35d177
Author: Jack Wang <jinpu.wang@cloud.ionos.com>

md: clear MD_CLOSING when array_state_store() bails on interrupted lock

This commit ensures that MD_CLOSING is correctly cleared if
mutex_lock_interruptible() fails while writing to array_state. It introduces
a common exit label and a boolean flag to track whether the flag was actual=
ly
set by the current thread.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d1465bcd86c81..7b7a4d9259079 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
[ ... ]
> @@ -4696,7 +4698,7 @@ array_state_store(struct mddev *mddev, const char *=
buf, size_t len)
>  	}
>  	err =3D mddev_lock(mddev);
>  	if (err)
> -		return err;
> +		goto out_clear_closing;

[Severity: High]
This is a pre-existing issue, but just above this code in array_state_store=
(),
there is a fast path that can sleep while holding a spinlock.

If a privileged user sets the md device to read-only using
blockdev --setro /dev/md0 and then writes 'active' to
/sys/block/md0/md/array_state, the code acquires the mddev->lock spinlock
and calls restart_array():

drivers/md/md.c:array_state_store() {
    ...
    spin_lock(&mddev->lock);
    if (st =3D=3D active) {
        restart_array(mddev);
    ...
}

restart_array() unconditionally calls set_disk_ro() to ensure the disk is
read-write:

drivers/md/md.c:restart_array() {
    ...
    set_disk_ro(disk, 0);
    ...
}

Because the disk was set to read-only, set_disk_ro() clears the flag and
triggers a uevent:

block/genhd.c:set_disk_ro() {
    ...
    set_disk_ro_uevent(disk, read_only);
    ...
}

This calls into kobject_uevent_env(), which performs an unconditional
GFP_KERNEL allocation:

lib/kobject_uevent.c:kobject_uevent_env() {
    ...
    devpath =3D kobject_get_path(kobj, GFP_KERNEL);
    ...
}

Can this sequence cause a sleep-in-atomic bug and potentially lead to a
deadlock or panic?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717051233.3833=
73-1-jinpu.wang@ionos.com?part=3D1
