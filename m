Received: from va-2-56.ptr.blmpb.com (va-2-56.ptr.blmpb.com [209.127.231.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF9B342514
	for <linux-raid@vger.kernel.org>; Sat, 20 Jun 2026 22:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781992912; cv=none; b=nm/vt3IjoaQ8lbavzXjfi2Nh9gNaM1VxyTY1SkHwLHK1TgaVhbo1nUDBiKtZ12G3KNRSm1bXeW2ZP7cgtXLF7choxylq3yMnxM6TfzeujUwMuY8hdDSZNF23Jsgwlib7iyJog9UnYBxYwJIkRPI1fkwmndJ1zBkI8UXTWCAvcTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781992912; c=relaxed/simple;
	bh=IAePlKXTP05125LnYyeV4c1RFvOKJGOn/GHsaE2SLCw=;
	h=In-Reply-To:To:Cc:Message-Id:From:Date:Mime-Version:Subject:
	 References:Content-Type; b=W2IuXoX9IFdWoRgO1JX/fGbfpUQ/w/+aza2YB/sZpsEQCHPSf40yejEifyzlAfjMTPpi1CxKtvnU3hfOhaImZ5/jIBP41N8JdCtuV9mxUl/WzrUO3qV7wLw9fZCBfeJTbBcKbIaQO8GiU3lWz4RAmmyXExl1UlbfJG5Eh5z5LoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Cd4f1adg; arc=none smtp.client-ip=209.127.231.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Cd4f1adg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1781992903;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=50CIcQqEhEABBcp9fMCNyyCg2Y5tf+SV5lIt4pVe3Qo=;
 b=Cd4f1adgOa71JaZ2ZghmtKUhejnkQY0BMJ5rhYPLttl0iXtDAtg7YT4++QjzIFDh0cMvG+
 tFaMbNkpjexfFp1MBEdVO9fxMrCtLyVYRrqjRvSN1X4cSs///tFSIRyQED9/iskGUTI3MZ
 NpgXvNhqVwAfk6sCeg9pEPmIK08Fg/wdqOaO0+oz43mS4+4evIJUdfkG6IfwdoVcz6ShRj
 IvdVyVdYo6rGAYBBiwEgxz6wQBBfPi4/wLpWU6HTpRyjtfJ1ozO//0qx6yyeFfnBjZ/sBv
 TbVfuQnHaPTXfPM9RC+5SVNO8fqLBqVUUtX1slC4LtzKMY7zLr7pLk4iJN9a2g==
In-Reply-To: <20260619081109.1218112-1-chencheng@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Sat, 20 Jun 2026 22:01:41 +0000
Reply-To: yukuai@fygo.io
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
Cc: <linux-kernel@vger.kernel.org>
Message-Id: <e958cb97-556a-4320-8e76-9aed18a435bc@fygo.io>
X-Lms-Return-Path: <lba+26a370dc6+cc4f28+vger.kernel.org+yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Date: Sun, 21 Jun 2026 06:01:38 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] md/raid5: read batch_head under stripe_lock in make_stripe_request
References: <20260619081109.1218112-1-chencheng@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/6/19 16:11, Chen Cheng =E5=86=99=E9=81=93:
> From: Chen Cheng <chencheng@fnnas.com>
>
> KCSAN reports race in raid5_make_request() vs. stripe_add_to_batch_list()
>
> Writer flow (stripe_add_to_batch_list):
> 1. grab `head` stripe;
> 2. lock_two_stripes(head, sh);
> 3. re-check stripe_can_batch() for both head and sh, which requires
>     STRIPE_BATCH_READY set on both;
> 4. write head->batch_head =3D head and sh->batch_head =3D head;
> 5. unlock_two_stripes.
>
> STRIPE_BATCH_READY is cleared in two places:
> - clear_batch_ready(), at the entry of handle_stripe();
> - __add_stripe_bio(), for non-batchable bios.
> And, both need to acquire `stripe_lock`.
>
> Under stripe_lock, if STRIPE_BATCH_READY is clear, then:
> - New writers cannot install a batch_head;
> - Existing writers have already finished.
> So .. handle_stripe() readers can ready `batch_head` locklessly.

This does not explain the race clearly, I still have no clue yet.

>
> Fix way:
> Writer side make_stripe_request() under STRIPE_BATCH_READY, so , need
> to be protected by stripe_lock when read something..
>
> v1 -> v2:
> - re-expalin how stripe_lock and batch_head work in commit message , and =
,
> - modify comment in raid5.h.
>
> Fixs: f4aec6a097387

Weird fix tag again.

>
>
> KCSAN report:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    BUG: KCSAN: data-race in raid5_make_request / raid5_make_request
>
>    write to 0xffff8f03062432d8 of 8 bytes by task 210246 on cpu 6:
>      raid5_make_request+0x175e/0x2ab0
>      md_handle_request+0x2c5/0x700
>      md_submit_bio+0x126/0x320
>      [.........]
>      btrfs_sync_file+0x181/0x970
>      vfs_fsync_range+0x71/0x110
>      do_fsync+0x46/0xa0
>      __x64_sys_fsync+0x20/0x30
>
>    read to 0xffff8f03062432d8 of 8 bytes by task 210251 on cpu 0:
>      raid5_make_request+0x7c7/0x2ab0
>      md_handle_request+0x2c5/0x700
>      md_submit_bio+0x126/0x320
>      [.........]
>      btrfs_remap_file_range+0x266/0x980
>      vfs_clone_file_range+0x16d/0x610
>      ioctl_file_clone+0x64/0xd0
>      do_vfs_ioctl+0x87f/0xbc0
>      __x64_sys_ioctl+0xb8/0x130
>
>    value changed: 0x0000000000000000 -> 0xffff8f0307798728

Is this a mismatch report?

>
>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>   drivers/md/raid5.c | 2 ++
>   drivers/md/raid5.h | 8 +++++++-
>   2 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 5521051a9425..efc63740f867 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6108,14 +6108,16 @@ static enum stripe_result make_stripe_request(str=
uct mddev *mddev,
>   		ctx->do_flush =3D false;
>   	}
>  =20
>   	set_bit(STRIPE_HANDLE, &sh->state);
>   	clear_bit(STRIPE_DELAYED, &sh->state);
> +	spin_lock_irq(&sh->stripe_lock);
>   	if ((!sh->batch_head || sh =3D=3D sh->batch_head) &&
>   	    (bi->bi_opf & REQ_SYNC) &&
>   	    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>   		atomic_inc(&conf->preread_active_stripes);
> +	spin_unlock_irq(&sh->stripe_lock);
>  =20
>   	release_stripe_plug(mddev, sh);
>   	return STRIPE_SUCCESS;
>  =20
>   out_release:
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 1c7b710fc9c1..9ff825697ba3 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -221,11 +221,17 @@ struct stripe_head {
>   	enum reconstruct_states reconstruct_state;
>   	spinlock_t		stripe_lock;
>   	int			cpu;
>   	struct r5worker_group	*group;
>  =20
> -	struct stripe_head	*batch_head; /* protected by stripe lock */
> +	/*
> +	 * Writer protected by stripe_lock.
> +	 * Reader hold stripe_lock when STRIPE_BATCH_READY is set.
> +	 * Without STRIPE_BATCH_READY means no concurrent write,
> +	 * lockless read is ok.
> +	 */
> +	struct stripe_head	*batch_head;
>   	spinlock_t		batch_lock; /* only header's lock is useful */
>   	struct list_head	batch_list; /* protected by head's batch lock*/
>  =20
>   	union {
>   		struct r5l_io_unit	*log_io;

--=20
Thanks,
Kuai
