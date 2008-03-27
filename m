From: Neil Brown <neilb@suse.de>
Subject: Re: Why are MD block IO requests subject to 'plugging'?
Date: Thu, 27 Mar 2008 15:07:39 +1100
Message-ID: <18411.7563.492191.944057@notabene.brown>
References: <18382.54925.354731.996508@tree.ty.sabi.co.UK>
	<18408.60019.523141.419772@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter Grandi on Tuesday March 25
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday March 25, pg_lxra@lxra.for.sabi.co.UK wrote:
> Another interesting detail is that while real disk devices have
> queueing parameter and MD device don't:
> 
>   # ls /sys/block/{md0,hda}/queue
>   ls: cannot access /sys/block/md0/queue: No such file or directory
>   /sys/block/hda/queue:
>   iosched  max_hw_sectors_kb  max_sectors_kb  nr_requests  read_ahead_kb  scheduler

No.  An md device doesn't have a queue, at least not in the same way
that IDE/SCSI drivers do.  Most of those values are completely
meaningless for an md device.

> 
> As one can set 'blockdev --setra' on an MD device (which should be
> the same as setting 'queue/read_head_kb' to half the value), and
> that does have an effect, but then the readhead on all the block
> devices in the MD array are ignored.

I'm not sure what you mean by that last line...

readahead is performed by the filesystem.  Each device has a
read-ahead number which serves as advice to the filesystem to suggest
how much readahead might be appropriate.
Components of an md device do not have a filesystem on them, so
readahead setting for those devices is not relevant.

When md sets the readahead for the md array, it does take some notice
of the read-ahead setting for the component devices.

> 
> Conversely, quite properly elevators (another request stream
> restructuring) apply to physical devices, not to partitions or MD
> devices, and one can have different elevators on different devices
> (even if having them different for MD slave devices in most cases
> is very dubious).
> 

This is exactly correct and exactly what Linux does.
There is no elevator above MD.  There is a distinct elevator above
each IDE/SCSI/etc device that is (or appear to Linux to be) a plain
device.

> 
> So I had a look at how the MD subsystem handles unplugging,
> because of a terrible suspicion that it does two-level
> unplugging, and wonder what:
> 
> http://www.gelato.unsw.edu.au/lxr/source/drivers/md/raid10.c#L599
> 
>   static void raid10_unplug(struct request_queue *q)
>   {
> 	  mddev_t *mddev = q->queuedata;
> 
> 	  unplug_slaves(q->queuedata);
> 	  md_wakeup_thread(mddev->thread);
>   }
> 
> Can some MD developer justify the lines above?

You need to look more deeply.

No md personality ever plugs read requests.
Sometimes write requests are plugged, in order to delay the requests
slightly.
There are two main reasons for this:

1/ When using a write-intent-bitmap we plug write request so as to
  gather lots of them together, to reduce the number of updates to the
  bitmap.

2/ For raid5/raid6 we plug writes in the hope of gathering a full
  stripe of writes so we can avoid pre-reading.  As soon as a stripe can
  be processed without any pre-reading, it is bypasses the plug.

> 
> Can some MD developer also explain why should MD engage in double
> level request queueing/unplugging at both the MD and slave level?

different reasons for small delays.

> 
> Can some MD developer then give some very good reason why the MD
> layer should be subject to plugging *at all*?

The MD layer doesn't do plugging.  Some MD personalities do, for
reasons I have explained above.

NeilBrown
