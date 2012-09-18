From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Serious performance issues with mdadm RAID-5 partition exported through LIO (iSCSI)
Date: Tue, 18 Sep 2012 22:18:32 +0100
Message-ID: <20568.58664.669085.313654@tree.ty.sabi.co.UK>
References: <50588731.5050502@bananateam.nl>
	<1347997760.25356.16.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1347997760.25356.16.camel@haakon2.linux-iscsi.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>, target-devel@vger.kernel.org
List-Id: linux-raid.ids

>> [ ... ] Before the buffers are full we're near wirespeed
>> (gigabit). We're running blockio in buffered mode with LIO. [
>> ... ] Whilst writing, copying a DVD from the Windows 2008 R2
>> initiator to the target - no other I/O was active, I noticed
>> in iostat something I personally find very weird. All the
>> disks in the RAID set (minus the spare) seem to read 6-7
>> times as much as they write. [ ... ] iostat doesn't show the
>> reads in iostat on the md device (which is the case if the
>> initiator issues reads) but only on the active disks in the
>> RAID set, [ ... ]

This seems to indicate as I mentioned in a previous comment that
there are RAID setup issues...

>> I've switched back to IETD now. With IETD I can copy with
>> 55MiB/s to the device *whilst* reading from the same device
>> (copy an ISO onto it, then copy the ISO from the disk back to
>> the disk, then copy all copies couple of times - so both
>> read/write).

For a RAID set of 6+1 2TB drives each capable of 60-120MB/s that
is still pretty terrible speed (even if the performance seems
not too bad).

>> Iostat with IETD whilst writing shows say 110-120% read per
>> write, however, in this case we were also actually reading.

>> [ ... ] IETD is running in fileio mode (write-back), so it
>> buffers too. [ ... ]

That probably helps the MD get a bit of help with aligned
writes, or perhaps at that point the array had been resynced,
who knows...

> Are you enabling emulate_write_cache=1 with your iblock
> backends..? This can have a gigantic effect on initiator
> performance for both MSFT + Linux SCSI clients.

That sounds interesting, but also potentially rather dangerous,
unless there is a very reliable implementation of IO barriers.
Just like with enabling write caches on real disks...

> [ ... ] check your [ ... ]/queue/max*sectors_kb for the MD
> RAID to make sure the WRITEs are striped aligned to get best
> performance with software MD raid.

That does not quite ensure that the writes are stripe aligned,
but perhaps a larger stripe cache would help.

> Please use FILEIO with this reporting emulate_write_cache=1
> (WCE=1) to the SCSI clients. Note that by default in the last
> kernel releases we've change FILEIO backends to only always
> use O_SYNC to ensure data consistency during a hard power
> failure, regardless of the emulate_write_cache=1 setting.

Ahh interesting too. That's also the right choice unless there
is IO barrier support at all levels.

> Also note that by default it's my understanding that IETD uses
> buffered FILEIO for performance, so in your particular type of
> setup you'd still see better performance with buffered FILEIO,
> but would still have the potential risk of silent data
> corruption with buffered FILEIO.

Not silent data corruption, but data loss. Silent data
corruption is usually meant for the case where an IO completes
and reports success, but the data recorded is not the data
submitted.

> [ ... ] understand the possible data integrity risks
> associated with using buffered FILEIO during a hard power
> failure, I'm fine with re-adding this back into
> target_core_file for v3.7 code for people who really know what
> they are doing.

That "people who really know what they are doing" is generally a
bit optimistic :-).

Do the various modes support IO barriers? That usually is what
is critical, at least for the better informed people.
