Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2310C3537E8
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 08:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787821105; cv=none; b=a6QQLnGIfwkN65pmhqUUec138IRmqrgNNpjrxOUYvn0n12OI22AqpFQReT7vOMMoMhIOlauwuv+d8zAvKkQ7KvcZ10eyRvYIzV3A1wi0cFuR/8UzrLhINBa4yIe6+djdn60jEwe3tb3gUSmFS60F+3vVZcSwKbibpBdT882HZoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787821105; c=relaxed/simple;
	bh=P2B0GVOlfBjm+wAiOMUcxL2pATBWyi6t4PKB3Ze7KWQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jWtWJA2NpY8UXAbWYvbIpRGQb5xhfTctiQl5v5c+UxzZ7HMvG8DDaTw0T/mvJ4RkNtlByK3GRHJ2GlAsRc6/pvJ2LqPlf4CqMWyD43xASAk+ksz4R9YzUAP3XP3cE8NlrKoUFpKcqeUImuZgMRqnU3Zz73LGTW+JxX2a3LG2giI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mXwPfWpC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mXwPfWpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775231F000E9;
	Thu, 27 Aug 2026 08:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787821103;
	bh=r5fZXsDkhZOKo9zaAuCGTcW0kp784r5kdzvE2Pu00rI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mXwPfWpCpS4TReZ2YAt46GH+6cHNQjm1l7NGVyGOhHJNeXoPz107KZTBhf8O4uxhy
	 PObhquwHbey6kiYmIL9SSG/hr7iWoQwEi6HpOgdyqEOF+UQw+gGrC3cMfY8ZmpJN4N
	 aHODH68ZPOuZ600kPE2xY3pEYAtFMxS/A9Ti6lTi8uSzHRPUCXQl6AlcusMfJu2OQX
	 v1FhCGwuKVWxnTh0AsC+vKpr5W56tytwyS9CH6VWyDOPUmuVzKDvkBbM5g/VVzsWPg
	 kQ4YIvo95MDaWzfPHtR26L2BiA4wwEVpmMPG/W1zvWz+/syEugmAsCc3CdDcigaIYd
	 5sT4nyee5MtKQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/3] md-cluster: fix lock_comm leak and __sendmsg
 error path
Reply-To: sashiko-reviews@lists.linux.dev
To: ghuicao@163.com
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260827084453.124629-1-ghuicao@163.com>
References: <20260827061200.79753-1-ghuicao@163.com>
 <20260827084453.124629-1-ghuicao@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 08:58:23 +0000
Message-Id: <20260827085823.775231F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Missing `wake_up(&cinfo->wait)` after clearing `MD_CLUSTER_SEND_LO=
CK` on the error path in `lock_comm()`.
- [High] The single-attempt lock release strategy leaves the DLM lock perma=
nently stuck when there is a pending timed-out conversion.
- [Medium] The fallback restoration of `ack_lockres` to `CR` incorrectly ex=
ecutes on all error paths, leading to redundant or synchronously failing re=
quests.

Pre-existing issues:
- [High] `metadata_update_start()` suffers from the exact same lock leak pa=
ttern that the patch attempts to fix in `lock_comm()`.
--

commit ab42e35df8bfdb28c9d4472b6f7586349538824c
Author: Cao Guanghui <caoguanghui@kylinos.cn>

md-cluster: fix lock_comm leak and __sendmsg error path

This commit addresses error handling issues in cluster communication. It cl=
ears
MD_CLUSTER_SEND_LOCK when lock_token() fails in lock_comm() to avoid hangs.
It also modifies __sendmsg() to attempt restoring ack_lockres to CR and
replaces an infinite loop with a single attempt when unlocking message_lock=
res.

> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 24dac6f09da82..fb62fdb492350 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -735,6 +735,8 @@ static int lock_comm(struct md_cluster_info *cinfo, b=
ool mddev_locked)
>  	wait_event(cinfo->wait,
>  		   !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));
>  	rv =3D lock_token(cinfo);
> +	if (rv)
> +		clear_bit_unlock(MD_CLUSTER_SEND_LOCK, &cinfo->state);

[Severity: High]
Does this clear operation also require a wake_up(&cinfo->wait)?

When lock_token() fails, this patch clears the lock bit but appears to miss
the wake_up() call. Any thread currently asleep in wait_event() waiting to
acquire MD_CLUSTER_SEND_LOCK could remain asleep indefinitely because
waitqueues require an explicit wakeup.

>  	if (set_bit)
>  		clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
>  	return rv;

[ ... ]

> @@ -801,7 +803,15 @@ static int __sendmsg(struct md_cluster_info *cinfo, =
struct cluster_msg *cmsg)
>  	}
> =20
>  failed_ack:
> -	while ((unlock_error =3D dlm_unlock_sync(cinfo->message_lockres)))
> +	if (error) {
> +		int ack_ret =3D dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_CR);

[Severity: Medium]
Will this unconditional fallback restoration fail synchronously?

If __sendmsg() fails on message_lockres, ack_lockres is still in CR, making
this conversion redundant. However, if it fails on ack_lockres due to a
timeout, the DLM resource is already busy with a pending request. The
immediate dlm_lock_sync() fallback to CR will fail synchronously with -EBUSY
and fail to recover the lock state.

> +
> +		if (ack_ret)
> +			pr_err("md-cluster: failed to restore ACK to CR (%d)\n",
> +			       ack_ret);
> +	}
> +	unlock_error =3D dlm_unlock_sync(cinfo->message_lockres);
> +	if (unlock_error)
>  		pr_err("md-cluster: failed convert to NL on MESSAGE(%d)\n",
>  			unlock_error);

[Severity: High]
Could this single-attempt lock release strategy leave the DLM lock stuck?

If dlm_lock_sync() times out (for example, when getting EX lock on MESSAGE),
it returns -EBUSY but leaves the lock request active in DLM. This single
dlm_unlock_sync() attempt translates to a new DLM lock request which is
immediately rejected with -EBUSY by DLM due to the pending request.=20

Proper recovery might require using dlm_unlock() with DLM_LKF_CANCEL to
cancel the pending operation.


[Severity: High]
This isn't a bug introduced by this patch, but metadata_update_start()
appears to suffer from the exact same lock leak pattern that this patch
attempts to fix in lock_comm().

Looking at metadata_update_start() in drivers/md/md-cluster.c:

	ret =3D lock_token(cinfo);
	clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
	return ret;

If lock_token() fails here, it returns without clearing MD_CLUSTER_SEND_LOCK
and without calling wake_up(&cinfo->wait), which could cause a permanent
cluster-wide hang during metadata updates.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827084453.1246=
29-1-ghuicao@163.com?part=3D1
