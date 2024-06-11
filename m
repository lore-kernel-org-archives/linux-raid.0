Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54A1101E2
	for <linux-raid@vger.kernel.org>; Tue, 11 Jun 2024 21:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718140714; cv=none; b=lNZJJ7QyatovPxOjDi42e0qC+woGkgK81i9h2HeMoJvnaRurcSJqMla345QyvZiUHxBJQwtFICBH8GB0xxqMf715VikikHvzfUEJtjd0GMgFWhu3aBaIOJjVL66wDtEjZitUhoKlFcjQ3Fjh1NDSIcXmjWYz2iIGMXg4RsI+B1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718140714; c=relaxed/simple;
	bh=iikes/s4NWLAMEvvj6ae0bGImM6i4w4Xln1BY2RkVOw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DWDJrwyOknLAryM4GN3R1yJ4yhEWkEgaj5M14wg17URDlYNwRF/7EXCdpkSzHl6pc8A+FqSHISh/W/5Xx77Yav4o8xo9Q5cCloW4Rt0mfUJ3j0W/8jY0rmh8rOQUgUiR+u8FBhZOrTG59xF+Tptz/6/lINqb7cq1ZI/0XBmMoT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wzc0GGTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wzc0GGTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30375C4AF1C
	for <linux-raid@vger.kernel.org>; Tue, 11 Jun 2024 21:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718140714;
	bh=iikes/s4NWLAMEvvj6ae0bGImM6i4w4Xln1BY2RkVOw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Wzc0GGTx4N36GduDfIjALtl+GKKQkplOZGbMJmayTIc3jVeMDTWYJsZIbAbKjVOk9
	 6nbbRYAGkgUPd9QsdwGKS2Pm9v4yQYFYmq0nUmNadhBDHyPZQ1oPzR4MdxxrtsIJ23
	 doImIV/IXHBxI1SzCbQKLhIti6uw8tL1xUTzHWlxHQPjhDzMHoK+T2vPly8IPldGmQ
	 /qNrrxW9Eb1PYDgxsBB3AX+GjDf8SNo3kbe6eXceJjKyxG8jyn4l7YjNzPr3mYk/oW
	 scYfO/Twmeh77PJlME7iQ25M5+rE4IxCpspl4pf6Uu/ghgrU9cKedZVNDdLm3t5bIQ
	 8lNZOPR1Ggv+Q==
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2ebe0a81dc8so17227951fa.2
        for <linux-raid@vger.kernel.org>; Tue, 11 Jun 2024 14:18:34 -0700 (PDT)
X-Gm-Message-State: AOJu0YxzTHqCqS+X8Ixz7zAx4QtZ46nbjOJq+CUyAdVY5UTQrb7YdAJQ
	1J1/A2x691sPX0MYDQWm4LgMnHvnDwRONObmEW/HiV1ZKzu/GnSUn3XIQcQdQrskWWO9bzWx3Zc
	W4mWHLGJaxqnLN1TWnhlyI3Igtw8=
X-Google-Smtp-Source: AGHT+IE60nOUAB+Kl84/mwllW0uUhqIZVUT9KCKS5iufgy1Nk34GJ3pTHfJg/oHB2N1IsKpvUBSpDloE5fkJeJZ3GIs=
X-Received: by 2002:a2e:9f12:0:b0:2eb:df11:ca0b with SMTP id
 38308e7fff4ca-2ebfc90527cmr107211fa.14.1718140712509; Tue, 11 Jun 2024
 14:18:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <SJ0PR10MB5741D624033B16510F56A525D8C72@SJ0PR10MB5741.namprd10.prod.outlook.com>
In-Reply-To: <SJ0PR10MB5741D624033B16510F56A525D8C72@SJ0PR10MB5741.namprd10.prod.outlook.com>
From: Song Liu <song@kernel.org>
Date: Tue, 11 Jun 2024 14:18:20 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4Kk-a+shEvBDk4+0G5xqWep6XxhjzBCSB15ZRR7H-f3A@mail.gmail.com>
Message-ID: <CAPhsuW4Kk-a+shEvBDk4+0G5xqWep6XxhjzBCSB15ZRR7H-f3A@mail.gmail.com>
Subject: Re: [RFC V6] md/raid5: optimize Scattered Address Space and
 Thread-Level Parallelism to improve RAID5 performance
To: Shushu Yi <teddyxym@outlook.com>
Cc: linux-raid@vger.kernel.org, Shushu Yi <firnyee@gmail.com>, 
	Yu Kuai <yukuai3@huawei.com>, hch@infradead.org, Paul Luse <paul.e.luse@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Shushu,

Thanks for your persistent work with this effort!

On Tue, Jun 11, 2024 at 12:35=E2=80=AFPM Shushu Yi <teddyxym@outlook.com> w=
rote:

This subject and commit log need some work.

For the subject, I think we can use something like:
md/bitmap: Optimize lock contention.

> Optimize scattered address space. Achieves significant improvements in
> both throughput and latency.
>
> Maximize thread-level parallelism and reduce CPU suspension time caused
> by lock contention. Achieve increased overall storage throughput by
> 89.4% and decrease the 99.99th percentile I/O latency by 85.4% on a
> system with four PCIe 4.0 SSDs. (Set the iodepth to 32 and employ
> libaio. Configure the I/O size as 4 KB with sequential write and 16
> threads. In RAID5 consist of 2+1 1TB Samsung 980Pro SSDs, throughput
> went from 5218MB/s to 9884MB/s.)

For the commit log, please provide more details. There is no word
limit here. Let's make it easy to understand.

> Note: Publish this work as a paper and provide the URL
> (https://www.hotstorage.org/2022/camera-ready/hotstorage22-5/pdf/
> hotstorage22-5.pdf).
>
> Co-developed-by: Yiming Xu <teddyxym@outlook.com>
> Signed-off-by: Yiming Xu <teddyxym@outlook.com>
> Signed-off-by: Shushu Yi <firnyee@gmail.com>
> Tested-by: Paul Luse <paul.e.luse@intel.com>
[...]
> -static int md_bitmap_checkpage(struct bitmap_counts *bitmap,
> -                              unsigned long page, int create, int no_hij=
ack)
> -__releases(bitmap->lock)
> -__acquires(bitmap->lock)
> +static int md_bitmap_checkpage(struct bitmap_counts *bitmap, unsigned lo=
ng page,
> +                              int create, int no_hijack, spinlock_t *bmc=
lock, int locktype)
> +__releases(bmclock)
> +__acquires(bmclock)
> +__releases(bitmap->mlock)
> +__acquires(bitmap->mlock)
>  {
>         unsigned char *mappage;
>
> @@ -65,8 +67,10 @@ __acquires(bitmap->lock)
>                 return -ENOENT;
>
>         /* this page has not been allocated yet */
> -
> -       spin_unlock_irq(&bitmap->lock);
> +       if (locktype)
> +               spin_unlock_irq(bmclock);
> +       else
> +               write_unlock_irq(&bitmap->mlock);

locktype seems unnecessary here. We can do something like

if (bmclock)
    spin_unlock_irq(bmclock);
else
    write_unlock_irq(...);

Also, please add some comment here to explain the logic.

>         /* It is possible that this is being called inside a
>          * prepare_to_wait/finish_wait loop from raid5c:make_request().
>          * In general it is not permitted to sleep in that context as it
> @@ -81,7 +85,11 @@ __acquires(bitmap->lock)
>          */
>         sched_annotate_sleep();
>         mappage =3D kzalloc(PAGE_SIZE, GFP_NOIO);
> -       spin_lock_irq(&bitmap->lock);
> +
> +       if (locktype)
> +               spin_lock_irq(bmclock);
> +       else
> +               write_lock_irq(&bitmap->mlock);
>
>         if (mappage =3D=3D NULL) {
>                 pr_debug("md/bitmap: map page allocation failed, hijackin=
g\n");
> @@ -399,7 +407,7 @@ static int read_file_page(struct file *file, unsigned=
 long index,
>         }
>
>         wait_event(bitmap->write_wait,
> -                  atomic_read(&bitmap->pending_writes)=3D=3D0);
> +                  atomic_read(&bitmap->pending_writes) =3D=3D 0);

I would prefer not to include this fix here.

>         if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
>                 ret =3D -EIO;
>  out:
> @@ -458,7 +466,7 @@ static void md_bitmap_wait_writes(struct bitmap *bitm=
ap)
>  {
>         if (bitmap->storage.file)
>                 wait_event(bitmap->write_wait,
> -                          atomic_read(&bitmap->pending_writes)=3D=3D0);
> +                          atomic_read(&bitmap->pending_writes) =3D=3D 0)=
;

and here. (and a few more later).

>         else
>                 /* Note that we ignore the return value.  The writes
>                  * might have failed, but that would just mean that
> @@ -1248,16 +1256,28 @@ void md_bitmap_write_all(struct bitmap *bitmap)
>  static void md_bitmap_count_page(struct bitmap_counts *bitmap,
>                                  sector_t offset, int inc)
>  {
> -       sector_t chunk =3D offset >> bitmap->chunkshift;
> -       unsigned long page =3D chunk >> PAGE_COUNTER_SHIFT;
> +       sector_t blockno =3D offset >> (PAGE_SHIFT - SECTOR_SHIFT);
> +       sector_t totblocks =3D bitmap->chunks << (bitmap->chunkshift - (P=
AGE_SHIFT - SECTOR_SHIFT));
> +       unsigned long bits =3D totblocks ? fls((totblocks - 1)) : 0;
> +       unsigned long mask =3D ULONG_MAX << bits | ~(ULONG_MAX <<
> +                                       (bits - (bitmap->chunkshift + SEC=
TOR_SHIFT - PAGE_SHIFT)));
> +       unsigned long cntid =3D blockno & mask;
> +       unsigned long page =3D cntid >> PAGE_COUNTER_SHIFT;
> +

We have similar logic 4 times in the code. Let's add some helper for it.

>         bitmap->bp[page].count +=3D inc;
>         md_bitmap_checkfree(bitmap, page);
>  }
>
>  static void md_bitmap_set_pending(struct bitmap_counts *bitmap, sector_t=
 offset)
>  {
> -       sector_t chunk =3D offset >> bitmap->chunkshift;
> -       unsigned long page =3D chunk >> PAGE_COUNTER_SHIFT;
> +       sector_t blockno =3D offset >> (PAGE_SHIFT - SECTOR_SHIFT);
> +       sector_t totblocks =3D bitmap->chunks << (bitmap->chunkshift - (P=
AGE_SHIFT - SECTOR_SHIFT));
> +       unsigned long bits =3D totblocks ? fls((totblocks - 1)) : 0;
> +       unsigned long mask =3D ULONG_MAX << bits | ~(ULONG_MAX <<
> +                                       (bits - (bitmap->chunkshift + SEC=
TOR_SHIFT - PAGE_SHIFT)));
> +       unsigned long cntid =3D blockno & mask;
> +       unsigned long page =3D cntid >> PAGE_COUNTER_SHIFT;
> +
>         struct bitmap_page *bp =3D &bitmap->bp[page];
>
>         if (!bp->pending)
> @@ -1266,7 +1286,7 @@ static void md_bitmap_set_pending(struct bitmap_cou=
nts *bitmap, sector_t offset)
>
>  static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts *bit=
map,
>                                                sector_t offset, sector_t =
*blocks,
> -                                              int create);
> +                                              int create, spinlock_t *bm=
clock, int locktype);

We don't need bmclock and locktype here, right?

>
>  static void mddev_set_timeout(struct mddev *mddev, unsigned long timeout=
,
>                               bool force)
> @@ -1349,7 +1369,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
>          * decrement and handle accordingly.
>          */
>         counts =3D &bitmap->counts;
[...]
> @@ -2227,18 +2309,29 @@ int md_bitmap_resize(struct bitmap *bitmap, secto=
r_t blocks,
>         blocks =3D min(old_counts.chunks << old_counts.chunkshift,
>                      chunks << chunkshift);
>
> +       /* initialize bmc locks */
> +       num_bmclocks =3D DIV_ROUND_UP(chunks, BITMAP_COUNTER_LOCK_RATIO);
> +       num_bmclocks =3D min(num_bmclocks, BITMAP_COUNTER_LOCK_MAX);
> +
> +       new_bmclocks =3D kvcalloc(num_bmclocks, sizeof(*new_bmclocks), GF=
P_KERNEL);
> +       bitmap->counts.bmclocks =3D new_bmclocks;
> +       for (i =3D 0; i < num_bmclocks; ++i) {
> +               spinlock_t *bmclock =3D &(bitmap->counts.bmclocks)[i];
> +
> +               spin_lock_init(bmclock);
> +       }
> +
>         /* For cluster raid, need to pre-allocate bitmap */
>         if (mddev_is_clustered(bitmap->mddev)) {
>                 unsigned long page;
>                 for (page =3D 0; page < pages; page++) {
> -                       ret =3D md_bitmap_checkpage(&bitmap->counts, page=
, 1, 1);
> +                       ret =3D md_bitmap_checkpage(&bitmap->counts, page=
, 1, 1, 0, 0);

For 0 pointer (bmclock), please use NULL.

>                         if (ret) {
>                                 unsigned long k;
>
>                                 /* deallocate the page memory */
> -                               for (k =3D 0; k < page; k++) {
> +                               for (k =3D 0; k < page; k++)
>                                         kfree(new_bp[k].map);
> -                               }
>                                 kfree(new_bp);
[...]
>
>  /* the superblock at the front of the bitmap file -- little endian */
> @@ -180,7 +186,8 @@ struct bitmap_page {
>  struct bitmap {
>
>         struct bitmap_counts {
> -               spinlock_t lock;
> +               rwlock_t mlock;                         /* lock for metad=
ata */
> +               spinlock_t *bmclocks;           /* locks for bmc */

A summary about the locking design here can be really helpful.

>                 struct bitmap_page *bp;
>                 unsigned long pages;            /* total number of pages
>                                                  * in the bitmap */
> --
> 2.43.0
>
