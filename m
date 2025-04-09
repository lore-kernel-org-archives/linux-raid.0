Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0502422E3F7
	for <linux-raid@vger.kernel.org>; Wed,  9 Apr 2025 10:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744193258; cv=none; b=qGDobxjXi7G9GwyVaFPgl1O7fFpba6tJEwTUOvcmRLhM9h1m5K3ZClA7PYioKHpZr994C8dC2QMWZ1wp7qTL1tJdFBZuq5yxi+ynCLN9JpG8BK/B/KzynOOor0U//Pt7XAgKZBAZGBHPT57emrBGNoMIZOUlw/I8Zo22huBN3H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744193258; c=relaxed/simple;
	bh=iVGYqnrbGiohrzWR1lcOuH8K2aIflgazjBn6EvA9XqY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QDVcmB2NTDGRdVb1tpFcdHoSveCxZqWBHAbSl+nA5N+5wE9sKSRJJTRyJqyyH3sf7Urk590iwIPQxIscNsJUhp8wZDo1ZdVaXWQ43zQXNDvkAeLDojE0kI2qXDONlgZo2bXck/rHKMymrRBOJG+8jypsVXaq3bZHpBr3iLg8q1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YymYhqvH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YymYhqvH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744193254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dMjQ6ODFHY8mVE/mnBvIQOKna4xKkf/ZL51R2pS8g3s=;
	b=YymYhqvHpaVt175RSuZxZ5hklC2PrH1Bypj0QyV2B8wM4UpENphsSsdoGyXjZnBannoWrd
	h2NYnTtpKLN424mGAkPuSy+p5pCVxF+nk7XsKjUvcrWOhwF+FLsW6nuOx6ORheUkcVCAVO
	mPuQkIhONlnO9nS8Onhr2DwQenS3WdY=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-2mD1u4vyOwuqJfT4PMQj5A-1; Wed, 09 Apr 2025 06:07:32 -0400
X-MC-Unique: 2mD1u4vyOwuqJfT4PMQj5A-1
X-Mimecast-MFC-AGG-ID: 2mD1u4vyOwuqJfT4PMQj5A_1744193251
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-549999af7bfso3392569e87.0
        for <linux-raid@vger.kernel.org>; Wed, 09 Apr 2025 03:07:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744193251; x=1744798051;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dMjQ6ODFHY8mVE/mnBvIQOKna4xKkf/ZL51R2pS8g3s=;
        b=j216jECdHRPcbKFf93kvCAciwhUY8YPpruQDeDkA3aVRK6kangfUx60T2FMZv7m/wj
         VGdMsAqBG1VNLn3TD6w31sKlWpx6u52IylfvI4k96r0TyA/zb/ERf/nKdQdQdOR6/9m6
         CoWTUch8PY4MP40BOX2dhcVfh0crurKcduY57hoycNBdguxslOfPH4FSlmkE9+0x7CKB
         dWPdLjHjD8PCtqVTr0QG1bmy5QidbC2KEshX0DGpgoxa3REzTc1j3j+qGbKbKvpwhxWW
         fd4OQD0yzbHttt2dbnLmT4EnDn5ip0IOc3uLMEH+kZjsnaCZc3/PeIaFIBdZoTCqtcym
         cS1A==
X-Forwarded-Encrypted: i=1; AJvYcCUYhs379nSUigQzPVJ4ZgXydclsjKFos9vWXinlA2ULjvSolQo8Cd6Si3RiPEPdkcDBX+wUcbs4m/qA@vger.kernel.org
X-Gm-Message-State: AOJu0YwEL207uIbx5iY99TpedHY8qS4+8FS8v5v3Gk5Q8rrc1x4S7wRJ
	xOuUdFV5LcArdcfgnQRyB8sa+xAZb66WkySOFbcyup+n7TZV/DxLl1vPrdtO9rIGxQD8C8BGaK5
	mS4OJiXCgB7u2SuJVD0qtTW8rvvhxrRkrRmX9NaTXBHkCJEvGDb5Qsrr6cfPkUVmLBN/4AXajmO
	+XZYNxWoES1W34d+GNd/eL2n1AuLAY/s4l5w==
X-Gm-Gg: ASbGncv+Tzo/jBsjmgIYQ1CGcTJIfecL/BE05bYUMWiOUnJq8rV3JYV5RqU/LrF9/N+
	gTkTOi4GCuLJbTX3yWh8Sn3kTdBTiw/ln+ebuu/PIdTxFJNq80G1Sy4ZWTcQB4Ttwf3+24A==
X-Received: by 2002:a05:6512:128f:b0:54b:117c:1355 with SMTP id 2adb3069b0e04-54c4456f8eamr519317e87.55.1744193250741;
        Wed, 09 Apr 2025 03:07:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJjtLL7RTD803r+phBDHX23nngs5HQMeFXwF85vOECWte+6Y8LR3JZ90s8zK4oHx2its5KhHgKtV7q6GR79N4=
X-Received: by 2002:a05:6512:128f:b0:54b:117c:1355 with SMTP id
 2adb3069b0e04-54c4456f8eamr519309e87.55.1744193250215; Wed, 09 Apr 2025
 03:07:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250408124125.2535488-1-yukuai1@huaweicloud.com>
 <CALTww29qrsF9ku1ykJwm1AhVuRfuOvFosd2cRSECU=m6aC7PVw@mail.gmail.com> <04e2d21d-7424-9be6-a2ec-e0c0a3154571@huawei.com>
In-Reply-To: <04e2d21d-7424-9be6-a2ec-e0c0a3154571@huawei.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 9 Apr 2025 18:07:17 +0800
X-Gm-Features: ATxdqUEu2cfE5EUZxAaYVmfp7c7wrbO1KZiKAa8s94yQSZvWxJt8GVNi3cLvuxA
Message-ID: <CALTww2-wC=juQdvL3rqA9JAEMVsmMR8y6E4N+sJhHsVOG1QYiw@mail.gmail.com>
Subject: Re: [PATCH RFC] md: fix is_mddev_idle()
To: Yu Kuai <yukuai3@huawei.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, axboe@kernel.dk, song@kernel.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 9, 2025 at 5:40=E2=80=AFPM Yu Kuai <yukuai3@huawei.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2025/04/09 16:46, Xiao Ni =E5=86=99=E9=81=93:
> > Hi Kuai
> >
> > I did a test with your patch. It also brings a big sync speed decrease
> > during the test. These are some test results:
> >
> > fio --name=3Dread --filename=3D/dev/md0 --ioengine=3Dlibaio --rw=3Dread
> > --bs=3D4k --direct=3D1 --numjobs=3D1 --runtime=3D120 --group_reporting
> > original version:
> > READ: bw=3D1845KiB/s (1889kB/s), 1845KiB/s-1845KiB/s
> > (1889kB/s-1889kB/s), io=3D216MiB (227MB), run=3D120053-120053msec
> > sync speed: about 190MB/s
> > with my patch:
> > READ: bw=3D19.1MiB/s (20.0MB/s), 19.1MiB/s-19.1MiB/s
> > (20.0MB/s-20.0MB/s), io=3D2286MiB (2397MB), run=3D120013-120013msec
> > sync speed: 80~100MB/sec
> > with this patch:
> > READ: bw=3D20.3MiB/s (21.2MB/s), 20.3MiB/s-20.3MiB/s
> > (21.2MB/s-21.2MB/s), io=3D2431MiB (2549MB), run=3D120001-120001msec
> > sync speed: about 40MB/sec
> >
> > fio --name=3Dread --filename=3D/dev/md0 --ioengine=3Dlibaio --rw=3Dread
> > --bs=3D4k --direct=3D1 --numjobs=3D1 --iodepth=3D32 --runtime=3D120
> > --group_reporting
> > original version:
> > READ: bw=3D9.78MiB/s (10.3MB/s), 9.78MiB/s-9.78MiB/s
> > (10.3MB/s-10.3MB/s), io=3D1174MiB (1231MB), run=3D120001-120001msec
> > sync speed: =EF=BD=9E170MB/S
> > with my patch:
> >   READ: bw=3D68.3MiB/s (71.6MB/s), 68.3MiB/s-68.3MiB/s
> > (71.6MB/s-71.6MB/s), io=3D8193MiB (8591MB), run=3D120014-120014msec
> > sync speed: ~100MB/sec
> > with this patch:
> > READ: bw=3D110MiB/s (115MB/s), 110MiB/s-110MiB/s (115MB/s-115MB/s),
> > io=3D12.8GiB (13.8GB), run=3D120003-120003msec
> > sync speed: ~25MB/sec
> >
> > fio --name=3Dwrite --filename=3D/dev/md0 --ioengine=3Dlibaio --rw=3Dwri=
te
> > --bs=3D4k --direct=3D1 --numjobs=3D1 --iodepth=3D32 --runtime=3D120
> > --group_reporting
> > original version:
> > WRITE: bw=3D1203KiB/s (1232kB/s), 1203KiB/s-1203KiB/s
> > (1232kB/s-1232kB/s), io=3D142MiB (149MB), run=3D120936-120936msec
> > sync speed: =EF=BD=9E170MB/S
> > with my patch:
> > WRITE: bw=3D4994KiB/s (5114kB/s), 4994KiB/s-4994KiB/s
> > (5114kB/s-5114kB/s), io=3D590MiB (619MB), run=3D121076-121076msec
> > sync speed: 100MB ~ 110MB/sec
> > with this patch:
> >    WRITE: bw=3D10.5MiB/s (11.0MB/s), 10.5MiB/s-10.5MiB/s
> > (11.0MB/s-11.0MB/s), io=3D1261MiB (1323MB), run=3D120002-120002msec
> > sync speed: 13MB/sec
> >
> > fio --name=3Drandread --filename=3D/dev/md0 --ioengine=3Dlibaio
> > --rw=3Drandread --random_generator=3Dtausworthe64 --bs=3D4k --direct=3D=
1
> > --numjobs=3D1 --runtime=3D120 --group_reporting
> > original version:
> > READ: bw=3D17.5KiB/s (18.0kB/s), 17.5KiB/s-17.5KiB/s
> > (18.0kB/s-18.0kB/s), io=3D2104KiB (2154kB), run=3D120008-120008msec
> > sync speed: =EF=BD=9E180MB/S
> > with my patch:
> > READ: bw=3D63.5KiB/s (65.0kB/s), 63.5KiB/s-63.5KiB/s
> > (65.0kB/s-65.0kB/s), io=3D7628KiB (7811kB), run=3D120201-120201msec
> > sync speed: 150MB ~ 160MB/sec
> > with this patch:
> >     READ: bw=3D266KiB/s (273kB/s), 266KiB/s-266KiB/s (273kB/s-273kB/s),
> > io=3D31.2MiB (32.7MB), run=3D120001-120001msec
> > sync speed: about 15MB/sec
> >
> > The sync speed decreases too much with this patch. As we talked, I'm
> > good if it's a new project. We can give the upper layer io a high
> > priority. But md has run for almost 10 years after patch
> > ac8fa4196d20("md: allow resync to go faster when there is competing
> > IO."). It's not good to change this (only my thought). I don't think
> > it's bad that raid5 tells md the io situation (my rfc
> > https://www.spinics.net/lists/raid/msg79342.html)
>
> Yes, sync speed decreases, but foreground IO bandwidth also increases,
> and foregroud IO latency is important as well, you might want to check
> it as well.

Sure, it's the reason why I tried to fix this problem. The upper layer
randread io can't be handled in a reasonable time. It's a trade-off
between sync io and upper layer io. I prefer the middle one.

>
> For raid5, this version limit inflight sync IO to 8 stripes, this is the
> reason sync speed is low. This can adjust to a higher value and sync
> speed will increase.

Yes, I adjust the limit:
128, the sync speed changes from 13MB/sec to 26MB/sec.
1280, the sync speed can be about 100MB

>
> However, I still believe foreground IO latency and bandwidth is much
> more important by default. We already offer the API speed min and speed
> max for user if they really want higher sync speed regardless of
> foreground IO.

Ok

Thanks
Xiao
>
> Thanks,
> Kuai
> >
> > Best Regards
> > Xiao
> >
> > On Tue, Apr 8, 2025 at 8:50=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com=
> wrote:
> >>
> >> From: Yu Kuai <yukuai3@huawei.com>
> >>
> >> If sync_speed is above speed_min, then is_mddev_idle() will be called
> >> for each sync IO to check if the array is idle, and inflihgt sync_io
> >> will be limited to one if the array is not idle.
> >>
> >> However, while mkfs.ext4 for a large raid5 array while recovery is in
> >> progress, it's found that sync_speed is already above speed_min while
> >> lots of stripes are used for sync IO, causing long delay for mkfs.ext4=
.
> >>
> >> Root cause is the following checking from is_mddev_idle():
> >>
> >> t1: submit sync IO: events1 =3D completed IO - issued sync IO
> >> t2: submit next sync IO: events2  =3D completed IO - issued sync IO
> >> if (events2 - events1 > 64)
> >>
> >> For consequence, the more sync IO issued, the less likely checking wil=
l
> >> pass. And when completed normal IO is more than issued sync IO, the
> >> condition will finally pass and is_mddev_idle() will return false,
> >> however, last_events will be updated hence is_mddev_idle() can only
> >> return false once in a while.
> >>
> >> Fix this problem by changing the checking as following:
> >>
> >> 1) mddev doesn't have normal IO completed;
> >> 2) mddev doesn't have normal IO inflight;
> >> 3) if any member disks is partition, and all other partitions doesn't
> >>     have IO completed.
> >>
> >> Noted in order to prevent sync speed to drop conspicuously, the inflig=
ht
> >> sync IO above speed_min is also increased from 1 to 8.
> >>
> >> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> >> ---
> >>   block/blk.h            |  1 -
> >>   block/genhd.c          |  1 +
> >>   drivers/md/md.c        | 97 +++++++++++++++++++++++++---------------=
--
> >>   drivers/md/md.h        | 12 +-----
> >>   drivers/md/raid1.c     |  3 --
> >>   drivers/md/raid10.c    |  9 ----
> >>   drivers/md/raid5.c     |  8 ----
> >>   include/linux/blkdev.h |  2 +-
> >>   8 files changed, 60 insertions(+), 73 deletions(-)
> >>
> >> diff --git a/block/blk.h b/block/blk.h
> >> index 90fa5f28ccab..a78f9df72a83 100644
> >> --- a/block/blk.h
> >> +++ b/block/blk.h
> >> @@ -413,7 +413,6 @@ void blk_apply_bdi_limits(struct backing_dev_info =
*bdi,
> >>   int blk_dev_init(void);
> >>
> >>   void update_io_ticks(struct block_device *part, unsigned long now, b=
ool end);
> >> -unsigned int part_in_flight(struct block_device *part);
> >>
> >>   static inline void req_set_nomerge(struct request_queue *q, struct r=
equest *req)
> >>   {
> >> diff --git a/block/genhd.c b/block/genhd.c
> >> index e9375e20d866..0ce35bc88196 100644
> >> --- a/block/genhd.c
> >> +++ b/block/genhd.c
> >> @@ -139,6 +139,7 @@ unsigned int part_in_flight(struct block_device *p=
art)
> >>
> >>          return inflight;
> >>   }
> >> +EXPORT_SYMBOL_GPL(part_in_flight);
> >>
> >>   static void part_in_flight_rw(struct block_device *part,
> >>                  unsigned int inflight[2])
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index cefa9cba711b..c65483a33d7a 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -8585,50 +8585,51 @@ void md_cluster_stop(struct mddev *mddev)
> >>          put_cluster_ops(mddev);
> >>   }
> >>
> >> -static int is_mddev_idle(struct mddev *mddev, int init)
> >> +static bool is_rdev_idle(struct md_rdev *rdev, bool init)
> >>   {
> >> -       struct md_rdev *rdev;
> >> -       int idle;
> >> -       int curr_events;
> >> +       int last_events =3D rdev->last_events;
> >>
> >> -       idle =3D 1;
> >> -       rcu_read_lock();
> >> -       rdev_for_each_rcu(rdev, mddev) {
> >> -               struct gendisk *disk =3D rdev->bdev->bd_disk;
> >> +       if (!bdev_is_partition(rdev->bdev))
> >> +               return true;
> >>
> >> -               if (!init && !blk_queue_io_stat(disk->queue))
> >> -                       continue;
> >> +       rdev->last_events =3D (int)part_stat_read_accum(rdev->bdev->bd=
_disk->part0, sectors) -
> >> +                           (int)part_stat_read_accum(rdev->bdev, sect=
ors);
> >>
> >> -               curr_events =3D (int)part_stat_read_accum(disk->part0,=
 sectors) -
> >> -                             atomic_read(&disk->sync_io);
> >> -               /* sync IO will cause sync_io to increase before the d=
isk_stats
> >> -                * as sync_io is counted when a request starts, and
> >> -                * disk_stats is counted when it completes.
> >> -                * So resync activity will cause curr_events to be sma=
ller than
> >> -                * when there was no such activity.
> >> -                * non-sync IO will cause disk_stat to increase withou=
t
> >> -                * increasing sync_io so curr_events will (eventually)
> >> -                * be larger than it was before.  Once it becomes
> >> -                * substantially larger, the test below will cause
> >> -                * the array to appear non-idle, and resync will slow
> >> -                * down.
> >> -                * If there is a lot of outstanding resync activity wh=
en
> >> -                * we set last_event to curr_events, then all that act=
ivity
> >> -                * completing might cause the array to appear non-idle
> >> -                * and resync will be slowed down even though there mi=
ght
> >> -                * not have been non-resync activity.  This will only
> >> -                * happen once though.  'last_events' will soon reflec=
t
> >> -                * the state where there is little or no outstanding
> >> -                * resync requests, and further resync activity will
> >> -                * always make curr_events less than last_events.
> >> -                *
> >> -                */
> >> -               if (init || curr_events - rdev->last_events > 64) {
> >> -                       rdev->last_events =3D curr_events;
> >> -                       idle =3D 0;
> >> -               }
> >> +       if (!init && rdev->last_events > last_events)
> >> +               return false;
> >> +
> >> +       return true;
> >> +}
> >> +
> >> +/*
> >> + * mddev is idle if following conditions are match since last check:
> >> + * 1) mddev doesn't have normal IO completed;
> >> + * 2) mddev doesn't have inflight normal IO;
> >> + * 3) if any member disk is partition, and other partitions doesn't h=
ave IO
> >> + *    completed;
> >> + *
> >> + * Noted this checking rely on IO accounting is enabled.
> >> + */
> >> +static bool is_mddev_idle(struct mddev *mddev, bool init)
> >> +{
> >> +       struct md_rdev *rdev;
> >> +       bool idle =3D true;
> >> +
> >> +       if (!mddev_is_dm(mddev)) {
> >> +               int last_events =3D mddev->last_events;
> >> +
> >> +               mddev->last_events =3D (int)part_stat_read_accum(mddev=
->gendisk->part0, sectors);
> >> +               if (!init && (mddev->last_events > last_events ||
> >> +                             part_in_flight(mddev->gendisk->part0)))
> >> +                       idle =3D false;
> >>          }
> >> +
> >> +       rcu_read_lock();
> >> +       rdev_for_each_rcu(rdev, mddev)
> >> +               if (!is_rdev_idle(rdev, init))
> >> +                       idle =3D false;
> >>          rcu_read_unlock();
> >> +
> >>          return idle;
> >>   }
> >>
> >> @@ -8940,6 +8941,21 @@ static sector_t md_sync_position(struct mddev *=
mddev, enum sync_action action)
> >>          }
> >>   }
> >>
> >> +/*
> >> + * For raid 456, sync IO is stripe(4k) per IO, for other levels, it's
> >> + * RESYNC_PAGES(64k) per IO, we limit inflight sync IO for no more th=
an
> >> + * 8 if sync_speed is above speed_min.
> >> + */
> >> +static int get_active_threshold(struct mddev *mddev)
> >> +{
> >> +       int max_active =3D 128 * 8;
> >> +
> >> +       if (mddev->level =3D=3D 4 || mddev->level =3D=3D 5 || mddev->l=
evel =3D=3D 6)
> >> +               max_active =3D 8 * 8;
> >> +
> >> +       return max_active;
> >> +}
> >> +
> >>   #define SYNC_MARKS     10
> >>   #define        SYNC_MARK_STEP  (3*HZ)
> >>   #define UPDATE_FREQUENCY (5*60*HZ)
> >> @@ -8953,6 +8969,7 @@ void md_do_sync(struct md_thread *thread)
> >>          unsigned long update_time;
> >>          sector_t mark_cnt[SYNC_MARKS];
> >>          int last_mark,m;
> >> +       int active_threshold =3D get_active_threshold(mddev);
> >>          sector_t last_check;
> >>          int skipped =3D 0;
> >>          struct md_rdev *rdev;
> >> @@ -9208,14 +9225,14 @@ void md_do_sync(struct md_thread *thread)
> >>                                  msleep(500);
> >>                                  goto repeat;
> >>                          }
> >> -                       if (!is_mddev_idle(mddev, 0)) {
> >> +                       if (atomic_read(&mddev->recovery_active) >=3D =
active_threshold &&
> >> +                           !is_mddev_idle(mddev, 0))
> >>                                  /*
> >>                                   * Give other IO more of a chance.
> >>                                   * The faster the devices, the less w=
e wait.
> >>                                   */
> >>                                  wait_event(mddev->recovery_wait,
> >>                                             !atomic_read(&mddev->recov=
ery_active));
> >> -                       }
> >>                  }
> >>          }
> >>          pr_info("md: %s: %s %s.\n",mdname(mddev), desc,
> >> diff --git a/drivers/md/md.h b/drivers/md/md.h
> >> index dd6a28f5d8e6..6890aa4ac8b4 100644
> >> --- a/drivers/md/md.h
> >> +++ b/drivers/md/md.h
> >> @@ -518,6 +518,7 @@ struct mddev {
> >>                                                           * adding a s=
pare
> >>                                                           */
> >>
> >> +       int last_events;                /* IO event timestamp */
> >>          atomic_t                        recovery_active; /* blocks sc=
heduled, but not written */
> >>          wait_queue_head_t               recovery_wait;
> >>          sector_t                        recovery_cp;
> >> @@ -714,17 +715,6 @@ static inline int mddev_trylock(struct mddev *mdd=
ev)
> >>   }
> >>   extern void mddev_unlock(struct mddev *mddev);
> >>
> >> -static inline void md_sync_acct(struct block_device *bdev, unsigned l=
ong nr_sectors)
> >> -{
> >> -       if (blk_queue_io_stat(bdev->bd_disk->queue))
> >> -               atomic_add(nr_sectors, &bdev->bd_disk->sync_io);
> >> -}
> >> -
> >> -static inline void md_sync_acct_bio(struct bio *bio, unsigned long nr=
_sectors)
> >> -{
> >> -       md_sync_acct(bio->bi_bdev, nr_sectors);
> >> -}
> >> -
> >>   struct md_personality
> >>   {
> >>          struct md_submodule_head head;
> >> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> >> index e366d0bba792..d422bab77580 100644
> >> --- a/drivers/md/raid1.c
> >> +++ b/drivers/md/raid1.c
> >> @@ -2376,7 +2376,6 @@ static void sync_request_write(struct mddev *mdd=
ev, struct r1bio *r1_bio)
> >>
> >>                  wbio->bi_end_io =3D end_sync_write;
> >>                  atomic_inc(&r1_bio->remaining);
> >> -               md_sync_acct(conf->mirrors[i].rdev->bdev, bio_sectors(=
wbio));
> >>
> >>                  submit_bio_noacct(wbio);
> >>          }
> >> @@ -3049,7 +3048,6 @@ static sector_t raid1_sync_request(struct mddev =
*mddev, sector_t sector_nr,
> >>                          bio =3D r1_bio->bios[i];
> >>                          if (bio->bi_end_io =3D=3D end_sync_read) {
> >>                                  read_targets--;
> >> -                               md_sync_acct_bio(bio, nr_sectors);
> >>                                  if (read_targets =3D=3D 1)
> >>                                          bio->bi_opf &=3D ~MD_FAILFAST=
;
> >>                                  submit_bio_noacct(bio);
> >> @@ -3058,7 +3056,6 @@ static sector_t raid1_sync_request(struct mddev =
*mddev, sector_t sector_nr,
> >>          } else {
> >>                  atomic_set(&r1_bio->remaining, 1);
> >>                  bio =3D r1_bio->bios[r1_bio->read_disk];
> >> -               md_sync_acct_bio(bio, nr_sectors);
> >>                  if (read_targets =3D=3D 1)
> >>                          bio->bi_opf &=3D ~MD_FAILFAST;
> >>                  submit_bio_noacct(bio);
> >> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> >> index 6ef65b4d1093..12fb01987ff3 100644
> >> --- a/drivers/md/raid10.c
> >> +++ b/drivers/md/raid10.c
> >> @@ -2426,7 +2426,6 @@ static void sync_request_write(struct mddev *mdd=
ev, struct r10bio *r10_bio)
> >>
> >>                  atomic_inc(&conf->mirrors[d].rdev->nr_pending);
> >>                  atomic_inc(&r10_bio->remaining);
> >> -               md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(=
tbio));
> >>
> >>                  if (test_bit(FailFast, &conf->mirrors[d].rdev->flags)=
)
> >>                          tbio->bi_opf |=3D MD_FAILFAST;
> >> @@ -2448,8 +2447,6 @@ static void sync_request_write(struct mddev *mdd=
ev, struct r10bio *r10_bio)
> >>                          bio_copy_data(tbio, fbio);
> >>                  d =3D r10_bio->devs[i].devnum;
> >>                  atomic_inc(&r10_bio->remaining);
> >> -               md_sync_acct(conf->mirrors[d].replacement->bdev,
> >> -                            bio_sectors(tbio));
> >>                  submit_bio_noacct(tbio);
> >>          }
> >>
> >> @@ -2583,13 +2580,10 @@ static void recovery_request_write(struct mdde=
v *mddev, struct r10bio *r10_bio)
> >>          d =3D r10_bio->devs[1].devnum;
> >>          if (wbio->bi_end_io) {
> >>                  atomic_inc(&conf->mirrors[d].rdev->nr_pending);
> >> -               md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(=
wbio));
> >>                  submit_bio_noacct(wbio);
> >>          }
> >>          if (wbio2) {
> >>                  atomic_inc(&conf->mirrors[d].replacement->nr_pending)=
;
> >> -               md_sync_acct(conf->mirrors[d].replacement->bdev,
> >> -                            bio_sectors(wbio2));
> >>                  submit_bio_noacct(wbio2);
> >>          }
> >>   }
> >> @@ -3757,7 +3751,6 @@ static sector_t raid10_sync_request(struct mddev=
 *mddev, sector_t sector_nr,
> >>                  r10_bio->sectors =3D nr_sectors;
> >>
> >>                  if (bio->bi_end_io =3D=3D end_sync_read) {
> >> -                       md_sync_acct_bio(bio, nr_sectors);
> >>                          bio->bi_status =3D 0;
> >>                          submit_bio_noacct(bio);
> >>                  }
> >> @@ -4882,7 +4875,6 @@ static sector_t reshape_request(struct mddev *md=
dev, sector_t sector_nr,
> >>          r10_bio->sectors =3D nr_sectors;
> >>
> >>          /* Now submit the read */
> >> -       md_sync_acct_bio(read_bio, r10_bio->sectors);
> >>          atomic_inc(&r10_bio->remaining);
> >>          read_bio->bi_next =3D NULL;
> >>          submit_bio_noacct(read_bio);
> >> @@ -4942,7 +4934,6 @@ static void reshape_request_write(struct mddev *=
mddev, struct r10bio *r10_bio)
> >>                          continue;
> >>
> >>                  atomic_inc(&rdev->nr_pending);
> >> -               md_sync_acct_bio(b, r10_bio->sectors);
> >>                  atomic_inc(&r10_bio->remaining);
> >>                  b->bi_next =3D NULL;
> >>                  submit_bio_noacct(b);
> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> index 6389383166c0..ca5b0e8ba707 100644
> >> --- a/drivers/md/raid5.c
> >> +++ b/drivers/md/raid5.c
> >> @@ -1240,10 +1240,6 @@ static void ops_run_io(struct stripe_head *sh, =
struct stripe_head_state *s)
> >>                  }
> >>
> >>                  if (rdev) {
> >> -                       if (s->syncing || s->expanding || s->expanded
> >> -                           || s->replacing)
> >> -                               md_sync_acct(rdev->bdev, RAID5_STRIPE_=
SECTORS(conf));
> >> -
> >>                          set_bit(STRIPE_IO_STARTED, &sh->state);
> >>
> >>                          bio_init(bi, rdev->bdev, &dev->vec, 1, op | o=
p_flags);
> >> @@ -1300,10 +1296,6 @@ static void ops_run_io(struct stripe_head *sh, =
struct stripe_head_state *s)
> >>                                  submit_bio_noacct(bi);
> >>                  }
> >>                  if (rrdev) {
> >> -                       if (s->syncing || s->expanding || s->expanded
> >> -                           || s->replacing)
> >> -                               md_sync_acct(rrdev->bdev, RAID5_STRIPE=
_SECTORS(conf));
> >> -
> >>                          set_bit(STRIPE_IO_STARTED, &sh->state);
> >>
> >>                          bio_init(rbi, rrdev->bdev, &dev->rvec, 1, op =
| op_flags);
> >> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> >> index 248416ecd01c..da1a161627ba 100644
> >> --- a/include/linux/blkdev.h
> >> +++ b/include/linux/blkdev.h
> >> @@ -182,7 +182,6 @@ struct gendisk {
> >>          struct list_head slave_bdevs;
> >>   #endif
> >>          struct timer_rand_state *random;
> >> -       atomic_t sync_io;               /* RAID */
> >>          struct disk_events *ev;
> >>
> >>   #ifdef CONFIG_BLK_DEV_ZONED
> >> @@ -1117,6 +1116,7 @@ static inline long nr_blockdev_pages(void)
> >>
> >>   extern void blk_io_schedule(void);
> >>
> >> +unsigned int part_in_flight(struct block_device *part);
> >>   int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
> >>                  sector_t nr_sects, gfp_t gfp_mask);
> >>   int __blkdev_issue_discard(struct block_device *bdev, sector_t secto=
r,
> >> --
> >> 2.39.2
> >>
> >
> >
> > .
> >
>

