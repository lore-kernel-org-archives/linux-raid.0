From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Buffer I/O error on dev md5, logical block 7073536, async page
 read
Date: Sun, 30 Oct 2016 17:19:29 +0100
Message-ID: <20161030161929.GA5582@metamorpher.de>
References: <20161030021614.asws67j34ji64qle@merlins.org>
 <20161030093337.GA3627@metamorpher.de>
 <20161030153857.GB28648@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161030153857.GB28648@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 30, 2016 at 08:38:57AM -0700, Marc MERLIN wrote:
> (mmmh, but even so, rebuilding the spare should have cleared the bad blocks
> on at least one drive, no?)

If n+1 disks have bad blocks there's no data to sync over, so they just 
propagate and stay bad forever. Or at least that's how it seemed to work 
last time I tried it. I'm not familiar with bad blocks. I just turn it off.

As long as the bad block list is empty you can --update=no-bbl.
If everything else fails - edit the metadata or carefully recreate.
Which I don't recommend because you can go wrong in a hundred ways.

I don't remember if anyone ever had a proper solution to this.
It came up a couple of times on the list so you could search.

If you've replaced drives since, the drive that has been part of the array 
the longest is probably the most likely to still have valid data in there. 
That could be synced over to the other drives once the bbl is cleared. 
It might not matter, you'd have to check with your filesystems if they 
believe any files located there. (Filesystems sometimes maintain their 
own bad block lists so you'd have to check those too.)

Regards
Andreas Klauer
