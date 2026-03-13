Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491DE1632DD
	for <linux-raid@vger.kernel.org>; Fri, 13 Mar 2026 03:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773371781; cv=pass; b=aM3qg0G5qYh6SLS196Kq82pVn5NTO5amyiBk0RDE0lXUxEHt9mhSqR4blMKowLsbOGd0qwRXb+EQ19lg5hRvC5sX/p9+DJuf6YTSb5OHebtO50mq0CcqwLkcimm4RqikbjcNNfX9pYjfhyoGejjvNqjs89eD/kTL/fYHZhAAyLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773371781; c=relaxed/simple;
	bh=gliWiYpQh09ZvY1VTNZpuwEls2MNMouyc+vYSd2kj6M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=csCkmF+k9Zr3SvAz0kFsImpB2R6stIgV/Cw1LWATtQBwiNa0KT4Ou4L3aXEac9f2wPEXyIk36DJmK5P4yNubfKLauEbFWZlX0w5aBnsUTWVkxnGBAhgfgBh1BxEyg/xdkrlIybFs5pBbcnKp+7He3bWJScJWEDDPp6WCyEQ1YXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KVwCuNMY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=akceZiyf; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KVwCuNMY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="akceZiyf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773371779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LXLwZqo80rFmWOBgIx6DbU6ie1bVVIzRXUKmIjS8/QQ=;
	b=KVwCuNMY61ehU7gR/wovZ1QykrQY6TCO32dvwGVnEoRS+0LeDWAs4JMY3hWzydi8LOHR1x
	Z5yWPyJHsJzvEqn9VKrub9iE4dO0lNs1Yqp8EynQj9R8cJSW34vhJeT8ysZztza5/wOSrL
	h9P8EOIFDN+hHWDC4oWV6LSJBDJPSt8=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-Vf27Xgw9PAqPpf0Ic4sn9Q-1; Thu, 12 Mar 2026 23:16:17 -0400
X-MC-Unique: Vf27Xgw9PAqPpf0Ic4sn9Q-1
X-Mimecast-MFC-AGG-ID: Vf27Xgw9PAqPpf0Ic4sn9Q_1773371776
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-59e28288067so1086644e87.2
        for <linux-raid@vger.kernel.org>; Thu, 12 Mar 2026 20:16:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773371774; cv=none;
        d=google.com; s=arc-20240605;
        b=bOZXg1FzGxKpf9kwQL2IZMussPXy/8Cpl5iBLpm9Xzcqsyn49Y149yblHqtVtN6Vpy
         HH4mNc3j1k+l4eW7bzSlVwkb4NfV0ZuUMrT/i/piqXfEjrL9jCtaEv8ujawTtjGIsHf8
         99Q69AXMbMK39EZAOfC6JMvH85BfqHUHE+IUtowgUPCsIqXRcC2TCZVLDBcFFQeW7yQN
         61bRzoTHimS4x8RID4+UIVSd8mgfByeMrkbY2Bl71nMYF7Y0VBV+XHBGwJQN+DpwtWQx
         1XS1MUKW7p4t7GrVCxejOCKcSOnuu3XhrMM+/p5EmlZ2Uqj+gq5DqOeTptrMKcMpAswc
         FpWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LXLwZqo80rFmWOBgIx6DbU6ie1bVVIzRXUKmIjS8/QQ=;
        fh=dD1yVL1xLzLCl9NCbNOk9si/jvyMUxnvFMHkuZAfJNE=;
        b=RajRDjItmeCpGB4XIJwEUeuqMCtW+l0xRGBhvnK50R1xSzArMx7JgBzukgr0MJ5DCE
         2Kwi4+jCyMOaRTfKb3U4tum3DMadpu9x3ouEsW9o6Ee56u2phfOEYHKhCqT+NzNLE5GC
         xtYpvsju+rJYfcqaiKf2mgUfi/ZiCB0DZsyFCaz4LFe6wV3K71j3hVcxASv12L8EoIiT
         tP3Cztl59zu2p/jRdGJ71BzappLoZBUPs6vMNysGIm1rvHRuGyZcQNEJLJLGZgZyZFqO
         87e8ou2x9fsOIFbBckH1BI1q5HN/tXiPTzG8t+8g7CDBFBGgn0wf2qiOFTfdosrSAYDW
         fLcA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773371774; x=1773976574; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LXLwZqo80rFmWOBgIx6DbU6ie1bVVIzRXUKmIjS8/QQ=;
        b=akceZiyf2kU4LLHO31LGP6efs7chvgiD6+R+64xP1mQuiYlOGy1xuJ7Q9QTfXvJ7Ey
         MmBuCit4Xj6u4IZyIf6T8l1muBtnAH3T5Q1DuDJLhdJw/Fww2zCHyG1waS2ej9MLbNKM
         dePrNzb6g2a64rxrUgfcVksYJzXYHPbFhtICmRZej4/IQZjzQIHJhGEQSzqQ2YEGY/B7
         0Na9wuUD6CqTvs4ONnKGXiLia/BR+pM6bcDSCrxSg82CTQGnooV9lkJj7t3aukZ9sAQL
         S1631uCnVD+awkPsnz+Ei1VokcU9QsPAwCvUBjceCi5Kl/NBAwQbXGFpOMeHhZreEnbm
         XMIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773371774; x=1773976574;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LXLwZqo80rFmWOBgIx6DbU6ie1bVVIzRXUKmIjS8/QQ=;
        b=UCy8jNpgDmvC4WK0fFR8CeGGm3FIsgBwuTrSVqcrUWCg071+a98mHZ7/ocActD7hdd
         cTHxclJnjN5b5/OMdQEOa5M1DqqVT5vbSV6tPWI7azBHDr/Aww/xcLKra20KYLjJj/0a
         faYwoffJw9IdkjCphsIp5nW+I2TQ5czD+kfpbYOZQ/GrGQHWV6QzuweuMVE0FIjmzDsS
         we1PV5p0oxWzcU9P9I4DyhDpP53M3s+GcbTsIlwojUvLwh8C3/EXTxCPlxEqYukgp05Q
         I+WuVNKC53gKqdmu+2B/k98cQRoVrJmmioITXiX+jzg9I85rpoVwGH6mE8IOhA2T6gYI
         B+Xg==
X-Forwarded-Encrypted: i=1; AJvYcCUmOZYR8J8G2UepO9Zv834MxGhgBfDbOyuUmY3mSrnmrNr5tlTExPeNiYBxuYnO0ci+27oN9kUqWxos@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0GWR/I6iROryk3R7cN0caATfA6E1MVXDne1WI26QuNsFfHUFh
	l4WdThImgkp+Qw97jyUS1Oy13rcxT4u+OrD04ezCWNhuIxGWyMEkZvUZczzhmcSOALdDmUhbx4/
	mdC2fdxYoC8rqPII4ijIcwcGRJf7hOX5Y+G16RMHnK1zwX1z882U1EFKlsAm3FFwZKWVo7ocBVS
	o0gSisayVMDExFgXOHjCgRsqyDApu0nEOumvbtqEe1VkocXw==
X-Gm-Gg: ATEYQzyeYmytyyM7wiP1xENNZc7VPWg9lJ6I0sHecVMJoGnh6L5NgChTmd5yMmG+XQf
	ZwcvorhhKrQLpM/s8ntWYPZ0Gntn9jmKKDqFmD8rNsQpCiaSYJLYLKYi5vQRxyHVn5Pcj/b3xmS
	/4Lm1knURpbmpN56LEetoChMRUIgEtul9FaBoN59AmLhZqAcm8KwQLTEihEvPAM3J8DsGV8e/4x
	nP6FUc1FrkqOcfnu1HPZ3L0Cpa8IDo7OjI5d/FEH/z3fzIL0KRGjYwzKkNXfESm2LRvV7h7tkNL
	XMBSNA==
X-Received: by 2002:a05:6512:324a:b0:5a1:52f7:3cd1 with SMTP id 2adb3069b0e04-5a162b151c4mr352827e87.37.1773371774315;
        Thu, 12 Mar 2026 20:16:14 -0700 (PDT)
X-Received: by 2002:a05:6512:324a:b0:5a1:52f7:3cd1 with SMTP id
 2adb3069b0e04-5a162b151c4mr352817e87.37.1773371773741; Thu, 12 Mar 2026
 20:16:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260223024038.3084853-1-yukuai@fnnas.com> <20260223024038.3084853-5-yukuai@fnnas.com>
In-Reply-To: <20260223024038.3084853-5-yukuai@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 13 Mar 2026 11:16:01 +0800
X-Gm-Features: AaiRm50kf8QAcjgTwavr5Qf-P15o5GDF7NYQVvbnHM6zbiE9lN_pf_kSFirX8ec
Message-ID: <CALTww2_cWUjHajL=7VRUSh-5jyzg4xK9ih2G_AhD3jMsF3qrAQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] md/md-llbitmap: add CleanUnwritten state for
 RAID-5 proactive parity building
To: Yu Kuai <yukuai@fnnas.com>
Cc: song@kernel.org, linan122@huawei.com, colyli@fnnas.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2026 at 10:44=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Add new states to the llbitmap state machine to support proactive XOR
> parity building for RAID-5 arrays. This allows users to pre-build parity
> data for unwritten regions before any user data is written.
>
> New states added:
> - BitNeedSyncUnwritten: Transitional state when proactive sync is trigger=
ed
>   via sysfs on Unwritten regions.
> - BitSyncingUnwritten: Proactive sync in progress for unwritten region.
> - BitCleanUnwritten: XOR parity has been pre-built, but no user data
>   written yet. When user writes to this region, it transitions to BitDirt=
y.
>
> New actions added:
> - BitmapActionProactiveSync: Trigger for proactive XOR parity building.
> - BitmapActionClearUnwritten: Convert CleanUnwritten/NeedSyncUnwritten/
>   SyncingUnwritten states back to Unwritten before recovery starts.
>
> State flows:
> - Current (lazy): Unwritten -> (write) -> NeedSync -> (sync) -> Dirty -> =
Clean
> - New (proactive): Unwritten -> (sysfs) -> NeedSyncUnwritten -> (sync) ->=
 CleanUnwritten
> - On write to CleanUnwritten: CleanUnwritten -> (write) -> Dirty -> Clean
> - On disk replacement: CleanUnwritten regions are converted to Unwritten
>   before recovery starts, so recovery only rebuilds regions with user dat=
a
>
> A new sysfs interface is added at /sys/block/mdX/md/llbitmap/proactive_sy=
nc
> (write-only) to trigger proactive sync. This only works for RAID-456 arra=
ys.
>
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>  drivers/md/md-llbitmap.c | 140 +++++++++++++++++++++++++++++++++++----
>  drivers/md/md.c          |   6 +-
>  2 files changed, 132 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 5f9e7004e3e3..461050b2771b 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -208,6 +208,20 @@ enum llbitmap_state {
>         BitNeedSync,
>         /* data is synchronizing */
>         BitSyncing,
> +       /*
> +        * Proactive sync requested for unwritten region (raid456 only).
> +        * Triggered via sysfs when user wants to pre-build XOR parity
> +        * for regions that have never been written.
> +        */
> +       BitNeedSyncUnwritten,
> +       /* Proactive sync in progress for unwritten region */
> +       BitSyncingUnwritten,
> +       /*
> +        * XOR parity has been pre-built for a region that has never had
> +        * user data written. When user writes to this region, it transit=
ions
> +        * to BitDirty.
> +        */
> +       BitCleanUnwritten,
>         BitStateCount,
>         BitNone =3D 0xff,
>  };
> @@ -232,6 +246,12 @@ enum llbitmap_action {
>          * BitNeedSync.
>          */
>         BitmapActionStale,
> +       /*
> +        * Proactive sync trigger for raid456 - builds XOR parity for
> +        * Unwritten regions without requiring user data write first.
> +        */
> +       BitmapActionProactiveSync,
> +       BitmapActionClearUnwritten,
>         BitmapActionCount,
>         /* Init state is BitUnwritten */
>         BitmapActionInit,
> @@ -304,6 +324,8 @@ static char state_machine[BitStateCount][BitmapAction=
Count] =3D {
>                 [BitmapActionDaemon]            =3D BitNone,
>                 [BitmapActionDiscard]           =3D BitNone,
>                 [BitmapActionStale]             =3D BitNone,
> +               [BitmapActionProactiveSync]     =3D BitNeedSyncUnwritten,
> +               [BitmapActionClearUnwritten]    =3D BitNone,
>         },
>         [BitClean] =3D {
>                 [BitmapActionStartwrite]        =3D BitDirty,
> @@ -314,6 +336,8 @@ static char state_machine[BitStateCount][BitmapAction=
Count] =3D {
>                 [BitmapActionDaemon]            =3D BitNone,
>                 [BitmapActionDiscard]           =3D BitUnwritten,
>                 [BitmapActionStale]             =3D BitNeedSync,
> +               [BitmapActionProactiveSync]     =3D BitNone,
> +               [BitmapActionClearUnwritten]    =3D BitNone,
>         },
>         [BitDirty] =3D {
>                 [BitmapActionStartwrite]        =3D BitNone,
> @@ -324,6 +348,8 @@ static char state_machine[BitStateCount][BitmapAction=
Count] =3D {
>                 [BitmapActionDaemon]            =3D BitClean,
>                 [BitmapActionDiscard]           =3D BitUnwritten,
>                 [BitmapActionStale]             =3D BitNeedSync,
> +               [BitmapActionProactiveSync]     =3D BitNone,
> +               [BitmapActionClearUnwritten]    =3D BitNone,
>         },
>         [BitNeedSync] =3D {
>                 [BitmapActionStartwrite]        =3D BitNone,
> @@ -334,6 +360,8 @@ static char state_machine[BitStateCount][BitmapAction=
Count] =3D {
>                 [BitmapActionDaemon]            =3D BitNone,
>                 [BitmapActionDiscard]           =3D BitUnwritten,
>                 [BitmapActionStale]             =3D BitNone,
> +               [BitmapActionProactiveSync]     =3D BitNone,
> +               [BitmapActionClearUnwritten]    =3D BitNone,
>         },
>         [BitSyncing] =3D {
>                 [BitmapActionStartwrite]        =3D BitNone,
> @@ -344,6 +372,44 @@ static char state_machine[BitStateCount][BitmapActio=
nCount] =3D {
>                 [BitmapActionDaemon]            =3D BitNone,
>                 [BitmapActionDiscard]           =3D BitUnwritten,
>                 [BitmapActionStale]             =3D BitNeedSync,
> +               [BitmapActionProactiveSync]     =3D BitNone,
> +               [BitmapActionClearUnwritten]    =3D BitNone,
> +       },
> +       [BitNeedSyncUnwritten] =3D {
> +               [BitmapActionStartwrite]        =3D BitNeedSync,
> +               [BitmapActionStartsync]         =3D BitSyncingUnwritten,
> +               [BitmapActionEndsync]           =3D BitNone,
> +               [BitmapActionAbortsync]         =3D BitUnwritten,
> +               [BitmapActionReload]            =3D BitUnwritten,
> +               [BitmapActionDaemon]            =3D BitNone,
> +               [BitmapActionDiscard]           =3D BitUnwritten,
> +               [BitmapActionStale]             =3D BitUnwritten,
> +               [BitmapActionProactiveSync]     =3D BitNone,
> +               [BitmapActionClearUnwritten]    =3D BitUnwritten,
> +       },
> +       [BitSyncingUnwritten] =3D {
> +               [BitmapActionStartwrite]        =3D BitSyncing,
> +               [BitmapActionStartsync]         =3D BitSyncingUnwritten,

Hi Kuai

Is it ok to set the above state to BitNone? The orignal state is
already BitSyncingUnwritten.

> +               [BitmapActionEndsync]           =3D BitCleanUnwritten,
> +               [BitmapActionAbortsync]         =3D BitUnwritten,
> +               [BitmapActionReload]            =3D BitUnwritten,
> +               [BitmapActionDaemon]            =3D BitNone,
> +               [BitmapActionDiscard]           =3D BitUnwritten,
> +               [BitmapActionStale]             =3D BitUnwritten,
> +               [BitmapActionProactiveSync]     =3D BitNone,
> +               [BitmapActionClearUnwritten]    =3D BitUnwritten,
> +       },
> +       [BitCleanUnwritten] =3D {
> +               [BitmapActionStartwrite]        =3D BitDirty,
> +               [BitmapActionStartsync]         =3D BitNone,
> +               [BitmapActionEndsync]           =3D BitNone,
> +               [BitmapActionAbortsync]         =3D BitNone,
> +               [BitmapActionReload]            =3D BitNone,
> +               [BitmapActionDaemon]            =3D BitNone,
> +               [BitmapActionDiscard]           =3D BitUnwritten,
> +               [BitmapActionStale]             =3D BitUnwritten,
> +               [BitmapActionProactiveSync]     =3D BitNone,
> +               [BitmapActionClearUnwritten]    =3D BitUnwritten,
>         },
>  };
>
> @@ -376,6 +442,7 @@ static void llbitmap_infect_dirty_bits(struct llbitma=
p *llbitmap,
>                         pctl->state[pos] =3D level_456 ? BitNeedSync : Bi=
tDirty;
>                         break;
>                 case BitClean:
> +               case BitCleanUnwritten:
>                         pctl->state[pos] =3D BitDirty;
>                         break;
>                 }
> @@ -383,7 +450,7 @@ static void llbitmap_infect_dirty_bits(struct llbitma=
p *llbitmap,
>  }
>
>  static void llbitmap_set_page_dirty(struct llbitmap *llbitmap, int idx,
> -                                   int offset)
> +                                   int offset, bool infect)
>  {
>         struct llbitmap_page_ctl *pctl =3D llbitmap->pctl[idx];
>         unsigned int io_size =3D llbitmap->io_size;
> @@ -398,7 +465,7 @@ static void llbitmap_set_page_dirty(struct llbitmap *=
llbitmap, int idx,
>          * resync all the dirty bits, hence skip infect new dirty bits to
>          * prevent resync unnecessary data.
>          */
> -       if (llbitmap->mddev->degraded) {
> +       if (llbitmap->mddev->degraded || !infect) {
>                 set_bit(block, pctl->dirty);
>                 return;
>         }
> @@ -438,7 +505,9 @@ static void llbitmap_write(struct llbitmap *llbitmap,=
 enum llbitmap_state state,
>
>         llbitmap->pctl[idx]->state[bit] =3D state;
>         if (state =3D=3D BitDirty || state =3D=3D BitNeedSync)
> -               llbitmap_set_page_dirty(llbitmap, idx, bit);
> +               llbitmap_set_page_dirty(llbitmap, idx, bit, true);
> +       else if (state =3D=3D BitNeedSyncUnwritten)
> +               llbitmap_set_page_dirty(llbitmap, idx, bit, false);
>  }
>
>  static struct page *llbitmap_read_page(struct llbitmap *llbitmap, int id=
x)
> @@ -627,11 +696,10 @@ static enum llbitmap_state llbitmap_state_machine(s=
truct llbitmap *llbitmap,
>                         goto write_bitmap;
>                 }
>
> -               if (c =3D=3D BitNeedSync)
> +               if (c =3D=3D BitNeedSync || c =3D=3D BitNeedSyncUnwritten=
)
>                         need_resync =3D !mddev->degraded;
>
>                 state =3D state_machine[c][action];
> -
>  write_bitmap:
>                 if (unlikely(mddev->degraded)) {
>                         /* For degraded array, mark new data as need sync=
. */
> @@ -658,8 +726,7 @@ static enum llbitmap_state llbitmap_state_machine(str=
uct llbitmap *llbitmap,
>                 }
>
>                 llbitmap_write(llbitmap, state, start);
> -
> -               if (state =3D=3D BitNeedSync)
> +               if (state =3D=3D BitNeedSync || state =3D=3D BitNeedSyncU=
nwritten)
>                         need_resync =3D !mddev->degraded;
>                 else if (state =3D=3D BitDirty &&
>                          !timer_pending(&llbitmap->pending_timer))
> @@ -1229,7 +1296,7 @@ static bool llbitmap_blocks_synced(struct mddev *md=
dev, sector_t offset)
>         unsigned long p =3D offset >> llbitmap->chunkshift;
>         enum llbitmap_state c =3D llbitmap_read(llbitmap, p);
>
> -       return c =3D=3D BitClean || c =3D=3D BitDirty;
> +       return c =3D=3D BitClean || c =3D=3D BitDirty || c =3D=3D BitClea=
nUnwritten;
>  }
>
>  static sector_t llbitmap_skip_sync_blocks(struct mddev *mddev, sector_t =
offset)
> @@ -1243,6 +1310,10 @@ static sector_t llbitmap_skip_sync_blocks(struct m=
ddev *mddev, sector_t offset)
>         if (c =3D=3D BitUnwritten)
>                 return blocks;
>
> +       /* Skip CleanUnwritten - no user data, will be reset after recove=
ry */
> +       if (c =3D=3D BitCleanUnwritten)
> +               return blocks;
> +
>         /* For degraded array, don't skip */
>         if (mddev->degraded)
>                 return 0;
> @@ -1261,14 +1332,25 @@ static bool llbitmap_start_sync(struct mddev *mdd=
ev, sector_t offset,
>  {
>         struct llbitmap *llbitmap =3D mddev->bitmap;
>         unsigned long p =3D offset >> llbitmap->chunkshift;
> +       enum llbitmap_state state;
> +
> +       /*
> +        * Before recovery starts, convert CleanUnwritten to Unwritten.
> +        * This ensures the new disk won't have stale parity data.
> +        */
> +       if (offset =3D=3D 0 && test_bit(MD_RECOVERY_RECOVER, &mddev->reco=
very) &&
> +           !test_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery))
> +               llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1,
> +                                      BitmapActionClearUnwritten);
> +
>
>         /*
>          * Handle one bit at a time, this is much simpler. And it doesn't=
 matter
>          * if md_do_sync() loop more times.
>          */
>         *blocks =3D llbitmap->chunksize - (offset & (llbitmap->chunksize =
- 1));
> -       return llbitmap_state_machine(llbitmap, p, p,
> -                                     BitmapActionStartsync) =3D=3D BitSy=
ncing;
> +       state =3D llbitmap_state_machine(llbitmap, p, p, BitmapActionStar=
tsync);
> +       return state =3D=3D BitSyncing || state =3D=3D BitSyncingUnwritte=
n;
>  }
>
>  /* Something is wrong, sync_thread stop at @offset */
> @@ -1474,9 +1556,15 @@ static ssize_t bits_show(struct mddev *mddev, char=
 *page)
>         }
>
>         mutex_unlock(&mddev->bitmap_info.mutex);
> -       return sprintf(page, "unwritten %d\nclean %d\ndirty %d\nneed sync=
 %d\nsyncing %d\n",
> +       return sprintf(page,
> +                      "unwritten %d\nclean %d\ndirty %d\n"
> +                      "need sync %d\nsyncing %d\n"
> +                      "need sync unwritten %d\nsyncing unwritten %d\n"
> +                      "clean unwritten %d\n",
>                        bits[BitUnwritten], bits[BitClean], bits[BitDirty]=
,
> -                      bits[BitNeedSync], bits[BitSyncing]);
> +                      bits[BitNeedSync], bits[BitSyncing],
> +                      bits[BitNeedSyncUnwritten], bits[BitSyncingUnwritt=
en],
> +                      bits[BitCleanUnwritten]);
>  }
>
>  static struct md_sysfs_entry llbitmap_bits =3D __ATTR_RO(bits);
> @@ -1549,11 +1637,39 @@ barrier_idle_store(struct mddev *mddev, const cha=
r *buf, size_t len)
>
>  static struct md_sysfs_entry llbitmap_barrier_idle =3D __ATTR_RW(barrier=
_idle);
>
> +static ssize_t
> +proactive_sync_store(struct mddev *mddev, const char *buf, size_t len)
> +{
> +       struct llbitmap *llbitmap;
> +
> +       /* Only for RAID-456 */
> +       if (!raid_is_456(mddev))
> +               return -EINVAL;
> +
> +       mutex_lock(&mddev->bitmap_info.mutex);
> +       llbitmap =3D mddev->bitmap;
> +       if (!llbitmap || !llbitmap->pctl) {
> +               mutex_unlock(&mddev->bitmap_info.mutex);
> +               return -ENODEV;
> +       }
> +
> +       /* Trigger proactive sync on all Unwritten regions */
> +       llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1,
> +                              BitmapActionProactiveSync);
> +
> +       mutex_unlock(&mddev->bitmap_info.mutex);
> +       return len;
> +}
> +
> +static struct md_sysfs_entry llbitmap_proactive_sync =3D
> +       __ATTR(proactive_sync, 0200, NULL, proactive_sync_store);
> +
>  static struct attribute *md_llbitmap_attrs[] =3D {
>         &llbitmap_bits.attr,
>         &llbitmap_metadata.attr,
>         &llbitmap_daemon_sleep.attr,
>         &llbitmap_barrier_idle.attr,
> +       &llbitmap_proactive_sync.attr,
>         NULL
>  };
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 245785ad0ffd..b6543d81ac96 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9878,8 +9878,10 @@ void md_do_sync(struct md_thread *thread)
>                                  * Give other IO more of a chance.
>                                  * The faster the devices, the less we wa=
it.
>                                  */
> -                               wait_event(mddev->recovery_wait,
> -                                          !atomic_read(&mddev->recovery_=
active));
> +                               wait_event_timeout(
> +                                       mddev->recovery_wait,
> +                                       !atomic_read(&mddev->recovery_act=
ive),
> +                                       HZ);

Could you explain this change? It no longer waits for synchronous I/O
to finish when the sync speed is fast. Does it have relasionship with
this major change of this patch?

Best Regards
Xiao
>                         }
>                 }
>         }
> --
> 2.51.0
>
>

