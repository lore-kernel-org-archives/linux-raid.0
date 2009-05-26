From: Jeremy Sanders <jss@ast.cam.ac.uk>
Subject: Re: Raid and badblocks
Date: Tue, 26 May 2009 13:59:14 +0100
Message-ID: <gvgp32$9se$1@ger.gmane.org>
References: <gv5q3p$vof$1@ger.gmane.org> <gv5qnk$1pe$1@ger.gmane.org> <77f027ed892f0a37b3df63d574ae7955.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:

> If you want to write to it which might make the drive think it isn't
> bad any more, you could
>    dd if=/dev/zero of=/dev/sdj seek=1953103080 count=1
> 
> But if it were me, I would do
>    dd if=/dev/sdj of=/dev/null skip=1953103080 count=1
> and confirm that gives and error, just to double check the numbers.

Thanks very much for your help. I managed to get rid of the bad block. 
However I had to write 4kB at once to the bad region (bs=4096) for the drive 
to correct the block. Using bs=1 didn't seem able to get rid of the errors.

Strangely, the Reallocated_Sector_Ct is still zero on the drive even though 
Current_Pending_Sector is now zero. This is a Samsung HD103UJ by the way.

Jeremy

-- 
Jeremy Sanders <jss@ast.cam.ac.uk>   http://www-xray.ast.cam.ac.uk/~jss/
X-Ray Group, Institute of Astronomy, University of Cambridge, UK.
Public Key Server PGP Key ID: E1AAE053


