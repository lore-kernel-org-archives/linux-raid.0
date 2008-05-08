From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: WARNING in 2.6.25-07422-gb66e1f1
Date: Thu, 8 May 2008 20:39:00 +0200
Message-ID: <200805082039.01316.rjw@sisk.pl>
References: <200805031151.44287.prakash@punnoor.de> <18462.46639.578272.994939@notabene.brown> <20080505190159.GA329@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080505190159.GA329@kernel.dk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Neil Brown <neilb@suse.de>, Jacek Luczak <difrost.kernel@gmail.com>, Prakash Punnoor <prakash@punnoor.de>, Linux Kernel list <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday, 5 of May 2008, Jens Axboe wrote:
> On Mon, May 05 2008, Neil Brown wrote:
> > On Sunday May 4, jens.axboe@oracle.com wrote:
> > > On Sun, May 04 2008, Jacek Luczak wrote:
> > > > Hi,
> > > > 
> > > > I've CC:-ed few guys which may help.
> > > > 
> > > > Prakash Punnoor pisze:
> > > > > Hi, I got this on boot:
> > > > >
> > > > > usb 2-1.3: new full speed USB device using ehci_hcd and address 3
> > > > > usb 2-1.3: configuration #1 chosen from 1 choice
> > > > > Clocksource tsc unstable (delta = -117343945 ns)
> > > > > ------------[ cut here ]------------
> > > > > WARNING: at include/linux/blkdev.h:443 blk_remove_plug+0x7d/0x90()
> > ...
> > > 
> > > Looks like it caught a real bug there - unfortunately we have to check
> > > for ->queue_lock here as well, if this is another stacked devices and
> > > not the bottom device. Does this make the warning go away for you?
> > > 
> > > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > > index 087eee0..958f26b 100644
> > > --- a/drivers/md/raid5.c
> > > +++ b/drivers/md/raid5.c
> > > @@ -3264,6 +3264,8 @@ static void raid5_unplug_device(struct request_queue *q)
> > >  	unsigned long flags;
> > >  
> > >  	spin_lock_irqsave(&conf->device_lock, flags);
> > > +	if (q->queue_lock)
> > > +		spin_lock(q->queue_lock);
> > >  
> > >  	if (blk_remove_plug(q)) {
> > >  		conf->seq_flush++;
> > > @@ -3271,6 +3273,8 @@ static void raid5_unplug_device(struct request_queue *q)
> > >  	}
> > >  	md_wakeup_thread(mddev->thread);
> > >  
> > > +	if (q->queue_lock)
> > > +		spin_unlock(q->queue_lock);
> > >  	spin_unlock_irqrestore(&conf->device_lock, flags);
> > >  
> > >  	unplug_slaves(mddev);
> > > 
> > 
> > I suspect that will just cause more problems, as the 'q' for an md
> > device never gets ->queue_lock initialised.
> > I suspect the correct thing to do is set
> > 	q->queue_lock = &conf->device_lock;
> > 
> > at some stage, probably immediately after device_lock is initialised
> > in 'run'.
> > 
> > I was discussing this with Dan Williams starting
> >   http://marc.info/?l=linux-raid&m=120951839903995&w=4
> > though we don't have an agreed patch yet.
> 
> I agree with the usage of the device lock. I (mistakenly) thought that
> raid5 used the bottom device queue for that unplug - I see that it does
> not, so where does the warning come from? mddev->queue->queue_lock
> should be NULL, since md never sets it and it's zeroed to begin with??
> 
> > I'm wondering why you mention the issues of stacked devices though.  I
> > don't see how it applies.  Could you explain?
> 
> See above, if the queue had been the bottom queue, ->queue_lock may or
> may not be NULL depending on whether this is the real device or
> (another) stacked device.

I get a similar warning with RAID1 on one of my test boxes:

WARNING: at /home/rafael/src/linux-2.6/include/linux/blkdev.h:443 blk_remove_plug+0x85/0xa0()
Modules linked in: raid456 async_xor async_memcpy async_tx xor raid0 ehci_hcd ohci_hcd sd_mod edd raid1 ext3 jbd fan sata_uli pata_ali thermal processor
Pid: 2159, comm: md1_raid1 Not tainted 2.6.26-rc1 #158

Call Trace:
 [<ffffffff80238bbf>] warn_on_slowpath+0x5f/0x80
 [<ffffffff8025e8d8>] ? __lock_acquire+0x748/0x10d0
 [<ffffffff80348f55>] blk_remove_plug+0x85/0xa0
 [<ffffffffa004df64>] :raid1:flush_pending_writes+0x44/0xb0
 [<ffffffffa004e649>] :raid1:raid1d+0x59/0xfe0
 [<ffffffff8025e8d8>] ? __lock_acquire+0x748/0x10d0
 [<ffffffff8025dc4f>] ? trace_hardirqs_on+0xbf/0x150
 [<ffffffff8043ea8c>] md_thread+0x3c/0x110
 [<ffffffff8024f6a0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8043ea50>] ? md_thread+0x0/0x110
 [<ffffffff8024f23d>] kthread+0x4d/0x80
 [<ffffffff8020c548>] child_rip+0xa/0x12
 [<ffffffff8020bc5f>] ? restore_args+0x0/0x30
 [<ffffffff8024f1f0>] ? kthread+0x0/0x80
 [<ffffffff8020c53e>] ? child_rip+0x0/0x12

---[ end trace 05d4e0844c61f45d ]---

This is the WARN_ON_ONCE(!queue_is_locked(q)) in queue_flag_clear(),
apparently.

Thanks,
Rafael
