Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E87024BBEE
	for <linux-raid@vger.kernel.org>; Sat, 17 Oct 2026 07:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792223353; cv=none; b=HIcjuvlcAgI6UbgpNO2jOdhlRcZnTIQFKhOqvgneiF26y2TzH73CYEy+eHhnWhWGne9akIyRL0WpDMruevK2iXEScHz5JgILqodQ8C6SX/4hPZiKG6H9HFrmj2HhNQWxGMV2B+NDB4BEFi4LcXsHrVzgiYanBIgkq2lViMuMB/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792223353; c=relaxed/simple;
	bh=SKZ71aQbijjqfQhwrb8lTG6h27r8Eigg00c0t7Rg3zM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=acFWQYC7i4m2aF5LqJO+S1+n3otisU00uxOGB71amzX3nnMEM8Zku9J3byLLimaOQPTuaPnSr1HKWHFOIKTNSNZmfMLV29vBodJouD70MFWgDj66phz2CuGDZkzTmiRq9UxGJkY6v7bNSOV4X1MsqPul09Y/Yy5wmwTDrfmjYVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OcRpkbPO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OcRpkbPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85571F000C4;
	Sat, 17 Oct 2026 07:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792223352;
	bh=1CRX2LdmphR7izU0mOthhP0zf/hvzb5S5MSxCCIG4Hw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OcRpkbPO+nqHcDrvF8OBDvgJNSWP7eDigixpqnfauo3r1gEnpLgM4RlwdVAhNB18L
	 AKhvnU34cVK0WJ1HkvFkeJtLDFEoK8cq+a3YVPrz1thua6/8GMy3qrQYgBII7Db7NZ
	 yV3gNU0WeiPqyON+3I9LCcW+e0hUymaksymir7hJoMsJMqvLMSuteTA4MScapDbxSP
	 oQ5GcxGZpvy4RP/vpnAhxRbMaMVz+8oAbF8R+RG0gbHjTFwDWoPL4NNEL88bIBtawZ
	 4sLWchEjlovH5AitsipPI0pt0Y01ct0JoJ4g+qwmjSsM3Nkb7/Tw526E4WZLFFDHai
	 1TT3rngiA74hw==
Message-ID: <sashiko-outbox-175372@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/raid5: fix inverted condition in rdev_set_badblocks
 call
Reply-To: sashiko-reviews@lists.linux.dev
To: zhanghao <zh_exit@163.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261017074343.59513-1-zh_exit@163.com>
References: <20261017074343.59513-1-zh_exit@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 07:49:11 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] md/raid5: missing md_error() in raid5_end_read_request() when not =
setting badblocks
--

commit 3b60bf439402ec230798b452291264b5f0962518
Author: zhanghao <zh_exit@163.com>

md/raid5: fix inverted condition in rdev_set_badblocks call

This commit fixes an inverted condition in raid5_end_read_request() so that
rdev_set_badblocks() is called when set_bad and In_sync are set.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b91545ce090de..d5e226c6cc68a 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2834,7 +2834,7 @@ static void raid5_end_read_request(struct bio * bi)
>  		else {
>  			clear_bit(R5_ReadError, &sh->dev[i].flags);
>  			clear_bit(R5_ReWrite, &sh->dev[i].flags);
> -			if (!(set_bad && test_bit(In_sync, &rdev->flags)))
> +			if (set_bad && test_bit(In_sync, &rdev->flags))
>  				rdev_set_badblocks(rdev, sh->sector,
>  						   RAID5_STRIPE_SECTORS(conf), 0);
>  		}

[Severity: High]
Does this need an else branch calling md_error(conf->mddev, rdev)?

Prior to commit fd4d44c14ff6 ("md: mark rdev Faulty when badblocks setting
fails"), the non-retry branch in raid5_end_read_request() had:

	if (!(set_bad && test_bit(In_sync, &rdev->flags) &&
	      rdev_set_badblocks(rdev, sh->sector, RAID5_STRIPE_SECTORS(conf), 0)))
		md_error(conf->mddev, rdev);

That called md_error() both when rdev_set_badblocks() failed and when
!(set_bad && test_bit(In_sync, &rdev->flags)) was true. Since
rdev_set_badblocks() only calls md_error() when it is actually invoked and
badblocks_set() fails, omitting the else branch leaves the cases where
!(set_bad && test_bit(In_sync, &rdev->flags)) holds without calling
md_error().

Specifically, in raid5_end_read_request(), retry =3D=3D 0 and
!(set_bad && test_bit(In_sync, &rdev->flags)) occurs when:

1. A read error happens on a replacement device (R5_ReadRepl is set, leaving
   set_bad =3D 0 and retry =3D 0).
2. Consecutive read errors exceed max_nr_stripes (atomic_read(&rdev->read_e=
rrors)
   > max_nr_stripes, which logs "Too many read errors, failing device" with
   set_bad =3D 0 and retry =3D 0).
3. An uncorrectable read error or failed R5_ReWrite sets set_bad =3D 1 on a
   device where In_sync is not set.

In these paths, R5_ReadError and R5_ReWrite are cleared while R5_UPTODATE
remains clear, and neither Faulty nor a badblock is recorded on rdev. When
handle_stripe() -> analyse_stripe() runs again, will it continue to treat
rdev as healthy and re-issue the failing read in an infinite loop?

Should this be:

	if (set_bad && test_bit(In_sync, &rdev->flags))
		rdev_set_badblocks(rdev, sh->sector,
				   RAID5_STRIPE_SECTORS(conf), 0);
	else
		md_error(conf->mddev, rdev);

instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017074343.5951=
3-1-zh_exit@163.com?part=3D1
