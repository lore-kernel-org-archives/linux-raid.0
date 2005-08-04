From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid5 endian question....
Date: Thu, 4 Aug 2005 15:09:05 +1000
Message-ID: <17137.41713.860387.102586@cse.unsw.edu.au>
References: <61C14314-53E9-4140-A4DB-3929A683FE67@blight.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Aaron Botsis on Sunday June 19
Sender: linux-raid-owner@vger.kernel.org
To: Aaron Botsis <aaron@blight.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday June 19, aaron@blight.com wrote:
> Hello,
> 
> I'm attempting to move a raid5 array from a big endian ppc machine to  
> a little endian x86.
> Upon trying to import the array, I get:
> mdadm: No super block found on /dev/hde1 (Expected magic a92b4efc,  
> got fc4e2ba9)
> 
> I assume this to be an endianess issue...
> Is this a bug? Is just the magic number whacked? or are the  
> superblock data structures too?
> 
> what's the best way to fix this?

As has been said, the original raid superblock (still the default)
uses host-endian data and so cannot be moved between machines.
The new version uses little-endian, but isn't in wide use yet.

It would not be too hard to get mdadm to re-write the superblocks when
assembling an array on a different machine.  However I am not in a
position to test it very well.

If you would be willing to help test some changes over the next
several days, I'd be happy to add this functionality to mdadm.
The risk of data-loss for you would be very remote.  However there
would be some risk of extended down-time while you wait for me to fix
some silly bug.

The change would involve:
  1/ Teaching "mdadm --examine" to recognise a wrong-endian superblock
     and display it with suitable swaps.
  2/ Teaching "mdadm --assemble" to accept "--update=endian" which
     would byte-swap all the superblocks and write them out again.

NeilBrown

 
