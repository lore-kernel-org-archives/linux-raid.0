From: John Lange <john.lange@bighostbox.com>
Subject: RE: raid and sleeping bad sectors
Date: Tue, 29 Jun 2004 11:30:08 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1088526607.13815.89.camel@localhost>
References: <200406291559.i5TFx6324611@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200406291559.i5TFx6324611@watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, my two cents; Why would a disk ever be automatically removed from an
array?

If a disk has errors the array should write a log message and then write
around the bad sectors. If you start to see a lot of error messages in
your logs then the sysadmin should make the judgment to replace the
drive.

Even if the drive completely fails it should not be automatically
removed from the array. md should continue to attempt to use it and keep
logging errors (perhaps a useful statistic for md to track is a running
percentage of disk accesses that resulted in an error?)

If a sysadmin (or more likely a monitoring script) sees an excessive
number of errors then it can take appropriate action. For example, if
there is a spare, then remove the bad drive and active the spare. If
there isn't a spare then keep the drive in the array but send out alerts
for a sysadmin to intervene.

I don't think automatically removing a drive does anything to protect
data, in fact it jeopardizes it since if two disks have errors its game
over. In essence it creates a very "fragile" array.

I certainly am not an expert but that is my view as a sysadmin.

Regards,

John Lange

On Tue, 2004-06-29 at 10:59, Guy wrote:
> You are correct.  1 bad sector on a read, the disk is kicked out!
> I agree with you, it (md) should not do that!  Your #3 is something I have
> mentioned here a few times.  I don't recall getting any comments!
> I get 1 read error about every 3 months or so.  I have 14 disks in a RAID5
> array.  Every time I have been able to re-use the same disk.  But it is a
> pain in the @$$!  And I worry about a second bad sector!!!
> 
> I do a read test of all of my disks each night!  Hoping to catch an error
> before md does.  Since a bad sector could go un-noticed for months!  As far
> as I know, md does not test the disks any!  As far as I know, md does not
> verify parity.  As far as I know, md does not verify RAID1 data matches on
> all disks.
> 
> You are also correct.  2 bad sectors on 2 different disks and "That's it
> man! Game over man! Game over!".  You may want to consider RAID6.  It will
> allow 2 bad sectors, but not 3!!  I have considered this myself.  I have 14
> disks with a spare.  I should just go with a 15 disk RAID6.
> 
> I disagree with your conclusion:  It is normal for a disk to grow bad
> sectors.  1 or 2 bad sectors is not an issue.  Maybe 10 or 100 is an issue.
> I don't know what the limit should be.  I have maybe 5-10 bad sectors on my
> 14 disks.  In about 2 years I have not had a hard failure.  I just correct
> the bad sector by hand and re-use the disk.  Maybe I should track which
> disks have had bad sectors to determine if there is a pattern, but I don't.
> I think md should to this.  I have said so here in the past.
> 
> Hardware RAID systems support bad sectors.  Not sure they all do, but some
> or most do.  EMC counts them and when some limit is reached the disk is
> copied to a spare.  The "bad" disk is kept on-line.  After all, it is still
> working.  I automatic service call is placed to have the "bad" disk
> replaced.  I have been told HP's XP-256 does not have a bad sector limit.
> They just wait until a disk fails!  Because of this EMC replaces disks more
> often.  Some see this a EMC has more failures.  I don't see it this way.
> They protect my data better.  Getting off topic I think!....
> 
> Guy
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Dieter Stueken
> Sent: Tuesday, June 29, 2004 6:48 AM
> To: linux-raid@vger.kernel.org
> Subject: raid and sleeping bad sectors
> 
> Question:
> 
> Under which conditions a disk of a raid-5 system gets off line?
> Does it happen on ANY error, even if some read error happened?
> Will double-fault read errors on different disks destroy my
> data?
> 
> long story:
> 
> I manage about 1TB of data on IDE disk and learned
> a lot about different kinds of disk failures.
> Fortunately I suffered no data loss so far, as I completely
> mirror all data each night (kind of manual raid-1 :-)
> I think about using raid-5 now.
> 
> My observation was: a sudden total loss of a whole disk
> was very unlikely. If you monitor the disk carefully using
> its internal SMART capabilities, you are able to copy the
> data and replace the disk long time before it finally dies.
> 
> see: http://smartmontools.sourceforge.net/
> 
> What happens frequently are spontaneous bad sectors, which
> can not be read any more (i.e. CRC errors). Most people
> think bad sectors are handled automatically by the firmware
> of your HD. Unfortunately this is not the whole truth.
> Instead of, a bad sector is indicated as bad, until it gets
> explicitly rewritten by some new data. At this point, the
> HD-firmware may decide to store the new data using a spare
> sector instead. The bad news are: sectors turn to become
> bad/unreadable quite spontaneously, even if they could be
> read successfully short time before!
> 
> You may ask, why this is a problem for a raid-5 system?
> It is especially designed to handle such problems!
> What makes me worry is, that those errors occur spontaneously
> and without any notice possibly on several disks simultaneously.
> You may detect such a problems only by a complete scan of
> all sectors of your disk. The critical question is: what
> happens, if the first bad sector on some disk get read.
> Does this event kick off that disk from the system?
> You may think its a good idea, to kick off the disk as
> soon as possible. I think, this may be bad, as it dramatically
> decreases the reliability of your remaining system, especially
> if you have some other sleeping bad sector on any other disk, too.
> At least when you try to rebuild your system, you run into
> trouble.
> 
> There are several possible solutions. (May be raid systems already
> works this way, but I have no experience so far, and I could not
> find too much about this in the FAQ or mailing-list)
> 
> 1) I think a disk should be kept online as long as possible.
> This means, that a simple read error should not deactivate the disk
> as long the disk can be successfully written to and thus is still in
> sync. As long, as "simple" read errors (even on different disks) occur,
> my data is still reliable, as it is very unlikely, that two disk fail
> with the SAME logical sector number. But it IS likely, that two disk
> carry some sleeping bad sectors simultaneously.
> 
> 2) If I decide to replace a disk, it should be possible to add a new
> disk to the system before degrading it. After I successfully build the
> new disk, I may switch off the bad one. This way I'm save against multi
> disk read errors all time.
> 
> example: array of the disks (A B C), want to replace B:
> 
>      123456789   <- sector number
> A   aaaaaaaXa   <- data on disk a, X = unreadable
> B   bbXbbbbbb   <- disk b, will be replaced
> C   ccccXcccc
> 
> B'  bbbbbbbbb   <- new spare disk for b build from current (A,B,C)
> 
> 3) If a disks happened to produce a bad sector, you may try to rewrite it
> again, if you still have the data. Using Raid 2 or 5 this is possible, as
> long as you don't have a double fault on exactly the same sector on any
> other disks. For a raid-1/5 system this means it might cure itself!
> I did such surgery manually already, and it works quite good.
> 
> Conclusion:
> 
> After a disk shows up with bad sectors, you should indeed think of replacing
> it as soon as possible, but it should not affect data integrity that much.
> Instead it should be kept alive as long as possible until any necessary
> recovery
> took place.
> 
> Dieter.

