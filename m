From: "Nicholas A. Bellinger" <nab@risingtidesystems.com>
Subject: Re: Serious performance issues with mdadm RAID-5 partition
 exported through LIO (iSCSI)
Date: Tue, 18 Sep 2012 15:20:18 -0700
Message-ID: <1348006818.25356.62.camel@haakon2.linux-iscsi.org>
References: <50588731.5050502@bananateam.nl>
	 <1347997760.25356.16.camel@haakon2.linux-iscsi.org>
	 <20568.58664.669085.313654@tree.ty.sabi.co.UK>
Reply-To: nab@risingtidesystems.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20568.58664.669085.313654@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>, target-devel@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2012-09-18 at 22:18 +0100, Peter Grandi wrote:
> >> [ ... ] Before the buffers are full we're near wirespeed
> >> (gigabit). We're running blockio in buffered mode with LIO. [
> >> ... ] Whilst writing, copying a DVD from the Windows 2008 R2
> >> initiator to the target - no other I/O was active, I noticed
> >> in iostat something I personally find very weird. All the
> >> disks in the RAID set (minus the spare) seem to read 6-7
> >> times as much as they write. [ ... ] iostat doesn't show the
> >> reads in iostat on the md device (which is the case if the
> >> initiator issues reads) but only on the active disks in the
> >> RAID set, [ ... ]
> 
> This seems to indicate as I mentioned in a previous comment that
> there are RAID setup issues...
> 

<SNIP>

> > Are you enabling emulate_write_cache=1 with your iblock
> > backends..? This can have a gigantic effect on initiator
> > performance for both MSFT + Linux SCSI clients.
> 
> That sounds interesting, but also potentially rather dangerous,
> unless there is a very reliable implementation of IO barriers.
> Just like with enabling write caches on real disks...
> 

Not exactly.  The name of the 'emulate_write_cache' device attribute is
a bit mis-leading here.  This bit simply reports (to the SCSI client)
that the WCE=1 bit is set during SCSI mode sense (caching page) is read
during the initial LUN scan.

For IBLOCK backends using submit_bio(), the I/O operations are already
bypassing buffer cache all together + are fully asynchronous.  So for
IBLOCK we just want to tell the SCSI client to be more aggressive with
it's I/O submission, (SCSI clients have historically been extremely
sensitive when WCE=0 is reported), but this attribute is actually
separate from what's may be running for WCE=1 on the drives making up
the MD RAID block device that's being exported as a SCSI target LUN.

For FILEIO this can be different.  We originally had an extra parameter
passed into rtslib -> /sys/kernel/config/target/core/$HBA/$DEV/control
to optionally disabled O_*SYNC -> enable buffered FILEIO operation.  In
buffered FILEIO operation we expect the initiator to be smart enough to
use FUA (forced unit access) WRITES + SYNCHRONIZE_CACHE to force write
out of write FILEIO blocks still in buffer cache.

> > [ ... ] check your [ ... ]/queue/max*sectors_kb for the MD
> > RAID to make sure the WRITEs are striped aligned to get best
> > performance with software MD raid.
> 
> That does not quite ensure that the writes are stripe aligned,
> but perhaps a larger stripe cache would help.
> 

I'm talking about what MD raid has chosen as it's underlying
max_sectors_kb to issue I/O to the underlying raid member devices.  This
depends on what backend storage hardware is in use, this may end up as
'127', which will result in ugly mis-aligned writes that ends up killing
performance.

We've (RTS) changed this with a one-liner patch to raid456.c code on .32
basded distro kernels in the past to get proper stripe aligned writes,
and it obviously makes a huge difference with fast storage hardware.

> > Please use FILEIO with this reporting emulate_write_cache=1
> > (WCE=1) to the SCSI clients. Note that by default in the last
> > kernel releases we've change FILEIO backends to only always
> > use O_SYNC to ensure data consistency during a hard power
> > failure, regardless of the emulate_write_cache=1 setting.
> 
> Ahh interesting too. That's also the right choice unless there
> is IO barrier support at all levels.
> 
> > Also note that by default it's my understanding that IETD uses
> > buffered FILEIO for performance, so in your particular type of
> > setup you'd still see better performance with buffered FILEIO,
> > but would still have the potential risk of silent data
> > corruption with buffered FILEIO.
> 
> Not silent data corruption, but data loss. Silent data
> corruption is usually meant for the case where an IO completes
> and reports success, but the data recorded is not the data
> submitted.
> 

That's exactly what I'm talking about.

With buffered FILEIO enabled a incoming WRITE payload will have already
been ACKs back to the SCSI fabric and up the storage -> filesystem
stack, but if a power loss was to occur before that data has been
written out (using a battery back-up unit for example), then the FS on
the client will have (silently) lost data.

This is why we removed the buffered FILEIO from mainline in the first
place, but in retrospect if people understand the consequences and still
want to use buffered FILEIO for performance reasons they should be able
to do so.

--nab

