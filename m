Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 332F7C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 15 Nov 2021 18:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18908635A9
	for <linux-raid@archiver.kernel.org>; Mon, 15 Nov 2021 18:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239511AbhKOSok (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 15 Nov 2021 13:44:40 -0500
Received: from group.wh-serverpark.com ([159.69.170.92]:41563 "EHLO
        group.wh-serverpark.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239455AbhKOSmE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 15 Nov 2021 13:42:04 -0500
Received: from localhost (localhost [127.0.0.1])
        by group.wh-serverpark.com (Postfix) with ESMTP id D3423EE292D;
        Mon, 15 Nov 2021 19:39:04 +0100 (CET)
Received: from group.wh-serverpark.com ([127.0.0.1])
        by localhost (group.wh-serverpark.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ZpCda7JUwf3n; Mon, 15 Nov 2021 19:39:03 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by group.wh-serverpark.com (Postfix) with ESMTP id C21B5EE292F;
        Mon, 15 Nov 2021 19:39:03 +0100 (CET)
X-Virus-Scanned: amavisd-new at valiant.wh-serverpark.com
Received: from group.wh-serverpark.com ([127.0.0.1])
        by localhost (group.wh-serverpark.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id A9NP1lxykQnO; Mon, 15 Nov 2021 19:39:03 +0100 (CET)
Received: from enterprise.localnet (unknown [93.189.159.254])
        by group.wh-serverpark.com (Postfix) with ESMTPSA id A2B1BEE292D;
        Mon, 15 Nov 2021 19:39:03 +0100 (CET)
From:   Markus Hochholdinger <Markus@hochholdinger.net>
To:     Xiao Ni <xni@redhat.com>
Cc:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Subject: Re: [PATCH] md: fix update super 1.0 on rdev size change
Date:   Mon, 15 Nov 2021 19:39:03 +0100
Message-ID: <181899007.qP1mJhO4kW@enterprise>
In-Reply-To: <CALTww28689G2xbZ9sWFpviXLwB1WKPfQL6Y1girjiBMEvWcQRw@mail.gmail.com>
References: <20211112142822.813606-1-markus@hochholdinger.net> <CALTww28689G2xbZ9sWFpviXLwB1WKPfQL6Y1girjiBMEvWcQRw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Xiao,

for 1.0 the super block is at the end of the device, out of "man mdadm":
    -e, --metadata=
              [..]
                     The different sub-versions
                     store the superblock at different locations  on  the  de-
                     vice, either at the end (for 1.0), at the start (for 1.1)
                     or 4K from the start (for 1.2).   "1"  is  equivalent  to
                     "1.2"  (the commonly preferred 1.x format).  "default" is
                     equivalent to "1.2".
(Because of other reasons, we have intentionally choosen the superblock at the 
end of the device.)

We change the device size of raid1 arrays, which are inside a VM, on a regular 
basis. And afterwards we grow the raid1 while the raid1 is online. Therefore, 
the superblock has to be moved.
This is very neat, because we can grow the raid1 and the filesystem size in a 
very short time frame and don't have to rebuild the raid1 twice (remove one 
device, resize and add with full rebuild because the old superblock is 
somewhere inbetween, then the same for the other device) before we can grow 
the raid1 and the filesystem.
If this explanation is not enough why we need this feature, I can explain in 
more detail why someone would do the software raid1 within a VM if you like.

As I understand, if the superblock isn't moved and we have grown the array and 
the filesystem on it, the superblock will now be updated inbetween the 
filesystem and may corrupt the filesystem and data.

Funny thing, after both devices are resized, the raid1 is still online and the 
grow does work. But afterwards, one can't do anything with the raid1, you get 
errors about the superblock, e.g. mdadm -D .. works, but mdadm -E .. for both 
devices doesn't. You can remove one device from the raid1, but you can't add 
it anymore, mdadm --add .. says: "mdadm: cannot load array metadata from /dev/
md0". And you can't re-assemble the raid1 after it is stopped.

I can reproduce this: With kernel version <= 5.8.18 the above works as 
expected. Since kernel version 5.9.x it doesn't anymore.
I tested this patch with kernel 5.15.1 and 5.10.46 and the above works again.


Here is a minimal setup to test this (but in real life we use it in a VM with 
virtual disks which can be resized online):
# truncate -s 1G /var/tmp/rdev1
# truncate -s 1G /var/tmp/rdev2
# losetup -f /var/tmp/rdev1
# losetup -f /var/tmp/rdev2
# losetup -j /var/tmp/rdev1
/dev/loop0: [2304]:786663 (/var/tmp/rdev1)
# losetup -j /var/tmp/rdev2
/dev/loop1: [2304]:788462 (/var/tmp/rdev2)
# mdadm --create --assume-clean /dev/md9 --metadata=1.0 --level=1 --raid-
disks=2 /dev/loop0 /dev/loop1
mdadm: array /dev/md9 started.
# mdadm -E /dev/loop0
/dev/loop0:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
[..]
# # grow the first loop device by 100MB
# dd if=/dev/zero bs=1M count=100 >> /var/tmp/rdev1
100+0 records in
100+0 records out
104857600 bytes (105 MB, 100 MiB) copied, 0.0960313 s, 1.1 GB/s
# losetup -c /dev/loop0

### with kernel <= 5.8.18 ###
# mdadm -E /dev/loop0
mdadm: No md superblock detected on /dev/loop0.
# echo 0 > /sys/block/md9/md/rd0/size
# mdadm -E /dev/loop0
/dev/loop0:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
[..]
# 

### with kernel >= 5.9.x ###
# mdadm -E /dev/loop0
mdadm: No md superblock detected on /dev/loop0.
# echo 0 > /sys/block/md9/md/rd0/size
# mdadm -E /dev/loop0
mdadm: No md superblock detected on /dev/loop0.
# 


Regards,
Markus

Am Montag, 15. November 2021, 10:47:12 CET schrieb Xiao Ni:
> The sb_start doesn't change in function super_1_rdev_size_change. For
> super1.0 the super start is always at a fixed position. Is there a
> possibility the disk size
> changes? sb_start is calculated based on i_size_read(rdev->bdev->bd_inode).
> 
> By the way, can you reproduce this problem? If so, could you share
> your test steps?
> 
> Regards
> Xiao
> 
> On Fri, Nov 12, 2021 at 10:29 PM <markus@hochholdinger.net> wrote:
> > From: Markus Hochholdinger <markus@hochholdinger.net>
> > 
> > The superblock of version 1.0 doesn't get moved to the new position on a
> > device size change. This leads to a rdev without a superblock on a known
> > position, the raid can't be re-assembled.
> > 
> > Fixes: commit d9c0fa509eaf ("md: fix max sectors calculation for super
> > 1.0") ---
> > 
> >  drivers/md/md.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 6c0c3d0d905a..ad968cfc883d 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -2193,6 +2193,7 @@ super_1_rdev_size_change(struct md_rdev *rdev,
> > sector_t num_sectors)> 
> >                 if (!num_sectors || num_sectors > max_sectors)
> >                 
> >                         num_sectors = max_sectors;
> > 
> > +               rdev->sb_start = sb_start;
> > 
> >         }
> >         sb = page_address(rdev->sb_page);
> >         sb->data_size = cpu_to_le64(num_sectors);
> > 
> > --
> > 2.30.2



