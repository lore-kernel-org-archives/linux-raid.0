Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C043240099C
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 08:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787821126; cv=none; b=bqAFvx3sfxnogMkq/lsztnnI74cUBYDwSiaNf5YjAtsPzs0DYJpPsNvuTVUjLMHkUd5IfVfe66I0OTJw8FwUQyVCSobA7QDt3CJdmN9KBMPgAp7CIpbVBVOr+jvHnXnwUshNgjRhrAPE4RusB6XIuWrU2kaHQiq8itxDWPXK0JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787821126; c=relaxed/simple;
	bh=KlyAMY5TEwvt/7p+qwOc+FfD0LlaRbGF067LxU7sf18=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DNCht12iZNMwUDDdVZlR/HRo8VOHg6Vy8v/DkBbDeKdV344WMSG/Ts2RDblK/nJfqYfUhNibrBcAVnCQgbEz/FMExfwmDssXB/dWb4SNVVKASo6UV521es91zYpauwrA6FOwMMVzK7FZInlf2sEn7bOPHuko4FfRrBKLdnwoLhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OkRHQdLd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OkRHQdLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340991F000E9;
	Thu, 27 Aug 2026 08:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787821124;
	bh=ENGHG3z7QScuWgbdNHmu0GtCayY0v5W5JS7A234eWTg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OkRHQdLdVNtjxmDKjRPmU4nqZQBv/44rdWJPz2DHjp3u2UaKwYqzbOlQ4zdJcPBJ2
	 OY1sd6ZqE7lMFPZBYZyKgHJsd0dXpHOHvtWWI3K5O//K+nY24MM5x4v3sfPZSSbg5o
	 KQzG8xhqa8J0baFuDaDUlas6PWk5aeda9WTnxdoDhegy4q7eg+XmRq/asizWjiRSvV
	 7FJCXY1bEj1haTpAWxugZinCbuxD3V9IzvCyRpQSqiAu2PNumblXmX06MiS1R8Q3oF
	 rKuUBUHhKwNCBgn0yd48XS2fWGoRcXJsxPOoKiflVO1DHLSWuWAb+0zHaao0rPvw0a
	 DAWiPF6mT4znA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/3] md-cluster: fix error handling and superblock
 consistency in update_size
Reply-To: sashiko-reviews@lists.linux.dev
To: ghuicao@163.com
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260827084453.124629-2-ghuicao@163.com>
References: <20260827061200.79753-1-ghuicao@163.com>
 <20260827084453.124629-1-ghuicao@163.com>
 <20260827084453.124629-2-ghuicao@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 08:58:43 +0000
Message-Id: <20260827085844.340991F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] When the cluster rejects a resize and the local revert succeeds, `=
update_size()` erroneously returns 0 (success), misleading userspace.
- [High] If the local revert resize fails after the cluster rejects the new=
 size, the code unconditionally updates the on-disk superblock with the rej=
ected new size.

Pre-existing issues:
- [High] Early failure paths in `update_size()` commit the new size to the =
on-disk superblock but fail to revert it on error, causing persistent clust=
er split-brain.
--

commit faab74a4740b5da9226b76ad0d7a819261f23143
Author: Cao Guanghui <caoguanghui@kylinos.cn>
Subject: md-cluster: fix error handling and superblock consistency in updat=
e_size

This commit attempts to fix error handling in update_size() by returning
proper error codes and ensuring the on-disk superblock is reverted if
other nodes in the cluster reject the size update.

> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index fb62fdb492350..0ba25053198d5 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -1302,18 +1302,19 @@ static int cluster_check_sync_size(struct mddev *=
mddev)
[ ... ]
> -static void update_size(struct mddev *mddev, sector_t old_dev_sectors)
> +static int update_size(struct mddev *mddev, sector_t old_dev_sectors)
>  {
>  	struct md_cluster_info *cinfo =3D mddev->cluster_info;
> +	bool reverted =3D false;
>  	struct cluster_msg cmsg;
>  	struct md_rdev *rdev;
> -	int ret =3D 0;
> +	int ret =3D 0, msg_ret =3D 0;
>  	int raid_slot =3D -1;
> =20
>  	md_update_sb(mddev, 1);
>  	if (lock_comm(cinfo, 1)) {
>  		pr_err("%s: lock_comm failed\n", __func__);
> -		return;
> +		return -EIO;
>  	}

[Severity: High]
This is a pre-existing issue, but since md_update_sb() has already
written the new array size to the on-disk superblock, does this early
error path need to revert that change?

If the cluster operation fails early here, or in the subsequent
__sendmsg() calls, the cluster is never notified of the size change but
the local node has already committed it to disk. On the next reboot,
this node might assemble the array with the new size while others use
the old size, causing a persistent cluster split-brain.

[ ... ]
> @@ -1359,12 +1360,28 @@ static void update_size(struct mddev *mddev, sect=
or_t old_dev_sectors)
>  	} else {
>  		/* revert to previous sectors */
>  		ret =3D mddev->pers->resize(mddev, old_dev_sectors);

[Severity: High]
When the cluster rejects a resize and the code enters this else block to
revert the size, does a successful local revert (where
mddev->pers->resize() returns 0) cause the function to return 0?

Returning 0 incorrectly signals a successful resize to the caller. This
might mislead userspace tools and administrators into assuming the
storage capacity has increased, when it was actually rejected by the
cluster and rolled back locally.

> -		ret =3D __sendmsg(cinfo, &cmsg);
>  		if (ret)
> +			pr_err("%s:%d: failed to revert array size\n",
> +			       __func__, __LINE__);
> +		reverted =3D true;

[Severity: High]
If the local revert resize fails (returning a non-zero error), the
reverted flag is still unconditionally set to true.

Because the reverted flag is true, md_update_sb() will be called at the
end of the function. Will this cause the local node to permanently store
the rejected new size in its on-disk superblock, leading to a cluster
split-brain?

> +		msg_ret =3D __sendmsg(cinfo, &cmsg);
> +		if (msg_ret) {
>  			pr_err("%s:%d: failed to send METADATA_UPDATED msg\n",
>  			       __func__, __LINE__);
> +			if (!ret)
> +				ret =3D msg_ret;
> +		}
>  	}
>  	unlock_comm(cinfo);
> +
> +	if (reverted)
> +		/* Update on-disk superblock to match reverted in-memory
> +		 * size. Must be after unlock_comm() to avoid self-deadlock
> +		 * since md_update_sb() acquires the cluster send lock.
> +		 */
> +		md_update_sb(mddev, 1);
> +
> +	return ret;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827084453.1246=
29-1-ghuicao@163.com?part=3D2
