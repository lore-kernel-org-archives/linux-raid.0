From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid5 Construction Question
Date: Fri, 20 Aug 2004 11:21:20 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16677.21008.119662.799869@cse.unsw.edu.au>
References: <200408191730.i7JHUd313659@watkins-home.com>
	<4124E8F5.1010105@psc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from PAulN on Thursday August 19
To: PAulN <pauln@psc.edu>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday August 19, pauln@psc.edu wrote:
> 
> md0 : active raid5 sdh1[7] sdf1[6] sdg1[5] sde1[4] sdd1[3] sdc1[2] 
> sdb1[1] sda1[0]
>       481949184 blocks level 5, 64k chunk, algorithm 2 [7/7] [UUUUUUU]
>       [>....................]  resync =  2.4% (1936280/80324864) 
> finish=4261.4min speed=305K/sec
> 
> In the docs I saw that "reconstruction" is possible with raidhotadd but 
> I didn't
> see anything about initialization.   So am I "screwed" until the resync 
> is fixed?  I was depeding
> on the disks to do some filesystem testing but maybe I'll have to wait a 
> few days.. 

When resyncing an array, raid5 will read all the blocks in each
stripe, check the parity, and if it is wrong, write out the new
parity.
For a mostly-correct array this just involves lots of sequential
reads.  For a mostly incorrect array, this involves lots of
read-seek-writes which is substantially slower.

When reconstructing onto a spare, raid5 will read all the good drives
and write to the spare.  This all IO is sequential, there are no
seeks, and it is nice and fast.

It is for this reason that 'mdadm' will normally create a raid5 array
with one missing drive and one spare, which is then immediately
reconstructed. 

mkraid, on the other hand, doesn't know about this, and just creates
the array and the sync happens which, as you note, can be quite slow.

So, you can either re-make the array with mdadm or, you can fail one
drive, remove it and re-add it.

   raidsetfaulty /dev/md0 /dev/sdh1
   raidhotremove /dev/md0 /dev/sdh1
   raidhotadd /dev/md0 /dev/sdh1

In either case it should stop the resync and start reconstruction
which will be much faster.

NeilBrown
