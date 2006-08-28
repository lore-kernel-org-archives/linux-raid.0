From: Neil Brown <neilb@suse.de>
Subject: Re: RAID6 fallen apart
Date: Mon, 28 Aug 2006 12:03:58 +1000
Message-ID: <17650.20238.346014.292009@cse.unsw.edu.au>
References: <87y7tcxu71.fsf@szonett.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Wagner Ferenc on Saturday August 26
Sender: linux-raid-owner@vger.kernel.org
To: Wagner Ferenc <wferi@niif.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday August 26, wferi@niif.hu wrote:
> Hi,
> 
> after an intermittent network failure, our RAID6 array of AoE devices
> can't run anymore.  Looks like the system dropped each of the disks one
> after the other, and at the third the array failed as expected.
> Trying to assemble the array results in all disks going into spare
> status, nothing useful.  The disks really must have been cut
> simultaneously, but their superblocks were probably altered since then
> by the recovery attempts.
> 
> Can anybody suggest a possible way out?  I'm thinking like restoring
> all the superblocks into a clean state, starting the array, checking
> the filesystem and doing a full copy of it, but don't know how to
> restore the superblocks.  Or am I mistaken?


You say some of the drives are 'spare'.  How did that happen?  Did you
try to add them back to the array after it has failed?  That is a
mistake.
The thing to do at that point is 
  - stop the array
  - make sure the network is back and the individual drives are
    working
  - use mdadm to assemble with --force.  This should 'just work'. 

But if you used --add, then you will have destroyed info in the
superblock.  That isn't the end of the world, but makes it a little
harder.

The easiest thing to do is simply recreate the array, making sure to
have the drives in the correct order, and any options (like chunk
size) the same.  This will not hurt the data (if done correctly).

NeilBrown
