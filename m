From: Marc MERLIN <marc@merlins.org>
Subject: Re: Buffer I/O error on dev md5, logical block 7073536, async page read
Date: Sun, 30 Oct 2016 09:43:42 -0700
Message-ID: <20161030164342.GC28648@merlins.org>
References: <20161030021614.asws67j34ji64qle@merlins.org> <20161030093337.GA3627@metamorpher.de> <20161030153857.GB28648@merlins.org> <20161030161929.GA5582@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161030161929.GA5582@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 30, 2016 at 05:19:29PM +0100, Andreas Klauer wrote:
> On Sun, Oct 30, 2016 at 08:38:57AM -0700, Marc MERLIN wrote:
> > (mmmh, but even so, rebuilding the spare should have cleared the bad blocks
> > on at least one drive, no?)
> 
> If n+1 disks have bad blocks there's no data to sync over, so they just 
> propagate and stay bad forever. Or at least that's how it seemed to work 
> last time I tried it. I'm not familiar with bad blocks. I just turn it off.
> 
> As long as the bad block list is empty you can --update=no-bbl.
> If everything else fails - edit the metadata or carefully recreate.
> Which I don't recommend because you can go wrong in a hundred ways.
 
Right.
There should be some --update=no-bbl --force if the admin knows the bad
block list is wrong and due to IO issues not related to the drive.

> I don't remember if anyone ever had a proper solution to this.
> It came up a couple of times on the list so you could search.

Will look, thanks.

> If you've replaced drives since, the drive that has been part of the array 
> the longest is probably the most likely to still have valid data in there. 
> That could be synced over to the other drives once the bbl is cleared. 
> It might not matter, you'd have to check with your filesystems if they 
> believe any files located there. (Filesystems sometimes maintain their 
> own bad block lists so you'd have to check those too.)

No drives were ever replaced, this is an original array used only a few
times (for backups).
At this point I'm almost tempted to wipe and start over, but it's going to
take a week to recreate the backup (lots of data, slow link).
As for the filesystem it's btrfs with data and metadata checksums, so it's
easy to verify that everything is fine once I can get md5 to stop returning
IO errors on blocks it thinks are bad, but in fact are not.

And here isn't one good drive between the 2, the bad blocks are identical on
both drives and must have happened at the same time due to those cable
induced IO errors I mentionned.
Too bad that mdadm doesn't seem to account for the fact that it could be
wrong when marking blocks as bad and does not seem to give a way to recover
from this easily....
I'll do more reading, thanks.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
