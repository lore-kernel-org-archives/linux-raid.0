From: Neil Brown <neilb@suse.de>
Subject: Re: raid1 error handling and faulty drives
Date: Thu, 6 Sep 2007 06:23:42 +0100
Message-ID: <18143.36574.398690.36732@notabene.brown>
References: <915.1189030947@mdt.ecitele.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Accetta on Wednesday September 5
Sender: linux-raid-owner@vger.kernel.org
To: Mike Accetta <maccetta@laurelnetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday September 5, maccetta@laurelnetworks.com wrote:
> 
> I've been looking at ways to minimize the impact of a faulty drive in
> a raid1 array.  Our major problem is that a faulty drive can absorb
> lots of wall clock time in error recovery within the device driver
> (SATA libata error handler in this case), during which any further raid
> activity is blocked and the system effectively hangs.  This tends to
> negate the high availability advantage of placing the file system on a
> RAID array in the first place.
> 
> We've had one particularly bad drive, for example, which could sync
> without indicating any write errors but as soon as it became active in
> the array would start yielding read errors.  It this particular case it
> would take 30 minutes or more for the process to progress to a point
> where some fatal error would occur to kick the drive out of the array
> and return the system to normal opreation.
> 
> For SATA, this effect can be partially mitigated by reducing the default
> 30 second timeout at the SCSI layer (/sys/block/sda/device/timeout).
> However, the system stills spends 45 seconds or so per retry in the
> driver issuing various reset operations in an attempt to recover from
> the error before returning control to the SCSI layer.
> 
> I've been experimenting with a patch which makes two basic changes.
> 
> 1) It issues the first read request against a mirror with more than 1 drive
>    active using the BIO_RW_FAILFAST flag to short-circuit the SCSI layer from 
>    re-trying the failed operation in the low level device driver the default 5
>    times.

I've recently become aware that we really need FAILFAST - possibly for
all IO from RAID1/5.  Modern drives don't need any retry at the OS
level - if the retry in the firmware cannot get the data, nothing will.

> 
> 2) It adds a threshold on the level of recent error acivity which is
>    acceptable in a given interval, all configured through /sys.  If a
>    mirror has generated more errors in this interval than the threshold,
>    it is kicked out of the array.

This is probably a good idea.  It bothers me a little to require 2
separate numbers in sysfs...

When we get a read error, we quiesce the device, the try to sort out
the read errors, so we effectively handle them in batches.  Maybe we
should just set a number of seconds, and if there are a 3 or more
batches in that number of seconds, we kick the drive... just a thought.

> 
> One would think that #2 should not be necessary as the raid1 retry
> logic already attempts to rewrite and then reread bad sectors and fails
> the drive if it cannot do both.  However, what we observe is that the
> re-write step succeeds as does the re-read but the drive is really no
> more healthy.  Maybe the re-read is not actually going out to the media
> in this case due to some caching effect?

I have occasionally wondered if a cache would defeat this test.  I
wonder if we can push a "FORCE MEDIA ACCESS" flag down with that
read.  I'll ask.

> 
> This patch (against 2.6.20) still contains some debugging printk's but
> should be otherwise functional.  I'd be interested in any feedback on
> this specific approach and would also be happy if this served to foster
> an error recovery discussion which came up with some even better approach.

Thanks.  I agree that we do need something along these lines.  It
might be a while before I can give the patch the brainspace it
deserves as I am travelling this fortnight.

NeilBrown
