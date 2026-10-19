Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792423543;
	b=jDq8aYntqr4nvy6tvA4HwYuBv9YvDPL5wchMi8FP2idxW8ytzzRVOH8deW80cyA/GKdu
	 Dh7BDJ7k5l1VeBxnj3xWhTuQEvV7zwXVHBEEhuHpdCIQFfThlUsgn6llq6ZkAZ9nCu6+D
	 /mqnPjeK2HCKzXSkDP48aeu+CC5cr8utkHsIklWXGHuUMGyuj9fwoctKNq3p+OrgrSaZR
	 yX1oGHlgR7IIAqQ2fQAIDiTeBj0rbvVMNHJ5RbSXvGK6Gr+BZtfB4DcjBqlendJ0kVClD
	 R34Qfaolo0BKGu7Jsy4ftHP9FN/M6pgNlUAze3XTnUoUOdKR1HniAyxakuS0xlkhu+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792423543;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FNT/YLycpkgihSpj86STCEX+zhUuwMFUOzum+l10R9A=;
	b=TKCo+OaLmKWN7HQGplzMff+y4wq8+g27U1UsrVzlH17Q4oOKQHVe8gjIJMRYeUhz2rxz
	 qlOT7j9+Cc4wEuBSEOPbrP7rIu0S4dvdRi/9eGmLjq6gEyl/SJmdQ+UlrtmcWIQPd3Hcw
	 CerGsR99uWpTwsVNlXFfE0TY/LSmolomIb1N7fhPH8jERJ6Am4/ZYdTqEtKRGpGpSAXu2
	 3CIeMziDljE1H4Ot9SokvlSPjxe/OgSwvxzKpXq3iWuRjj9E2VoHNaQiJ/nHprYzT/tJM
	 8oB85PG1FM2BVpnB96Z9z3wbWsiTQuiy2wEJD1e7I8ep26KjTxQFTf1YoY+6sQm+7iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AVqoivKo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E38660B09A6
	for <linux-raid@vger.kernel.org>; Mon, 19 Oct 2026 15:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AVqoivKo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5AE1F000C5;
	Mon, 19 Oct 2026 15:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792423542;
	bh=FNT/YLycpkgihSpj86STCEX+zhUuwMFUOzum+l10R9A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AVqoivKoYRPTUSkt4p6GmTHHFe/Xley9nn4hnEpmwU4KIhJeTeC0lwoL9wwAPjhZr
	 YptLUKcKv16iR4JLskWco9dCCNHdtQvQyRCOrwJruRESu4zO0CSIAGkuaR6b40/JX3
	 N9trnDXo7ZVni4JK1v2TgW5kxnjNALJ/3ibJ/annhUeHoj9VReeY06NITSYeacrsEE
	 NkGDmhlv2D9U9MJYYiXUedbbtnI4OmqGaR6WfHpzFRXIdAhAG/LMClIQB5+UrDsm6c
	 eiLKBKrpWpZMNLyCLTJdhHRyeEG7Z7oKK32m1njObZhD01kK50sUDrrUMlAUvRLiTu
	 IIPWphGm6tzaA==
Message-ID: <sashiko-outbox-177721@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18] md/raid5: complete discard bios while
 reshape is active
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261019135441.1420968-447-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
 <20261019135441.1420968-447-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 15:25:42 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] md/raid5: make_discard_request() returns BLK_STS_AGAIN without R=
EQ_NOWAIT
--

commit 2fc0a245a9d15532fa0b76f75c094edac4ec73ed
Author: Genjian Zhang <zhanggenjian@kylinos.cn>

md/raid5: complete discard bios while reshape is active

This commit completes discard bios in make_discard_request() with
BLK_STS_AGAIN when reshape is active instead of returning without
calling bio_endio().

Link: https://patch.msgid.link/20260711161326.962336-1-zhanggenjian@126.com

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 2817cd7d197e9..b7da2b83e1938 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5707,8 +5707,7 @@ static void make_discard_request(struct mddev *mdde=
v, struct bio *bi)
>  	int stripe_sectors;
> =20
>  	if (mddev->reshape_position !=3D MaxSector)
> -		/* Skip discard while reshape is happening */
> -		return;
> +		goto complete_again;
> =20
>  	stripe_sectors =3D conf->chunk_sectors *
>  		(conf->raid_disks - conf->max_degraded);
> @@ -5786,6 +5785,11 @@ static void make_discard_request(struct mddev *mdd=
ev, struct bio *bi)
>  	}
> =20
>  	bio_endio(bi);
> +	return;
> +
> +complete_again:
> +	/* Skip discard while reshape is happening */
> +	bio_endio_status(bi, BLK_STS_AGAIN);
>  }

[Severity: Medium]
Is it valid to complete synchronous discard bios with BLK_STS_AGAIN when
REQ_NOWAIT is not set?

In include/linux/blk_types.h, BLK_STS_AGAIN is documented as only valid
when RQF_NOWAIT is set:

    /*
     * BLK_STS_AGAIN should only be returned if RQF_NOWAIT is set
     * and the bio would block (cf bio_wouldblock_error())
     */
    #define BLK_STS_AGAIN		((__force blk_status_t)12)

When a mounted filesystem or fstrim issues a synchronous discard via
sb_issue_discard() -> blkdev_issue_discard() -> submit_bio_wait() while
RAID5 reshape is active (mddev->reshape_position !=3D MaxSector),
blkdev_issue_discard() only masks -EOPNOTSUPP and propagates -EAGAIN to
the caller:

    if (!ret && bio) {
        ret =3D submit_bio_wait(bio);
        if (ret =3D=3D -EOPNOTSUPP)
            ret =3D 0;
        bio_put(bio);
    }

In fs/ext4/mballoc.c:ext4_mb_clear_bb(), when freeing blocks with the
discard mount option enabled (in no-journal or data=3Dwriteback mode),
only -EOPNOTSUPP is ignored:

    if (test_opt(sb, DISCARD)) {
        err =3D ext4_issue_discard(sb, block_group, bit,
                                 count_clusters);
        if (err =3D=3D -EOPNOTSUPP)
            err =3D 0;
        if (err)
            ext4_msg(sb, KERN_WARNING, "discard request in"
                     " group:%u block:%d count:%lu failed"
                     " with %d", block_group, bit, count,
                     err);
    }

When err is -EAGAIN, ext4_mb_clear_bb() skips freeing cross-group
overflow blocks and passes -EAGAIN to ext4_std_error(sb, err), marking
the filesystem in error and triggering a read-only remount or panic.

Similarly, in fs/gfs2/rgrp.c:gfs2_rgrp_send_discards(), an -EAGAIN
return from sb_issue_discard() jumps to fail: and sets
sdp->sd_args.ar_discard =3D 0, permanently disabling discards on the
mounted filesystem even after reshape completes.

Since make_discard_request() already completes skipped sub-stripe
advisory discards with bio_endio(bi) (BLK_STS_OK):

    if (first_stripe >=3D last_stripe) {
        bio_endio(bi);
        return;
    }

should discard bios skipped during reshape also be completed with
bio_endio(bi) (or BLK_STS_NOTSUPP) when REQ_NOWAIT is not set?

> =20
>  static bool ahead_of_reshape(struct mddev *mddev, sector_t sector,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019135441.1420=
968-447-sashal@kernel.org?part=3D1
