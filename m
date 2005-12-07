From: Neil Brown <neilb@suse.de>
Subject: Re: Raid1 "synchronous" mirror question
Date: Wed, 7 Dec 2005 11:01:47 +1100
Message-ID: <17302.9835.421430.402621@cse.unsw.edu.au>
References: <43955E0F.6090704@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Robert Heinzmann on Tuesday December 6
Sender: linux-raid-owner@vger.kernel.org
To: Robert Heinzmann <Robert.Heinzmann@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday December 6, Robert.Heinzmann@gmx.net wrote:
> Hello,
> 
> I'm currently trying to understand the "flow" of the I/O in Linux raid1 
> devices in regard to superblock updates and resynces on machine crashes. 
> I looked at the source (2.6 kernel) and made some guesses about the 
> working of  the raid1 kernel module. The problem is that I'm not an 
> kernel expert so I try to point out the basic algotithms and it would be 
> great if some expert could give ma a yes/no answer :)
> 
> 1) As soon as the first write is made, the superblock is updated and 
> mddev->in_sync is set to 0

Yes.

> 2) There is a machanism (can you tell me which part of the kernel does 
> this ?) that looks if all write requests have been written to both disks 
> and if no write requests are queued anymore, the superblock is updated 
> with the information mddev->in_sync=1

Before a write request starts, md_write_start is called.  If in_sync
was set, this clears it and writes the superblock.
It also keeps count of the number of outstanding writes in
->writes_pending.

When a write completes, md_write_end is called.  This decrements
->writes_pending.
If it reaches zero, then a timer is started (safemode_timer) to count
for safemode_delay (20msec).  When the timer expires, in_sync is set and the
superblock is written (by md_check_recovery).


> 
> 
> The question is, whats the maximal time that data can be "out of sync" 
> on both mirrors making the mirror an NON-synchronous mirror ?
> Is there a way to make the mirror a "real" synchronous mirror ?

What do you mean by a "real" synchronous mirror?  md/raid1 is as
synchronous as it makes sense to be.
It is not physically possible to write a block to both drives at
exactly the same time.
When a filesystem requests a write, md/raid1 will submit the write to
all drives, and will not tell the filesystem that the write is
complete until it is complete on all working drives.

If you crash, there is a chance that there will be different data on
the different drives, and there is absolutely nothing that can
possibly be done about that.  What can be done is fixing any
differences quickly.  For that purpose we have resync, and
bitmap-assisted resync, and other possibilities requiring support from
the filesystem (see recent post to linux-raid titled
   Journal-guided Resynchronization for Software RAID
)

NeilBrown
