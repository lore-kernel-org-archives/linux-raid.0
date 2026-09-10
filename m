Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CD03C1986
	for <linux-raid@vger.kernel.org>; Thu, 10 Sep 2026 08:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789029365; cv=none; b=maURxKfEUGyyNPIMFdcdHnI2g/n+XhRcHFQZL8M21jzNWXv6VM2hL4rFYuDWn5EqcmNImbm0kAQhacyn1L9gHU1kpy68m9KM8GRwP+JDeLeWn8qH3991ybdR6oPZlHPZiF/C3ysLOscaMGgOv5mZJ7tkg3cOXrtUQlAlw9t8qLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789029365; c=relaxed/simple;
	bh=w1leNRR6uJL2Ex6eODT7dYPhOh2QdI5765yqdIzrn4k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=K+FNEQGZy/eJHaoLhbEuERko6tOzEY28eJ63lGFwl7CPO16OsKpQ19FWVfE4nW26etQKwLOhGQs+zirDp9VZAx8hndOj12BSJqfKn0nejKZr6UcqwSK6aw93lVZiUuzXTh//Qw+6JjvR0J2oc6Qrg9qnZuIyAGVu3SF1RX6/H28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O6tI8bWx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O6tI8bWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8431F00893;
	Thu, 10 Sep 2026 08:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789029363;
	bh=FWWPlOIWeYCCV/oQDAM6gdKH2Jc5Wxq+dlL0kIXB7Io=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O6tI8bWx4R8k/0XbdiK5Wmxi69fAOd3Sbks6dYdszOldjP/ftuHz/uTW7si7LHjpo
	 RUDgs63kr8cpZOg68L0uO1RAqK6uFLLfGPp7dYInzC3P+R5CCgfXWUvhR/4NPRiBG9
	 CCDC5RwMN7AZD3tmSnPzgc7Ucxig9xd66c+Ym+3Oj8/SZ0MsCCatM9cnb7jsNUjCQL
	 UV9h+aOFPwN6SQ1CooUII4LuIu/UvBxNZe5xlyGV+tW+JkEFUNkMa4pCSWRhg2aEUo
	 yin5Vx12qdtTESuOmp7stNnS0q1uRbqueK8zfKJrNZyVbqDhwpVqQd/QW0Rf8lUsfa
	 TnK76GgoKLJBw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/8] md: don't wait for q->limits_lock in
 check_sb_changes()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jack Wang" <jinpu.wang@ionos.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260910081114.1605746-3-jinpu.wang@ionos.com>
References: <20260910081114.1605746-1-jinpu.wang@ionos.com>
 <20260910081114.1605746-3-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 08:36:02 +0000
Message-Id: <20260910083603.6F8431F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Bypassing queue limit stacking for hot-added disks on cluster peer=
 nodes leaves the array with potentially invalid queue limits.
--

commit 82a21bb72118b2177a8f4af3c99a80190f1aac3e
Author: Jack Wang <jinpu.wang@cloud.ionos.com>

md: don't wait for q->limits_lock in check_sb_changes()

This commit modifies check_sb_changes() to bypass queue limit stacking for
a newly activated spare by passing MDDEV_STACK_SKIP to remove_and_add_spare=
s().
This is intended to prevent deadlocks when reconfig_mutex is held.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 28fc903ffeea3..e60dc2c7eb90e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -10885,7 +10885,14 @@ static void check_sb_changes(struct mddev *mddev=
, struct md_rdev *rdev)
>  					rdev2->saved_raid_disk =3D -1;
>  				else
>  					rdev2->saved_raid_disk =3D role;
> -				ret =3D remove_and_add_spares(mddev, rdev2, NULL);
> +				/*
> +				 * reconfig_mutex is held, so q->limits_lock
> +				 * cannot be taken here.  The device is
> +				 * already a member, its limits are stacked,
> +				 * so add it without touching them.
> +				 */
> +				ret =3D remove_and_add_spares(mddev, rdev2,
> +							    MDDEV_STACK_SKIP);

[Severity: High]
Does this code permanently bypass limit stacking for disks hot-added on
cluster peer nodes?

In a clustered MD array, when a remote node adds a new disk, the local peer
processes the NEWDISK message via md_add_new_disk() and add_bound_rdev().
Because personalities like raid1 and raid10 implement hot_remove_disk,
add_bound_rdev() intentionally skips calling hot_add_disk(), meaning the new
disk's limits are not stacked at that time.

When the remote node later activates the disk and sends a METADATA_UPDATED
message, this check_sb_changes() code handles it. By passing
MDDEV_STACK_SKIP, the personality's hot_add_disk() detects the flag and
bypasses mddev_stack_new_rdev():

drivers/md/raid1.c:raid1_add_disk() {
    ...
    if (lim =3D=3D MDDEV_STACK_SKIP)
        err =3D 0;
    else if (lim)
        err =3D mddev_stack_rdev_into(mddev, rdev, lim);
    ...
}

Since the disk is marked with raid_disk >=3D 0, the sync thread will ignore=
 it,
so it seems its limits will never be stacked. Can this leave the array with
invalid queue limits, potentially causing the local block layer to submit
incompatible I/O to the newly activated disk?

Also, the commit message states "The device is already a member, so its
limits are stacked", which appears to be inaccurate for Candidate disks
added remotely. I noticed that none of the follow-up patches in this series
correct this missing limits update.

>  				pr_info("Activated spare: %pg\n",
>  					rdev2->bdev);
>  				/* wakeup mddev->thread here, so array could

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910081114.1605=
746-1-jinpu.wang@ionos.com?part=3D2
