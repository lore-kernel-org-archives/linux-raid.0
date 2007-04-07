From: Gavin McCullagh <gmccullagh@gmail.com>
Subject: Re: LINEAR RAID, little help
Date: Sat, 7 Apr 2007 21:34:35 +0100
Message-ID: <20070407203435.GA32499@gmail.com>
References: <46177DD8.9080707@pcfusion.co.uk> <20070407173352.GA23645@gmail.com> <4617E5E2.2090609@pcfusion.co.uk>
Reply-To: Gavin McCullagh <gmccullagh@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4617E5E2.2090609@pcfusion.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Rich <rich@pcfusion.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On Sat, 07 Apr 2007, Rich wrote:

> Er, I went with Linear as reading around people seemed to recommend this 
> for odd sized drives (my old drives are 80's, 120 and 320's) also a read 
> somewhere that data on the other drives is more recoverable that most of 
> the other RAID's.

You just want to make a large filesystem out of odd sized disks.  I guess
that's fair enough.  The only reservation I'd have is that with N disks
your likelihood of failure is multiplied by N as any disk failure takes the
array down.  Personally, I'd be more inclined to try and put a separate
filesystem on each disk and use symlinks to pull them together into one
tree.

But now I know why linear raid can be more useful than raid-0, thanks.

> Well it contains stuff like TV and films a lot of which my friends have, 
> so loosing it is not that big of a deal just inconvenient. As I said 
> before I read linear was a better choice for odd sized drives and had 
> better data recovery that the other RAID's

I guess you're using it similarly to LVM then. 

http://en.wikipedia.org/wiki/Logical_Volume_Manager_(Linux)
http://tldp.org/HOWTO/LVM-HOWTO/

It sounds reasonable that recovery would be more feasible than RAID-0 but
neither would be nice to have to do.  RAID1, 5, etc. would be less likely
to require recovery as they have redundancy so a single disk failure
shouldn't take down the array at all.

> I'm sure I read somewhere on the mdadm page in one of the posts about 
> adding support for linear growing, and that was dated 2004 so it might 
> be in there? Just wasn't to sure how to do it...

This looks like your page.

http://cgi.cse.unsw.edu.au/~neilb/SoftRaid

and the mdadm changelog has it:

Changes Prior to 1.7.0 release
   -   Support "--grow --add" to add a device to a linear array, if the
       kernel supports it.  Not documented yet.

I've only grown raid5 arrays myself.  I imagine you must do --add to add
the extra disk partition to the array and then do "mdadm --grow
--size=max", same as with raid5.  

Gavin

