From: Philip Molter <philip@corp.texas.net>
Subject: Re: Force parity resync on raid5?
Date: Thu, 12 Aug 2004 06:52:52 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <411B5A14.8070608@corp.texas.net>
References: <200408120406.i7C46s309087@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408120406.i7C46s309087@watkins-home.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Recovering from a power failure does force a re-build (2.4), but from what I
> remember the system looks like it is re-building a failed disk, which is not
> what he wants to do.  If the parity was good, re-building any 1 disk would
> be fine.

Actually, under a 2.4, the superblock is marked dirty and the parity is 
rebuilt.  We've done this to over 100 systems (thank you, broken RedHat 
installer) and it's worked flawlessly.

Neil, the new mdadm --update=resync works like a charm.  The one thing I 
did notice is that when a drive fails out during the resync, the resync 
restarts on the remaining failed drives.  As far as I can tell, that 
does what it's supposed to.  Is that a nice little feature of the resync?

Philip
