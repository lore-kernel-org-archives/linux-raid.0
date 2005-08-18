From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] proactive raid5 disk replacement for 2.6.11, updated
Date: Thu, 18 Aug 2005 15:28:41 +1000
Message-ID: <17156.7305.638579.812295@cse.unsw.edu.au>
References: <1124322731.3810.77.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Pallai Roland on Thursday August 18
Sender: linux-raid-owner@vger.kernel.org
To: Pallai Roland <dap@mail.index.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thanks for this.  There are definitely some good ideas here.
However I think I would like to do it a little bit differently.

If we want to mirror a single drive in a raid5 array, I would really
like to do that using the raid1 personality.
e.g.
   suspend io
   remove the drive
   build a raid1 (with no superblock) using the drive.
   add that back into the array
   resume io.

Then another drive can be added to the raid1 and synced.

This allows shuffling of drives even when they haven't actually
failed.

To handle read failures, I would like the first step to be to re-write
the failed block.  I believe most (all?) drives will relocate the
block if a write cannot succeed at the normal location, so this will
often fix the problem.  

A userspace process can then notice an unacceptable failure rate and
start a miror/swap process as above.

This possible doesn't handle the possibility of a write failing very
well, but I'm not sure what your approach does in that case.  Could
you explain that?

It also means that if the raid1 rebuild hits a read-error it cannot
cope whereas your code would just reconstruct the block from the rest
of the raid5.

I'll think through this some more and try to work out how I really
want it to work.

Thanks again for the ideas and code,

NeilBrown

