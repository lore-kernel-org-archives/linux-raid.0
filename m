Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E6C3CB2D9
	for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 09:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776851911; cv=pass; b=iUAd7LDaHn07wF1AxfeSo3dThAzTHoR/vzaEt3ooCm+iOixJ1UYEOlY0vw9Yf7mYhWdg962HYUq5Ga91a2UGAoW0FHXx9TQrAegnWS/NpwmqK9KUni/UZ3yIK19a4bIXsKwY+lxxKGDqRwsQnG6dc92sdunY1TX5U+0+I30LxCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776851911; c=relaxed/simple;
	bh=EC11Y3vyMmB/Q/cm7lJbxm1JG8YBrXNT034yIEeyXt0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OdnG3icQl5/qF8WohinfGf/feDGtER6xh3lo3dECgrXHH44oUNGB8e20HQDKHhungGBlMzlcUOo8Sh6vkfMJrXDqjgB+wkC7AKloIHF0N1v/OMrM1aysciseNoGPDywfrnl4Zt0aW+W4OweTY3jJyYLQuD4FIE/0KnziZp+8BrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TrqCW8KV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sEtobtWu; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TrqCW8KV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sEtobtWu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776851909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tmwNlum+GScoMSRK+6uvuC4//taXSJ0HkuWKsvWIqig=;
	b=TrqCW8KVXcuGkyb5TRGvggBj2qCk7TboNm7vGxDla0b4VBKaRjoJvoseL7PEJfNdg4Xa+y
	aH9tXaisCcn6gmZWLGbaXkrsE5DpzfdAkUH7aFEwkEN0JNz5cIS5WBSbSV/x149Yjxg6ha
	gGfEoltGDVwjZpboLLcgwMoC8/gsXhc=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-107-GIV0TF1VMximU75WLYNjPQ-1; Wed, 22 Apr 2026 05:58:28 -0400
X-MC-Unique: GIV0TF1VMximU75WLYNjPQ-1
X-Mimecast-MFC-AGG-ID: GIV0TF1VMximU75WLYNjPQ_1776851907
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-38e817d9498so24341201fa.2
        for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 02:58:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776851905; cv=none;
        d=google.com; s=arc-20240605;
        b=Px6/wtiuEoO4mzFPYVA5hdX+ewRNwgCb+ziDsUTDFKLDbjnPAt0ZymmPWPif661Pa8
         FsKg+l362rWlNOv0V3DfdZ10eHae1xelcxoJFVMTTTyT92XmToAgfxor08Hf8X3dtb/Z
         5+SL0Ggz2X+ogr8xWS9JXbS/ADB2kitw0aj1XzDFJJmPzGbI3kfTuFE4uWFW8Sw4UgcE
         dP8A22c2t2eY00mMsKq/0q+dSVn5a3DjghRhpELKh1DUFo4vDrFP3SQ/LzHoCjSpZBto
         LDBE3p6LR1d7v5gfy5CNA0MOKuxq3g5emyC/ESbGKg1JIVzDtArQcPQwNntJGwkU5YbV
         jOvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tmwNlum+GScoMSRK+6uvuC4//taXSJ0HkuWKsvWIqig=;
        fh=+N3VoTIp/NYPExHC6q9GyoUBOluZV1NYyTLCMlizsec=;
        b=Ma/v17xaeXKGhA3IyNYFjn9HYnHghDsSdvo8OF1NIuJfgVTUHf/eOKU7kAU1KlFzDO
         ZyCEliz2K5L9YR7OtajmgO3dLbROB4ZSvxcd+Y0mWlQncgqqSlr9l/NU5GUx5AZ86jbD
         lQFXdVGnD7xHRh0SJEXKLWcVVwKdNQtFrXwi74HDMsNOfoKMOOPSRwQZvj+zA3CxaKIW
         I9Rq4NVNFEkkHtbQbCSSWm0F05vzRjTWg9kfG5+J1zYgclwmuaPuB2NSXvd86RDD3fSv
         Qh7w1RwevNAcuHf9IJWR7ck+Ma95+uJ9Vg5ikR9LBUV2mysFwtehJ548q2URSo7GQops
         sJag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776851905; x=1777456705; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tmwNlum+GScoMSRK+6uvuC4//taXSJ0HkuWKsvWIqig=;
        b=sEtobtWumWE7+yWMgUiU85jm8qce+zR1tdIAjUnPM8hnfvnspp3TufMR9Ffwhh/JKB
         uqyJP2VLh0b0I76J1xRy0osQO4LE+4dMFYOin0rL3AR4uXjSkXfRJXKU6/MIEMFnKGrt
         5bZn94qNOt1qG58GAWjEkYuCEtLwEZrD+GmHNRatcDqfldQvG6JoZMA4IAzTTTPYI7SW
         TluJ73E1EFZI1MZy4CFBtSy+YLcSsK5JFDh77cI6v0xWvr45Ke4cc8EJ93U+TqkAbhJX
         RAwabkk/Onx0vEq4zqEPqGgGlLhinMI1K7zzRzH2F6xizd0aCL84Gs+VhoBlgwMLN5iA
         6huw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776851905; x=1777456705;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tmwNlum+GScoMSRK+6uvuC4//taXSJ0HkuWKsvWIqig=;
        b=XkfSLi4CqYOJgvMB8SixTegOVOI4KUWx186a9aAGcwNOiPYclrsgJtrBoXRWKqP9vZ
         tquQAVSuCO1xLhaqUFxdRHWrYT0BqwpzHGIpdb+r5yyvDHhPdzX0KwC/FaHrJwWyeBgk
         3UDHLCHL29D0mGSu+9QW7GNJ4hZ4nUs9zwuris+ty8VWIO6xDqnJKTTdII1TfS2zW8N9
         JQ4JEQpvAqD2TTBBUAJ19H5DmqrQNWBrZ1kHtdNqADA7NnlAbXcDHjGXdhu1jakDcDSP
         lgXTsZillemHEsfoy+GMuQmkjtG/DOG0MlVcAwaIHdGRVF6FLSV+JBWdlPem5jCvPQSE
         /ONw==
X-Forwarded-Encrypted: i=1; AFNElJ+GJ7aAN/EAlvWt2o3wB/GjM7Iu6DZmULQ1VoJ9S0GqYG14WFGXOSBGrDJHPN5/x8HPY7S8qMdTZvIZ@vger.kernel.org
X-Gm-Message-State: AOJu0YxjInPyNeVeqcVqtwuRaxi2aFVcwfOjdWsLmz0twdDsXtf1KMFd
	F/HgPK1qA7tsv2Lnb14Hv/7n9d+kzrBv5ZGrM/fre6ZXmziX0heq1ldyJ99feMtawZDwXpJEqgQ
	vrOr0KdLv6sWQF8a6DDlhBu+oSH1TimS9newXewqvfcz6tF3J+rtRPrlDkO0HTbatIIaUZR+mLf
	/88m02cada4U+K2R3yX+JtpK49BzkhmbpjbopjN4VL9ATCvcbOlvM=
X-Gm-Gg: AeBDieuZV3wbOptmoyGHibeRw9sk9LwQCHdArvsMHTWi9p2F0YG2yP3DaXv6FbbfxnG
	hnEBemNwc+9bnuxZQjRg7CZWQuSrYxXqlNhxkftG+uQKczED/DsiMI7jVYdjnux22+VKKWzIePP
	U7R1evK5F53uyBkSLQ4dsZlWpTQ7fY+7WoKkLt5nt36ei1qsSB65JYlKD1wOrNFSX82MKNmi2Sv
	mm4PKbOu5PCvgITZ5X8ynbSmQpIXRTDSiEA9fKMewVedGJgNc+yUUMMXjfEYBcS2grV+md4s+Ac
	nlmM/vkLE4i9
X-Received: by 2002:a05:6512:12c4:b0:5a4:1687:a32 with SMTP id 2adb3069b0e04-5a4172e47damr7674245e87.33.1776851905462;
        Wed, 22 Apr 2026 02:58:25 -0700 (PDT)
X-Received: by 2002:a05:6512:12c4:b0:5a4:1687:a32 with SMTP id
 2adb3069b0e04-5a4172e47damr7674230e87.33.1776851904853; Wed, 22 Apr 2026
 02:58:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ad6FNUtSCS_zTrHW@redhat.com> <20260414190350.1946406-1-bmarzins@redhat.com>
In-Reply-To: <20260414190350.1946406-1-bmarzins@redhat.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 22 Apr 2026 17:58:11 +0800
X-Gm-Features: AQROBzBrq25lZuxIRU48QL5iysCPWwrt42l70tafWZ7uVSy37zefF7nWrPHUtu8
Message-ID: <CALTww295wXriSs0zWwS4bsYfQiJ0-xKLFYmqO5P2eLBxUe+yGg@mail.gmail.com>
Subject: Re: [RFC PATCH] dm-raid: only requeue bios when dm is suspending.
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Yang Xiuwei <yangxiuwei@kylinos.cn>, 
	Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>, 
	Li Nan <linan666@huaweicloud.com>, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, 
	dm-devel@lists.linux.dev, Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2026 at 3:03=E2=80=AFAM Benjamin Marzinski <bmarzins@redhat=
.com> wrote:
>
> returning DM_MAPIO_REQUEUE from the target map() function only requeues
> the bio during noflush suspends. During regular operations or during
> flushing suspends, it fails the bio. Failing the bio during flushing
> suspends is the correct behavior here. We cannot handle the bio, and we
> cannot suspends while it is outstanding. But during normal operations,
> we should not push the bio back to do. Instead, wait for the reshape
> to be resumed.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>
> Yang Xiuwei, if you are still able to see I/O errors during LVM testing,
> does this patch fix them?
>
>  drivers/md/dm-raid.c | 7 +++++++
>  drivers/md/md.h      | 1 +
>  drivers/md/raid5.c   | 6 ++++--
>  3 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 4bacdc499984..cac61d57e7e2 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3831,6 +3831,7 @@ static void raid_presuspend(struct dm_target *ti)
>          * resume, raid_postsuspend() is too late.
>          */
>         set_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
> +       WRITE_ONCE(mddev->dm_suspending, 1);
>
>         if (!reshape_interrupted(mddev))
>                 return;
> @@ -3847,6 +3848,9 @@ static void raid_presuspend(struct dm_target *ti)
>  static void raid_presuspend_undo(struct dm_target *ti)
>  {
>         struct raid_set *rs =3D ti->private;
> +       struct mddev *mddev =3D &rs->md;
> +
> +       WRITE_ONCE(mddev->dm_suspending, 0);
>
>         clear_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
>  }
> @@ -3854,6 +3858,7 @@ static void raid_presuspend_undo(struct dm_target *=
ti)
>  static void raid_postsuspend(struct dm_target *ti)
>  {
>         struct raid_set *rs =3D ti->private;
> +       struct mddev *mddev =3D &rs->md;
>
>         if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) =
{
>                 /*
> @@ -3864,6 +3869,8 @@ static void raid_postsuspend(struct dm_target *ti)
>                 mddev_suspend(&rs->md, false);
>                 rs->md.ro =3D MD_RDONLY;
>         }
> +       WRITE_ONCE(mddev->dm_suspending, 0);
> +
>  }
>
>  static void attempt_restore_of_faulty_devices(struct raid_set *rs)
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ac84289664cd..e8d7332c5cb9 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -463,6 +463,7 @@ struct mddev {
>         int                             delta_disks, new_level, new_layou=
t;
>         int                             new_chunk_sectors;
>         int                             reshape_backwards;
> +       int                             dm_suspending;
>
>         struct md_thread __rcu          *thread;        /* management thr=
ead */
>         struct md_thread __rcu          *sync_thread;   /* doing resync o=
r reconstruct */
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8854e024f311..d528263f92a3 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6042,8 +6042,10 @@ static enum stripe_result make_stripe_request(stru=
ct mddev *mddev,
>         raid5_release_stripe(sh);
>  out:
>         if (ret =3D=3D STRIPE_SCHEDULE_AND_RETRY && reshape_interrupted(m=
ddev)) {
> -               bi->bi_status =3D BLK_STS_RESOURCE;
> -               ret =3D STRIPE_WAIT_RESHAPE;
> +               if (!mddev_is_dm(mddev) || READ_ONCE(mddev->dm_suspending=
)) {
> +                       bi->bi_status =3D BLK_STS_RESOURCE;
> +                       ret =3D STRIPE_WAIT_RESHAPE;
> +               }
>                 pr_err_ratelimited("dm-raid456: io across reshape positio=
n while reshape can't make progress");
>         }
>         return ret;
> --
> 2.50.1
>

Looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

