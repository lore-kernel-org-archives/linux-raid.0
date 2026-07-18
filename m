Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BF143F0B5
	for <linux-raid@vger.kernel.org>; Sat, 18 Jul 2026 03:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784347002; cv=none; b=oJuXgKDoNiXkS5UtBZ6FFMcWyPGRSUQKCgeGF3DQWQn1X6YPzLtJ0h+WjklgXxyJYxkombtBYYYbit9v84noe5Qtm0jIxUtfdS40MG74wlsdFu5KjiaYKUkPiUJ3KRVROwJ1pQJ5umHluYUIwDeJSoKCfDRSekLhtVTd5fYkHQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784347002; c=relaxed/simple;
	bh=fMsk1ZkEqV8OetY/0IQTkw993pGrA02QXu6gsNQW19c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=soT/k/XasQUrx4Zgliu82aFhVwK0mlL1em/zwqr5XjZt0R2GOee14fbPYXwhN16Grphjp4UW+Cz2x9Z/uXPbcZE2bjWxBYX/wbZLiKvVh1/56iqlq67QZpH6fGvOFEdU312cRZrFALwZdPmObD8MK7CmhrjOVXfbCnopQKaF2R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cf3qeC+B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cf3qeC+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE7B1F000E9;
	Sat, 18 Jul 2026 03:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784347000;
	bh=monfxFXIahkCi88MikFug+8ZJXB/PDecBItvsDuSOZ4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Cf3qeC+BoIetU8IMVY/BEir/661kk3tcHSJbGU9D+JMtK8PvtzQicUZxubOe1EIDo
	 HpteSsktf4d4jXAnKl4/u+ROEJ9vJLT+3lsijfNDZ1l1s2fv7IK1cDgTG8u89Geu1Q
	 VEUxmzR7MZnbW6HQ81nf3ZM6Tou8pulgrAwYi0gz9xfVC1/HEbo/jIPNnPQSREpSDh
	 almZGMQhneNlQs/NvYBQbFSY5o1lTzLF7eMV/X2zGMjsVKofyXiX6c1hVRkBPtXlnk
	 vttm8+mQs6geODPviT/FMQD8qvoxVudrqQg2aOI5xG8ztrNGQVpdBnUc+uUr7+ccqh
	 LgPqMWN/ref6A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/bitmap: resume array on backlog_store() error path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Cheng" <chencheng@fnnas.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260718034236.4119093-1-chencheng@fnnas.com>
References: <20260718034236.4119093-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 18 Jul 2026 03:56:39 +0000
Message-Id: <20260718035640.6DE7B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Silent allocation failures in `mddev_create_serial_pool()` lea=
d to NULL pointer dereferences and silent data corruption.
- [High] Cross-ioctl and error path usage of `mddev_suspend()` in `dm-raid`=
 leaks `PF_MEMALLOC_NOIO` task flag.
--

--- Patch [1]: [PATCH] md/bitmap: resume array on backlog_store() error pat=
h ---
Hi,

Thank you for the patch. I noticed a few pre-existing issues in the related
code paths that might be worth addressing.

commit 5425190104cdbeefa8ae0eda1f825b462b6535ca
Author: Chen Cheng <chencheng@fnnas.com>

md/bitmap: resume array on backlog_store() error path
   =20
backlog_store() suspends the array before checking whether a write-mostly
device exists. If no such device exists, the error path only unlocks
reconfig_mutex and leaves the array suspended, blocking subsequent I/O.
Use mddev_unlock_and_resume() to release both states.

> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 0f02e2956398d..c90fa1e106e26 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2862,7 +2862,7 @@ backlog_store(struct mddev *mddev, const char *buf,=
 size_t len)
>  	if (!has_write_mostly) {
>  		pr_warn_ratelimited("%s: can't set backlog, no write mostly device ava=
ilable\n",
>  				    mdname(mddev));
> -		mddev_unlock(mddev);
> +		mddev_unlock_and_resume(mddev);

[Severity: High]
This isn't a bug introduced by this patch, but since this patch fixes an er=
ror
path missing a resume, does this same missing resume problem exist in
dm-raid.c?

In drivers/md/dm-raid.c:raid_postsuspend(), the code suspends the mddev and
acquires the PF_MEMALLOC_NOIO flag, but returns to userspace without resumi=
ng:

    mddev_suspend(&rs->md, false);

If a user-space process issues a DM_DEV_SUSPEND ioctl, this leaves the flag
set. When DM_DEV_RESUME is later issued, potentially by a different task,
raid_resume() calls mddev_resume(), which applies the saved flags to the
new task.

Also, in raid_ctr(), if setup fails, the error path skips the restore
completely and permanently leaks the flag:

bad_unlock:
    md_stop(&rs->md);
    mddev_unlock(&rs->md);

Could this permanently leak the PF_MEMALLOC_NOIO task flag and cause
memory reclaim deadlocks?

[Severity: Critical]
This is a pre-existing issue, but further down in backlog_store(), is it
possible for mddev_create_serial_pool() to fail silently?

drivers/md/md-bitmap.c:backlog_store() {
    ...
    } else if (backlog && !mddev->serial_info_pool) {
        /* serial_info_pool is needed since backlog is not zero */
        rdev_for_each(rdev, mddev)
            mddev_create_serial_pool(mddev, rdev);
    }
    ...
}

Since mddev_create_serial_pool() returns void, it hides memory allocation
failures. If it fails for a disk in this loop, that device is left without
initialization. Does this silently bypass write-behind serialization for th=
at
disk, leading to overlapping writes and silent data corruption?

Similarly, if MD_SERIALIZE_POLICY is active, check_and_add_serial() in
drivers/md/raid1.c will unconditionally dereference rdev->serial:

    int idx =3D sector_to_idx(r1_bio->sector);
    struct serial_in_rdev *serial =3D &rdev->serial[idx];
    struct serial_info *head_si;

    spin_lock_irqsave(&serial->serial_lock, flags);

Can this cause a NULL pointer dereference for devices that failed
initialization?

>  		return -EINVAL;
>  	}
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260718034236.4119=
093-1-chencheng@fnnas.com?part=3D1
