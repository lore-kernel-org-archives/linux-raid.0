From: Jon Lewis <jlewis@lewis.org>
Subject: Re: resync (what is it doing when making a new array?)
Date: Mon, 9 Aug 2004 16:55:45 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0408091650490.1853@web1.mmaero.com>
References: <1091924709.209ea25bc637f@www.then7.com>
 <Pine.LNX.4.56.0408080821010.805@lion.drogon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0408080821010.805@lion.drogon.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 8 Aug 2004, Gordon Henderson wrote:

> On Sat, 7 Aug 2004, Eli Cantu wrote:
>
> > (watching a raid 5 array, composed of five 250gb disks, resyncing...to
> > be completed 16 hours from now...)
>
> One thing to check (if it's IDE drives) is that they are working in DMA
> mode - use hdparm /dev/hda, etc. to check and force DMA if necessary
> (although you might need to re-compile your kernel to include the correct
> drivers for your IDE hardware)
>
> It'll still take a long time with 250GB drives, though.

16 hours seems kind of long.  I've recently been dealing with a 6 200gb
drive (SATA) sw RAID5, and resyncs took around 3 hours on an otherwise
totally idle P4 2.4ghz.

----------------------------------------------------------------------
 Jon Lewis                   |  I route
 Senior Network Engineer     |  therefore you are
 Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
