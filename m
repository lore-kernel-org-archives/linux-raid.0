Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5017F367B7E
	for <linux-raid@vger.kernel.org>; Thu, 10 Sep 2026 08:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789030279; cv=none; b=UH2hPtRoxSXOvuTbIaCUk6kDtcI9ORqKeemMSS/lfJ1hIpVjsZer9B22OYZZY7J7ugTU9HxibcJfsfiv17gwRJXHCN7hhHwzQsqS4rkPbjZuVYvuxgW0JM4e2vc6eWOgxYJwtxAZ5SSgHbhpTxC0at4H9tac08eth+5ayQnjUtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789030279; c=relaxed/simple;
	bh=FaUTFTsgIFG+GxNRoYtuTZg3OMhkevxpYmDEzjktRho=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rc9RmLRoLJoFQ8xhpvVdOOuUR0bdVW/YfXOprtHUgcbQI1g4eA60ZMgk9R8JDWLkpIUN6t3mqH0GRWe4rDADuhBi6xdoTtCYyaDDkgR+Jih+C48cq14vQkPTPrS1fMfc8NVMgBLkk4vLt8zhVtiozGwdUvRyId4SyO5UARHLITg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TSSKaI0R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TSSKaI0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46F11F00893;
	Thu, 10 Sep 2026 08:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789030273;
	bh=F81dq5sOLM7MLbb/tSrXAX4DQZ9ppQBiLQpGoyNth7o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TSSKaI0R+oDZdCgPs7zjuLhS4z/xa4phSzA3w8Qf0/uQGdOeWmVKIcHdU5BDfa/6p
	 cbYe5HM7HAlnGVJfZp1woeGpC76M1p9d8gNmMFCyYKS/YJbo9kepv6frsT8gIFn1es
	 cb9J8A661O4e9A81bQVc6yKZapq6aFLcENZrtS2D6Tn5O24HGAjSjBlg7O3QYkSbff
	 rL7Hqpm1jh/KeKbz3S6CIn0ivBs5bUtNG/7qSNl8BFLjMxCLfr3IxkhyBYuV9KqNHF
	 bzhSzrXhBWSc67kQgY3BeFEMoOpOZ7tuf90hgVjBJPPmxAostEQpNozuyOcOm/q7Y+
	 GMlIgrKwokKdQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/8] md: take q->limits_lock before locking and
 suspending the array
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jack Wang" <jinpu.wang@ionos.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260910081114.1605746-6-jinpu.wang@ionos.com>
References: <20260910081114.1605746-1-jinpu.wang@ionos.com>
 <20260910081114.1605746-6-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 08:51:12 +0000
Message-Id: <20260910085112.E46F11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Missing rollback when `queue_limits_commit_update()` fails, leavin=
g the array mutated with rejected and potentially dangerous block limits.

Pre-existing issues:
- [High] The patch leaves an ABBA deadlock unresolved in `action_store()` w=
hen triggering `ACTION_RESHAPE`.
- [High] Writing 'remove' to a spare disk's state attribute in a degraded a=
rray incorrectly hot-adds the disk to the array instead of removing it.
--

commit 7025b63183a90cd4ea9de7b41e69a4702b7c8d13
Author: Jack Wang <jinpu.wang@cloud.ionos.com>

md: take q->limits_lock before locking and suspending the array

This commit modifies block limit handling during MD array reconfigurations
to acquire q->limits_lock before locking and suspending the array. This=20
fixes an ABBA deadlock between the limits lock, reconfig_mutex, and the=20
array suspend state.

> Two callers still take the lock inside reconfig_mutex with the array
> suspended: ->start_reshape() from action_store(), which suspends before
> flushing sync_work so the update cannot be held across it, and
> raid*_run() from level_store(), which a later patch converts.

[Severity: High]
This is a pre-existing issue, but by leaving the action_store() path
unresolved here, does this leave the system vulnerable to the same ABBA
deadlock if a user writes 'reshape' to sync_action? Concurrent I/O could=20
still park in the block layer, and a sysfs write to queue limits could=20
still wait in blk_mq_freeze_queue for q_usage_counter to drain while=20
mddev_stack_new_rdev attempts to acquire q->limits_lock.

[ ... ]
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 87e17ba86d93a..0668a048db716 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
[ ... ]
> @@ -3119,7 +3119,7 @@ state_store(struct md_rdev *rdev, const char *buf, =
size_t len,
>  	} else if (cmd_match(buf, "remove")) {
>  		if (rdev->mddev->pers) {
>  			clear_bit(Blocked, &rdev->flags);
> -			remove_and_add_spares(rdev->mddev, rdev, NULL);
> +			remove_and_add_spares(rdev->mddev, rdev, lim);
>  		}
>  		if (rdev->raid_disk >=3D 0)
>  			err =3D -EBUSY;

[Severity: High]
This isn't a bug introduced by this patch, but if an admin tries to remove
a spare from a degraded array by writing "remove" to the state attribute,
could this unintentionally hot-add the spare instead? Looking at
remove_and_add_spares(), rdev_removeable() would skip spares because they
have raid_disk < 0. Then rdev_addable() might return true, causing
hot_add_disk() to be called and returning -EBUSY.

[ ... ]
> @@ -3782,15 +3785,41 @@ rdev_attr_store(struct kobject *kobj, struct attr=
ibute *attr,
[ ... ]
>  	rv =3D suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev);
>  	if (!rv) {
>  		if (rdev->mddev =3D=3D NULL)
>  			rv =3D -ENODEV;
>  		else
> -			rv =3D entry->store(rdev, page, length, NULL);
> +			rv =3D entry->store(rdev, page, length, limp);
> +		/* apply the limits before the array takes I/O again */
> +		if (limp) {
> +			int err =3D queue_limits_commit_update(q, limp);
> +
> +			limp =3D NULL;
> +			if (err && rv >=3D 0)
> +				rv =3D err;
> +		}

[Severity: High]
If queue_limits_commit_update() fails and rejects the stacked limits, the
error is bubbled up, but is it possible that the array has already been=20
mutated by entry->store() (such as structurally binding a new disk)? This
might leave the disk actively bound to the array configuration with
stale/rejected block limits.

[ ... ]
> @@ -8618,6 +8677,9 @@ static int md_ioctl(struct block_device *bdev, blk_=
mode_t mode,
>  	    err !=3D -EINVAL)
>  		mddev->hold_active =3D 0;
> =20
> +	if (limp)
> +		err =3D queue_limits_commit_update(q, limp) ?: err;
> +

[Severity: High]
Similar to the rdev_attr_store() path above, if the limit commit fails
here, are the array mutations (such as ADD_NEW_DISK) reverted?

[ ... ]
> @@ -10419,6 +10501,8 @@ static void md_start_sync(struct work_struct *ws)
[ ... ]
>  	 *     https://bugzilla.kernel.org/show_bug.cgi?id=3D218200
>  	 * Therefore, use __mddev_resume(mddev, false).
>  	 */
> +	if (limp && queue_limits_commit_update(q, limp))
> +		pr_err("%s: could not apply queue limits\n", mdname(mddev));

[Severity: High]
If the limit commit fails, this merely logs an error. Will any spares=20
recently added via remove_and_add_spares() remain fully active with
stale limits, potentially causing data corruption or crashing lower-level=20
drivers?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910081114.1605=
746-1-jinpu.wang@ionos.com?part=3D5
