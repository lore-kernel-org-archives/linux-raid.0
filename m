Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8E5E571
	for <linux-raid@vger.kernel.org>; Wed, 11 Feb 2026 02:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770778222; cv=pass; b=ozgaM7U9v1oFhXkv8NxkiPqCBEZdPROecBLhvuLExYxd+xtTMLHUfFuKtwAQxxpXewDg7boBJ/zWdX5NyILGZ0i7aNZUTiIpAGKaiaC7Tj8oZgR+VcHBPs+AQoPtJWuTLxWto+3AMA2CdxFfKzNL8BRR8fe/DP5Yi4kAFOb05y8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770778222; c=relaxed/simple;
	bh=ekMlu/AEWVvHJYAoIu1YjpPckAFtBNSWRXR7YJrImCU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BuU571aCMRoHw/xmNuf13Y1jpwBEXdIaO6gJVoGETc8CQqqcUlSE8b9QnJAO3APQydZ2OVJrL4qo00Iuod8Lt4xB9CPWYShL5sAl0VJWZT0SXa49+nTlppXFk9xy7VyPiG8xpUtj4gi/qxxXrjIS9jGkuLVSasLu33XiWROQjU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P3WsPUvD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VKz7GApn; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P3WsPUvD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VKz7GApn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770778220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Psxo+HWtpH1yQJ4S7hUmPcpnWnSqmSJZ09J4fYoKp94=;
	b=P3WsPUvDHdYwN52R09dA555YryY9PZIlwCYZ+IjUx30hVz/ttwsfdNJk5KZQlSkodTh9tP
	JpRmflreOSPdZu7MNpKawRkdB3YFnBBJM5+XWdE6RFZ/U6V8/hKVvP3kGUXK7hO6cDlldn
	l5DCSJtI2Zq8XrzURa5rTw2lXd9osBI=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-nIu4fqQXPKyDXI89RE7eqQ-1; Tue, 10 Feb 2026 21:50:19 -0500
X-MC-Unique: nIu4fqQXPKyDXI89RE7eqQ-1
X-Mimecast-MFC-AGG-ID: nIu4fqQXPKyDXI89RE7eqQ_1770778217
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-59b786498b0so853450e87.3
        for <linux-raid@vger.kernel.org>; Tue, 10 Feb 2026 18:50:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770778217; cv=none;
        d=google.com; s=arc-20240605;
        b=W7ESbeXeFRMY0JRkygYpNfNUulLmzLikx+6Wc2Rjt9QfJvKPzoz2/QE2F4OuDMXoKO
         lkzcSf5NAZ3ZHP60kpgVWodd2x3myLIWXUdtKl0wWVWM6Jsn3j0+82ecmTmeDbXfejVO
         UsOP5b0f8YjcsbU9nETJ1o+dg4UctKlbfph+TOKYOzPmFdmE9xYEzp0wXlXGH19omdDS
         dHYhFGZosiCrTvyKvXlpWWwsiAptOUfrjMfrVnqhPphQP8xJfAZhCQt/LjgVXhYb37/K
         t+KLVE+GCiPZk9nojr2/Aau1a/ZawZsj9Zc556bJfcMTdTzHaTN4N1lZR816ndBuCz1u
         JWxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Psxo+HWtpH1yQJ4S7hUmPcpnWnSqmSJZ09J4fYoKp94=;
        fh=4HWTGbDEjaKKaHG2g3xv3+HEGkYwXptSltRZhSkKkbM=;
        b=LlnzRBC4VfsKGhEftyTAhM0XE/zmxOJ+gwJgOEDek9itZvyj+uOV3DDJQd/C6u7tP8
         yKCUhHvfdtpHhEhD+3XoslBRoFszaUDEC0Bk4f1+KcfMMm0iJkMwnkZHr20rlLxp3BN8
         T7knSxMWwq0n3+57P8gyEDQhqW0iixlv+hbeSxcXI5rMJ76XfH4HXNqETJi3bQ68GrDw
         NZ+PLjNeU/SPofHydBnt8xKnoz5JtdTMxVkN58dibUTQMDnkrLBvpt8Mh6UYW6tcWRdd
         UScLmNgi1gmhrGr9uw+u9OzkNsJN3UFNWSJsKLurV8ZAxjeJxiBIncpaNoSKgJ9ovEYD
         fc+w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770778217; x=1771383017; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Psxo+HWtpH1yQJ4S7hUmPcpnWnSqmSJZ09J4fYoKp94=;
        b=VKz7GApnQCiSB8jnSsGy67hi3fxT2fmgaVbPCBgluaohk+0AqSMa4mXQ1GzemJzmP4
         uY1IzgmiTBB+yWPE/ijN9g2/zElJ+3OkmrfdMTMh0EyHETxDNz4sBsBdrGV9auVO4M8y
         OYLrP46r8q/nD6BSlUh6dL3ma0b946sv49wCLg23XAwF0/DvObrFkem3dUqEdL/kW8Nn
         zAUHW3ZZWJJj+V6KxRyAvfYvAwP1AD8LAgK4nHDzIB+V5cUlw7i1s3nqAje8w093ef89
         EGhqMrBHtqVsShPKkAet97t2SJUMVySmcgBPs0HM9UgWGUOq0+7uCG50QTX+uFvGw2kB
         K9Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770778217; x=1771383017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Psxo+HWtpH1yQJ4S7hUmPcpnWnSqmSJZ09J4fYoKp94=;
        b=OkfavkovO+wOcWWkPMCa8JX6KMfYwNNy3iXotsUMB19yFGApkHKrK2CNt13pxdm/Ow
         v8TwP6qQwuidxGS8c82btiOZu316Mb+bvamf/2rZ/858lHo99ozyMVA7I2xDwyoKxH6F
         wBWpt0XGzeLptGRsre0En1ldM3IW6zGZ2mMujXRmTim+YO8wmihx4a9cGR7Vs/loaXFW
         HQn0R3Ffpi/gF81XXf8QTifZaw4v4MRgdTNnGEAj/hBhuz3Qcd7E1L9EzTbL6l9O5vsc
         p03B6t54ZkaNXuBz6h9GjeDScWpmFADPZDJ+L5sWLIt7JOgmRVZtoFAwRVDv0TKSmCn3
         FwZw==
X-Forwarded-Encrypted: i=1; AJvYcCVUgQQABUa3DNDWDsDFOo2gAoGs0x08ny3btc9jGyrIbEA+Rmr4BsqBVk/L8YQeEgGbqPwHk1MeOOcH@vger.kernel.org
X-Gm-Message-State: AOJu0YzxJVZHbsFHPJtfZyUvfSZID62Ky1sf3WWDw7awUFwMCpuA1hti
	wAhDOscLJcM0uXVO1cm+XpQytxjZU9Gw6AvIb2qT3yBYsspP2Cv/u1NVIaFuI+/NknBRGGbLaf3
	OiyHTNCyFM/h0cZusiUP3wnMuq+EUiTcSg74tL6CqbWfeguph/RWdOIewXlewYPCg6JD7FE7yxj
	Nu5NgEZyhip46Hh/Tyv0rPfee2PhEf36//2LB8I/IQV5Lmkl7g
X-Gm-Gg: AZuq6aI+Cq8LTQBE6LYSBdFmzvKC3Ax9RbM+PJ82aGfI14WhS6GZb/ZbkC6+oRfjfb3
	suDfRJOIW97iA/tPfLpv8R4oI8Xm6WzM0Aw0Pkzg1nDqPvjb5FjMSKEgW5u9oM5unOTPd5qkSRD
	qrJ94Ou5csskKNkZgrJd3z3WV14jrTyz63SlOaJNlLClbYCJolIhBvbhbx1Ed8Wn90HS22M6yoz
	U4mo60SmIGDUMq6VuUlUavrNdFiLKE3lq+RiNE05nG7HiAnxMPngW/sfkpuW0qfqtUAlLCoi/Iw
	6DZQLA==
X-Received: by 2002:a05:6512:1325:b0:59e:3e8f:ccca with SMTP id 2adb3069b0e04-59e4515331dmr6120525e87.34.1770778216569;
        Tue, 10 Feb 2026 18:50:16 -0800 (PST)
X-Received: by 2002:a05:6512:1325:b0:59e:3e8f:ccca with SMTP id
 2adb3069b0e04-59e4515331dmr6120508e87.34.1770778215531; Tue, 10 Feb 2026
 18:50:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206053826.37416-1-xni@redhat.com> <20260206053826.37416-3-xni@redhat.com>
 <9bd6581f-289a-4490-af6d-f15589446e1e@fnnas.com> <CALTww29NpmNbEb79KbVCX-rAF4o39rEd3-P1TjiDTc1OWpQiAw@mail.gmail.com>
In-Reply-To: <CALTww29NpmNbEb79KbVCX-rAF4o39rEd3-P1TjiDTc1OWpQiAw@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 11 Feb 2026 10:50:03 +0800
X-Gm-Features: AZwV_QhwZqntzNYFCKnGbhWv-FGPXw1Rgb84qFycWVNi1dCJFSstX3-x375BOII
Message-ID: <CALTww29YXPEQvAREE5Fd=z2-mfTs9q1V9827HVJ+atmJPq_+ug@mail.gmail.com>
Subject: Re: [PATCH 2/2] md/raid1: serialize overlapped io for writemostly disk
To: yukuai@fnnas.com
Cc: song@kernel.org, linux-raid@vger.kernel.org, linan666@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 11, 2026 at 10:44=E2=80=AFAM Xiao Ni <xni@redhat.com> wrote:
>
> On Wed, Feb 11, 2026 at 10:32=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote=
:
> >
> > Hi,
> >
> > =E5=9C=A8 2026/2/6 13:38, Xiao Ni =E5=86=99=E9=81=93:
> > > In behind mode, overlap bios for writemostly device are queued. They
> > > In behind mode, bios which overlap the bio from the interval tree
> > > need to wait in waitqueue. Those bios will be handled once the in-tre=
e
> > > bio finishes. They are waken up and try to get the tree lock. The bio
> > > which gets the lock will be handled. So the sequence can't be guarant=
eed.
> > >
> > > For example
> > > bio1(100,200)
> > > bio2(150,200)
> > > bio3(150,300)
> > > The write sequence of fast device is bio1,bio2,bio3. But the write
> > > sequence of slow device is bio1,bio3,bio2. This causes data corruptio=
n.
> > > Replace waitqueue with a fifo list to guarantee the write sequence.
> >
> > To be honest, I think this is fine with the respect user won't send ove=
rlap
> > bios. In this case, bio1 is done in fast disk and pending in slow disk,=
 then
> > bio2 will stuck while issuing and waiting for bio1 to return from slow =
disk.
> > So send bio3 in this case is not expected, and if you do you can't guar=
antee
> > the complete order from fast disk as bio2, bio3 as well.
>
> Hi Kuai
>
> In write behind mode, raid1 returns bio1 to the upper layer once the
> write on the fast disk finishes. The upper layer (app/filesystem)
> thinks that bio1 has finished, while the write of bio1 to the slow
> disk is still in progress. So bio2 will not be stuck while issuing, am
> I right? If so, bio2 can be submitted to raid1 once the write of bio1
> to the fast disk finishes. And bio3 can be submitted to raid1 once the
> write of bio2 to fast disk finishes.

By the way, it's reported by our customer, there is a data corruption
by the following test script:
#!/bin/sh

disk1=3D/dev/loop0
disk2=3D/dev/loop1
mddev=3D/dev/md0
mount_md=3D/data-md
mount_disk1=3D/data-1
mount_disk2=3D/data-2
bitmap=3D/root/bitmap
test_prg=3D/root/test-serializewrite
test_num=3D1000
test_str=3Dabcdefghijklmnopqrstuvwxyz

loop=3D0
touch MD-TEST
while [ -f MD-TEST ]; do
    set -x
    loop=3D$((loop + 1))
    echo "START LOOP=3D$loop at $(date)"

    echo "# lsblk"
    lsblk

    echo "# dmsetup"
    dmsetup create disk-500ms --table "0 $(blockdev --getsz $disk2)
delay $disk2 0 500"
    sleep 2

    echo "# mdadm"
    #mdadm --create $mddev --run --assume-clean --force --level=3D1
--write-behind=3D1024 --bitmap=3D$bitmap --raid-devices=3D2 $disk1
--write-mostly /dev/mapper/disk-500ms
    mdadm --create $mddev --run --assume-clean --force --level=3D1
--write-behind=3D1024 --bitmap=3Dinternal --raid-devices=3D2 $disk1
--write-mostly /dev/mapper/disk-500ms

    echo "# cat /proc/mdstat"
    cat /proc/mdstat

    #echo "# mdadm -X $bitmap"
    #mdadm -X $bitmap

    echo "# mkfs.xfs -f $mddev"
    mkfs.xfs -f $mddev

    echo "# mount $mddev $mount_md"
    mount $mddev $mount_md

    set +x
    echo "# $test_prg"
    for n in $(seq 1 $test_num); do
$test_prg $mount_md/test.$n $test_str &
    done

    while true; do
sleep 2
pgrep -f $(basename $test_prg) > /dev/null
if [ $? -ne 0 ]; then
    break
fi
    done

    set -x
    echo "# cat /proc/mdstat"
    cat /proc/mdstat

    #echo "# mdadm -X $bitmap"
    #mdadm -X $bitmap

    echo "# umount $mount_md"
    sleep 10
    while true; do
sleep 2
umount $mount_md
if [ $? -eq 0 ]; then
    break
fi
    done

    echo "# mdadm --stop $mddev"
    mdadm --stop $mddev

    echo "# dmsetup remove disk-500ms"
    while true; do
        dmsetup remove disk-500ms
        if [ $? -ne 0 ]; then
            sleep 5
        else
            break
        fi
    done

    offset=3D$(mdadm --examine $disk1 | awk -F': ' '/Data Offset/ {print
$2}' | awk '{print $1}')
    offset=3D$((offset * 512))
    echo "# mount -o ro,offset=3D$offset,nouuid $disk1 $mount_disk1"
    mount -o ro,offset=3D$offset,nouuid $disk1 $mount_disk1

    offset=3D$(mdadm --examine $disk2 | awk -F': ' '/Data Offset/ {print
$2}' | awk '{print $1}')
    #offset=3D$(mdadm --examine /dev/mapper/disk-500ms | awk -F': '
'/Data Offset/ {print $2}' | awk '{print $1}')

    offset=3D$((offset * 512))
    echo "# mount -o ro,offset=3D$offset,nouuid $disk2 $mount_disk2"
    #echo "# mount -o ro,offset=3D$offset,nouuid /dev/mapper/disk-500ms
$mount_disk2"

    mount -o ro,offset=3D$offset,nouuid $disk2 $mount_disk2
    #mount -o ro,offset=3D$offset,nouuid /dev/mapper/disk-500ms $mount_disk=
2

    echo "# diff -rq $mount_disk1 $mount_disk2"
    diff -rq $mount_disk1 $mount_disk2
    if [ $? -eq 0 ]; then
echo "@@@ PASS (loop=3D$loop)"
    else
echo "@@@ FAIL (loop=3D$loop)"
    fi

    umount $mount_disk1
    umount $mount_disk2

    mdadm --zero-superblock  $disk1
    mdadm --zero-superblock  $disk2

    sleep 10
    set +x
done
>
> Best Regards
> Xiao
> >
> > >
> > > Signed-off-by: Xiao Ni <xni@redhat.com>
> > > ---
> > >   drivers/md/md.c    |  1 -
> > >   drivers/md/md.h    |  4 +++-
> > >   drivers/md/raid1.c | 39 +++++++++++++++++++++++++++++----------
> > >   3 files changed, 32 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index 59cd303548de..ab91d17c2d68 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -188,7 +188,6 @@ static int rdev_init_serial(struct md_rdev *rdev)
> > >
> > >               spin_lock_init(&serial_tmp->serial_lock);
> > >               serial_tmp->serial_rb =3D RB_ROOT_CACHED;
> > > -             init_waitqueue_head(&serial_tmp->serial_io_wait);
> > >       }
> > >
> > >       rdev->serial =3D serial;
> > > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > > index ac84289664cd..64ffbb2efb87 100644
> > > --- a/drivers/md/md.h
> > > +++ b/drivers/md/md.h
> > > @@ -126,7 +126,6 @@ enum sync_action {
> > >   struct serial_in_rdev {
> > >       struct rb_root_cached serial_rb;
> > >       spinlock_t serial_lock;
> > > -     wait_queue_head_t serial_io_wait;
> > >   };
> > >
> > >   /*
> > > @@ -382,6 +381,9 @@ struct serial_info {
> > >       sector_t start;         /* start sector of rb node */
> > >       sector_t last;          /* end sector of rb node */
> > >       sector_t _subtree_last; /* highest sector in subtree of rb node=
 */
> > > +     struct list_head        list_node;
> > > +     struct list_head        waiters;
> > > +     struct completion       ready;
> > >   };
> > >
> > >   /*
> > > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > > index a41b1ec3d695..38c73538d038 100644
> > > --- a/drivers/md/raid1.c
> > > +++ b/drivers/md/raid1.c
> > > @@ -57,19 +57,25 @@ INTERVAL_TREE_DEFINE(struct serial_info, node, se=
ctor_t, _subtree_last,
> > >                    START, LAST, static inline, raid1_rb);
> > >
> > >   static int check_and_add_serial(struct md_rdev *rdev, struct r1bio =
*r1_bio,
> > > -                             struct serial_info *si, int idx)
> > > +                             struct serial_info *si)
> > >   {
> > >       unsigned long flags;
> > >       int ret =3D 0;
> > >       sector_t lo =3D r1_bio->sector;
> > >       sector_t hi =3D lo + r1_bio->sectors - 1;
> > > +     int idx =3D sector_to_idx(r1_bio->sector);
> > >       struct serial_in_rdev *serial =3D &rdev->serial[idx];
> > > +     struct serial_info *head_si;
> > >
> > >       spin_lock_irqsave(&serial->serial_lock, flags);
> > >       /* collision happened */
> > > -     if (raid1_rb_iter_first(&serial->serial_rb, lo, hi))
> > > +     head_si =3D raid1_rb_iter_first(&serial->serial_rb, lo, hi);
> > > +     if (head_si && head_si !=3D si) {
> > > +             si->start =3D lo;
> > > +             si->last =3D hi;
> > > +             list_add_tail(&si->list_node, &head_si->waiters);
> > >               ret =3D -EBUSY;
> > > -     else {
> > > +     } else if (!head_si) {
> > >               si->start =3D lo;
> > >               si->last =3D hi;
> > >               raid1_rb_insert(si, &serial->serial_rb);
> > > @@ -83,19 +89,23 @@ static void wait_for_serialization(struct md_rdev=
 *rdev, struct r1bio *r1_bio)
> > >   {
> > >       struct mddev *mddev =3D rdev->mddev;
> > >       struct serial_info *si;
> > > -     int idx =3D sector_to_idx(r1_bio->sector);
> > > -     struct serial_in_rdev *serial =3D &rdev->serial[idx];
> > >
> > >       if (WARN_ON(!mddev->serial_info_pool))
> > >               return;
> > >       si =3D mempool_alloc(mddev->serial_info_pool, GFP_NOIO);
> > > -     wait_event(serial->serial_io_wait,
> > > -                check_and_add_serial(rdev, r1_bio, si, idx) =3D=3D 0=
);
> > > +     INIT_LIST_HEAD(&si->waiters);
> > > +     INIT_LIST_HEAD(&si->list_node);
> > > +     init_completion(&si->ready);
> > > +     while (check_and_add_serial(rdev, r1_bio, si)) {
> > > +             wait_for_completion(&si->ready);
> > > +             reinit_completion(&si->ready);
> > > +     }
> > >   }
> > >
> > >   static void remove_serial(struct md_rdev *rdev, sector_t lo, sector=
_t hi)
> > >   {
> > >       struct serial_info *si;
> > > +     struct serial_info *first_si;
> > >       unsigned long flags;
> > >       int found =3D 0;
> > >       struct mddev *mddev =3D rdev->mddev;
> > > @@ -106,16 +116,25 @@ static void remove_serial(struct md_rdev *rdev,=
 sector_t lo, sector_t hi)
> > >       for (si =3D raid1_rb_iter_first(&serial->serial_rb, lo, hi);
> > >            si; si =3D raid1_rb_iter_next(si, lo, hi)) {
> > >               if (si->start =3D=3D lo && si->last =3D=3D hi) {
> > > -                     raid1_rb_remove(si, &serial->serial_rb);
> > > -                     mempool_free(si, mddev->serial_info_pool);
> > >                       found =3D 1;
> > >                       break;
> > >               }
> > >       }
> > >       if (!found)
> > >               WARN(1, "The write IO is not recorded for serialization=
\n");
> > > +     else {
> > > +             raid1_rb_remove(si, &serial->serial_rb);
> > > +             if (!list_empty(&si->waiters)) {
> > > +                     first_si =3D list_first_entry(&si->waiters,
> > > +                                             struct serial_info, lis=
t_node);
> > > +                     list_del_init(&first_si->list_node);
> > > +                     list_splice_init(&si->waiters, &first_si->waite=
rs);
> > > +                     raid1_rb_insert(first_si, &serial->serial_rb);
> > > +                     complete(&first_si->ready);
> > > +             }
> > > +             mempool_free(si, mddev->serial_info_pool);
> > > +     }
> > >       spin_unlock_irqrestore(&serial->serial_lock, flags);
> > > -     wake_up(&serial->serial_io_wait);
> > >   }
> > >
> > >   /*
> >
> > --
> > Thansk,
> > Kuai
> >

