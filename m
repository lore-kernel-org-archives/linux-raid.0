Received: from sg-3-42.ptr.tlmpb.com (sg-3-42.ptr.tlmpb.com [101.45.255.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DAE3438A8
	for <linux-raid@vger.kernel.org>; Sat, 20 Jun 2026 21:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781992358; cv=none; b=IeytJxiDksvorAEFOxHD6XfC6IF88g2XOPTOQ8CcYn2NyNf+2D26l2hSBqZQSDAi2U8uAu1MrTp3TFQMBQ17Bqkx1WRgfoPLSDI3gFNbz01I0Rw7FjAW48Sj5CzxcY0W2PlaIChHCrEzNWnB09ol5kUSCUXyQsVvDVDHXvi0bVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781992358; c=relaxed/simple;
	bh=+K9O/nw2p76eDJ04Rq8T8niC+6v5XVi+YyKOkZ61TFs=;
	h=Cc:Message-Id:Content-Type:Mime-Version:References:To:Subject:
	 Date:From:In-Reply-To; b=d5CVuDp1QJv9Le+0GFfxg6opD0GL9QC6tRaOJHS+6EpaNiw8OSG8drBCm2bjrmcIuQAKAkpLq2C19Jc9QFsx/tUgWfsLD5k7KJQbnjkhVvW62R1/COVH/SRmVh4XGOfGG+R+vm6ncSRXV5m3VNsH+V52gvESmWbaaNRKbr4By/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=OVjY3yRv; arc=none smtp.client-ip=101.45.255.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="OVjY3yRv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1781992274;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Rh8vphOjLt6fCjK1dmAuDd4VAPekIv8JODYqiCCgCnU=;
 b=OVjY3yRvX5DzvWk4rtFWGmMbvrX5ZQoV8jlZjVfZYRijtHI4X8GvvRyJYtGxhnrWu3HxFa
 APU5+M8ZlMADvehRgTB2/mWfeQlJghD3TsTyYxros2PczXcShBjcncqEMB2sCD5Koxk7s8
 VfPVSYP9s0THszye61aEZzf8kOmNpoKTGAcz0vrcdv3iAyQBMgffWdSL0TxlcasWEt6Swa
 Ao/06sgzA43ALE4b6XX3rwpMZsgySk/zHbpCnK5HPOBqlIvPY3bSFI+ygmuv/BmH33QINq
 gUjA34xMOmGBn2Sd01XfU0f/u6jUTAi1j34ecQhAuHYQXihlABtkUL5EnLYrcA==
Cc: <chenchneg33@gmail.com>, <linux-kernel@vger.kernel.org>
Message-Id: <61ab9ced-3cad-430f-b6ee-0ae51cfff601@fygo.io>
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Sat, 20 Jun 2026 21:51:13 +0000
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26a370b52+6a0c13+vger.kernel.org+yukuai@fygo.io>
References: <20260619041013.1207148-1-chencheng@fnnas.com>
Reply-To: yukuai@fygo.io
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
Subject: Re: [PATCH] md/raid5: avoid R5_Overlap races while breaking stripe batches
Date: Sun, 21 Jun 2026 05:51:10 +0800
From: "yu kuai" <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
In-Reply-To: <20260619041013.1207148-1-chencheng@fnnas.com>

=E5=9C=A8 2026/6/19 12:10, Chen Cheng =E5=86=99=E9=81=93:

> From: Chen Cheng <chencheng@fnnas.com>
>
> KCSAN report a race in break_stripe_batch_list() vs. raid5_make_request()
> on sh->dev[i].flags (plain word write vs. atomic bit op)..
>
> and .. one possible scenario is:
>
> CPU1                            CPU2
> break_stripe_batch_list(sh1)
> -> handle sh2
> -> lock(sh2)
> -> sh2->batch_head =3D NULL
> -> unlock(sh2)
> -> test_and_clear_bit(R5_Overlap, sh2->dev[i].flags)
> -> wake_up_bit(sh2->dev[i].flags)
>                                  raid5_make_request()
>                                  -> add_all_stripe_bios(sh2)
>                                  -> lock(sh2)
>                                  -> stripe_bio_overlaps(sh2) returns true
> 				   batch_head is NULL, so new bio overlap
> 				   exist bio on sh2 -> true
>                                  -> set_bit(R5_Overlap, sh2->dev[i].flags=
)
>                                  -> unlock(sh2)
>                                  -> wait_on_bit(sh2->dev[i].flags)
> -> sh2->dev[i].flags =3D sh1->dev[i].flags & ~R5_Overlap
>
> No wait_up_bit(), CPU2 could be wait_on_bit() forever...
>
> Fix by :
> - Expand the protect zone.
> - Use batch_head's device flag's snaphot when no held head_sh->stripe_loc=
k.
> - Move sh/head_sh->batch_head =3D NULL to the end of protected zone , and=
 ,
>    any concurrent add_all_stripe_bios() grabs sh->stripe_lock now either:
> 	- see batch_head !=3D null, and , is rejected by stripe_bio_overlaps()
> 	  under the lock (no R5_Overlap wait ) , or ,
> 	- sees batch_head =3D=3D NULL, only after dev[i].flags has already been
> 	  set and the prior R5_Overlap waiters worken.
>
> KCSAN report:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    BUG: KCSAN: data-race in break_stripe_batch_list / raid5_make_request
>
>    write (marked) to 0xffff8e89c8117548 of 8 bytes by task 4042 on cpu 0:
>      raid5_make_request+0xea0/0x2930
>      md_handle_request+0x4a2/0xa40
>      md_submit_bio+0x109/0x1a0
>      __submit_bio+0x2ec/0x390
>      submit_bio_noacct_nocheck+0x457/0x710
>      submit_bio_noacct+0x2a7/0xc20
>      submit_bio+0x56/0x250
>      blkdev_direct_IO+0x54c/0xda0
>      blkdev_write_iter+0x38f/0x570
>      aio_write+0x22b/0x490
>      io_submit_one+0xa51/0xf70
>      __x64_sys_io_submit+0xf7/0x220
>      x64_sys_call+0x1907/0x1c60
>      do_syscall_64+0x130/0x570
>      entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
>    read to 0xffff8e89c8117548 of 8 bytes by task 4010 on cpu 5:
>      break_stripe_batch_list+0x249/0x480
>      handle_stripe_clean_event+0x720/0x9b0
>      handle_stripe+0x32fb/0x4500
>      handle_active_stripes.isra.0+0x6e0/0xa50
>      raid5d+0x7e0/0xba0
>      md_thread+0x15a/0x2d0
>      kthread+0x1e3/0x220
>      ret_from_fork+0x37a/0x410
>      ret_from_fork_asm+0x1a/0x30
>
>    value changed: 0x0000000000000019 -> 0x0000000000000099 --> R5_Overlap
>
> Fixes: fb642b92c267b

Fix this tag and applied to md-7.2

>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>   drivers/md/raid5.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index a376560be92e..5521051a9425 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4939,30 +4939,30 @@ static void break_stripe_batch_list(struct stripe=
_head *head_sh,
>   			      state & (1 << STRIPE_INSYNC));
>  =20
>   		sh->check_state =3D head_sh->check_state;
>   		sh->reconstruct_state =3D head_sh->reconstruct_state;
>   		spin_lock_irq(&sh->stripe_lock);
> -		sh->batch_head =3D NULL;
> -		spin_unlock_irq(&sh->stripe_lock);
>   		for (i =3D 0; i < sh->disks; i++) {
>   			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
>   				wake_up_bit(&sh->dev[i].flags, R5_Overlap);
> -			sh->dev[i].flags =3D head_sh->dev[i].flags &
> +			sh->dev[i].flags =3D READ_ONCE(head_sh->dev[i].flags) &
>   				(~((1 << R5_WriteError) | (1 << R5_Overlap)));
>   		}
> +		sh->batch_head =3D NULL;
> +		spin_unlock_irq(&sh->stripe_lock);
>  =20
>   		state =3D READ_ONCE(sh->state);
>   		if (handle_flags =3D=3D 0 || (state & handle_flags))
>   			set_bit(STRIPE_HANDLE, &sh->state);
>   		raid5_release_stripe(sh);
>   	}
>   	spin_lock_irq(&head_sh->stripe_lock);
> -	head_sh->batch_head =3D NULL;
> -	spin_unlock_irq(&head_sh->stripe_lock);
>   	for (i =3D 0; i < head_sh->disks; i++)
>   		if (test_and_clear_bit(R5_Overlap, &head_sh->dev[i].flags))
>   			wake_up_bit(&head_sh->dev[i].flags, R5_Overlap);
> +	head_sh->batch_head =3D NULL;
> +	spin_unlock_irq(&head_sh->stripe_lock);
>  =20
>   	state =3D READ_ONCE(head_sh->state);
>   	if (state & handle_flags)
>   		set_bit(STRIPE_HANDLE, &head_sh->state);
>   }

--=20
Thanks,
Kuai
