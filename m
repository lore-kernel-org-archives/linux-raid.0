Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9884854F6
	for <linux-raid@vger.kernel.org>; Sat,  5 Sep 2026 11:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788606028; cv=none; b=A2CUs+QHEC422wdjRin2ijefve76HPjn1M8kRu9yUyxE26Tk+xcxLYh8tvrjmMpLvYmxZMp7CMyYZXkJ3FqOT+UayNKKOGNTyR2O2eWY8yDzZVCVIBUm6xnmiwZLSzRYBHzjRAj/Lm5UphkxbqTLyQOC86XMgnqv/N8Ru+UajeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788606028; c=relaxed/simple;
	bh=1mugIYNNEzEw6GF2hTtIwLo0OJiQkqk81kQdWnVd1Ms=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uHR1viwQS4s8FqSq8KTuXYEV2FCzMEJCdnIOAVWfodg2S38PAIa4zGRaFqACO9OeQB149hQZEqFBdwjwvNzDMNNehIby2agWgY23ixVUpgrHorrq3XOTcDmbbePUPqRNrBADTy5i31va1deg2JXYjWxUXdg7pJ4ZBfmemFdpCKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WQa0VCVf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WQa0VCVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0571F00A3D;
	Sat,  5 Sep 2026 11:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788606026;
	bh=QycwHNaQWCwiAIN20r4KWzJecSHpJSXHkVsleEQK3mA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WQa0VCVfing0yEaVrE4ah22h4UYjnLfAcxWzK4FA4hWxGjx+A9rq+G/pxlP69seLw
	 JtYPysf1kWbeKhq2vyMIabstKwBKnNSpdv4EJ+pYummgP9JaaaYLubxJM60irXicVL
	 KBZvC0gfSfo38fCUsUxLaj/jS80ePGIHQON9fQ33qRPsIIk0rVqr60GEFIVRqZZVWT
	 qh0CcFDOm5BWAZRltZZnF0VX3sH+MQGs58KpyFyGk445OV8JZ8v/ustLBao36gOIu4
	 q0B3gChEfCm1ERRZZUAPBvHuCTEri+lhTAYJDvxt6LlQ/oApzR9Nx1nhBF6wp7mzGV
	 GW5gG/RrgACig==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] md/raid5: reject raid4/5 arrays with too few disks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Cheng" <chencheng@fnnas.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260905104323.2202902-1-chencheng@fnnas.com>
References: <20260905104323.2202902-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 11:00:25 +0000
Message-Id: <20260905110026.5C0571F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Rejecting RAID5 arrays with fewer than 3 disks breaks explicitly s=
upported 2-disk RAID5 arrays, preventing assembly and RAID1-to-RAID5 reshap=
ing.

Pre-existing issues:
- [Critical] The patch fails to validate `previous_raid_disks` during a res=
hape, allowing the syzbot panic (`data_disks =3D=3D 0`) to still be trigger=
ed.
- [High] Null pointer dereference during hotplug teardown in raid5_free_per=
cpu() error path.
- [Medium] Memory leak of disk extra_page allocations on the setup_conf() e=
rror path.
--

commit 354e4797772beea1449d8c8f033639134da1c7b9
Author: Chen Cheng <chencheng@fnnas.com>

md/raid5: reject raid4/5 arrays with too few disks

This commit rejects RAID4 arrays with fewer than 2 disks and RAID5 arrays
with fewer than 3 disks during setup_conf(). This is intended to prevent
invalid geometries from reaching queue limit setup and causing a panic
due to a zero stripe size.

Closes: https://lore.kernel.org/r/6a778c82.01d0871a.3a0d52.006a.GAE@google.=
com/

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b91545ce090de..4d8bb0cf26055 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7657,9 +7657,12 @@ static struct r5conf *setup_conf(struct mddev *mdd=
ev)
>  			mdname(mddev), mddev->new_layout);
>  		return ERR_PTR(-EIO);
>  	}
> -	if (mddev->new_level =3D=3D 6 && mddev->raid_disks < 4) {
> -		pr_warn("md/raid:%s: not enough configured devices (%d, minimum 4)\n",
> -			mdname(mddev), mddev->raid_disks);
> +	if ((mddev->new_level =3D=3D 4 && mddev->raid_disks < 2) ||
> +	    (mddev->new_level =3D=3D 5 && mddev->raid_disks < 3) ||

[Severity: High]
Does this unintentionally break 2-disk RAID5 arrays?

The md driver supports and intentionally creates 2-disk RAID5 arrays during=
 a
RAID1-to-RAID5 reshape. For example, in drivers/md/raid5.c
raid5_takeover_raid1() creates a 2-disk RAID5:

    mddev->new_level =3D 5;
    mddev->new_layout =3D ALGORITHM_LEFT_SYMMETRIC;
    mddev->new_chunk_sectors =3D chunksect;

    ret =3D setup_conf(mddev);

By unconditionally rejecting mddev->new_level =3D=3D 5 && mddev->raid_disks=
 < 3
here, doesn't this cause valid reshape operations and assembly of legitimate
2-disk RAID5 arrays to fail with -EINVAL?

> +	    (mddev->new_level =3D=3D 6 && mddev->raid_disks < 4)) {
> +		pr_warn("md/raid:%s: not enough configured devices (%d, minimum %d)\n",
> +			mdname(mddev), mddev->raid_disks,
> +			mddev->new_level - 2);
>  		return ERR_PTR(-EINVAL);
>  	}

[Severity: Critical]
This is a pre-existing issue, but does this actually fix the root cause of
the syzbot panic?

Later in setup_conf(), previous_raid_disks is calculated using an unvalidat=
ed
delta_disks from the superblock:

    if (mddev->reshape_position =3D=3D MaxSector)
        conf->previous_raid_disks =3D mddev->raid_disks;
    else
        conf->previous_raid_disks =3D mddev->raid_disks - mddev->delta_disk=
s;

An attacker or fuzzed image could bypass the new minimum disk check by
providing a valid raid_disks (e.g., 3 for RAID5) but supplying a positive
delta_disks (e.g., 2), resulting in previous_raid_disks =3D 1.

Then in raid5_set_limits():

    data_disks =3D conf->previous_raid_disks - conf->max_degraded;
    stripe =3D roundup_pow_of_two(data_disks * (mddev->chunk_sectors << 9));

Since max_degraded is 1 for RAID5, data_disks becomes 0 again, and
roundup_pow_of_two(0) will still trigger the exact same division by zero
panic. Should we also be validating delta_disks or previous_raid_disks?

[Severity: Medium]
This is a pre-existing issue, but does the error path out of setup_conf()
leak the disk extra_page allocations?

In setup_conf(), extra pages are allocated using max_disks as the bound:

    for (i =3D 0; i < max_disks; i++) {
        conf->disks[i].extra_page =3D alloc_page(GFP_KERNEL);
        if (!conf->disks[i].extra_page)
            goto abort;
    }

If a subsequent initialization step fails, setup_conf() jumps to the abort
label and calls free_conf(). However, free_conf() iterates using
conf->pool_size to free these pages:

    for (i =3D 0; i < conf->pool_size; i++)
        if (conf->disks[i].extra_page)
            put_page(conf->disks[i].extra_page);

Since conf->pool_size is zero-initialized in setup_conf() and only populated
later in grow_stripes(), doesn't the cleanup loop terminate immediately and
leak all the successfully allocated pages?

[Severity: High]
This is a pre-existing issue, but does the setup_conf() error path trigger a
NULL pointer dereference during hotplug teardown?

Earlier in setup_conf(), raid5_alloc_percpu() is called:

    conf->percpu =3D alloc_percpu(struct raid5_percpu);
    if (!conf->percpu)
        return -ENOMEM;

    err =3D cpuhp_state_add_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
    if (!err) {
        ...

If cpuhp_state_add_instance() fails (for example, due to a memory allocation
failure in raid456_cpu_up_prepare()), it returns an error but leaves
conf->percpu allocated and conf->node unhashed.

When setup_conf() handles the error by jumping to abort and calling
free_conf(), it invokes raid5_free_percpu():

    if (!conf->percpu)
        return;
   =20
    cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);

Because conf->percpu is non-NULL, cpuhp_state_remove_instance() is called.
The CPU hotplug core then calls hlist_del(&conf->node), which dereferences
the NULL pprev pointer of the unhashed list node. Can this crash the system
under memory pressure?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905104323.2202=
902-1-chencheng@fnnas.com?part=3D1
