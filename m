From: maarten <maarten@ultratux.net>
Subject: Re: Spares and partitioning huge disks
Date: Thu, 6 Jan 2005 19:18:16 +0100
Message-ID: <200501061918.16088.maarten@ultratux.net>
References: <200501061731.j06HVi932064@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501061731.j06HVi932064@www.watkins-home.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 06 January 2005 18:31, Guy wrote:
> This idea of splitting larger disks into smaller partitions, then
> re-assembling them seems odd.  But it should help with the "bad block kicks
> out a disk" problem.

Yes.  And I'm absolutely sure I read it on linux-raid.  Couple of months back.

> However, if you are going to use LVM anyway, why not allow LVM to assemble
> the disks?  I do that sort of thing all the time with HP-UX.  I create
> stripped mirrors using 4 or more disks.  With HP-UX, use the -D option with
> lvcreate.  No idea if Linux and LVM can strip.

I think so.  But I am more familiar with md, so I'll still use that.  In any 
case LVM's striping is akin raid-0, whereas I will definitely use raid-5.

> You are making me think!  I hate that!  :)  Since your 6 RAID5 arrays are

;-)  Terrible, isn't it.

> on the same 4 disks, striping them will kill performance.  The poor heads
> will be going from 1 end to the other, all the time.  You should use LINEAR
> is you combine them with md.  If you use LVM, make sure it does not stripe
> them.  With LVM on HP-UX, the default behavior is to not stripe.

Exactly what I thought.  That they are on the same disks should not matter; 
only when one full md set (6-1)*40GB=200GB is full (or used, or whatever) 
will the "access" move on to the next set of drives.  It is indeed imperative 
to NOT have LVM striping (nor use raid-0, thanks for observing that!), as 
that would be totally counterproductive and may thus kill performance. 
(r/w head thrashing)

For all clarity, this is how it would look:

md0 : active raid5 sda1[0] sdb1[1] sdc1[2] sdd1[3]
      40000000 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
...
...
...
md5 : active raid5 sda6[0] sdb6[1] sdc6[2] sdd6[3]
      40000000 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

The lvm part is still new to me, but the goal is simply to add all PVs /dev/
md0 through /dev/md5 to one LV yielding... well, a very large volume. :-)

I was planning to do this quickly tonight, but I've overlooked one essential 
thing ;-|  The old server has already 220 GB of data built of 4 80GB disks in 
raid-5.  But I cannot connect all 8 disks at the same time, so I'll have to 
'free up' another system to define the arrays and copy the data over Gbit 
LAN.  I definitely don't want to lose the data!
What complicates this a bit is that I wanted to copy the OS verbatim (it is 
not part of that raid-5 set, just raid-1). But I suppose booting a rescue CD 
would enable me to somehow netcat the OS over to the new disks...
We'll see.

But for now I'm searching my home for a spare system with SATA onboard... :-)

Maarten

-- 


