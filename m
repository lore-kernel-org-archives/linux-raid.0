Received: from va-2-48.ptr.blmpb.com (va-2-48.ptr.blmpb.com [209.127.231.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40E7372EEA
	for <linux-raid@vger.kernel.org>; Sun,  5 Jul 2026 08:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783241443; cv=none; b=Ap/jMP21G8FF4uwDMHw07qni8OMdjmgsWfAVISOAFHc8kZtcMke2yNUTHM4pYsQc8w+yvo/1XBdnAbF4T1g68412CAFhLGfsliOrUDR/mhy39rWuJ/JQ6IgiQCaXSc9h66/+WJ1itohmE0xdsiLM/mWvrxsWRSOw8IhwzOfi8IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783241443; c=relaxed/simple;
	bh=WlEMdGtzcKNnwpn8PU29AUDF5RIqrSCV102VCqlrTk8=;
	h=To:From:Message-Id:Mime-Version:Content-Type:Subject:Date:
	 References:In-Reply-To:Cc; b=V3u0/P0Gyak3OzNQQXNjua/IWdIy15B2EH9dNFrfGDnC6JIrzHFfWDPaDzOjznbATW40H0eR+cYoNa1f1Y4bFOBYvvFRZlRVyJy0fRmF/dqBEvNarYe1Ux6lnIVw7JHQVEjz/e4qpplBTtqZ+MHO4PesFA34pwPWHC4YSnu0h38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=l+vdLFmh; arc=none smtp.client-ip=209.127.231.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="l+vdLFmh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783241433;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=xyqwMNPPLy0pTxzfWs6GBSLStx6XvtgEnVs9jNLizi4=;
 b=l+vdLFmh0bB5O2uVfXx00ttEYd2N6rpjyX+NGnj4OJuu7ochCL+0NVAEDmgad51B2scbnJ
 W8hHWalKdQByY79UfhNEaTDO82y7RmkMODF2AvEDJhdQ1HXuCGv1o52DrD8dG3fm5WwjeV
 bjNMiKgp7c/4x0p+OcvAAdiOsSknKyBnvPX/qtW7b6VG297BFtNgVdnM0Rbuqw3ENmHZRg
 uUd+uGkV/9CHV8QyvSRdq2HAvCXKpdm64hl7GrC9xIW1yZi1Xg6isMg+3vB+uQ8S04aGfu
 j4qDZMbnAYP9IcCiLU4E19WpB77FU5lZgfI8G0+88wPtLg+E3VcQvrYDFbqZUw==
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <6204807c-3da4-4eb6-96f0-066f66030d33@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
Subject: Re: [PATCH v2] md/raid5: protect bitmap batch counters aka seq_flush/seq_write consistency
Date: Sun, 5 Jul 2026 16:50:28 +0800
References: <20260617142839.882378-1-chencheng@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Sun, 05 Jul 2026 08:50:32 +0000
In-Reply-To: <20260617142839.882378-1-chencheng@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Cc: <chenchneg33@gmail.com>, <linux-kernel@vger.kernel.org>
X-Original-From: yu kuai <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26a4a1ad9+19915b+vger.kernel.org+yukuai@fygo.io>

=E5=9C=A8 2026/6/17 22:28, Chen Cheng =E5=86=99=E9=81=93:

> From: Chen Cheng<chencheng@fnnas.com>
>
> kcsan detect race :
> - raid5d() closes the current bitmap batch by updating
> 	conf->seq_flush under conf->device_lock.
> - __add_stripe_bio() read conf->seq_flush without that
> 	lock when assigning sh->bm_seq.
>
> so, protect seq_flush/seq_write consistency for multiple CPUs by
> READ_ONCE()/WRITE_ONCE() under the path without held device_lock.
>
> re-explain the stripe batch sequence number update flow:
> 1. sh->bm_seq declare which batch number the stripe belongs to
>     when perform bitmap-related write.
> 	=3D=3D> bm_seq =3D seq_flush+1
>
> 2. stripe be handled,
> 	* if sh->bm_seq - conf->seq_write > 0, means the
> 	  batch stripes **newer than** the last written
> 	  batch, it cannot proceed yet, queued on bitmap_list.
> 	* otherwise , has already proceed.
>
> 3. raid5d() `++seq_flush` to closes the current batch, means
> 	* no more stripes join that old batch
> 	* just-closed batch ready to write-out to disk
>
> 4. raid5d() calls bitmap hooks unplug() or writeout, then,
>     `++seq_write` to the same as bm_seq.
>
> - seq_flush - for producer, to close batches.
> - seq_write - for consumer, the checkpoint number.
>
> the report:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KCSAN: data-race in __add_stripe_bio / raid5d
>
> write to 0xffff88ba5625d470 of 4 bytes by task 82401 on cpu 0:
>   raid5d+0x1d9/0xba0
>   [.....]
>
> read to 0xffff88ba5625d470 of 4 bytes by task 82421 on cpu 8:
>   __add_stripe_bio+0x332/0x400
>   raid5_make_request+0x6ac/0x2930
>   md_handle_request+0x4a2/0xa40
>   md_submit_bio+0x109/0x1a0
>   __submit_bio+0x2ec/0x390
>   [.....]
>
> v1 -> v2:
> - remove WRITE_ONCE(conf->seq_write) in held device_lock path.
> - remove READ_ONCE(conf->seq_flush) in held device_lock path.
>
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
>   drivers/md/raid5.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)

Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
