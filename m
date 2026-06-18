Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42834334C1C
	for <linux-raid@vger.kernel.org>; Thu, 18 Jun 2026 03:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781752354; cv=none; b=Ikh6BzuJsxynSHreYiH4b+Zd45hnSxK6smDI/hEXkOcg0eu4tmitK325kxRaITWHUm7zyZrFon3nXqaVo9vcat/2i7vEyNhGDEWqAaTahQGnNK/i5Mmoro1NuWLGh9zm+IwUVLi89ZeRiH+fkGbqFucBdwZzNFFUOLnrRiOfnz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781752354; c=relaxed/simple;
	bh=ZXA0Jbbyg/s37BtnwFEVnCRkF+AZrahFv6DvvmGtUVk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ME79rTFnnc1PobzfV34tHYnqR/SiSF4UvuUr5CDO5TTU2ywtGIfuXq7hL3z8bd6EBhxw3qn7HKMXE66gsFtNkRYNxCl5rEd+1+K77D0/PFAV/3hnStA91H75sx6ew6ySO6sK82VZLh4m8PFBkmE4/RRMYXynwuiYt5ioQRIn4Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TeMNxqx/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TeMNxqx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831A41F000E9;
	Thu, 18 Jun 2026 03:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781752352;
	bh=Y0enYRdDXjVjB36YXXo7akL/9o9DpUCTU71wotCfLf4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TeMNxqx/7LvzoIrWnHOabeex65DTjqkDE8QjhEGV8hC2GrzcQfwtkabFK+pdNK4U+
	 cZQ/pYMkoswNnpe/zSHnk02m/ehkTsIADvF1bhtSPiPhPgkp7NkFa1T7M5ez1SJmoO
	 JueK6UeczeGQf2JMcEnexs7Zqk01rgkVULIQr2kA6Cdc5WkcSKooq19lF2YmsxGiJv
	 Uz9496+NkftO529ajvSisu9C0wyxk7hZHgJtmX+JqC0FTi7XoTBdLj5KjtSRZ/VgZm
	 18VrEKmKZSGA9Vt2qnOlDxIRnBZGtuKb1F2e8WyIQFJ2q+Axf1OP2J6aM28CRxiQ5+
	 Ro+/svONKFtvw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/raid5: let stripe batch bm_seq comparison wrap-safe
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Cheng" <chencheng@fnnas.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260618025735.915113-1-chencheng@fnnas.com>
References: <20260618025735.915113-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 18 Jun 2026 03:12:32 +0000
Message-Id: <20260618031232.831A41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] Wrap-safe sequence comparison introduces signed integer overflow=
, triggering UBSAN.

Pre-existing issues:
- [High] Concurrent lockless read-modify-write of `batch_head->bm_seq` can =
result in lost bitmap flush sequence updates.
--

commit 38cbf25fbeef1204525d320e539132e2704c3653
Author: Chen Cheng <chencheng@fnnas.com>

md/raid5: let stripe batch bm_seq comparison wrap-safe

This commit alters the comparison of sequence numbers in the RAID5=20
stripe batching path to correctly handle wrap-around by using subtraction.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index d0d7f96fd7cd9..5882670f7d0c9 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -996,7 +996,7 @@ static void stripe_add_to_batch_list(struct r5conf *c=
onf,
>  	if (test_and_clear_bit(STRIPE_BIT_DELAY, &sh->state)) {
>  		int seq =3D sh->bm_seq;
>  		if (test_bit(STRIPE_BIT_DELAY, &sh->batch_head->state) &&

[Severity: High]
This isn't a bug introduced by this patch, but it appears that the shared
batch_head->bm_seq is being accessed and updated locklessly here. If multip=
le
threads concurrently append stripes to different parts of the batch list,
could Thread A and Thread B concurrently read batch_head->bm_seq, compare i=
t,
and write it back, causing a race?

An unguarded read-modify-write might allow a thread writing an older
sequence number to overwrite a newer one written by another thread. If bm_s=
eq
gets overwritten with an older value, could the batch start processing befo=
re
the newer bitmap flush completes, potentially risking data corruption on po=
wer
loss?

> -		    sh->batch_head->bm_seq > seq)
> +		    sh->batch_head->bm_seq - seq > 0)

[Severity: Medium]
Since both sh->batch_head->bm_seq and seq are signed ints, does this wrap-s=
afe
comparison introduce a signed integer overflow when the sequence wraps?

While the kernel is compiled with -fno-strict-overflow so it functions as
intended, subtracting two signed integers whose difference exceeds the
representable range of a 32-bit signed integer can trigger Undefined Behavi=
or
Sanitizer (UBSAN) splats.

Could this be written by casting to unsigned before subtraction and back to
signed, such as (s32)((u32)a - (u32)b) > 0, to avoid UBSAN warnings and
potential kernel panics on environments with panic_on_warn?

>  			seq =3D sh->batch_head->bm_seq;
>  		set_bit(STRIPE_BIT_DELAY, &sh->batch_head->state);
>  		sh->batch_head->bm_seq =3D seq;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260618025735.9151=
13-1-chencheng@fnnas.com?part=3D1
