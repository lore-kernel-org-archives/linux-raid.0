From: jlewis@lewis.org
Subject: Re: Status of HighPoint / Promise drivers?
Date: Tue, 30 Dec 2003 18:55:59 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0312301852310.1212-100000@redhat1.mmaero.com>
References: <3FF20C50.6000207@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FF20C50.6000207@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 30 Dec 2003, Jeff Garzik wrote:

> > While I'm investigating: How about the HighPoint drivers, more
> > specifically the one for HPT374 (the HighPoint 1540 card)?
> > It's significantly cheaper than the Promise cards.
> 
> There is a GPL'd driver for HighPoint SATA floating around somewhere... 
>   not really well support though, is the basic answer.

Based on my experience with a HPT Rocket100 (not a RAID card), and the
2.4.x kernel driver and the drivers supplied by HPT, I'd be very afraid.  
I bought the Rocket100 thinking it was supported.  It's not.  Red Hat 8.0,
9, and Fedora Core 1.0 installs either don't recognize it or lock up when
probing the drives connected to it.  HPT's driver disks for 8.0 and 9 get
as far as starting to install RPMS, then die with disk i/o errors.  Same
hardware with a Promise UltraTX2-100 swapped for the Rocket100 works just
fine.
 
----------------------------------------------------------------------
 Jon Lewis *jlewis@lewis.org*|  I route
 Senior Network Engineer     |  therefore you are
 Atlantic Net                |  
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________

