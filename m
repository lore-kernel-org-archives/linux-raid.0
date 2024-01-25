Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D3A134DE
	for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 07:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706169085; cv=none; b=ArczAkUBRFdIIu7viXH7fuJV/qL9us1QZIoDq8+CZZdBp34m86aeSzCbHl2Mco6ONz+6EWbhIFBKGkAxdJcI+oQ8/9mf2763G8v7aO4HyMDSo+IlXYkx3uHpoVi8oFswrv7HZ61n60R22rvqr0zR63YqByYyxZK0W2PMnRDSGdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706169085; c=relaxed/simple;
	bh=IJk53f2ApOxRAEPTKIzDtiOaoN3YBA85NACNk6p/iB4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E22FeCmJc8nf0B/lGNdQmuQTV7xDHWUvKl0o4Yt8KQ/c8OqHrlkqDqCvkiSZT2QMNhTHparMG39l4kL3dJ1xv4Td/5LX0qf1VOAeHgSRikx6ROdgwuyBPP/dFVn1G8NylZOMUV4CPzhX2BJgGVxMj1ZpZGgWdv0IFxCKkTVXh4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Eeo9A142; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Eeo9A142"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706169083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LyC31zzzcvBQLccO8yitrHL0CNB1m9jX4OQ2W97orWU=;
	b=Eeo9A142nrlESfzN5SuMt7VbtXV/ff5X4629s+1QLTXxr7UCuuHc1hGXCy0INc3h5w6WVB
	5PxoioksFMFUKkuD4sdOgLALlfbei+NdyHcDP1IGRMdG71BmHqRpk8BnZKEPheSn0sC1yC
	xuFt4jbVpVeXm7ORU4HGEe5f0+ZVQfI=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-rEZdGG5_O5-8XgQBctPzPA-1; Thu, 25 Jan 2024 02:51:21 -0500
X-MC-Unique: rEZdGG5_O5-8XgQBctPzPA-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-6d9b266183eso6049869b3a.1
        for <linux-raid@vger.kernel.org>; Wed, 24 Jan 2024 23:51:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706169080; x=1706773880;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LyC31zzzcvBQLccO8yitrHL0CNB1m9jX4OQ2W97orWU=;
        b=ptYmtE93bI3F1J2ialplClQE67nti/tqRJybdj7P4xeqAFw73TmKGHQtp0ZGhlj/nT
         U8h30HADnqPZ+j0JsKZIAkwAtMNd766hIg0YjW49g0U8DbCzkhq1SyRDEWDt0ybbJIqu
         iPE8KFRzDtG6xoT8jycC/cF+Ozb5/vaOhqorIyIOGuZTKQMK3EYecYHIugqOSfKHO5lB
         SJp6w0Q95UwnL0cLcjNMrjdlM2Tj7p+p483kW5nhHNuvcSg/2GzOj/JaSplv8qN5sqKL
         AyTjkFoyknK7fjtDSgvdieyRFmbVW9bIvDBxfv9wlmSU3O4OwzssilTKaczFy0rL6yZs
         G5xg==
X-Gm-Message-State: AOJu0YxgWxkXKOlY+i4NPaNmsl+2Lv6nbWeyXF7ykxhM/zeL+wVSkke/
	gLDJ0+PvA2t26YaIsDKfH/VNYhvM9cwcOYMb/PwlYJdhe6WyKvWsOAssdPBzkX1cLE091TxZ/PF
	oRVaSTFhaxpbE4ys2hL4MPacMU/lDUb2SMo2S39g8NGyCIoKoc2TDAuxqhraelQOO/vBfmIahpD
	WG/gppWFHd7NQ40dv8ShIG+6iNJ5CEiaQHcw==
X-Received: by 2002:aa7:9819:0:b0:6dd:c379:28f7 with SMTP id e25-20020aa79819000000b006ddc37928f7mr252932pfl.21.1706169079990;
        Wed, 24 Jan 2024 23:51:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHSlcVyOOUsGiV0wV1PdgkTikecKl6oWsCQDpmwLacZpUS4x9H+HIkFzdIbi1zrP/QBZOMNarTehuzV4tTCU7g=
X-Received: by 2002:aa7:9819:0:b0:6dd:c379:28f7 with SMTP id
 e25-20020aa79819000000b006ddc37928f7mr252918pfl.21.1706169079670; Wed, 24 Jan
 2024 23:51:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240124091421.1261579-1-yukuai3@huawei.com> <20240124091421.1261579-6-yukuai3@huawei.com>
In-Reply-To: <20240124091421.1261579-6-yukuai3@huawei.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 25 Jan 2024 15:51:08 +0800
Message-ID: <CALTww2_hG2_YL1v-d0=uv2=bVzJ2wwpSJyQdBBGMCBx79bot-Q@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] md: export helpers to stop sync_thread
To: Yu Kuai <yukuai3@huawei.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	dm-devel@lists.linux.dev, song@kernel.org, jbrassow@f14.redhat.com, 
	neilb@suse.de, heinzm@redhat.com, shli@fb.com, akpm@osdl.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 24, 2024 at 5:19=E2=80=AFPM Yu Kuai <yukuai3@huawei.com> wrote:
>
> The new heleprs will be used in dm-raid in later patches to fix
> regressions and prevent calling md_reap_sync_thread() directly.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 41 +++++++++++++++++++++++++++++++++++++----
>  drivers/md/md.h |  3 +++
>  2 files changed, 40 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6c5d0a372927..90cf31b53804 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4915,30 +4915,63 @@ static void stop_sync_thread(struct mddev *mddev,=
 bool locked, bool check_seq)
>                 mddev_lock_nointr(mddev);
>  }
>
> -static void idle_sync_thread(struct mddev *mddev)
> +void md_idle_sync_thread(struct mddev *mddev)
>  {
> +       lockdep_assert_held(mddev->reconfig_mutex);
> +

Hi Kuai

There is a building error. It should give a pointer to
lockdep_assert_held. And same with the other two places in this patch.

Regards
Xiao

>         mutex_lock(&mddev->sync_mutex);
>         clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +       stop_sync_thread(mddev, true, true);
> +       mutex_unlock(&mddev->sync_mutex);
> +}
> +EXPORT_SYMBOL_GPL(md_idle_sync_thread);
> +
> +void md_frozen_sync_thread(struct mddev *mddev)
> +{
> +       lockdep_assert_held(mddev->reconfig_mutex);
> +
> +       mutex_lock(&mddev->sync_mutex);
> +       set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +       stop_sync_thread(mddev, true, false);
> +       mutex_unlock(&mddev->sync_mutex);
> +}
> +EXPORT_SYMBOL_GPL(md_frozen_sync_thread);
>
> +void md_unfrozen_sync_thread(struct mddev *mddev)
> +{
> +       lockdep_assert_held(mddev->reconfig_mutex);
> +
> +       mutex_lock(&mddev->sync_mutex);
> +       clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +       set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +       md_wakeup_thread(mddev->thread);
> +       sysfs_notify_dirent_safe(mddev->sysfs_action);
> +       mutex_unlock(&mddev->sync_mutex);
> +}
> +EXPORT_SYMBOL_GPL(md_unfrozen_sync_thread);
> +
> +static void idle_sync_thread(struct mddev *mddev)
> +{
>         if (mddev_lock(mddev)) {
>                 mutex_unlock(&mddev->sync_mutex);
>                 return;
>         }
>
> +       mutex_lock(&mddev->sync_mutex);
> +       clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>         stop_sync_thread(mddev, false, true);
>         mutex_unlock(&mddev->sync_mutex);
>  }
>
>  static void frozen_sync_thread(struct mddev *mddev)
>  {
> -       mutex_lock(&mddev->sync_mutex);
> -       set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> -
>         if (mddev_lock(mddev)) {
>                 mutex_unlock(&mddev->sync_mutex);
>                 return;
>         }
>
> +       mutex_lock(&mddev->sync_mutex);
> +       set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>         stop_sync_thread(mddev, false, false);
>         mutex_unlock(&mddev->sync_mutex);
>  }
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 8d881cc59799..437ab70ce79b 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -781,6 +781,9 @@ extern void md_rdev_clear(struct md_rdev *rdev);
>  extern void md_handle_request(struct mddev *mddev, struct bio *bio);
>  extern int mddev_suspend(struct mddev *mddev, bool interruptible);
>  extern void mddev_resume(struct mddev *mddev);
> +extern void md_idle_sync_thread(struct mddev *mddev);
> +extern void md_frozen_sync_thread(struct mddev *mddev);
> +extern void md_unfrozen_sync_thread(struct mddev *mddev);
>
>  extern void md_reload_sb(struct mddev *mddev, int raid_disk);
>  extern void md_update_sb(struct mddev *mddev, int force);
> --
> 2.39.2
>

