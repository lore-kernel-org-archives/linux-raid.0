Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DCB344056
	for <linux-raid@vger.kernel.org>; Tue, 16 Dec 2025 12:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888205; cv=none; b=Y4lgOWlrY6z/j5i9Lmu5gWCFRaiDc9vI+WgY9DstKDbehLZmo692X6e18cD+H8z4tzWYF7chuinyxANNC0FrByppNrUbpf0DGQwn+nQAgc1eV/3wA0tZgja3xfQjIMlvl9/c4Q87P67cNKUyVq3hJZDhrfQZfKADOmpTjxwExi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888205; c=relaxed/simple;
	bh=C7sy7YhMEoV65NsRUKlIUuY7pujBHTE0q0sZt7ulh5Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gdJTzCliCU3N3TaK99FnrOEaKhap4ZscNfzKuC+J2Pslk/kK67ffUoenGsxqTIx84oRutTXkJnoPd7Y8im6JlKYJ7SNoW3a+eiUIfl/fAOM0iI16qOWqwx5HN6dH9DWex90R8v7wSyy4rxwKkMuwCCPlkDnE6AaDLNsRSUlpgVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V7VZ8tGP; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MSwYt5La; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V7VZ8tGP";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MSwYt5La"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765888202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mW/zTQ7F2uxZuRYUtPmapIHMCWa1ZINjpVTaY2L8J0w=;
	b=V7VZ8tGPTb1a+gvDHPOPH3DYJIwG2btFMnCi/TaUhzk2DMZfh813PAPLA1RopN67HjLH7I
	V3PnloR2F1QCn8N3277EEIs4yW+pVOV+upRZ7rbNXYXsaR2HdzXRSkiSR1H06m7R6JA+x4
	yDMtvjsPPzxLrYJGb0S6qB9irvAH6SE=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-346-EMJAmLs1NnyBAgJZcPQSSQ-1; Tue, 16 Dec 2025 07:30:00 -0500
X-MC-Unique: EMJAmLs1NnyBAgJZcPQSSQ-1
X-Mimecast-MFC-AGG-ID: EMJAmLs1NnyBAgJZcPQSSQ_1765888199
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-37a35d16347so18913081fa.1
        for <linux-raid@vger.kernel.org>; Tue, 16 Dec 2025 04:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765888199; x=1766492999; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mW/zTQ7F2uxZuRYUtPmapIHMCWa1ZINjpVTaY2L8J0w=;
        b=MSwYt5LacLfFEL1Xo0VPVZevOJD+wIDQaEZ21FgpvbAVQSFrhrIHaj66HZm3U3olJt
         8XbH+BZUAdnNNea8u8Vo0tB8bkY/VZkBBppB1c0QK66gzmG0sTrQCXuIKlUSQY6vHCzf
         ZlbKCfENjDiodLaTsXxfe++JuJGC1eQEzyopqeC6WbCaVeVRUggzV6kTuo491S2q0jWq
         zrl8djOyIAY25IS4CR+oQZ0NZBiZ/BbCtib4aDA63wLl0EE/ud5dnCAUcNk9QKIDSFFW
         OLY6MCRhaV5Lrebc6bjwpitC/tK0QvNYP4uCGDaB+44I5F4cJ2fjVp9uEi8dL2wPnGIr
         +0hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765888199; x=1766492999;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mW/zTQ7F2uxZuRYUtPmapIHMCWa1ZINjpVTaY2L8J0w=;
        b=WywLiapDaUzJzpnsFKl5VSFmODA9tslfsAB/Q5Fi9ebokY+CQ7rVhz4NUKtD2Nbtc8
         fgIHOromTjUY5FnLo2biVIAtZIzgMcPXEnL5M+sORRopdR9Z8p26DhA9cWP/69yDpBiu
         AziWTfN3s43r0FcZdws7k2n2XJxhefNsbvb4UuuQr5r7inkpxaoS3he6Q9zFleKzusee
         SRkt+rwujBSnPAxmoc5950dL3ui68ToMIPR6NH228scAQYWChzbs31Uz3HfuHe8m/81z
         awi0YTb6V5nXUbkKHg5/F4nikmUIBG6NFZj6dYVbWLMXYn9gjx3Zlak5vcd/mn3+DXZl
         aYqA==
X-Forwarded-Encrypted: i=1; AJvYcCWP4zL4c98AXRsmo+vO61WIzNtv7jc9HsNZpcgPpXcpkU5HmySic5hW5hR8BtFbaTR9AoLs3vkq7bt9@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/PE8p+YVsA7zKl4NsCP2/vURoVWqKphFphzoM76NCGV1C7d92
	oiW1J2uQ5JhiXZ6Zd14kI/2VkiJHEWUIsVmCq6bZy6paAnoVf8op7RyrZlu+xxUrHHD9twKvMm/
	O2Sq6owaveOU1nQdfJjqfCTEqwFoU7hancm3o01OImI4FDXDwaQ3rsJg3k7YnEupXD7Ocf9iC05
	shXzTxzYkzbDIwLYf8OnnTZi27wRcWHf+zK8+HDg==
X-Gm-Gg: AY/fxX5EYU/oyllE1zAIr6uF4F1+t301u0e6FsiuX2/7zNFDbrf8U6mC1ZVdNS7xd2X
	SFavkKVpzvlN7ilrfxl6L698exmiyA2sel+6SAMhzmu+ob+JZBY87+V6UzjGE0HIjyjGZ3zko17
	qIF5mBJwrTggYlA5+ZEG4NsI/XzALAe0t4jmtbKvDs2Kt8Vxw1j315cyi7E0RXfDtxJOsqIWbiS
	2RmZaoWt0fvWpDBVgSfj13Rya7dmnrYsBfZUj5Om6JHDOnRhAnIM7GJg+KfuYdfJDoKMw==
X-Received: by 2002:a05:651c:2112:b0:37b:b8c0:b5e1 with SMTP id 38308e7fff4ca-37fd0884d11mr49090131fa.27.1765888198871;
        Tue, 16 Dec 2025 04:29:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHiXYbHsuQ5otViDT8qLoR567WdhkEkEYeRCLocMQiSZMdovhImWCxWDip0uxVl60LxJ87995nqd7Olo10+SN8=
X-Received: by 2002:a05:651c:2112:b0:37b:b8c0:b5e1 with SMTP id
 38308e7fff4ca-37fd0884d11mr49089941fa.27.1765888198237; Tue, 16 Dec 2025
 04:29:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALTww29S+fk2WcR6_Rm1h7X3ktCsi=exp5ZuwKnFGgEBYOAXLA@mail.gmail.com>
 <0106019b22c4e290-8379f848-c04a-4737-8fcc-baf9aa897164-000000@ap-northeast-1.amazonses.com>
In-Reply-To: <0106019b22c4e290-8379f848-c04a-4737-8fcc-baf9aa897164-000000@ap-northeast-1.amazonses.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 16 Dec 2025 20:29:46 +0800
X-Gm-Features: AQt7F2qSbBQrlCDz38oFaqbcH3hxIjDnQkR5xR06EhRqz7QTFubLmsyEXTyAIaw
Message-ID: <CALTww2_nJqyA99cG9YNarXEB4wimFK=pKy=qrxdkfB60PaUa1w@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] md/raid1,raid10: Do not set MD_BROKEN on failfast
 io failure
To: Kenta Akagi <k@mgml.me>
Cc: song@kernel.org, yukuai3@huawei.com, mtkaczyk@kernel.org, jgq516@gmail.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 12:08=E2=80=AFAM Kenta Akagi <k@mgml.me> wrote:
>
> Hi, Xiao
> Sorry for late reply.
>
> On 2025/11/19 12:13, Xiao Ni wrote:
> > Hi Kenta
> >
> > I know the patch set is already V5 now. I'm looking at all the emails t=
o understand the evolution process. Because v5 is much more complicated tha=
n the original version. I understand the problem already. We don't want to =
set MD_BROKEN for failfast normal/metadata io. Can't it work that check Fai=
lFast before setting MD_BROKEN, such as:
> >
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index 202e510f73a4..7acac7eef514 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -1755,12 +1755,13 @@ static void raid1_error(struct mddev *mddev, st=
ruct md_rdev *rdev)
> >
> >         if (test_bit(In_sync, &rdev->flags) &&
> >             (conf->raid_disks - mddev->degraded) =3D=3D 1) {
> > -               set_bit(MD_BROKEN, &mddev->flags);
> >
> > -               if (!mddev->fail_last_dev) {
> > +               if (!mddev->fail_last_dev || test_bit(FailFast, &rdev->=
flags)) {
> >                         conf->recovery_disabled =3D mddev->recovery_dis=
abled;
> >                         return;
> >                 }
> > +
> > +               set_bit(MD_BROKEN, &mddev->flags);
> >         }
> >         set_bit(Blocked, &rdev->flags);
> >         if (test_and_clear_bit(In_sync, &rdev->flags))
> >
> > I know mostly this way can't resolve this problem. Because you, Linan a=
nd Kuai already talked a lot about this problem. But I don't know why this =
change can't work.
>
> I may have been too concerned with maintaining the behavior seen from the=
 user space.
> and I think this method is good.
>
> We may need to consider that raid1/raid10 will never MD_BROKEN when rdev =
has failfast.
> MD_BROKEN was introduced to raid1/raid10 in 2023, and I believe there are
> almost no cases where people expect it to become "broken" when the last r=
dev behaves strangely.
> So, rather than complicating error handling for failfast, it seems better=
 to have a way of not
> set MD_BROKEN when failfast is configured.
>
> I'll sending the next patch using this approach.
>
> Thanks!
> Akagi

Hi Akagi

Thanks for your understanding.

Regards
Xiao
>
> >
> > Best Regards
> >
> > Xiao
> >
> > On Fri, Aug 29, 2025 at 12:39=E2=80=AFAM Kenta Akagi <k@mgml.me <mailto=
:k@mgml.me>> wrote:
> >
> >     This commit ensures that an MD_FAILFAST IO failure does not put
> >     the array into a broken state.
> >
> >     When failfast is enabled on rdev in RAID1 or RAID10,
> >     the array may be flagged MD_BROKEN in the following cases.
> >     - If MD_FAILFAST IOs to multiple rdevs fail simultaneously
> >     - If an MD_FAILFAST metadata write to the 'last' rdev fails
> >
> >     The MD_FAILFAST bio error handler always calls md_error on IO failu=
re,
> >     under the assumption that raid{1,10}_error will neither fail
> >     the last rdev nor break the array.
> >     After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"=
),
> >     calling md_error on the 'last' rdev in RAID1/10 always sets
> >     the MD_BROKEN flag on the array.
> >     As a result, when failfast IO fails on the last rdev, the array
> >     immediately becomes failed.
> >
> >     Normally, MD_FAILFAST IOs are not issued to the 'last' rdev, so thi=
s is
> >     an edge case; however, it can occur if rdevs in a non-degraded
> >     array share the same path and that path is lost, or if a metadata
> >     write is triggered in a degraded array and fails due to failfast.
> >
> >     When a failfast metadata write fails, it is retried through the
> >     following sequence. If a metadata write without failfast fails,
> >     the array will be marked with MD_BROKEN.
> >
> >     1. MD_SB_NEED_REWRITE is set in sb_flags by super_written.
> >     2. md_super_wait, called by the function executing md_super_write,
> >        returns -EAGAIN due to MD_SB_NEED_REWRITE.
> >     3. The caller of md_super_wait (e.g., md_update_sb) receives the
> >        negative return value and retries md_super_write.
> >     4. md_super_write issues the metadata write again,
> >        this time without MD_FAILFAST.
> >
> >     Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
> >     Signed-off-by: Kenta Akagi <k@mgml.me <mailto:k@mgml.me>>
> >     ---
> >      drivers/md/md.c     | 14 +++++++++-----
> >      drivers/md/md.h     | 13 +++++++------
> >      drivers/md/raid1.c  | 18 ++++++++++++++++--
> >      drivers/md/raid10.c | 21 ++++++++++++++++++---
> >      4 files changed, 50 insertions(+), 16 deletions(-)
> >
> >     diff --git a/drivers/md/md.c b/drivers/md/md.c
> >     index ac85ec73a409..547b88e253f7 100644
> >     --- a/drivers/md/md.c
> >     +++ b/drivers/md/md.c
> >     @@ -999,14 +999,18 @@ static void super_written(struct bio *bio)
> >             if (bio->bi_status) {
> >                     pr_err("md: %s gets error=3D%d\n", __func__,
> >                            blk_status_to_errno(bio->bi_status));
> >     +               if (bio->bi_opf & MD_FAILFAST)
> >     +                       set_bit(FailfastIOFailure, &rdev->flags);
> >                     md_error(mddev, rdev);
> >                     if (!test_bit(Faulty, &rdev->flags)
> >                         && (bio->bi_opf & MD_FAILFAST)) {
> >     +                       pr_warn("md: %s: Metadata write will be rep=
eated to %pg\n",
> >     +                               mdname(mddev), rdev->bdev);
> >                             set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flag=
s);
> >     -                       set_bit(LastDev, &rdev->flags);
> >                     }
> >     -       } else
> >     -               clear_bit(LastDev, &rdev->flags);
> >     +       } else {
> >     +               clear_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
> >     +       }
> >
> >             bio_put(bio);
> >
> >     @@ -1048,7 +1052,7 @@ void md_super_write(struct mddev *mddev, stru=
ct md_rdev *rdev,
> >
> >             if (test_bit(MD_FAILFAST_SUPPORTED, &mddev->flags) &&
> >                 test_bit(FailFast, &rdev->flags) &&
> >     -           !test_bit(LastDev, &rdev->flags))
> >     +           !test_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags))
> >                     bio->bi_opf |=3D MD_FAILFAST;
> >
> >             atomic_inc(&mddev->pending_writes);
> >     @@ -1059,7 +1063,7 @@ int md_super_wait(struct mddev *mddev)
> >      {
> >             /* wait for all superblock writes that were scheduled to co=
mplete */
> >             wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writ=
es)=3D=3D0);
> >     -       if (test_and_clear_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags=
))
> >     +       if (test_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags))
> >                     return -EAGAIN;
> >             return 0;
> >      }
> >     diff --git a/drivers/md/md.h b/drivers/md/md.h
> >     index 51af29a03079..52c9fc759015 100644
> >     --- a/drivers/md/md.h
> >     +++ b/drivers/md/md.h
> >     @@ -281,9 +281,10 @@ enum flag_bits {
> >                                      * It is expects that no bad block =
log
> >                                      * is present.
> >                                      */
> >     -       LastDev,                /* Seems to be the last working dev=
 as
> >     -                                * it didn't fail, so don't use Fai=
lFast
> >     -                                * any more for metadata
> >     +       FailfastIOFailure,      /* rdev with failfast IO failure
> >     +                                * but md_error not yet completed.
> >     +                                * If the last rdev has this flag,
> >     +                                * error_handler must not fail the =
array
> >                                      */
> >             CollisionCheck,         /*
> >                                      * check if there is collision betw=
een raid1
> >     @@ -331,8 +332,8 @@ struct md_cluster_operations;
> >       * @MD_CLUSTER_RESYNC_LOCKED: cluster raid only, which means node,=
 already took
> >       *                            resync lock, need to release the loc=
k.
> >       * @MD_FAILFAST_SUPPORTED: Using MD_FAILFAST on metadata writes is=
 supported as
> >     - *                         calls to md_error() will never cause th=
e array to
> >     - *                         become failed.
> >     + *                         calls to md_error() with FailfastIOFail=
ure will
> >     + *                         never cause the array to become failed.
> >       * @MD_HAS_PPL:  The raid array has PPL feature set.
> >       * @MD_HAS_MULTIPLE_PPLS: The raid array has multiple PPLs feature=
 set.
> >       * @MD_NOT_READY: do_md_run() is active, so 'array_state', ust not=
 report that
> >     @@ -360,7 +361,7 @@ enum mddev_sb_flags {
> >             MD_SB_CHANGE_DEVS,              /* Some device status has c=
hanged */
> >             MD_SB_CHANGE_CLEAN,     /* transition to or from 'clean' */
> >             MD_SB_CHANGE_PENDING,   /* switch from 'clean' to 'active' =
in progress */
> >     -       MD_SB_NEED_REWRITE,     /* metadata write needs to be repea=
ted */
> >     +       MD_SB_NEED_REWRITE,     /* metadata write needs to be repea=
ted, do not use failfast */
> >      };
> >
> >      #define NR_SERIAL_INFOS                8
> >     diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> >     index 408c26398321..8a61fd93b3ff 100644
> >     --- a/drivers/md/raid1.c
> >     +++ b/drivers/md/raid1.c
> >     @@ -470,6 +470,7 @@ static void raid1_end_write_request(struct bio =
*bio)
> >                         (bio->bi_opf & MD_FAILFAST) &&
> >                         /* We never try FailFast to WriteMostly devices=
 */
> >                         !test_bit(WriteMostly, &rdev->flags)) {
> >     +                       set_bit(FailfastIOFailure, &rdev->flags);
> >                             md_error(r1_bio->mddev, rdev);
> >                     }
> >
> >     @@ -1746,8 +1747,12 @@ static void raid1_status(struct seq_file *se=
q, struct mddev *mddev)
> >       *     - recovery is interrupted.
> >       *     - &mddev->degraded is bumped.
> >       *
> >     - * @rdev is marked as &Faulty excluding case when array is failed =
and
> >     - * &mddev->fail_last_dev is off.
> >     + * If @rdev has &FailfastIOFailure and it is the 'last' rdev,
> >     + * then @mddev and @rdev will not be marked as failed.
> >     + *
> >     + * @rdev is marked as &Faulty excluding any cases:
> >     + *     - when @mddev is failed and &mddev->fail_last_dev is off
> >     + *     - when @rdev is last device and &FailfastIOFailure flag is =
set
> >       */
> >      static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
> >      {
> >     @@ -1758,6 +1763,13 @@ static void raid1_error(struct mddev *mddev,=
 struct md_rdev *rdev)
> >
> >             if (test_bit(In_sync, &rdev->flags) &&
> >                 (conf->raid_disks - mddev->degraded) =3D=3D 1) {
> >     +               if (test_and_clear_bit(FailfastIOFailure, &rdev->fl=
ags)) {
> >     +                       spin_unlock_irqrestore(&conf->device_lock, =
flags);
> >     +                       pr_warn_ratelimited("md/raid1:%s: Failfast =
IO failure on %pg, "
> >     +                               "last device but ignoring it\n",
> >     +                               mdname(mddev), rdev->bdev);
> >     +                       return;
> >     +               }
> >                     set_bit(MD_BROKEN, &mddev->flags);
> >
> >                     if (!mddev->fail_last_dev) {
> >     @@ -2148,6 +2160,7 @@ static int fix_sync_read_error(struct r1bio *=
r1_bio)
> >             if (test_bit(FailFast, &rdev->flags)) {
> >                     /* Don't try recovering from here - just fail it
> >                      * ... unless it is the last working device of cour=
se */
> >     +               set_bit(FailfastIOFailure, &rdev->flags);
> >                     md_error(mddev, rdev);
> >                     if (test_bit(Faulty, &rdev->flags))
> >                             /* Don't try to read from here, but make su=
re
> >     @@ -2652,6 +2665,7 @@ static void handle_read_error(struct r1conf *=
conf, struct r1bio *r1_bio)
> >                     fix_read_error(conf, r1_bio);
> >                     unfreeze_array(conf);
> >             } else if (mddev->ro =3D=3D 0 && test_bit(FailFast, &rdev->=
flags)) {
> >     +               set_bit(FailfastIOFailure, &rdev->flags);
> >                     md_error(mddev, rdev);
> >             } else {
> >                     r1_bio->bios[r1_bio->read_disk] =3D IO_BLOCKED;
> >     diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> >     index b60c30bfb6c7..530ad6503189 100644
> >     --- a/drivers/md/raid10.c
> >     +++ b/drivers/md/raid10.c
> >     @@ -488,6 +488,7 @@ static void raid10_end_write_request(struct bio=
 *bio)
> >                             dec_rdev =3D 0;
> >                             if (test_bit(FailFast, &rdev->flags) &&
> >                                 (bio->bi_opf & MD_FAILFAST)) {
> >     +                               set_bit(FailfastIOFailure, &rdev->f=
lags);
> >                                     md_error(rdev->mddev, rdev);
> >                             }
> >
> >     @@ -1995,8 +1996,12 @@ static int enough(struct r10conf *conf, int =
ignore)
> >       *     - recovery is interrupted.
> >       *     - &mddev->degraded is bumped.
> >       *
> >     - * @rdev is marked as &Faulty excluding case when array is failed =
and
> >     - * &mddev->fail_last_dev is off.
> >     + * If @rdev has &FailfastIOFailure and it is the 'last' rdev,
> >     + * then @mddev and @rdev will not be marked as failed.
> >     + *
> >     + * @rdev is marked as &Faulty excluding any cases:
> >     + *     - when @mddev is failed and &mddev->fail_last_dev is off
> >     + *     - when @rdev is last device and &FailfastIOFailure flag is =
set
> >       */
> >      static void raid10_error(struct mddev *mddev, struct md_rdev *rdev=
)
> >      {
> >     @@ -2006,6 +2011,13 @@ static void raid10_error(struct mddev *mddev=
, struct md_rdev *rdev)
> >             spin_lock_irqsave(&conf->device_lock, flags);
> >
> >             if (test_bit(In_sync, &rdev->flags) && !enough(conf, rdev->=
raid_disk)) {
> >     +               if (test_and_clear_bit(FailfastIOFailure, &rdev->fl=
ags)) {
> >     +                       spin_unlock_irqrestore(&conf->device_lock, =
flags);
> >     +                       pr_warn_ratelimited("md/raid10:%s: Failfast=
 IO failure on %pg, "
> >     +                               "last device but ignoring it\n",
> >     +                               mdname(mddev), rdev->bdev);
> >     +                       return;
> >     +               }
> >                     set_bit(MD_BROKEN, &mddev->flags);
> >
> >                     if (!mddev->fail_last_dev) {
> >     @@ -2413,6 +2425,7 @@ static void sync_request_write(struct mddev *=
mddev, struct r10bio *r10_bio)
> >                                     continue;
> >                     } else if (test_bit(FailFast, &rdev->flags)) {
> >                             /* Just give up on this device */
> >     +                       set_bit(FailfastIOFailure, &rdev->flags);
> >                             md_error(rdev->mddev, rdev);
> >                             continue;
> >                     }
> >     @@ -2865,8 +2878,10 @@ static void handle_read_error(struct mddev *=
mddev, struct r10bio *r10_bio)
> >                     freeze_array(conf, 1);
> >                     fix_read_error(conf, mddev, r10_bio);
> >                     unfreeze_array(conf);
> >     -       } else
> >     +       } else {
> >     +               set_bit(FailfastIOFailure, &rdev->flags);
> >                     md_error(mddev, rdev);
> >     +       }
> >
> >             rdev_dec_pending(rdev, mddev);
> >             r10_bio->state =3D 0;
> >     --
> >     2.50.1
> >
> >
>

