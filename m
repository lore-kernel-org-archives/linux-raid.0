Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2897EC8FF
	for <linux-raid@vger.kernel.org>; Sat,  9 Nov 2024 11:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731152618; cv=none; b=V07FvP4fXupFbxvZh+TRlr/7nn4/Wbb5g4QZ4Y+A4HGb1jl2c61SAY2b++ryRTayZ0jUcXWO5BpZCx/Z7lpJJhCLODTaWUUVwoucabS5MnFsJrLWyIFPe+5TM7C/ss4WQRk7IprjpWTfT7xyT77QbHEmQ1GkuOa/PDIfcC3LO9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731152618; c=relaxed/simple;
	bh=qiI8T7DTwuVxtkfzPY8gD4pB6WMkodj/1l86KfwdkgA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S4WyvNTR9ubJZOHepzXuMN6TJHUZhJ84VZ6annKIG3JWdhKhpoZzDWz1/8aNLDZDjxFuNtuUO3WhaCMyZkZz8iTQfC+5OYl86HhR8kLBDAtguzOM1XjuAptIWqjM9eucQF4DsE23F874Wi0d64vdfaVLlpaivEYfk+RsmOXFv/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DKa6lvry; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DKa6lvry"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731152614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4GCjWtdYLBdfVG5/VngKS0hH5hz/5lvx3/KgU/2X8pw=;
	b=DKa6lvryIgJYKj7kFR10oJVa/ZiIWmwenDCU/P8Hrpy5cj+8+tx8eNgDWoLiPPSgMFJ8GW
	Gc2c7p+WHzFhSvRbbKksGUfE909suJk74kcvuxkx+0I/QEObQ3IxH1k/xo6IJBBamben6b
	iCfjyUlHe/43cHZL9x742qZxU9aYuQo=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-R8WyJQXnO8-t4uNrY-W-pw-1; Sat, 09 Nov 2024 06:43:33 -0500
X-MC-Unique: R8WyJQXnO8-t4uNrY-W-pw-1
X-Mimecast-MFC-AGG-ID: R8WyJQXnO8-t4uNrY-W-pw
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-539f7abe2e6so2461310e87.1
        for <linux-raid@vger.kernel.org>; Sat, 09 Nov 2024 03:43:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731152610; x=1731757410;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4GCjWtdYLBdfVG5/VngKS0hH5hz/5lvx3/KgU/2X8pw=;
        b=ALaqwX9qGXWj2/5Nufa2ThX+GXqrKDARZ6MCXbYBB6JaYnEDuPaovmnkiCFTkBzEft
         wPrMtx2iD59HszeRwVHpbSXFkcWQ4AHco0TkY+wDwjaqrscF5FPfbpysOiJ/6QGAkm3n
         QiYGBi+ex8i6Uvxj60N/deIWqoUJIPsrbew7K4rRI8vKjdCmqXEkPoEfchNKvs8N0iMx
         vpv+YnIg53Ai23zIXOoaMunipoeIt7SO4a+LvdRIN/F5HhYPFU19d7Si909nKihzAG2L
         /nhRu+HO4DF8eicZz/sGut7f7UeBDeRk5xoB16As2CwH4Gpadi38TX5KVBIvcBob0FY/
         4zFw==
X-Forwarded-Encrypted: i=1; AJvYcCV4rba/RFbDTmip791tfIoxpN17gl9k5/6uxDvH1+r8t8gP3vvDNR+nSWwZxA+kEGBderZiKjioYr9d@vger.kernel.org
X-Gm-Message-State: AOJu0YwCpEOq2DzXDQfiHChA1OcooMvmnesPx7JkkR4nnwqU4rkhueVd
	+V1ZQJ8OFsZCcLKPIhPUPmfdVVt0B8qLSYgVJ56I1KxNKVtHjIXAIE9CNr+EMyedpIcmt5l7hC8
	jAKBWtCbDJ+3mg9akGVLXBmZuxdyLufTp1x4RllwkflXiUJNwHXU4Zptx1+LzCCKspot8BS0GAD
	T0Ti7nUDwVPMGWoSKnXBFXDHKoEx2xkrM+ebLsioIB36JPG2U=
X-Received: by 2002:ac2:4c49:0:b0:537:a745:3e with SMTP id 2adb3069b0e04-53d8626c363mr2927802e87.45.1731152609802;
        Sat, 09 Nov 2024 03:43:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFY1C4T5GE6I3zDA4izw++n+StQaTAqekFdIXAyjtudFW/tRVUPZfbf9uUy1GkzHXR1OieNgrpxfINdBFa2HnE=
X-Received: by 2002:ac2:4c49:0:b0:537:a745:3e with SMTP id 2adb3069b0e04-53d8626c363mr2927789e87.45.1731152609289;
 Sat, 09 Nov 2024 03:43:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com>
 <CALtW_ahYbP71XPM=ZGoqyBd14wVAtUyGGgXK0gxk52KjJZUk4A@mail.gmail.com>
 <CAJpMwyjG61FjozvbG1oSej2ytRxnRpj3ga=V7zTLrjXKeDYZ_Q@mail.gmail.com> <4a914bc9-0d4e-e7c8-bed8-7b781f585587@huaweicloud.com>
In-Reply-To: <4a914bc9-0d4e-e7c8-bed8-7b781f585587@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Sat, 9 Nov 2024 19:43:17 +0800
Message-ID: <CALTww297-iYB1m2Y0_ceHn1Y43nB-RZdw67QSm6zWZ3hGEtkig@mail.gmail.com>
Subject: Re: Experiencing md raid5 hang and CPU lockup on kernel v6.11
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Haris Iqbal <haris.iqbal@ionos.com>, =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>, 
	linux-raid@vger.kernel.org, Jinpu Wang <jinpu.wang@ionos.com>, 
	=?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>, 
	"yukuai (C)" <yukuai3@huawei.com>, "yangerkun@huawei.com" <yangerkun@huawei.com>, 
	David Jeffery <djeffery@redhat.com>
Content-Type: multipart/mixed; boundary="0000000000005460c606267960e0"

--0000000000005460c606267960e0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 7, 2024 at 9:22=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2024/11/05 23:34, Haris Iqbal =E5=86=99=E9=81=93:
> > On Tue, Nov 5, 2024 at 3:04=E2=80=AFPM Dragan Milivojevi=C4=87 <galileo=
@pkm-inc.com> wrote:
> >>
> >> On Tue, 5 Nov 2024 at 10:58, Haris Iqbal <haris.iqbal@ionos.com> wrote=
:
> >>>
> >>> Hi,
> >>>
> >>> I am running fio over a RDMA block device. The server side of this
> >>> mapping is an md-raid0 device, created over 3 md-raid5 devices.
> >>> The md-raid5 devices each are created over 8 block devices. Below is
> >>> how the raid configuration looks (md400, md300, md301 and md302 are
> >>> relevant for this discussion here).
> >>
> >> Try disabling the bitmap as a quick "fix" and see if that helps.
> >
> > Yes. Disabling bitmap does seem to prevent the hang completely. I ran
> > fio for 10 minutes and no hang.
> > Triggered the hang in 10 seconds after reverting back to internal bitma=
p.
> >
>
> Can you give the following patch a test? It's based on v6.11.
>
> Thanks,
> Kuai
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d3a837506a36..5e1a82b79e41 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8753,6 +8753,30 @@ void md_submit_discard_bio(struct mddev *mddev,
> struct md_rdev *rdev,
>   }
>   EXPORT_SYMBOL_GPL(md_submit_discard_bio);
>
> +static bool is_raid456(struct mddev *mddev)
> +{
> +       return mddev->pers->level =3D=3D 4 || mddev->pers->level =3D=3D 5=
 ||
> +              mddev->pers->level =3D=3D 6;
> +}
> +
> +static void bitmap_startwrite(struct mddev *mddev, struct bio *bio)
> +{
> +       if (!is_raid456(mddev) || !mddev->bitmap)
> +               return;
> +
> +       md_bitmap_startwrite(mddev->bitmap, bio_offset(bio),
> bio_sectors(bio),
> +                            0);
> +}
> +
> +static void bitmap_endwrite(struct mddev *mddev, struct bio *bio,
> sector_t sectors)
> +{
> +       if (!is_raid456(mddev) || !mddev->bitmap)
> +               return;
> +
> +       md_bitmap_endwrite(mddev->bitmap, bio_offset(bio), sectors,o
> +                          bio->bi_status =3D=3D BLK_STS_OK, 0);
> +}
> +
>   static void md_end_clone_io(struct bio *bio)
>   {
>          struct md_io_clone *md_io_clone =3D bio->bi_private;
> @@ -8765,6 +8789,7 @@ static void md_end_clone_io(struct bio *bio)
>          if (md_io_clone->start_time)
>                  bio_end_io_acct(orig_bio, md_io_clone->start_time);
>
> +       bitmap_endwrite(mddev, orig_bio, md_io_clone->sectors);
>          bio_put(bio);
>          bio_endio(orig_bio);
>          percpu_ref_put(&mddev->active_io);
> @@ -8778,6 +8803,7 @@ static void md_clone_bio(struct mddev *mddev,
> struct bio **bio)
>                  bio_alloc_clone(bdev, *bio, GFP_NOIO,
> &mddev->io_clone_set);
>
>          md_io_clone =3D container_of(clone, struct md_io_clone, bio_clon=
e);
> +       md_io_clone->sectors =3D bio_sectors(*bio);
>          md_io_clone->orig_bio =3D *bio;
>          md_io_clone->mddev =3D mddev;
>          if (blk_queue_io_stat(bdev->bd_disk->queue))
> @@ -8790,6 +8816,7 @@ static void md_clone_bio(struct mddev *mddev,
> struct bio **bio)
>
>   void md_account_bio(struct mddev *mddev, struct bio **bio)
>   {
> +       bitmap_startwrite(mddev, *bio);
>          percpu_ref_get(&mddev->active_io);
>          md_clone_bio(mddev, bio);
>   }
> @@ -8807,6 +8834,8 @@ void md_free_cloned_bio(struct bio *bio)
>          if (md_io_clone->start_time)
>                  bio_end_io_acct(orig_bio, md_io_clone->start_time);
>
> +       bitmap_endwrite(mddev, orig_bio, md_io_clone->sectors);
> +
>          bio_put(bio);
>          percpu_ref_put(&mddev->active_io);
>   }
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index a0d6827dced9..0c2794230e0a 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -837,6 +837,7 @@ struct md_io_clone {
>          struct mddev    *mddev;
>          struct bio      *orig_bio;
>          unsigned long   start_time;
> +       sector_t        sectors;
>          struct bio      bio_clone;
>   };
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index c14cf2410365..4f009e32f68a 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3561,12 +3561,6 @@ static void __add_stripe_bio(struct stripe_head
> *sh, struct bio *bi,
>                   * is added to a batch, STRIPE_BIT_DELAY cannot be chang=
ed
>                   * any more.
>                   */
> -               set_bit(STRIPE_BITMAP_PENDING, &sh->state);
> -               spin_unlock_irq(&sh->stripe_lock);
> -               md_bitmap_startwrite(conf->mddev->bitmap, sh->sector,
> -                                    RAID5_STRIPE_SECTORS(conf), 0);
> -               spin_lock_irq(&sh->stripe_lock);
> -               clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
>                  if (!sh->batch_head) {
>                          sh->bm_seq =3D conf->seq_flush+1;
>                          set_bit(STRIPE_BIT_DELAY, &sh->state);
> @@ -3621,7 +3615,6 @@ handle_failed_stripe(struct r5conf *conf, struct
> stripe_head *sh,
>          BUG_ON(sh->batch_head);
>          for (i =3D disks; i--; ) {
>                  struct bio *bi;
> -               int bitmap_end =3D 0;
>
>                  if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
>                          struct md_rdev *rdev =3D conf->disks[i].rdev;
> @@ -3646,8 +3639,6 @@ handle_failed_stripe(struct r5conf *conf, struct
> stripe_head *sh,
>                  sh->dev[i].towrite =3D NULL;
>                  sh->overwrite_disks =3D 0;
>                  spin_unlock_irq(&sh->stripe_lock);
> -               if (bi)
> -                       bitmap_end =3D 1;
>
>                  log_stripe_write_finished(sh);
> @@ -3662,10 +3653,6 @@ handle_failed_stripe(struct r5conf *conf, struct
> stripe_head *sh,
>                          bio_io_error(bi);
>                          bi =3D nextbi;
>                  }
> -               if (bitmap_end)
> -                       md_bitmap_endwrite(conf->mddev->bitmap, sh->secto=
r,
> -                                          RAID5_STRIPE_SECTORS(conf),
> 0, 0);
> -               bitmap_end =3D 0;
>                  /* and fail all 'written' */
>                  bi =3D sh->dev[i].written;
>                  sh->dev[i].written =3D NULL;
> @@ -3674,7 +3661,6 @@ handle_failed_stripe(struct r5conf *conf, struct
> stripe_head *sh,
>                          sh->dev[i].page =3D sh->dev[i].orig_page;
>                  }
>
> -               if (bi) bitmap_end =3D 1;
>                  while (bi && bi->bi_iter.bi_sector <
>                         sh->dev[i].sector + RAID5_STRIPE_SECTORS(conf)) {
>                          struct bio *bi2 =3D r5_next_bio(conf, bi,
> sh->dev[i].sector);
> @@ -3708,9 +3694,6 @@ handle_failed_stripe(struct r5conf *conf, struct
> stripe_head *sh,
>                                  bi =3D nextbi;
>                          }
>                  }
> -               if (bitmap_end)
> -                       md_bitmap_endwrite(conf->mddev->bitmap, sh->secto=
r,
> -                                          RAID5_STRIPE_SECTORS(conf),
> 0, 0);
>                  /* If we were in the middle of a write the parity block
> might
>                   * still be locked - so just clear all R5_LOCKED flags
>                   */
> @@ -4059,10 +4042,6 @@ static void handle_stripe_clean_event(struct
> r5conf *conf,
>                                          bio_endio(wbi);
>                                          wbi =3D wbi2;
>                                  }
> -                               md_bitmap_endwrite(conf->mddev->bitmap,
> sh->sector,
> - RAID5_STRIPE_SECTORS(conf),
> - !test_bit(STRIPE_DEGRADED, &sh->state),
> -                                                  0);
>                                  if (head_sh->batch_head) {
>                                          sh =3D
> list_first_entry(&sh->batch_list,
>                                                                struct
> stripe_head,
> @@ -5788,13 +5767,6 @@ static void make_discard_request(struct mddev
> *mddev, struct bio *bi)
>                  }
>                  spin_unlock_irq(&sh->stripe_lock);
>                  if (conf->mddev->bitmap) {
> -                       for (d =3D 0;
> -                            d < conf->raid_disks - conf->max_degraded;
> -                            d++)
> -                               md_bitmap_startwrite(mddev->bitmap,
> -                                                    sh->sector,
> - RAID5_STRIPE_SECTORS(conf),
> -                                                    0);
>                          sh->bm_seq =3D conf->seq_flush + 1;
>                          set_bit(STRIPE_BIT_DELAY, &sh->state);
>                  }
> > .
> >
>
>

Hi all

I just replied against one raid5 stuck problem. This one looks like a
similar one. We have a customer who reports one similar problem. David
has a patch that can work. I place it in the attachment. Can you have
a try also? The patch can be applied cleanly on 6.11-rc6

Regards
Xiao

--0000000000005460c606267960e0
Content-Type: application/octet-stream; 
	name="md_raid5_one_bitmap_claim_per_stripe_head.patch"
Content-Disposition: attachment; 
	filename="md_raid5_one_bitmap_claim_per_stripe_head.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m3a3gi0o0>
X-Attachment-Id: f_m3a3gi0o0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvcmFpZDUuYyBiL2RyaXZlcnMvbWQvcmFpZDUuYwppbmRl
eCBjMTRjZjI0MTAzNjUuLjZlMzE4NTk4YTdiNiAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZC9yYWlk
NS5jCisrKyBiL2RyaXZlcnMvbWQvcmFpZDUuYwpAQCAtMzU0OCw3ICszNTQ4LDcgQEAgc3RhdGlj
IHZvaWQgX19hZGRfc3RyaXBlX2JpbyhzdHJ1Y3Qgc3RyaXBlX2hlYWQgKnNoLCBzdHJ1Y3QgYmlv
ICpiaSwKIAkJICgqYmlwKS0+YmlfaXRlci5iaV9zZWN0b3IsIHNoLT5zZWN0b3IsIGRkX2lkeCwK
IAkJIHNoLT5kZXZbZGRfaWR4XS5zZWN0b3IpOwogCi0JaWYgKGNvbmYtPm1kZGV2LT5iaXRtYXAg
JiYgZmlyc3R3cml0ZSkgeworCWlmIChjb25mLT5tZGRldi0+Yml0bWFwICYmIGZpcnN0d3JpdGUg
JiYgIXRlc3RfYW5kX3NldF9iaXQoU1RSSVBFX0JJVE1BUF9DTEFJTSwgJnNoLT5zdGF0ZSkpIHsK
IAkJLyogQ2Fubm90IGhvbGQgc3BpbmxvY2sgb3ZlciBiaXRtYXBfc3RhcnR3cml0ZSwKIAkJICog
YnV0IG11c3QgZW5zdXJlIHRoaXMgaXNuJ3QgYWRkZWQgdG8gYSBiYXRjaCB1bnRpbAogCQkgKiB3
ZSBoYXZlIGFkZGVkIHRvIHRoZSBiaXRtYXAgYW5kIHNldCBibV9zZXEuCkBAIC0zNjIxLDcgKzM2
MjEsNiBAQCBoYW5kbGVfZmFpbGVkX3N0cmlwZShzdHJ1Y3QgcjVjb25mICpjb25mLCBzdHJ1Y3Qg
c3RyaXBlX2hlYWQgKnNoLAogCUJVR19PTihzaC0+YmF0Y2hfaGVhZCk7CiAJZm9yIChpID0gZGlz
a3M7IGktLTsgKSB7CiAJCXN0cnVjdCBiaW8gKmJpOwotCQlpbnQgYml0bWFwX2VuZCA9IDA7CiAK
IAkJaWYgKHRlc3RfYml0KFI1X1JlYWRFcnJvciwgJnNoLT5kZXZbaV0uZmxhZ3MpKSB7CiAJCQlz
dHJ1Y3QgbWRfcmRldiAqcmRldiA9IGNvbmYtPmRpc2tzW2ldLnJkZXY7CkBAIC0zNjQ2LDggKzM2
NDUsNiBAQCBoYW5kbGVfZmFpbGVkX3N0cmlwZShzdHJ1Y3QgcjVjb25mICpjb25mLCBzdHJ1Y3Qg
c3RyaXBlX2hlYWQgKnNoLAogCQlzaC0+ZGV2W2ldLnRvd3JpdGUgPSBOVUxMOwogCQlzaC0+b3Zl
cndyaXRlX2Rpc2tzID0gMDsKIAkJc3Bpbl91bmxvY2tfaXJxKCZzaC0+c3RyaXBlX2xvY2spOwot
CQlpZiAoYmkpCi0JCQliaXRtYXBfZW5kID0gMTsKIAogCQlsb2dfc3RyaXBlX3dyaXRlX2Zpbmlz
aGVkKHNoKTsKIApAQCAtMzY2MiwxMCArMzY1OSw2IEBAIGhhbmRsZV9mYWlsZWRfc3RyaXBlKHN0
cnVjdCByNWNvbmYgKmNvbmYsIHN0cnVjdCBzdHJpcGVfaGVhZCAqc2gsCiAJCQliaW9faW9fZXJy
b3IoYmkpOwogCQkJYmkgPSBuZXh0Ymk7CiAJCX0KLQkJaWYgKGJpdG1hcF9lbmQpCi0JCQltZF9i
aXRtYXBfZW5kd3JpdGUoY29uZi0+bWRkZXYtPmJpdG1hcCwgc2gtPnNlY3RvciwKLQkJCQkJICAg
UkFJRDVfU1RSSVBFX1NFQ1RPUlMoY29uZiksIDAsIDApOwotCQliaXRtYXBfZW5kID0gMDsKIAkJ
LyogYW5kIGZhaWwgYWxsICd3cml0dGVuJyAqLwogCQliaSA9IHNoLT5kZXZbaV0ud3JpdHRlbjsK
IAkJc2gtPmRldltpXS53cml0dGVuID0gTlVMTDsKQEAgLTM2NzQsNyArMzY2Nyw2IEBAIGhhbmRs
ZV9mYWlsZWRfc3RyaXBlKHN0cnVjdCByNWNvbmYgKmNvbmYsIHN0cnVjdCBzdHJpcGVfaGVhZCAq
c2gsCiAJCQlzaC0+ZGV2W2ldLnBhZ2UgPSBzaC0+ZGV2W2ldLm9yaWdfcGFnZTsKIAkJfQogCi0J
CWlmIChiaSkgYml0bWFwX2VuZCA9IDE7CiAJCXdoaWxlIChiaSAmJiBiaS0+YmlfaXRlci5iaV9z
ZWN0b3IgPAogCQkgICAgICAgc2gtPmRldltpXS5zZWN0b3IgKyBSQUlENV9TVFJJUEVfU0VDVE9S
Uyhjb25mKSkgewogCQkJc3RydWN0IGJpbyAqYmkyID0gcjVfbmV4dF9iaW8oY29uZiwgYmksIHNo
LT5kZXZbaV0uc2VjdG9yKTsKQEAgLTM3MDgsMTQgKzM3MDAsMTUgQEAgaGFuZGxlX2ZhaWxlZF9z
dHJpcGUoc3RydWN0IHI1Y29uZiAqY29uZiwgc3RydWN0IHN0cmlwZV9oZWFkICpzaCwKIAkJCQli
aSA9IG5leHRiaTsKIAkJCX0KIAkJfQotCQlpZiAoYml0bWFwX2VuZCkKLQkJCW1kX2JpdG1hcF9l
bmR3cml0ZShjb25mLT5tZGRldi0+Yml0bWFwLCBzaC0+c2VjdG9yLAotCQkJCQkgICBSQUlENV9T
VFJJUEVfU0VDVE9SUyhjb25mKSwgMCwgMCk7CiAJCS8qIElmIHdlIHdlcmUgaW4gdGhlIG1pZGRs
ZSBvZiBhIHdyaXRlIHRoZSBwYXJpdHkgYmxvY2sgbWlnaHQKIAkJICogc3RpbGwgYmUgbG9ja2Vk
IC0gc28ganVzdCBjbGVhciBhbGwgUjVfTE9DS0VEIGZsYWdzCiAJCSAqLwogCQljbGVhcl9iaXQo
UjVfTE9DS0VELCAmc2gtPmRldltpXS5mbGFncyk7CiAJfQorCWlmICh0ZXN0X2FuZF9jbGVhcl9i
aXQoU1RSSVBFX0JJVE1BUF9DTEFJTSwgJnNoLT5zdGF0ZSkpIHsKKwkJbWRfYml0bWFwX2VuZHdy
aXRlKGNvbmYtPm1kZGV2LT5iaXRtYXAsIHNoLT5zZWN0b3IsCisJCQkJICAgUkFJRDVfU1RSSVBF
X1NFQ1RPUlMoY29uZiksIDAsIDApOworCX0KIAlzLT50b193cml0ZSA9IDA7CiAJcy0+d3JpdHRl
biA9IDA7CiAKQEAgLTQwNTksMTAgKzQwNTIsNiBAQCBzdGF0aWMgdm9pZCBoYW5kbGVfc3RyaXBl
X2NsZWFuX2V2ZW50KHN0cnVjdCByNWNvbmYgKmNvbmYsCiAJCQkJCWJpb19lbmRpbyh3YmkpOwog
CQkJCQl3YmkgPSB3YmkyOwogCQkJCX0KLQkJCQltZF9iaXRtYXBfZW5kd3JpdGUoY29uZi0+bWRk
ZXYtPmJpdG1hcCwgc2gtPnNlY3RvciwKLQkJCQkJCSAgIFJBSUQ1X1NUUklQRV9TRUNUT1JTKGNv
bmYpLAotCQkJCQkJICAgIXRlc3RfYml0KFNUUklQRV9ERUdSQURFRCwgJnNoLT5zdGF0ZSksCi0J
CQkJCQkgICAwKTsKIAkJCQlpZiAoaGVhZF9zaC0+YmF0Y2hfaGVhZCkgewogCQkJCQlzaCA9IGxp
c3RfZmlyc3RfZW50cnkoJnNoLT5iYXRjaF9saXN0LAogCQkJCQkJCSAgICAgIHN0cnVjdCBzdHJp
cGVfaGVhZCwKQEAgLTQwNzcsNyArNDA2NiwxMSBAQCBzdGF0aWMgdm9pZCBoYW5kbGVfc3RyaXBl
X2NsZWFuX2V2ZW50KHN0cnVjdCByNWNvbmYgKmNvbmYsCiAJCQl9IGVsc2UgaWYgKHRlc3RfYml0
KFI1X0Rpc2NhcmQsICZkZXYtPmZsYWdzKSkKIAkJCQlkaXNjYXJkX3BlbmRpbmcgPSAxOwogCQl9
Ci0KKwlpZiAodGVzdF9hbmRfY2xlYXJfYml0KFNUUklQRV9CSVRNQVBfQ0xBSU0sICZzaC0+c3Rh
dGUpKSB7CisJCW1kX2JpdG1hcF9lbmR3cml0ZShjb25mLT5tZGRldi0+Yml0bWFwLCBzaC0+c2Vj
dG9yLAorCQkJCSAgIFJBSUQ1X1NUUklQRV9TRUNUT1JTKGNvbmYpLAorCQkJCSAgICF0ZXN0X2Jp
dChTVFJJUEVfREVHUkFERUQsICZzaC0+c3RhdGUpLCAwKTsKKwl9CiAJbG9nX3N0cmlwZV93cml0
ZV9maW5pc2hlZChzaCk7CiAKIAlpZiAoIWRpc2NhcmRfcGVuZGluZyAmJgpAQCAtNTc4OCwxMyAr
NTc4MSwxMSBAQCBzdGF0aWMgdm9pZCBtYWtlX2Rpc2NhcmRfcmVxdWVzdChzdHJ1Y3QgbWRkZXYg
Km1kZGV2LCBzdHJ1Y3QgYmlvICpiaSkKIAkJfQogCQlzcGluX3VubG9ja19pcnEoJnNoLT5zdHJp
cGVfbG9jayk7CiAJCWlmIChjb25mLT5tZGRldi0+Yml0bWFwKSB7Ci0JCQlmb3IgKGQgPSAwOwot
CQkJICAgICBkIDwgY29uZi0+cmFpZF9kaXNrcyAtIGNvbmYtPm1heF9kZWdyYWRlZDsKLQkJCSAg
ICAgZCsrKQotCQkJCW1kX2JpdG1hcF9zdGFydHdyaXRlKG1kZGV2LT5iaXRtYXAsCi0JCQkJCQkg
ICAgIHNoLT5zZWN0b3IsCi0JCQkJCQkgICAgIFJBSUQ1X1NUUklQRV9TRUNUT1JTKGNvbmYpLAot
CQkJCQkJICAgICAwKTsKKwkJCXNldF9iaXQoU1RSSVBFX0JJVE1BUF9DTEFJTSwgJnNoLT5zdGF0
ZSk7CisJCQltZF9iaXRtYXBfc3RhcnR3cml0ZShtZGRldi0+Yml0bWFwLAorCQkJCQkgICAgIHNo
LT5zZWN0b3IsCisJCQkJCSAgICAgUkFJRDVfU1RSSVBFX1NFQ1RPUlMoY29uZiksCisJCQkJCSAg
ICAgMCk7CiAJCQlzaC0+Ym1fc2VxID0gY29uZi0+c2VxX2ZsdXNoICsgMTsKIAkJCXNldF9iaXQo
U1RSSVBFX0JJVF9ERUxBWSwgJnNoLT5zdGF0ZSk7CiAJCX0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bWQvcmFpZDUuaCBiL2RyaXZlcnMvbWQvcmFpZDUuaAppbmRleCA5YjVhN2RjM2YyYTAuLjgzMGQ1
YjMzYTRmYyAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZC9yYWlkNS5oCisrKyBiL2RyaXZlcnMvbWQv
cmFpZDUuaApAQCAtMzk5LDYgKzM5OSw5IEBAIGVudW0gewogCQkJCSAqIGluIGNvbmYtPnI1Y19m
dWxsX3N0cmlwZV9saXN0KQogCQkJCSAqLwogCVNUUklQRV9SNUNfUFJFRkxVU0gsCS8qIG5lZWQg
dG8gZmx1c2ggam91cm5hbCBkZXZpY2UgKi8KKwlTVFJJUEVfQklUTUFQX0NMQUlNLAkvKiBIYXMg
YSBjbGFpbSBvbiB0aGUgYml0bWFwIHdoaWNoIHdpbGwgbmVlZCB0bworCQkJCSAqIGJlIHJlbGVh
c2VkCisJCQkJICovCiB9OwogCiAjZGVmaW5lIFNUUklQRV9FWFBBTkRfU1lOQ19GTEFHUyBcCg==
--0000000000005460c606267960e0--

