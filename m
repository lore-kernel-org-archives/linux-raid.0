Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA48D35C69F
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 06:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787811815; cv=none; b=JrJqSWY516mmb727ppPg9m6+CcXkS420LSBfXxusTXQokX/mQvOXYlJt+c4X8/nkmTFUYMxNAZM2NA5lnuSFxdXyN8isL+yCy9RwBlV5OvzZdgTYFD7WQPDWtx4gGlJ//Qc/bJIS9OrAOSvHXmwWRPWR4WJ5QBkk/SG1CK8nFbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787811815; c=relaxed/simple;
	bh=xYQPakckQi63HNfM3t1MZe6KpjW0+agIeRnWM+n8Oro=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UYv+xdfpjsIP4SDfckpNsXBhVaEvO77Z9RKuht3zZtz2CscWBFSYSJMRaKGvfZCagDfCxPTJu/DcsLx5sOOuHWbxFtDN7THFLH9czOOrHLCnl4QhDT0eL91T8eNbzVNeXOcJ13mbGdn1EQ7V1yuGaHbzDaeiWJA/1tC8ZJdDGMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BOOcYrKN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BOOcYrKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132DE1F000E9;
	Thu, 27 Aug 2026 06:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787811813;
	bh=xNcKo/8tDdsphUcqibCeOd9dWbKK9ctWuOuTQedtJCY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BOOcYrKNULhmUYZ1KfPPj30Izv6+9ahY+jXLGGG98n9PpbYBgAPgsdf/jU1HGQUiq
	 hd9QfP6JGaTdPglgtWQebyZeYmuUpuVPYHGvMx543u31QKS5lLMW2VKs9jrsjLumia
	 9WpHUG0aiEybMIUd678TR8MCkdRg2EiNmtaxkvRj+ccoauW6gVOV7J3qIDgcLGXyR0
	 kCj7uOXSDRpZmnSRLq6OCpKzxlpoksY1kKbKD3sIFt9gcxQz9psrbeDeanGqEgvcww
	 lm4TiI6ZloFRQCEAPpkGhM+1mJZHvhTWdYwNj3P9ofDZL4Q/MuKggE1oyYFiUkbt3U
	 cJWOmk6LXrurg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/3] md-cluster: propagate update_size() errors to
 callers
Reply-To: sashiko-reviews@lists.linux.dev
To: ghuicao@163.com
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260827061200.79753-2-ghuicao@163.com>
References: <20260827025229.40138-1-ghuicao@163.com>
 <20260827061200.79753-1-ghuicao@163.com>
 <20260827061200.79753-2-ghuicao@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 06:23:32 +0000
Message-Id: <20260827062333.132DE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] Self-deadlock in error path of update_size() when calling md_updat=
e_sb() while holding cluster locks.
- [High] The patch fails its stated goal by returning success when a cluste=
r capacity revert occurs.
- [High] Early cluster communication error paths return an error without re=
verting the local array size, leaving the cluster in a split-brain state.
- [Medium] The patch propagates hardcoded `-1` returns from update_size() w=
hich translates to `-EPERM` for userspace, violating standard kernel error =
codes.

Pre-existing issues:
- [High] lock_comm() leaks the MD_CLUSTER_SEND_LOCK bit on lock_token() fai=
lure, causing permanent hangs for future cluster operations.
--

commit 10a3e68b8ff2647112ced9ea72fb738bc9b14bb0
Author: Cao Guanghui <caoguanghui@kylinos.cn>

md-cluster: propagate update_size() errors to callers

This patch updates the update_size() callback in the md_cluster_ops structu=
re
to return an integer instead of void. This allows error codes from cluster
operations to be propagated up to the caller in md.c, instead of failing
silently.

> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 9f404660a1fb7..bc4118d8c5a9f 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -1292,7 +1292,7 @@ static int cluster_check_sync_size(struct mddev *md=
dev)
[ ... ]
> -static void update_size(struct mddev *mddev, sector_t old_dev_sectors)
> +static int update_size(struct mddev *mddev, sector_t old_dev_sectors)
>  {
>  	struct md_cluster_info *cinfo =3D mddev->cluster_info;
>  	struct cluster_msg cmsg;
> @@ -1303,7 +1303,7 @@ static void update_size(struct mddev *mddev, sector=
_t old_dev_sectors)
>  	md_update_sb(mddev, 1);
>  	if (lock_comm(cinfo, 1)) {

[Severity: High]
This is a pre-existing issue, but does lock_comm() leak the
MD_CLUSTER_SEND_LOCK bit on failure?

Looking at lock_comm(), if test_and_set_bit(MD_CLUSTER_SEND_LOCK) succeeds,
but lock_token() fails, lock_comm() directly returns the error without
clearing the bit:

lock_comm() {
    ...
    wait_event(cinfo->wait,
               !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));
    rv =3D lock_token(cinfo);
    if (set_bit)
        clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
    return rv;
}

If this occurs, will subsequent cluster operations permanently hang in
wait_event() waiting for the bit to clear?

>  		pr_err("%s: lock_comm failed\n", __func__);
> -		return;
> +		return -1;

[Severity: Medium]
Could returning -1 here cause userspace to see a confusing -EPERM error?

Since the patch changes this callback to return int, using standard error
codes like -EIO, -EAGAIN, or -ENODEV might be more appropriate than a
hardcoded -1.

[ ... ]
> @@ -1325,12 +1325,12 @@ static void update_size(struct mddev *mddev, sect=
or_t old_dev_sectors)
>  			pr_err("%s:%d: failed to send METADATA_UPDATED msg\n",
>  			       __func__, __LINE__);
>  			unlock_comm(cinfo);
> -			return;
> +			return ret;
>  		}
>  	} else {
>  		pr_err("md-cluster: No good device id found to send\n");
>  		unlock_comm(cinfo);
> -		return;
> +		return -1;

[Severity: Medium]
Does returning -1 here also similarly risk propagating -EPERM to userspace
for an internal configuration or device availability error?

>  	}
> =20
>  	/*
[ ... ]
>  	if (cluster_check_sync_size(mddev) =3D=3D 0) {
>  		memset(&cmsg, 0, sizeof(cmsg));
>  		cmsg.type =3D cpu_to_le32(CHANGE_CAPACITY);
>  		ret =3D __sendmsg(cinfo, &cmsg);
>  		if (ret)
>  			pr_err("%s:%d: failed to send CHANGE_CAPACITY msg\n",
>  			       __func__, __LINE__);
>  		set_capacity_and_notify(mddev->gendisk, mddev->array_sectors);
>  	} else {
>  		/* revert to previous sectors */
>  		ret =3D mddev->pers->resize(mddev, old_dev_sectors);
>  		if (ret)
>  			pr_err("%s:%d: failed to revert array size\n",
>  			       __func__, __LINE__);
>  		md_update_sb(mddev, 1);

[Severity: High]
Could this call to md_update_sb() cause a self-deadlock?

The current thread holds the cluster send lock because lock_comm() was call=
ed
successfully at the start of update_size(). When md_update_sb() is called, =
it
triggers a cluster metadata update:

md_update_sb() -> mddev->cluster_ops->metadata_update_start()

The metadata_update_start() path appears to wait for MD_CLUSTER_SEND_LOCK to
be cleared. Since the lock is held by the same thread, will it wait forever?

>  		ret =3D __sendmsg(cinfo, &cmsg);

[Severity: High]
Does this __sendmsg() call overwrite the failure state from the capacity
revert?

If the cluster sync size check fails, the result of the local revert
operation is stored in 'ret' right above. By reassigning 'ret' to the result
of __sendmsg() here, would a successful broadcast incorrectly return 0
(success) to userspace instead of propagating the failure of the resize?

>  		if (ret)
>  			pr_err("%s:%d: failed to send METADATA_UPDATED msg\n",
>  			       __func__, __LINE__);
>  	}
>  	unlock_comm(cinfo);
> +	return ret;
>  }

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3d..b723fd9eccc0b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8023,7 +8023,7 @@ static int update_size(struct mddev *mddev, sector_=
t num_sectors)
>  	rv =3D mddev->pers->resize(mddev, num_sectors);
>  	if (!rv) {
>  		if (mddev_is_clustered(mddev))
> -			mddev->cluster_ops->update_size(mddev, old_dev_sectors);
> +			rv =3D mddev->cluster_ops->update_size(mddev, old_dev_sectors);

[Severity: High]
If the cluster update_size() operation fails early (for example, if lock_co=
mm
fails or it cannot find an active raid device), we now propagate the error
back to userspace.

However, the local array has already been resized by mddev->pers->resize()
right above this call. Does this local resize need to be reverted if the
cluster update fails, to prevent a split-brain state where the local node h=
as
a different capacity than the rest of the cluster?

>  		else if (!mddev_is_dm(mddev))
>  			set_capacity_and_notify(mddev->gendisk,
>  						mddev->array_sectors);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827061200.7975=
3-1-ghuicao@163.com?part=3D2
