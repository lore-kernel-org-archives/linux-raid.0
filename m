Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51C62D73A0
	for <linux-raid@vger.kernel.org>; Wed, 19 Nov 2025 03:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763522541; cv=none; b=Vgucz8A/CQYVNP2oQ4jBahjamCtKfB0r5NyyFd39LHGuUBRbnuW0DmRAcWqyy27aouJT1fE80SaNkFZOIWZ43W0T/1NrlRQlxchv9KSkSiPubPwxvsltQnlxtFhhSxbBBcsaQlYwH0bSoLv4CBtP/pPGi5Rv0j/NmI5G0L4mahs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763522541; c=relaxed/simple;
	bh=i/OkKOt57vyOiuIpjuVEPJtpJcBUSFj+xYEMYidEmIo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KRK78gygePKjTZ4v38JVtRIAjktMdWBRfYXVv9KxfCjfZxOfaSZfscfFSoic42IY+XCIlSOJI/zx1R9ShNWvYaBqSDTDjW07NOYL2o3ReByZIrs76RPlCdjgDGbLDrMOF5mvYMhnT5wNW9LoQND1pDWaGM/s4QtROh2kLl/gEW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G8R5SrhJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ILxPQcBd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G8R5SrhJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ILxPQcBd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763522537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iPoqYMP6koE9BCJ3a7rwPUKDdojOJLQtdfcpC/Jcykg=;
	b=G8R5SrhJwAPZpau9CXqTEkTPAj1mC/BBAzIs8DvadgcYQHDr2tABvGjJovUdY0wGsl9ITw
	NQS5uu9TsMkULqUUV0x4PZM0YdrsCoQT2v/QBJ2Cm0EpYXAgmJMFFjAveqNWOLRQ/77K+j
	c03m+T7AToZgqN5lyI+XdvugkG9z4lM=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-390-LetxDfj_OPa0xEVhvv68-g-1; Tue, 18 Nov 2025 22:22:16 -0500
X-MC-Unique: LetxDfj_OPa0xEVhvv68-g-1
X-Mimecast-MFC-AGG-ID: LetxDfj_OPa0xEVhvv68-g_1763522534
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5942ee3c805so5536363e87.2
        for <linux-raid@vger.kernel.org>; Tue, 18 Nov 2025 19:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763522534; x=1764127334; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iPoqYMP6koE9BCJ3a7rwPUKDdojOJLQtdfcpC/Jcykg=;
        b=ILxPQcBdLYekyg52uJiAs2N5XAQzChSeLLlS/wSeLEG/NEiehQiLaj/U0LoirI2Ua/
         nIFFX3YIVFGScK9NjfUmir56UyKG/huZ8VFSifhezWrETGzra/PO4X+XEK/5M9aloMXy
         qs5MEgzwG5lTZ5uOcPiCv7CMmjd0WL1pkSMHXpPQ7yvZxh5JhUrtItvukg4fYHSqFpOu
         ks5GYY89lu34gRBhrLs9FD8UkcoD9GNsAoqWIQzPZ5YQneyRkzsOu6nf7NZttBg4U+8U
         sNhX8W5Cb/Lts+D83PpYuODRCXofAXbYBODVD+vCOqQtHdiaQUXOjujHSv1RLR8tBslS
         nlcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763522534; x=1764127334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iPoqYMP6koE9BCJ3a7rwPUKDdojOJLQtdfcpC/Jcykg=;
        b=YPklby6re+IuqDwUmxW5oiMWBN1mF2Fo/Y7Wyc7C+vzVVwsGhPNIev1jbtFbIMNePW
         2hKC0pBXDdqjIa7ZQ7Ls34K+GpimeI7BM/GKzFUC8iK5+fhGY7GmABwu0RFpe8PhcAJB
         rEXPC9P8yuE4GTJrXNT/un+grHoLxXqVtrS7uRF5ny2EUcGZqf/BB2Dca0W0xgZ9e4bI
         vpusbZxtdHwAbJ1T7LXq3RdzHkq/ePpQvYo99vMg2Duk4PrFSzw/dILOV4h43eVpYor3
         XiP0I4t/s9Def37hFYyxIe+nqVS3/TXkHi/SStV21k3A8hgNodNJ3R2YZdGhbIRgZ62L
         cZJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfYFyDUTF7BJcxa/11e+8oaOWuD04bmWn+n4mkAgmJY8SPMrkAX+Q4jyvCfuPNVOZbGRjUdUNZI9ym@vger.kernel.org
X-Gm-Message-State: AOJu0YyMuX/xoFtDwoQt8qaLmJmeLIvdi+ChNVhxvP1/xAuow4cq5N/Q
	mb9kiv7m4mDKR9w8J0nLzNh8IIV0SnuVOg3JcjF4UOH+EWVPTLzWvo6x/Uui6YdE15NT0+02vuU
	G+53QP/pKuHb6CB+CvIBlAQfRYSBTKNhFgaW0Gw6F3cXlRqVLc0mCLTUY9UCbUkB+0QAp0oIm+H
	wCwa61qFajzB/zMyd9OypOBnV3IhU2URSWnNFicQ==
X-Gm-Gg: ASbGncuINWHjvPVaRG69Cx7q2Rx3k6hyD5TVEE41M9ukEGuaZjsXo0HKtxo1rp09Iqd
	Sy3DEMcY+eZhRZtGLE73X7OJTqUNHkOT74h/V881nmuqHPqS0hlWB+BGYD5HhWkFbOIzy0mO1Fn
	+t7+RrgxNG8NmbsbV9/Ql+bCFjHneFUch/Pb8C+k3nqmPNu2BZ7hqFKse6vK+UlR2EhPw=
X-Received: by 2002:a05:6512:b01:b0:594:292f:bbe9 with SMTP id 2adb3069b0e04-595841fa9femr5950788e87.36.1763522534171;
        Tue, 18 Nov 2025 19:22:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IESi+GJ2bbpU6kS2QacYlRH1AwP4nrDqmAMNaI7jfInAQTPWLoAZ314izPyzTIs9oKbNkoSvOgbxbE7a8lYg0o=
X-Received: by 2002:a05:6512:b01:b0:594:292f:bbe9 with SMTP id
 2adb3069b0e04-595841fa9femr5950767e87.36.1763522533590; Tue, 18 Nov 2025
 19:22:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250828163216.4225-1-k@mgml.me> <20250828163216.4225-2-k@mgml.me>
In-Reply-To: <20250828163216.4225-2-k@mgml.me>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 19 Nov 2025 11:22:00 +0800
X-Gm-Features: AWmQ_bl9suET4V2xVtbfBd085skOU5AsQkhn92uNcGN90z9HWoXYb7lMm_dD09c
Message-ID: <CALTww28uPhB1R5xumS7MwEqE-S0C1MKET+2mEsC_nvdgrvJJsg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] md/raid1,raid10: Do not set MD_BROKEN on failfast
 io failure
To: Kenta Akagi <k@mgml.me>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	Mariusz Tkaczyk <mtkaczyk@kernel.org>, Guoqing Jiang <jgq516@gmail.com>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kenta

Re-send the email because I received the reject email from
linux-raid/linux-kernel.

I know the patch set is already V5 now. I'm looking at all the emails
to understand the evolution process. Because v5 is much more
complicated than the original version. I understand the problem
already. We don't want to set MD_BROKEN for failfast normal/metadata
io. Can't it work that check FailFast before setting MD_BROKEN, such
as:

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 202e510f73a4..7acac7eef514 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1755,12 +1755,13 @@ static void raid1_error(struct mddev *mddev,
struct md_rdev *rdev)

        if (test_bit(In_sync, &rdev->flags) &&
            (conf->raid_disks - mddev->degraded) =3D=3D 1) {
-               set_bit(MD_BROKEN, &mddev->flags);

-               if (!mddev->fail_last_dev) {
+               if (!mddev->fail_last_dev || test_bit(FailFast, &rdev->flag=
s)) {
                        conf->recovery_disabled =3D mddev->recovery_disable=
d;
                        return;
                }
+
+               set_bit(MD_BROKEN, &mddev->flags);
        }
        set_bit(Blocked, &rdev->flags);
        if (test_and_clear_bit(In_sync, &rdev->flags))

I know mostly this way can't resolve this problem. Because you, Linan
and Kuai already talked a lot about this problem. But I don't know why
this change can't work.

Regards
Xiao

On Fri, Aug 29, 2025 at 12:39=E2=80=AFAM Kenta Akagi <k@mgml.me> wrote:
>
> This commit ensures that an MD_FAILFAST IO failure does not put
> the array into a broken state.
>
> When failfast is enabled on rdev in RAID1 or RAID10,
> the array may be flagged MD_BROKEN in the following cases.
> - If MD_FAILFAST IOs to multiple rdevs fail simultaneously
> - If an MD_FAILFAST metadata write to the 'last' rdev fails
>
> The MD_FAILFAST bio error handler always calls md_error on IO failure,
> under the assumption that raid{1,10}_error will neither fail
> the last rdev nor break the array.
> After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
> calling md_error on the 'last' rdev in RAID1/10 always sets
> the MD_BROKEN flag on the array.
> As a result, when failfast IO fails on the last rdev, the array
> immediately becomes failed.
>
> Normally, MD_FAILFAST IOs are not issued to the 'last' rdev, so this is
> an edge case; however, it can occur if rdevs in a non-degraded
> array share the same path and that path is lost, or if a metadata
> write is triggered in a degraded array and fails due to failfast.
>
> When a failfast metadata write fails, it is retried through the
> following sequence. If a metadata write without failfast fails,
> the array will be marked with MD_BROKEN.
>
> 1. MD_SB_NEED_REWRITE is set in sb_flags by super_written.
> 2. md_super_wait, called by the function executing md_super_write,
>    returns -EAGAIN due to MD_SB_NEED_REWRITE.
> 3. The caller of md_super_wait (e.g., md_update_sb) receives the
>    negative return value and retries md_super_write.
> 4. md_super_write issues the metadata write again,
>    this time without MD_FAILFAST.
>
> Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
> Signed-off-by: Kenta Akagi <k@mgml.me>
> ---
>  drivers/md/md.c     | 14 +++++++++-----
>  drivers/md/md.h     | 13 +++++++------
>  drivers/md/raid1.c  | 18 ++++++++++++++++--
>  drivers/md/raid10.c | 21 ++++++++++++++++++---
>  4 files changed, 50 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ac85ec73a409..547b88e253f7 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -999,14 +999,18 @@ static void super_written(struct bio *bio)
>         if (bio->bi_status) {
>                 pr_err("md: %s gets error=3D%d\n", __func__,
>                        blk_status_to_errno(bio->bi_status));
> +               if (bio->bi_opf & MD_FAILFAST)
> +                       set_bit(FailfastIOFailure, &rdev->flags);
>                 md_error(mddev, rdev);
>                 if (!test_bit(Faulty, &rdev->flags)
>                     && (bio->bi_opf & MD_FAILFAST)) {
> +                       pr_warn("md: %s: Metadata write will be repeated =
to %pg\n",
> +                               mdname(mddev), rdev->bdev);
>                         set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
> -                       set_bit(LastDev, &rdev->flags);
>                 }
> -       } else
> -               clear_bit(LastDev, &rdev->flags);
> +       } else {
> +               clear_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
> +       }
>
>         bio_put(bio);
>
> @@ -1048,7 +1052,7 @@ void md_super_write(struct mddev *mddev, struct md_=
rdev *rdev,
>
>         if (test_bit(MD_FAILFAST_SUPPORTED, &mddev->flags) &&
>             test_bit(FailFast, &rdev->flags) &&
> -           !test_bit(LastDev, &rdev->flags))
> +           !test_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags))
>                 bio->bi_opf |=3D MD_FAILFAST;
>
>         atomic_inc(&mddev->pending_writes);
> @@ -1059,7 +1063,7 @@ int md_super_wait(struct mddev *mddev)
>  {
>         /* wait for all superblock writes that were scheduled to complete=
 */
>         wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes)=3D=
=3D0);
> -       if (test_and_clear_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags))
> +       if (test_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags))
>                 return -EAGAIN;
>         return 0;
>  }
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 51af29a03079..52c9fc759015 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -281,9 +281,10 @@ enum flag_bits {
>                                  * It is expects that no bad block log
>                                  * is present.
>                                  */
> -       LastDev,                /* Seems to be the last working dev as
> -                                * it didn't fail, so don't use FailFast
> -                                * any more for metadata
> +       FailfastIOFailure,      /* rdev with failfast IO failure
> +                                * but md_error not yet completed.
> +                                * If the last rdev has this flag,
> +                                * error_handler must not fail the array
>                                  */
>         CollisionCheck,         /*
>                                  * check if there is collision between ra=
id1
> @@ -331,8 +332,8 @@ struct md_cluster_operations;
>   * @MD_CLUSTER_RESYNC_LOCKED: cluster raid only, which means node, alrea=
dy took
>   *                            resync lock, need to release the lock.
>   * @MD_FAILFAST_SUPPORTED: Using MD_FAILFAST on metadata writes is suppo=
rted as
> - *                         calls to md_error() will never cause the arra=
y to
> - *                         become failed.
> + *                         calls to md_error() with FailfastIOFailure wi=
ll
> + *                         never cause the array to become failed.
>   * @MD_HAS_PPL:  The raid array has PPL feature set.
>   * @MD_HAS_MULTIPLE_PPLS: The raid array has multiple PPLs feature set.
>   * @MD_NOT_READY: do_md_run() is active, so 'array_state', ust not repor=
t that
> @@ -360,7 +361,7 @@ enum mddev_sb_flags {
>         MD_SB_CHANGE_DEVS,              /* Some device status has changed=
 */
>         MD_SB_CHANGE_CLEAN,     /* transition to or from 'clean' */
>         MD_SB_CHANGE_PENDING,   /* switch from 'clean' to 'active' in pro=
gress */
> -       MD_SB_NEED_REWRITE,     /* metadata write needs to be repeated */
> +       MD_SB_NEED_REWRITE,     /* metadata write needs to be repeated, d=
o not use failfast */
>  };
>
>  #define NR_SERIAL_INFOS                8
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 408c26398321..8a61fd93b3ff 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -470,6 +470,7 @@ static void raid1_end_write_request(struct bio *bio)
>                     (bio->bi_opf & MD_FAILFAST) &&
>                     /* We never try FailFast to WriteMostly devices */
>                     !test_bit(WriteMostly, &rdev->flags)) {
> +                       set_bit(FailfastIOFailure, &rdev->flags);
>                         md_error(r1_bio->mddev, rdev);
>                 }
>
> @@ -1746,8 +1747,12 @@ static void raid1_status(struct seq_file *seq, str=
uct mddev *mddev)
>   *     - recovery is interrupted.
>   *     - &mddev->degraded is bumped.
>   *
> - * @rdev is marked as &Faulty excluding case when array is failed and
> - * &mddev->fail_last_dev is off.
> + * If @rdev has &FailfastIOFailure and it is the 'last' rdev,
> + * then @mddev and @rdev will not be marked as failed.
> + *
> + * @rdev is marked as &Faulty excluding any cases:
> + *     - when @mddev is failed and &mddev->fail_last_dev is off
> + *     - when @rdev is last device and &FailfastIOFailure flag is set
>   */
>  static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>  {
> @@ -1758,6 +1763,13 @@ static void raid1_error(struct mddev *mddev, struc=
t md_rdev *rdev)
>
>         if (test_bit(In_sync, &rdev->flags) &&
>             (conf->raid_disks - mddev->degraded) =3D=3D 1) {
> +               if (test_and_clear_bit(FailfastIOFailure, &rdev->flags)) =
{
> +                       spin_unlock_irqrestore(&conf->device_lock, flags)=
;
> +                       pr_warn_ratelimited("md/raid1:%s: Failfast IO fai=
lure on %pg, "
> +                               "last device but ignoring it\n",
> +                               mdname(mddev), rdev->bdev);
> +                       return;
> +               }
>                 set_bit(MD_BROKEN, &mddev->flags);
>
>                 if (!mddev->fail_last_dev) {
> @@ -2148,6 +2160,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio=
)
>         if (test_bit(FailFast, &rdev->flags)) {
>                 /* Don't try recovering from here - just fail it
>                  * ... unless it is the last working device of course */
> +               set_bit(FailfastIOFailure, &rdev->flags);
>                 md_error(mddev, rdev);
>                 if (test_bit(Faulty, &rdev->flags))
>                         /* Don't try to read from here, but make sure
> @@ -2652,6 +2665,7 @@ static void handle_read_error(struct r1conf *conf, =
struct r1bio *r1_bio)
>                 fix_read_error(conf, r1_bio);
>                 unfreeze_array(conf);
>         } else if (mddev->ro =3D=3D 0 && test_bit(FailFast, &rdev->flags)=
) {
> +               set_bit(FailfastIOFailure, &rdev->flags);
>                 md_error(mddev, rdev);
>         } else {
>                 r1_bio->bios[r1_bio->read_disk] =3D IO_BLOCKED;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index b60c30bfb6c7..530ad6503189 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -488,6 +488,7 @@ static void raid10_end_write_request(struct bio *bio)
>                         dec_rdev =3D 0;
>                         if (test_bit(FailFast, &rdev->flags) &&
>                             (bio->bi_opf & MD_FAILFAST)) {
> +                               set_bit(FailfastIOFailure, &rdev->flags);
>                                 md_error(rdev->mddev, rdev);
>                         }
>
> @@ -1995,8 +1996,12 @@ static int enough(struct r10conf *conf, int ignore=
)
>   *     - recovery is interrupted.
>   *     - &mddev->degraded is bumped.
>   *
> - * @rdev is marked as &Faulty excluding case when array is failed and
> - * &mddev->fail_last_dev is off.
> + * If @rdev has &FailfastIOFailure and it is the 'last' rdev,
> + * then @mddev and @rdev will not be marked as failed.
> + *
> + * @rdev is marked as &Faulty excluding any cases:
> + *     - when @mddev is failed and &mddev->fail_last_dev is off
> + *     - when @rdev is last device and &FailfastIOFailure flag is set
>   */
>  static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>  {
> @@ -2006,6 +2011,13 @@ static void raid10_error(struct mddev *mddev, stru=
ct md_rdev *rdev)
>         spin_lock_irqsave(&conf->device_lock, flags);
>
>         if (test_bit(In_sync, &rdev->flags) && !enough(conf, rdev->raid_d=
isk)) {
> +               if (test_and_clear_bit(FailfastIOFailure, &rdev->flags)) =
{
> +                       spin_unlock_irqrestore(&conf->device_lock, flags)=
;
> +                       pr_warn_ratelimited("md/raid10:%s: Failfast IO fa=
ilure on %pg, "
> +                               "last device but ignoring it\n",
> +                               mdname(mddev), rdev->bdev);
> +                       return;
> +               }
>                 set_bit(MD_BROKEN, &mddev->flags);
>
>                 if (!mddev->fail_last_dev) {
> @@ -2413,6 +2425,7 @@ static void sync_request_write(struct mddev *mddev,=
 struct r10bio *r10_bio)
>                                 continue;
>                 } else if (test_bit(FailFast, &rdev->flags)) {
>                         /* Just give up on this device */
> +                       set_bit(FailfastIOFailure, &rdev->flags);
>                         md_error(rdev->mddev, rdev);
>                         continue;
>                 }
> @@ -2865,8 +2878,10 @@ static void handle_read_error(struct mddev *mddev,=
 struct r10bio *r10_bio)
>                 freeze_array(conf, 1);
>                 fix_read_error(conf, mddev, r10_bio);
>                 unfreeze_array(conf);
> -       } else
> +       } else {
> +               set_bit(FailfastIOFailure, &rdev->flags);
>                 md_error(mddev, rdev);
> +       }
>
>         rdev_dec_pending(rdev, mddev);
>         r10_bio->state =3D 0;
> --
> 2.50.1
>
>

