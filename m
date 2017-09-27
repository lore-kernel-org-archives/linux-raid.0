From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v4 1/7] md: Make md resync and reshape threads freezable
Date: Wed, 27 Sep 2017 19:00:09 +0800
Message-ID: <20170927110006.GB1994@ming.t460p>
References: <20170925202924.16603-1-bart.vanassche@wdc.com>
 <20170925202924.16603-2-bart.vanassche@wdc.com>
 <20170926111747.GA16794@ming.t460p>
 <1506436926.3787.24.camel@wdc.com>
 <20170926145919.GC31449@ming.t460p>
 <1506481915.2822.9.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1506481915.2822.9.camel@wdc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "shli@kernel.org" <shli@kernel.org>
List-Id: linux-raid.ids

On Wed, Sep 27, 2017 at 03:12:47AM +0000, Bart Van Assche wrote:
> On Tue, 2017-09-26 at 22:59 +0800, Ming Lei wrote:
> > On Tue, Sep 26, 2017 at 02:42:07PM +0000, Bart Van Assche wrote:
> > > On Tue, 2017-09-26 at 19:17 +0800, Ming Lei wrote:
> > > > Just test this patch a bit and the following failure of freezing task
> > > > is triggered during suspend: [ ... ]
> > > 
> > > What kernel version did you start from and which patches were applied on top of
> > > that kernel? Only patch 1/7 or all seven patches? What storage configuration did
> > 
> > It is v4.14-rc1+, and top commit is 8d93c7a43157, with all your 7 patches
> > applied.
> > 
> > > you use in your test and what command(s) did you use to trigger suspend?
> > 
> > Follows my pm test script:
> > 
> > 	#!/bin/sh
> > 	
> > 	echo check > /sys/block/md127/md/sync_action
> > 	
> > 	mkfs.ext4 -F /dev/md127
> > 	
> > 	mount /dev/md0 /mnt/data
> > 	
> > 	dd if=/dev/zero of=/mnt/data/d1.img bs=4k count=128k&
> > 	
> > 	echo 9 > /proc/sys/kernel/printk
> > 	echo devices > /sys/power/pm_test
> > 	echo mem > /sys/power/state
> > 	
> > 	wait
> > 	umount /mnt/data
> > 
> > Storage setting:
> > 
> > 	sudo mdadm --create /dev/md/test /dev/sda /dev/sdb --level=1 --raid-devices=2
> > 	both /dev/sda and /dev/sdb are virtio-scsi.
> 
> Thanks for the detailed reply. I have been able to reproduce the freeze failure
> you reported. The output of SysRq-t learned me that the md reboot notifier was
> waiting for the frozen md sync thread and that this caused the freeze failure. So
> I have started testing the patch below instead of the patch at the start of this
> e-mail thread:

OK, thanks for figuring out the reason.

With current linus tree, SCSI I/O is prevented from being dispatch to
device during suspend by SCSI quiesce, and will be dispatched again
in resume. With Safe SCSI quiesce[1], any underlying IO request will
stop at blk_queue_enter() during suspend, and restart from there during
resume.

For other non-SCSI driver, their .suspend/.resume often
handles I/O in similar way, for example, NVMe queue will
be frozen in .suspend, and unfreeze in .resume.

So could you explain a bit which kind of bug this patch fixes?

[1] https://marc.info/?l=linux-block&m=150649136519281&w=2


-- 
Ming
