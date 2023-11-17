Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6FD6C197A0
	for <linux-raid@archiver.kernel.org>; Fri, 17 Nov 2023 09:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjKQJIs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 17 Nov 2023 04:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbjKQJIs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 17 Nov 2023 04:08:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B0D11F
        for <linux-raid@vger.kernel.org>; Fri, 17 Nov 2023 01:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1700212123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nwkYD2KSvLsNr42XYYYBqulY61ruhRC+SJXpVF+jdgs=;
        b=PKYRZUBFfAR73oRuirjyABwrbpyYoaUsS78OMheJ2bxytknjQFml7biEi6aA/JCZW3T9Q1
        ZBWCAvKD177g/RbeG04nsRH564RmFjvdjXRQ3CB9bH6dUIeFXnNQaSePFWWdxpUhWlCY4U
        HUp9q+6hdm1cXXVu+5C5RPss5jagv00=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-LssvuwhJMNKS7EZGRmgt-Q-1; Fri, 17 Nov 2023 04:08:41 -0500
X-MC-Unique: LssvuwhJMNKS7EZGRmgt-Q-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2802c0b610dso2638166a91.1
        for <linux-raid@vger.kernel.org>; Fri, 17 Nov 2023 01:08:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700212120; x=1700816920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nwkYD2KSvLsNr42XYYYBqulY61ruhRC+SJXpVF+jdgs=;
        b=IaE56Vq5YZS/tQ6dUODAlXbPneX/nn537Bk3oPtaYm0k9sgW50RY0zYwzoDXgA3AZ3
         7m4/RqQR2pHEVa5ILPdl5VsgLjlJ9chOT6cwI/cVy8xLWqcjwgb+90i0+0B4zOCAMCf7
         U4cJD1tZCe3UnB2S4XWhcTnxvkB5N5EWO4+Wt+ZiY+oCWqRYYV6vfN3m8+OKowABw0NW
         fucjl8+45aN6Z5PVx7Bj+I1NOsx2w10gHbNlDB8b8+tdGZpGhYBneWOuby2hjgwcP9Qx
         Rx16LLTuugT6gZZczE81OW28JeBXNAVAlMwwu1hGjtI7c4UE3G/gbiVPIu13Ridl2wN0
         07Yg==
X-Gm-Message-State: AOJu0YyagRlQozfCke+Ww71neOb/SvxoEtKP5WtrM6wWPbkNbMGxSikE
        Cmz3u9atvTqQYOdp3bMfQLUKej9gRSFkKDMYCytnULHWWlso4K9lFr0YiAil/qUPWPgHzOwVszX
        3+lZljFdKGAY44u7sHeU4cCcIsJ1rcWKdybAnSw==
X-Received: by 2002:a17:90b:1647:b0:27d:853:9109 with SMTP id il7-20020a17090b164700b0027d08539109mr17740129pjb.20.1700212120023;
        Fri, 17 Nov 2023 01:08:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFa6NzKLjGTFNPzHZdQXDE+LXkkVkmDt5U0jix4+1w8qoU5C0zWBUBVyLKvoUsQ/jRm0UNA6r52YsMFtZC4lsY=
X-Received: by 2002:a17:90b:1647:b0:27d:853:9109 with SMTP id
 il7-20020a17090b164700b0027d08539109mr17740118pjb.20.1700212119718; Fri, 17
 Nov 2023 01:08:39 -0800 (PST)
MIME-Version: 1.0
References: <5727380.DvuYhMxLoT@bvd0> <CAPhsuW4+Ktd7mzTQ6M4n9-=8vgyMDJUi8Xkcv50JXTf_2yqTFA@mail.gmail.com>
In-Reply-To: <CAPhsuW4+Ktd7mzTQ6M4n9-=8vgyMDJUi8Xkcv50JXTf_2yqTFA@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 17 Nov 2023 17:08:28 +0800
Message-ID: <CALTww29LApgdNXKJfKQHR-AwUiAjtzGsDV1igOXhZTOoB6e3uQ@mail.gmail.com>
Subject: Re: [REGRESSION] Data read from a degraded RAID 4/5/6 array could be
 silently corrupted.
To:     Song Liu <song@kernel.org>
Cc:     Bhanu Victor DiCara <00bvd0+linux@gmail.com>,
        Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org, regressions@lists.linux.dev,
        jiangguoqing@kylinos.cn, jgq516@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

I can reproduce this quickly with the commands mentioned at
https://www.spinics.net/lists/raid/msg73521.html in my environment.
After several hours test, this problem hasn't happened. This patch
works for me

Tested-by: Xiao Ni <xni@redhat.com>

On Fri, Nov 17, 2023 at 12:25=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> + more folks.
>
> On Fri, Nov 10, 2023 at 7:00=E2=80=AFPM Bhanu Victor DiCara
> <00bvd0+linux@gmail.com> wrote:
> >
> > A degraded RAID 4/5/6 array can sometimes read 0s instead of the actual=
 data.
> >
> >
> > #regzbot introduced: 10764815ff4728d2c57da677cd5d3dd6f446cf5f
> > (The problem does not occur in the previous commit.)
> >
> > In commit 10764815ff4728d2c57da677cd5d3dd6f446cf5f, file drivers/md/rai=
d5.c, line 5808, there is `md_account_bio(mddev, &bi);`. When this line (an=
d the previous line) is removed, the problem does not occur.
>
> The patch below should fix it. Please give it more thorough tests and
> let me know whether it fixes everything. I will send patch later with
> more details.
>
> Thanks,
> Song
>
> diff --git i/drivers/md/md.c w/drivers/md/md.c
> index 68f3bb6e89cb..d4fb1aa5c86f 100644
> --- i/drivers/md/md.c
> +++ w/drivers/md/md.c
> @@ -8674,7 +8674,8 @@ static void md_end_clone_io(struct bio *bio)
>         struct bio *orig_bio =3D md_io_clone->orig_bio;
>         struct mddev *mddev =3D md_io_clone->mddev;
>
> -       orig_bio->bi_status =3D bio->bi_status;
> +       if (bio->bi_status)
> +               orig_bio->bi_status =3D bio->bi_status;
>
>         if (md_io_clone->start_time)
>                 bio_end_io_acct(orig_bio, md_io_clone->start_time);
>
>
> >
> > Similarly, in commit ffc253263a1375a65fa6c9f62a893e9767fbebfa (v6.6), f=
ile drivers/md/raid5.c, when line 6200 is removed, the problem does not occ=
ur.
> >
> >
> > Steps to reproduce the problem (using bash or similar):
> > 1. Create a degraded RAID 4/5/6 array:
> > fallocate -l 2056M test_array_part_1.img
> > fallocate -l 2056M test_array_part_2.img
> > lo1=3D$(losetup --sector-size 4096 --find --nooverlap --direct-io --sho=
w  test_array_part_1.img)
> > lo2=3D$(losetup --sector-size 4096 --find --nooverlap --direct-io --sho=
w  test_array_part_2.img)
> > # The RAID level must be 4 or 5 or 6 with at least 1 missing drive in a=
ny order. The following configuration seems to be the most effective:
> > mdadm --create /dev/md/tmp_test_array --level=3D4 --raid-devices=3D3 --=
chunk=3D1M --size=3D2G  $lo1 missing $lo2
> >
> > 2. Create the test file system and clone it to the degraded array:
> > fallocate -l 4G test_fs.img
> > mke2fs -t ext4 -b 4096 -i 65536 -m 0 -E stride=3D256,stripe_width=3D512=
 -L test_fs  test_fs.img
> > lo3=3D$(losetup --sector-size 4096 --find --nooverlap --direct-io --sho=
w  test_fs.img)
> > mount $lo3 /mnt/1
> > python3 create_test_fs.py /mnt/1
> > umount /mnt/1
> > cat test_fs.img > /dev/md/tmp_test_array
> > cmp -l test_fs.img /dev/md/tmp_test_array  # Optionally verify the clon=
e
> > mount --read-only $lo3 /mnt/1
> >
> > 3. Mount the degraded array:
> > mount --read-only /dev/md/tmp_test_array /mnt/2
> >
> > 4. Compare the files:
> > diff -q /mnt/1 /mnt/2
> >
> > If no files are detected as different, do `umount /mnt/2` and `echo 2 >=
 /proc/sys/vm/drop_caches`, and then go to step 3.
> > (Doing `echo 3 > /proc/sys/vm/drop_caches` and then going to step 4 is =
less effective.)
> > (Only doing `umount /mnt/2` and/or `echo 1 > /proc/sys/vm/drop_caches` =
is much less effective and the effectiveness wears off.)
> >
> >
> > create_test_fs.py:
> > import errno
> > import itertools
> > import os
> > import random
> > import sys
> >
> >
> > def main(test_fs_path):
> >         rng =3D random.Random(0)
> >         try:
> >                 for i in itertools.count():
> >                         size =3D int(2**rng.uniform(12, 24))
> >                         with open(os.path.join(test_fs_path, str(i).zfi=
ll(4) + '.bin'), 'xb') as f:
> >                                 f.write(b'\xff' * size)
> >                         print(f'Created file {f.name!r} with size {size=
}')
> >         except OSError as e:
> >                 if e.errno !=3D errno.ENOSPC:
> >                         raise
> >                 print(f'Done: {e.strerror} (partially created file {f.n=
ame!r})')
> >
> >
> > if __name__ =3D=3D '__main__':
> >         main(sys.argv[1])
> >
> >
> >
>

