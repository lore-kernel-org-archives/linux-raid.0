From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: [PATCH 007 of 7] md: Get name for block device in sysfs
Date: Sat, 15 Dec 2007 17:58:26 +0100
Message-ID: <3ae72650712150858v14681823td2b0410eb67b1d04@mail.gmail.com>
References: <20071214171950.1308.patches@notabene> <1071214062647.1928@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1071214062647.1928@suse.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Greg KH <greg@kroah.com>
List-Id: linux-raid.ids

On Dec 14, 2007 7:26 AM, NeilBrown <neilb@suse.de> wrote:
>
> Given an fd on a block device, returns a string like
>
>         /block/sda/sda1
>
> which can be used to find related information in /sys.
>
> Ideally we should have an ioctl that works on char devices as well,
> but that seems far from trivial, so it seems reasonable to have
> this until the later can be implemented.
>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Neil Brown <neilb@suse.de>
>
> ### Diffstat output
>  ./block/ioctl.c      |   13 +++++++++++++
>  ./include/linux/fs.h |    2 ++
>  2 files changed, 15 insertions(+)
>
> diff .prev/block/ioctl.c ./block/ioctl.c
> --- .prev/block/ioctl.c 2007-12-14 17:18:50.000000000 +1100
> +++ ./block/ioctl.c     2007-12-14 16:15:41.000000000 +1100
> @@ -227,8 +227,21 @@ int blkdev_ioctl(struct inode *inode, st
>         struct block_device *bdev = inode->i_bdev;
>         struct gendisk *disk = bdev->bd_disk;
>         int ret, n;
> +       char b[BDEVNAME_SIZE*2  + 10];
>
>         switch(cmd) {
> +       case BLKGETNAME:
> +               strcpy(b, "/block/");

As pointed out to when you came up with the idea, we can't do this. A devpath
is a path to the device and will not necessarily start with "/block" for block
devices. It may start with "/devices" and can be much longer than
BDEVNAME_SIZE*2  + 10.

Please do not apply!

Kay
