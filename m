From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH -stable] block: destroy bdi before blockdev is unregistered.
Date: Mon, 27 Apr 2015 10:27:55 -0600
Message-ID: <553E638B.7040408@fb.com>
References: <20150414171537.GH25394@azat>	<20150423160551.45345f96@notabene.brown> <20150427141222.5dac22f1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150427141222.5dac22f1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Azat Khuzhin <a3at.mail@gmail.com>, Christoph Hellwig <hch@lst.de>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Guoqing Jiang <GQJiang@suse.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On 04/26/2015 10:12 PM, NeilBrown wrote:
>
> Because of the peculiar way that md devices are created (automatically
> when the device node is opened), a new device can be created and
> registered immediately after the
> 	blk_unregister_region(disk_devt(disk), disk->minors);
> call in del_gendisk().
>
> Therefore it is important that all visible artifacts of the previous
> device are removed before this call.  In particular, the 'bdi'.
>
> Since:
> commit c4db59d31e39ea067c32163ac961e9c80198fd37
> Author: Christoph Hellwig <hch@lst.de>
>      fs: don't reassign dirty inodes to default_backing_dev_info
>
> moved the
>     device_unregister(bdi->dev);
> call from bdi_unregister() to bdi_destroy() it has been quite easy to
> lose a race and have a new (e.g.) "md127" be created after the
> blk_unregister_region() call and before bdi_destroy() is ultimately
> called by the final 'put_disk', which must come after del_gendisk().
>
> The new device finds that the bdi name is already registered in sysfs
> and complains
>
>> [ 9627.630029] WARNING: CPU: 18 PID: 3330 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x5a/0x70()
>> [ 9627.630032] sysfs: cannot create duplicate filename '/devices/virtual/bdi/9:127'
>
> We can fix this by moving the bdi_destroy() call out of
> blk_release_queue() (which can happen very late when a refcount
> reaches zero) and into blk_cleanup_queue() - which happens exactly when the md
> device driver calls it.
>
> Then it is only necessary for md to call blk_cleanup_queue() before
> del_gendisk().  As loop.c devices are also created on demand by
> opening the device node, we make the same change there.
>
> Fixes: c4db59d31e39ea067c32163ac961e9c80198fd37
> Reported-by: Azat Khuzhin <a3at.mail@gmail.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: stable@vger.kernel.org (v4.0)
> Signed-off-by: NeilBrown <neilb@suse.de>
>
> --
> Hi Jens,
>   if you could check this and forward on to Linus I'd really appreciate it.

Yup, I added it. BTW, that line needs 3 '-', otherwise git am will pick 
up the comments below :-)

Thanks Neil.

-- 
Jens Axboe

