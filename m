From: Richard Michael <rmichael-raid@edgeofthenet.org>
Subject: Re: Sharing disks amoung multiple software RAIDs
Date: Fri, 2 May 2008 09:26:10 -0400
Message-ID: <20080502132610.GB2140@nexus.edgeofthenet.org>
References: <20080502083656.28029.qmail@science.horizon.com> <432288.71787.qm@web50205.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <432288.71787.qm@web50205.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > Can you explain what you mean, exactly?
> As an example, you have disks /dev/sd[abc]. /dev/md0 would be made 
> from /dev/sda1, /dev/sdb1, and /dev/sdc1; /dev/md1 would be made  from /dev/sda2, /dev/sdb2, and /dev/sdc2.

I've been watching this thread with interest, because I wanted
clarification on what the OP meant.

If by "sharing disks", the OP meant the above, I'm surprised (and
concerned) there's any question at all.  How is this anything other than
the definition of "mirror"?  What would a mirror be, if not this;
perhaps the entire disk in one partition (which is still
partition-based, albeit one), or an entire raw disk?

I've been doing this for years (with hardware RAID, and with other
operating system software RAID implementations as well, e.g. on
Solaris).  (I even just split the mirror on my own system and ran off
half, then wiped the second disk for emergency scratch space for a few
hours, then put the second disk back in and resynced.  No problems.)

In fact, I currently have a system with a three-way mirror.  The third
disk is removed for offsite storage and returned to the pool on a
schedule for resync (to implement a crude offsite policy where other
means of data transfer are not effective, and the entire system can be
recovered with a slight data loss window).

I'm now wondering, what is OP's concern?  Just performance?

Regards,
Richard
