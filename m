From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: RAID5 rebuild question
Date: Mon, 4 Jul 2005 11:20:46 +1000
Message-ID: <17096.36590.780673.451541@cse.unsw.edu.au>
References: <42C78399.5030501@nighthawkrad.net>
	<200507030642.j636g5p16857@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Guy on Sunday July 3
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Christopher Smith' <csmith@nighthawkrad.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday July 3, bugzilla@watkins-home.com wrote:
> It looks like it is rebuilding to a spare or new disk.

Yep.

> If this is a new array, I would think that create would be writing to all
> disks, but not sure.

Nope....

When creating a new raid5 array, we need to make sure the parity
blocks are all correct (obviously).  There are several ways to do
this.

1/ write zeros to all drives.  This would make the array unusable
   until the clearing is complete, so isn't a good option.
2/ Read all the data blocks, compute the parity block, and then write
   out the parity block.  This works, but is not optimal.  Remembering
   that the parity block is on a different drive for each 'stripe',
   think about what the read/write heads are doing.
   The heads on the 'reading' drives will be somewhere ahead of the
   heads on the 'writing' drive.  Every time we step to a new stripe
   and change which is the 'writing' head, the other reading heads
   have to wait for the head that has just changes from 'writing' to
   'reading' to catch up (finish writing, then start reading).
   Waiting slows things down, so this is uniformly sub-optimal.
3/ read all data blocks and parity blocks, check the parity block to
   see if it is correct, and only write out a new block if it wasn't.
   This works quite well if most of the parity blocks are correct as
   all heads are reading in parallel and are pretty-much synchronised.
   This is how the raid5 'resync' process in md works.  It happens
   after an unclean shutdown if the array was active at crash-time.
   However if most or even many of the parity blocks are wrong, this
   process will be quite slow as the parity-block drive will have to
   read-a-bunch, step-back, write-a-bunch.  So it isn't good for
   initially setting the parity.
4/ Assume that the parity blocks are all correct, but that one drive
   is missing (i.e. the array is degraded).  This is repaired by
   reconstructing what should have been on the missing drive, onto a
   spare.  This involves reading all the 'good' drives in parallel,
   calculating them missing block (whether data or parity) and writing
   it to the 'spare' drive.  The 'spare' will be written to a few (10s
   or 100s of) blocks behind the blocks being read off the 'good'
   drives, but each drive will run completely sequentially and so at
   top speed.

On a new array where most of the parity blocks are probably bad, '4'
is clearly the best option. 'mdadm' makes sure this happens by creating
a raid5 array not with N good drives, but with N-1 good drives and one
spare.  Reconstruction then happens and you should see exactly what
was reported: reads from all but the last drive, writes to that last
drives.

This should go in a FAQ.  Is anyone actively maintaining an md/mdadm
FAQ at the moment, or should I start putting something together??

NeilBrown

