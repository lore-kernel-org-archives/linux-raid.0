From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: raid and sleeping bad sectors
Date: Wed, 30 Jun 2004 06:12:52 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0406300608320.31747@praktifix.dwd.de>
References: <40E148EF.509@conterra.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40E148EF.509@conterra.de>
To: Dieter Stueken <stueken@conterra.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

But what if the block device is not a disk? Remember md can consist of
any block device even mixture of them.

Holger
-- 

On Tue, 29 Jun 2004, Dieter Stueken wrote:

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
>     123456789   <- sector number
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
> 
> 
