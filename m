From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Really need RESYNC at creation of array???
Date: Tue, 1 Jul 2003 14:46:30 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16129.4646.823424.64170@gargle.gargle.HOWL>
References: <3EFD4BBF.1020405@attbi.com>
	<16125.20826.76778.935888@gargle.gargle.HOWL>
	<003301c33f2e$5abfca70$6401a8c0@bmoon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from bmoon on Monday June 30
To: bmoon <bo@anthologysolutions.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday June 30, bo@anthologysolutions.com wrote:
> Hi Neil & Raiders,
> 
> 
> 
> I am not quite sure if we really need to resync the array at the time of 
> 
> RAID 1 or RAID 5 array creation. I tried and tested without RESYNC by
> 
> modifying "case1" and "case2" from MDADM source, I could not notice
> 
> any problems or issues.
> 
> 
> 
> So I want to know from you what is the reason for these codes, and 
> 
> what you experieced from without RESYNC.
> 
> 

Others have answered with very relevant arguments for an initial sync.

For raid1 it is not absolutely essential, but for the reasons others
have mentioned it can be a good idea.

For raid5 it is essential:  you do not have any guarantee of data
integrity after a drive fails without it.

Consider:
   You start with a raid5 array where all the parity blocks are wrong.
   You write to a block on disk A and update the parity using a 
   read-modify-write cycle.  i.e.
      pre-read A.  pre-read Parity.
      subtract old A from parity.  Add new A into parity
      write new A, write new parity.
    The parity block is still wrong with respect to all other data
    blocks in that strip.
   Now drive A fails.  You have lost the block that you wrote there.


I would not be against adding a flag to mdadm which caused it to
create a raid1 array without any initial resync.  I would be against
allowing it for raid5.

NeilBrown
