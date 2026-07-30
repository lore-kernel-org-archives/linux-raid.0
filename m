Received: from va-2-56.ptr.blmpb.com (va-2-56.ptr.blmpb.com [209.127.231.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C513CB2FE
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 07:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397261; cv=none; b=gFTxjQubbsj8KnuQtbSod0eKloE48Z462C9FXHMtiFmfgYu9wstTxLc4/hN+AgfGY3YZFC1bkfOPEfgOsVx5K0Bir8p4q1o7Uj2UW4B+HvuhiAlplKBWX7W12R80hjIErTtfLEGx+qnKZSSiM99B2c13ihBJsNM5zHQoj6edKOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397261; c=relaxed/simple;
	bh=WU7PTnzE+mM5s4mnTw/a0KhvGlIkT3SPtZHBWcA/kKk=;
	h=Mime-Version:In-Reply-To:Cc:From:Date:References:To:Message-Id:
	 Content-Type:Subject; b=R64JXV6pe1ns1hLhcd9fsuN9NED+9IzdSVxhdI/cJUEoAMyzg41PlXNUjaB6RBK1Nj+p8A4hnv6lsYzut6FNfQU4pdYYXqcACRDNhGBfO9Yze+KMO1w3RVaefLlxQhXxD855tNMZtuEXdQvQdLKt1Ak/Tl3Mkipg8LAkDo0S8ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=FIa59Bn3; arc=none smtp.client-ip=209.127.231.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="FIa59Bn3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785397245;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=kKURUERJP5uyLs4MIcjTjvyKIyQfGK7n7b8fbZjGVvE=;
 b=FIa59Bn3h6+7L0NB0+z6TzKBs3SDibbvx6qizFjH3y1UdWOAJuQ3JCUDI7D5l3DUiCcOw7
 +O7HxvqfH1I4RGNirTAsrIyGxylhVlVIQdsw1hHA/2VfD0yUr5VtMJgotu/ZLZHHW4aibL
 otkOZHKwR6wvVo+cbZjW1WL1f7ztpT3mAZ8kdAoTy8QAGiRc/gyLJniILNKRuQ5V55TAU9
 wbEQFXl2cIMJe/NRvl3GpMLWv8etGnlVMdSowhqS5DaKsDNLYQUMkhLBpeYkPLx8l3gfv9
 d8J6q56eWDVNKRx2OKmblkvc9eF0E07HuUMdaWxLuA8OMKKwbjVRXbOqBq0oaw==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
In-Reply-To: <20260622124649.1780233-1-chencheng@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 07:40:44 +0000
Cc: <linux-kernel@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Date: Thu, 30 Jul 2026 15:40:40 +0800
Content-Transfer-Encoding: quoted-printable
References: <20260622124649.1780233-1-chencheng@fnnas.com>
Reply-To: yukuai@fygo.io
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Message-Id: <9994b970-9f4a-4c38-8c62-6383cd741a86@fygo.io>
X-Lms-Return-Path: <lba+26a6afffd+9d9ae0+vger.kernel.org+yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH] md/raid5: protect bitmap batch counters aka seq_flush/seq_write consistency
User-Agent: Mozilla Thunderbird

=E5=9C=A8 2026/6/22 20:46, Chen Cheng =E5=86=99=E9=81=93:

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
> Fixes: 7c13edc87510f ("md: incorporate new plugging into raid5.")
>
> v1 -> v2:
> - remove WRITE_ONCE(conf->seq_write) in held device_lock path.
> - remove READ_ONCE(conf->seq_flush) in held device_lock path.
>
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
>   drivers/md/raid5.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
Applied to md-7.3

--=20
Thanks,
Kuai
