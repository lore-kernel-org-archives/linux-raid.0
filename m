From: Nathan Lewis <nathapl@cs.okstate.edu>
Subject: Digging into raid5.c and raid6main.c...
Date: Tue, 17 Feb 2004 23:34:31 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6.0.1.1.2.20040217232659.0211de48@mail.athenet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've decided to base my rs-raid work on 2.6, and thus raid5.c and 
raid6main.c.  I'm pretty sure I can utilize all the stripe buffer code 
pretty much verbatim, and most of the rework will need to be done to 
handle_stripe().  I've dug through most of it, updating things to 
correspond to m parity disks instead of 1 or 2.  However, I've encountered 
something strange.  From what I can tell, after a call to compute_block_1 
or compute_block_2, I assumed that all the data in the stripe (including 
parity) was valid.  However, around line 1270 in raid6main.c, 
compute_block_1 or 2 may be called, then immediately after the PRINTK, it 
calls compute_parity too.  Isn't this redundant somehow?  The logic that 
sets must_compute is also really complicated - can anyone explain this 
section to me?

