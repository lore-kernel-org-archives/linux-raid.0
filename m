Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA6E2C54FB9
	for <linux-raid@archiver.kernel.org>; Thu, 16 Nov 2023 16:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjKPQZA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Nov 2023 11:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjKPQY7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 16 Nov 2023 11:24:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE4F1A8
        for <linux-raid@vger.kernel.org>; Thu, 16 Nov 2023 08:24:55 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7569AC433CC
        for <linux-raid@vger.kernel.org>; Thu, 16 Nov 2023 16:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700151895;
        bh=fHJOnX6EfnqlraT0kalO/OUaA5Xx+jQ//lsFenWOUlo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jZJmVtSH/kgJBlI3yL7Tw5CzxpHNJgoTXURFhhdjdYOkQ6LjA8o6LWIc+nZOwbXpd
         7Yi4q07jJOBHiyLhfMFqyVGOLwcKeAc2LDTbHnduCyzAIOWHua+EnniVYpEBL6sVc7
         fWVVrqf8LSBzcxvqPK/TFKj6xciRd7s7AoafMSx9QnrAd5ozI1x/w99JexL8POtVij
         nk3SguDEv6QPKLSMxLjSu9MFUCtAFAXnBIcSCZb3aAz8VDy9hgAqumo+Y04Ju5FHYL
         9NduSVY9Rz7CNMub33ZVtG69rnvqy+ah3ZgsKDCjvP9SV/kc4MEbJ6qgNB65srwlkn
         DnEsmiVp0g4vQ==
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1cc3bc5df96so8323625ad.2
        for <linux-raid@vger.kernel.org>; Thu, 16 Nov 2023 08:24:55 -0800 (PST)
X-Gm-Message-State: AOJu0Yzr9goDr/wU0G+XOacCx1ZH6cFx0WlymiF89A9/8LsBK45SEl8B
        YGjUcWoDm5vwLPON6UaIjyLKCUY1AWge19vk87o=
X-Google-Smtp-Source: AGHT+IHc9mHKMnMq319rkQ2g6Hp3kh7yhrT6o8c2f94gF6JWHahDBoLfV7EU41fN+fzFYKVHvBN8L6dEzJnfQtLDa/o=
X-Received: by 2002:a17:902:ce89:b0:1c6:3157:29f3 with SMTP id
 f9-20020a170902ce8900b001c6315729f3mr10735491plg.36.1700151894950; Thu, 16
 Nov 2023 08:24:54 -0800 (PST)
MIME-Version: 1.0
References: <5727380.DvuYhMxLoT@bvd0>
In-Reply-To: <5727380.DvuYhMxLoT@bvd0>
From:   Song Liu <song@kernel.org>
Date:   Thu, 16 Nov 2023 11:24:40 -0500
X-Gmail-Original-Message-ID: <CAPhsuW4+Ktd7mzTQ6M4n9-=8vgyMDJUi8Xkcv50JXTf_2yqTFA@mail.gmail.com>
Message-ID: <CAPhsuW4+Ktd7mzTQ6M4n9-=8vgyMDJUi8Xkcv50JXTf_2yqTFA@mail.gmail.com>
Subject: Re: [REGRESSION] Data read from a degraded RAID 4/5/6 array could be
 silently corrupted.
To:     Bhanu Victor DiCara <00bvd0+linux@gmail.com>,
        Xiao Ni <xni@redhat.com>,
        Mateusz Grzonka <mateusz.grzonka@intel.com>
Cc:     linux-raid@vger.kernel.org, regressions@lists.linux.dev,
        jiangguoqing@kylinos.cn, jgq516@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

+ more folks.

On Fri, Nov 10, 2023 at 7:00=E2=80=AFPM Bhanu Victor DiCara
<00bvd0+linux@gmail.com> wrote:
>
> A degraded RAID 4/5/6 array can sometimes read 0s instead of the actual d=
ata.
>
>
> #regzbot introduced: 10764815ff4728d2c57da677cd5d3dd6f446cf5f
> (The problem does not occur in the previous commit.)
>
> In commit 10764815ff4728d2c57da677cd5d3dd6f446cf5f, file drivers/md/raid5=
.c, line 5808, there is `md_account_bio(mddev, &bi);`. When this line (and =
the previous line) is removed, the problem does not occur.

The patch below should fix it. Please give it more thorough tests and
let me know whether it fixes everything. I will send patch later with
more details.

Thanks,
Song

diff --git i/drivers/md/md.c w/drivers/md/md.c
index 68f3bb6e89cb..d4fb1aa5c86f 100644
--- i/drivers/md/md.c
+++ w/drivers/md/md.c
@@ -8674,7 +8674,8 @@ static void md_end_clone_io(struct bio *bio)
        struct bio *orig_bio =3D md_io_clone->orig_bio;
        struct mddev *mddev =3D md_io_clone->mddev;

-       orig_bio->bi_status =3D bio->bi_status;
+       if (bio->bi_status)
+               orig_bio->bi_status =3D bio->bi_status;

        if (md_io_clone->start_time)
                bio_end_io_acct(orig_bio, md_io_clone->start_time);


>
> Similarly, in commit ffc253263a1375a65fa6c9f62a893e9767fbebfa (v6.6), fil=
e drivers/md/raid5.c, when line 6200 is removed, the problem does not occur=
.
>
>
> Steps to reproduce the problem (using bash or similar):
> 1. Create a degraded RAID 4/5/6 array:
> fallocate -l 2056M test_array_part_1.img
> fallocate -l 2056M test_array_part_2.img
> lo1=3D$(losetup --sector-size 4096 --find --nooverlap --direct-io --show =
 test_array_part_1.img)
> lo2=3D$(losetup --sector-size 4096 --find --nooverlap --direct-io --show =
 test_array_part_2.img)
> # The RAID level must be 4 or 5 or 6 with at least 1 missing drive in any=
 order. The following configuration seems to be the most effective:
> mdadm --create /dev/md/tmp_test_array --level=3D4 --raid-devices=3D3 --ch=
unk=3D1M --size=3D2G  $lo1 missing $lo2
>
> 2. Create the test file system and clone it to the degraded array:
> fallocate -l 4G test_fs.img
> mke2fs -t ext4 -b 4096 -i 65536 -m 0 -E stride=3D256,stripe_width=3D512 -=
L test_fs  test_fs.img
> lo3=3D$(losetup --sector-size 4096 --find --nooverlap --direct-io --show =
 test_fs.img)
> mount $lo3 /mnt/1
> python3 create_test_fs.py /mnt/1
> umount /mnt/1
> cat test_fs.img > /dev/md/tmp_test_array
> cmp -l test_fs.img /dev/md/tmp_test_array  # Optionally verify the clone
> mount --read-only $lo3 /mnt/1
>
> 3. Mount the degraded array:
> mount --read-only /dev/md/tmp_test_array /mnt/2
>
> 4. Compare the files:
> diff -q /mnt/1 /mnt/2
>
> If no files are detected as different, do `umount /mnt/2` and `echo 2 > /=
proc/sys/vm/drop_caches`, and then go to step 3.
> (Doing `echo 3 > /proc/sys/vm/drop_caches` and then going to step 4 is le=
ss effective.)
> (Only doing `umount /mnt/2` and/or `echo 1 > /proc/sys/vm/drop_caches` is=
 much less effective and the effectiveness wears off.)
>
>
> create_test_fs.py:
> import errno
> import itertools
> import os
> import random
> import sys
>
>
> def main(test_fs_path):
>         rng =3D random.Random(0)
>         try:
>                 for i in itertools.count():
>                         size =3D int(2**rng.uniform(12, 24))
>                         with open(os.path.join(test_fs_path, str(i).zfill=
(4) + '.bin'), 'xb') as f:
>                                 f.write(b'\xff' * size)
>                         print(f'Created file {f.name!r} with size {size}'=
)
>         except OSError as e:
>                 if e.errno !=3D errno.ENOSPC:
>                         raise
>                 print(f'Done: {e.strerror} (partially created file {f.nam=
e!r})')
>
>
> if __name__ =3D=3D '__main__':
>         main(sys.argv[1])
>
>
>
