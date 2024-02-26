Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375C577F06
	for <linux-raid@vger.kernel.org>; Mon, 26 Feb 2024 09:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708938117; cv=none; b=LyYLq+voFtRVCyOxkVrNlMOyEDhtwRILNd6g7ywDNkE2R/WB7VtMGRSAHpqBZN6FQCpzsJSRn37SVsJQZDgeO7yZQnznvD/IIBiypnO62psr/QYPjM61vSF0FZefsjsVXLwcce4tbSKFSBEy1Mm3Yi+tr4p1+334dJmACZxZXvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708938117; c=relaxed/simple;
	bh=KzAk9MosC0RT51GrLVoGCoVD1Ap0ZnxIMOrYGln5YLA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mG+6ZCswymoptZBsOoQF7oKRYuO8vM95D6dNMv0I9TryGTlSlWCLud7datjfzrm/93q5mPwjWI7Q/ahzr4RSlI9+oRVR8RkSJKvoD1ryjrP1jyFReuiLElJaJqBVNDE6eQQCQblgJ22JhY54vyyTU9DZlOpjhQl3STUFURDJQj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T1eK8TFh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T1eK8TFh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708938113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=thM6w/Yn6Bo7SwMs4tgrLOx2+ltH4ZvcsiCqsPUNldE=;
	b=T1eK8TFhNwlb9tlKKLIV6bFF+qVgA+HkpmEN9a9IeLHtcNarGblHTGxddq1ZvBWLYprt+U
	wrEyDNcip2q/tLja3VatTi79M34cBeO41GViXeE6K1tCbcrtVRyhjsTRavQfsZ9kI8TyZy
	NB/LBiktFBkaVUvG/liR8OrEzpceJ4k=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-zrzbIWVONPamp1ctsffH7w-1; Mon, 26 Feb 2024 04:01:52 -0500
X-MC-Unique: zrzbIWVONPamp1ctsffH7w-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6e4e8fae664so1601138b3a.1
        for <linux-raid@vger.kernel.org>; Mon, 26 Feb 2024 01:01:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708938110; x=1709542910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=thM6w/Yn6Bo7SwMs4tgrLOx2+ltH4ZvcsiCqsPUNldE=;
        b=OcBhPjIyUrxorKc0n5fVNMnc6BR3oGDTryLPnVrCwpYiTeJROSoKu56EaY19zZWItv
         l8I1sS7VI1PPVNF1UyTEkaOAuOv1Uql9K2mDQNqWQxUFdhzYerbvQj8CL1HIc9kcU9cQ
         0SnvRrlhbLfsaMuTlKXykZM9PArw1lLasgpRR2tHfgkTan0evzKImr+sB3vsyJsmGhQM
         ehvjbJL4X8FmH1xZh2M2pgSBGKh6wweKjqPFATGmQmy1b4D6dEMGupPkzsHldInCWTtY
         H7pyK06bx322iQxmx8tVzKQgo3uF9KAAsxYN2Epooii6kgBI8ep1wChjTVPxwLBz8fMO
         feFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXvaVA6IDYjCErN5obD+wp8kK7dz7ZXYwdE2gW7qED8oH0U+LP1jRE34Sv/0ow802JlUS2wXp2aODon03JlXIR0sxaONMKBnu+3Yg==
X-Gm-Message-State: AOJu0Yxjmwbeycfl6xA/PdgZMNMi4qOsgBXT1dbTGH/u7NYe6uHDMWNe
	BTTuSdGYxaD+lDyid7Q2XfoNcdphzejCypxdsWOAksn9r7FNEKW4FC/9kqn2/3VYDUxrlqnC/6I
	IYxaZGIiIOv5TivGlxTqqUUI6sKURPLYuG53rmvzT21qdkrY1N1N9NiAaZ+pWYKc8aor966hB9K
	No/U6U0VpLTAojn+O/jwK+SUj/Nmn010YzzoHGDTPXKRb1
X-Received: by 2002:a05:6a00:1d9b:b0:6e4:f3d6:b10f with SMTP id z27-20020a056a001d9b00b006e4f3d6b10fmr5755782pfw.20.1708938110349;
        Mon, 26 Feb 2024 01:01:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHGNZnV4tx95F48WidNiqrtnrG2f301gLzgB/OzjUhB1svwj5Czm1B+C/vQgIoPrUYkDlkrihgGA6Qhs/3rDFk=
X-Received: by 2002:a05:6a00:1d9b:b0:6e4:f3d6:b10f with SMTP id
 z27-20020a056a001d9b00b006e4f3d6b10fmr5755754pfw.20.1708938109982; Mon, 26
 Feb 2024 01:01:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222075806.1816400-1-yukuai1@huaweicloud.com> <20240222075806.1816400-2-yukuai1@huaweicloud.com>
In-Reply-To: <20240222075806.1816400-2-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 26 Feb 2024 17:01:38 +0800
Message-ID: <CALTww29hJHjRMk+dRfLLckvmwmH=CyuNebWjL7nhLzdJ=Rea_g@mail.gmail.com>
Subject: Re: [PATCH md-6.9 01/10] md: add a new helper rdev_has_badblock()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: paul.e.luse@linux.intel.com, song@kernel.org, neilb@suse.com, shli@fb.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, 
	yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 22, 2024 at 4:05=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> The current api is_badblock() must pass in 'first_bad' and
> 'bad_sectors', however, many caller just want to know if there are
> badblocks or not, and these caller must define two local variable that
> will never be used.
>
> Add a new helper rdev_has_badblock() that will only return if there are
> badblocks or not, remove unnecessary local variables and replace
> is_badblock() with the new helper in many places.
>
> There are no functional changes, and the new helper will also be used
> later to refactor read_balance().
>
> Co-developed-by: Paul Luse <paul.e.luse@linux.intel.com>
> Signed-off-by: Paul Luse <paul.e.luse@linux.intel.com>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.h     | 10 ++++++++++
>  drivers/md/raid1.c  | 26 +++++++-------------------
>  drivers/md/raid10.c | 45 ++++++++++++++-------------------------------
>  drivers/md/raid5.c  | 35 +++++++++++++----------------------
>  4 files changed, 44 insertions(+), 72 deletions(-)
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 8d881cc59799..a49ab04ab707 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -222,6 +222,16 @@ static inline int is_badblock(struct md_rdev *rdev, =
sector_t s, int sectors,
>         }
>         return 0;
>  }
> +
> +static inline int rdev_has_badblock(struct md_rdev *rdev, sector_t s,
> +                                   int sectors)
> +{
> +       sector_t first_bad;
> +       int bad_sectors;
> +
> +       return is_badblock(rdev, s, sectors, &first_bad, &bad_sectors);
> +}
> +
>  extern int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sect=
ors,
>                               int is_new);
>  extern int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int se=
ctors,
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 286f8b16c7bd..a145fe48b9ce 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -498,9 +498,6 @@ static void raid1_end_write_request(struct bio *bio)
>                  * to user-side. So if something waits for IO, then it
>                  * will wait for the 'master' bio.
>                  */
> -               sector_t first_bad;
> -               int bad_sectors;
> -
>                 r1_bio->bios[mirror] =3D NULL;
>                 to_put =3D bio;
>                 /*
> @@ -516,8 +513,8 @@ static void raid1_end_write_request(struct bio *bio)
>                         set_bit(R1BIO_Uptodate, &r1_bio->state);
>
>                 /* Maybe we can clear some bad blocks. */
> -               if (is_badblock(rdev, r1_bio->sector, r1_bio->sectors,
> -                               &first_bad, &bad_sectors) && !discard_err=
or) {
> +               if (rdev_has_badblock(rdev, r1_bio->sector, r1_bio->secto=
rs) &&
> +                   !discard_error) {
>                         r1_bio->bios[mirror] =3D IO_MADE_GOOD;
>                         set_bit(R1BIO_MadeGood, &r1_bio->state);
>                 }
> @@ -1944,8 +1941,6 @@ static void end_sync_write(struct bio *bio)
>         struct r1bio *r1_bio =3D get_resync_r1bio(bio);
>         struct mddev *mddev =3D r1_bio->mddev;
>         struct r1conf *conf =3D mddev->private;
> -       sector_t first_bad;
> -       int bad_sectors;
>         struct md_rdev *rdev =3D conf->mirrors[find_bio_disk(r1_bio, bio)=
].rdev;
>
>         if (!uptodate) {
> @@ -1955,14 +1950,11 @@ static void end_sync_write(struct bio *bio)
>                         set_bit(MD_RECOVERY_NEEDED, &
>                                 mddev->recovery);
>                 set_bit(R1BIO_WriteError, &r1_bio->state);
> -       } else if (is_badblock(rdev, r1_bio->sector, r1_bio->sectors,
> -                              &first_bad, &bad_sectors) &&
> -                  !is_badblock(conf->mirrors[r1_bio->read_disk].rdev,
> -                               r1_bio->sector,
> -                               r1_bio->sectors,
> -                               &first_bad, &bad_sectors)
> -               )
> +       } else if (rdev_has_badblock(rdev, r1_bio->sector, r1_bio->sector=
s) &&
> +                  !rdev_has_badblock(conf->mirrors[r1_bio->read_disk].rd=
ev,
> +                                     r1_bio->sector, r1_bio->sectors)) {
>                 set_bit(R1BIO_MadeGood, &r1_bio->state);
> +       }
>
>         put_sync_write_buf(r1_bio, uptodate);
>  }
> @@ -2279,16 +2271,12 @@ static void fix_read_error(struct r1conf *conf, s=
truct r1bio *r1_bio)
>                         s =3D PAGE_SIZE >> 9;
>
>                 do {
> -                       sector_t first_bad;
> -                       int bad_sectors;
> -
>                         rdev =3D conf->mirrors[d].rdev;
>                         if (rdev &&
>                             (test_bit(In_sync, &rdev->flags) ||
>                              (!test_bit(Faulty, &rdev->flags) &&
>                               rdev->recovery_offset >=3D sect + s)) &&
> -                           is_badblock(rdev, sect, s,
> -                                       &first_bad, &bad_sectors) =3D=3D =
0) {
> +                           rdev_has_badblock(rdev, sect, s) =3D=3D 0) {
>                                 atomic_inc(&rdev->nr_pending);
>                                 if (sync_page_io(rdev, sect, s<<9,
>                                          conf->tmppage, REQ_OP_READ, fals=
e))
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 7412066ea22c..d5a7a621f0f0 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -518,11 +518,7 @@ static void raid10_end_write_request(struct bio *bio=
)
>                  * The 'master' represents the composite IO operation to
>                  * user-side. So if something waits for IO, then it will
>                  * wait for the 'master' bio.
> -                */
> -               sector_t first_bad;
> -               int bad_sectors;
> -
> -               /*
> +                *
>                  * Do not set R10BIO_Uptodate if the current device is
>                  * rebuilding or Faulty. This is because we cannot use
>                  * such device for properly reading the data back (we cou=
ld
> @@ -535,10 +531,9 @@ static void raid10_end_write_request(struct bio *bio=
)
>                         set_bit(R10BIO_Uptodate, &r10_bio->state);
>
>                 /* Maybe we can clear some bad blocks. */
> -               if (is_badblock(rdev,
> -                               r10_bio->devs[slot].addr,
> -                               r10_bio->sectors,
> -                               &first_bad, &bad_sectors) && !discard_err=
or) {
> +               if (rdev_has_badblock(rdev, r10_bio->devs[slot].addr,
> +                                     r10_bio->sectors) &&
> +                   !discard_error) {
>                         bio_put(bio);
>                         if (repl)
>                                 r10_bio->devs[slot].repl_bio =3D IO_MADE_=
GOOD;
> @@ -1330,10 +1325,7 @@ static void wait_blocked_dev(struct mddev *mddev, =
struct r10bio *r10_bio)
>                 }
>
>                 if (rdev && test_bit(WriteErrorSeen, &rdev->flags)) {
> -                       sector_t first_bad;
>                         sector_t dev_sector =3D r10_bio->devs[i].addr;
> -                       int bad_sectors;
> -                       int is_bad;
>
>                         /*
>                          * Discard request doesn't care the write result
> @@ -1342,9 +1334,8 @@ static void wait_blocked_dev(struct mddev *mddev, s=
truct r10bio *r10_bio)
>                         if (!r10_bio->sectors)
>                                 continue;
>
> -                       is_bad =3D is_badblock(rdev, dev_sector, r10_bio-=
>sectors,
> -                                            &first_bad, &bad_sectors);
> -                       if (is_bad < 0) {
> +                       if (rdev_has_badblock(rdev, dev_sector,
> +                                             r10_bio->sectors) < 0) {
>                                 /*
>                                  * Mustn't write here until the bad block
>                                  * is acknowledged
> @@ -2290,8 +2281,6 @@ static void end_sync_write(struct bio *bio)
>         struct mddev *mddev =3D r10_bio->mddev;
>         struct r10conf *conf =3D mddev->private;
>         int d;
> -       sector_t first_bad;
> -       int bad_sectors;
>         int slot;
>         int repl;
>         struct md_rdev *rdev =3D NULL;
> @@ -2312,11 +2301,10 @@ static void end_sync_write(struct bio *bio)
>                                         &rdev->mddev->recovery);
>                         set_bit(R10BIO_WriteError, &r10_bio->state);
>                 }
> -       } else if (is_badblock(rdev,
> -                            r10_bio->devs[slot].addr,
> -                            r10_bio->sectors,
> -                            &first_bad, &bad_sectors))
> +       } else if (rdev_has_badblock(rdev, r10_bio->devs[slot].addr,
> +                                    r10_bio->sectors)) {
>                 set_bit(R10BIO_MadeGood, &r10_bio->state);
> +       }
>
>         rdev_dec_pending(rdev, mddev);
>
> @@ -2597,11 +2585,8 @@ static void recovery_request_write(struct mddev *m=
ddev, struct r10bio *r10_bio)
>  static int r10_sync_page_io(struct md_rdev *rdev, sector_t sector,
>                             int sectors, struct page *page, enum req_op o=
p)
>  {
> -       sector_t first_bad;
> -       int bad_sectors;
> -
> -       if (is_badblock(rdev, sector, sectors, &first_bad, &bad_sectors)
> -           && (op =3D=3D REQ_OP_READ || test_bit(WriteErrorSeen, &rdev->=
flags)))
> +       if (rdev_has_badblock(rdev, sector, sectors) &&
> +           (op =3D=3D REQ_OP_READ || test_bit(WriteErrorSeen, &rdev->fla=
gs)))
>                 return -1;
>         if (sync_page_io(rdev, sector, sectors << 9, page, op, false))
>                 /* success */
> @@ -2658,16 +2643,14 @@ static void fix_read_error(struct r10conf *conf, =
struct mddev *mddev, struct r10
>                         s =3D PAGE_SIZE >> 9;
>
>                 do {
> -                       sector_t first_bad;
> -                       int bad_sectors;
> -
>                         d =3D r10_bio->devs[sl].devnum;
>                         rdev =3D conf->mirrors[d].rdev;
>                         if (rdev &&
>                             test_bit(In_sync, &rdev->flags) &&
>                             !test_bit(Faulty, &rdev->flags) &&
> -                           is_badblock(rdev, r10_bio->devs[sl].addr + se=
ct, s,
> -                                       &first_bad, &bad_sectors) =3D=3D =
0) {
> +                           rdev_has_badblock(rdev,
> +                                             r10_bio->devs[sl].addr + se=
ct,
> +                                             s) =3D=3D 0) {
>                                 atomic_inc(&rdev->nr_pending);
>                                 success =3D sync_page_io(rdev,
>                                                        r10_bio->devs[sl].=
addr +
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 14f2cf75abbd..9241e95ef55c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1210,10 +1210,8 @@ static void ops_run_io(struct stripe_head *sh, str=
uct stripe_head_state *s)
>                  */
>                 while (op_is_write(op) && rdev &&
>                        test_bit(WriteErrorSeen, &rdev->flags)) {
> -                       sector_t first_bad;
> -                       int bad_sectors;
> -                       int bad =3D is_badblock(rdev, sh->sector, RAID5_S=
TRIPE_SECTORS(conf),
> -                                             &first_bad, &bad_sectors);
> +                       int bad =3D rdev_has_badblock(rdev, sh->sector,
> +                                                   RAID5_STRIPE_SECTORS(=
conf));
>                         if (!bad)
>                                 break;
>
> @@ -2855,8 +2853,6 @@ static void raid5_end_write_request(struct bio *bi)
>         struct r5conf *conf =3D sh->raid_conf;
>         int disks =3D sh->disks, i;
>         struct md_rdev *rdev;
> -       sector_t first_bad;
> -       int bad_sectors;
>         int replacement =3D 0;
>
>         for (i =3D 0 ; i < disks; i++) {
> @@ -2888,9 +2884,8 @@ static void raid5_end_write_request(struct bio *bi)
>         if (replacement) {
>                 if (bi->bi_status)
>                         md_error(conf->mddev, rdev);
> -               else if (is_badblock(rdev, sh->sector,
> -                                    RAID5_STRIPE_SECTORS(conf),
> -                                    &first_bad, &bad_sectors))
> +               else if (rdev_has_badblock(rdev, sh->sector,
> +                                          RAID5_STRIPE_SECTORS(conf)))
>                         set_bit(R5_MadeGoodRepl, &sh->dev[i].flags);
>         } else {
>                 if (bi->bi_status) {
> @@ -2900,9 +2895,8 @@ static void raid5_end_write_request(struct bio *bi)
>                         if (!test_and_set_bit(WantReplacement, &rdev->fla=
gs))
>                                 set_bit(MD_RECOVERY_NEEDED,
>                                         &rdev->mddev->recovery);
> -               } else if (is_badblock(rdev, sh->sector,
> -                                      RAID5_STRIPE_SECTORS(conf),
> -                                      &first_bad, &bad_sectors)) {
> +               } else if (rdev_has_badblock(rdev, sh->sector,
> +                                            RAID5_STRIPE_SECTORS(conf)))=
 {
>                         set_bit(R5_MadeGood, &sh->dev[i].flags);
>                         if (test_bit(R5_ReadError, &sh->dev[i].flags))
>                                 /* That was a successful write so make
> @@ -4674,8 +4668,6 @@ static void analyse_stripe(struct stripe_head *sh, =
struct stripe_head_state *s)
>         /* Now to look around and see what can be done */
>         for (i=3Ddisks; i--; ) {
>                 struct md_rdev *rdev;
> -               sector_t first_bad;
> -               int bad_sectors;
>                 int is_bad =3D 0;
>
>                 dev =3D &sh->dev[i];
> @@ -4719,8 +4711,8 @@ static void analyse_stripe(struct stripe_head *sh, =
struct stripe_head_state *s)
>                 rdev =3D conf->disks[i].replacement;
>                 if (rdev && !test_bit(Faulty, &rdev->flags) &&
>                     rdev->recovery_offset >=3D sh->sector + RAID5_STRIPE_=
SECTORS(conf) &&
> -                   !is_badblock(rdev, sh->sector, RAID5_STRIPE_SECTORS(c=
onf),
> -                                &first_bad, &bad_sectors))
> +                   !rdev_has_badblock(rdev, sh->sector,
> +                                      RAID5_STRIPE_SECTORS(conf)))
>                         set_bit(R5_ReadRepl, &dev->flags);
>                 else {
>                         if (rdev && !test_bit(Faulty, &rdev->flags))
> @@ -4733,8 +4725,8 @@ static void analyse_stripe(struct stripe_head *sh, =
struct stripe_head_state *s)
>                 if (rdev && test_bit(Faulty, &rdev->flags))
>                         rdev =3D NULL;
>                 if (rdev) {
> -                       is_bad =3D is_badblock(rdev, sh->sector, RAID5_ST=
RIPE_SECTORS(conf),
> -                                            &first_bad, &bad_sectors);
> +                       is_bad =3D rdev_has_badblock(rdev, sh->sector,
> +                                                  RAID5_STRIPE_SECTORS(c=
onf));
>                         if (s->blocked_rdev =3D=3D NULL
>                             && (test_bit(Blocked, &rdev->flags)
>                                 || is_bad < 0)) {
> @@ -5463,8 +5455,8 @@ static int raid5_read_one_chunk(struct mddev *mddev=
, struct bio *raid_bio)
>         struct r5conf *conf =3D mddev->private;
>         struct bio *align_bio;
>         struct md_rdev *rdev;
> -       sector_t sector, end_sector, first_bad;
> -       int bad_sectors, dd_idx;
> +       sector_t sector, end_sector;
> +       int dd_idx;
>         bool did_inc;
>
>         if (!in_chunk_boundary(mddev, raid_bio)) {
> @@ -5493,8 +5485,7 @@ static int raid5_read_one_chunk(struct mddev *mddev=
, struct bio *raid_bio)
>
>         atomic_inc(&rdev->nr_pending);
>
> -       if (is_badblock(rdev, sector, bio_sectors(raid_bio), &first_bad,
> -                       &bad_sectors)) {
> +       if (rdev_has_badblock(rdev, sector, bio_sectors(raid_bio))) {
>                 rdev_dec_pending(rdev, mddev);
>                 return 0;
>         }
> --
> 2.39.2
>
>

This patch looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

