From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Redundancy check using "echo check > sync_action": error
	reporting?
Date: Thu, 20 Mar 2008 12:35:51 -0400
Message-ID: <20080320163551.GG13719@mit.edu>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47E2725C.1020206@tuxes.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Bas van Schaik <bas@tuxes.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 20, 2008 at 03:19:08PM +0100, Bas van Schaik wrote:
> > There's no explicit message produced by the md module, no.  You need to
> > check the /sys/block/md{X}/md/mismatch_cnt entry to find out how many
> > mismatches there are.  Similarly, following a repair this will indicate
> > how many mismatches it thinks have been fixed (by updating the parity
> > block to match the data blocks).
> >   
> Marvellous! I naively assumed that the module would warn me, but that's
> not true. Wouldn't it be appropriate to print a message to dmesg if such
> a mismatch occurs during a check? Such a mismatch clearly means that
> there is something wrong with your hardware lying beneath md, doesn't it?

If a mismatch is detected in a RAID-6 configuration, it should be
possible to figure out what should be fixed (since with two hot spares
there should be enough redundancy not only to detect an error, but to
correct it.)  Out of curiosity, does md do this automatically, either
when reading from a stripe, or during a resync operation?

     	     	    	       	      - Ted
