From: jlewis@lewis.org
Subject: Re: Adding a mirror to a RAID1 Device
Date: Tue, 25 Nov 2003 17:58:04 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311251756030.1140-100000@redhat1.mmaero.com>
References: <3FC3D27A.5010105@eglifamily.dnsalias.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FC3D27A.5010105@eglifamily.dnsalias.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 25 Nov 2003, Dan Egli wrote:

> | all is done.... unless you are using raidstart, but that is
> | universally a mistake.
> 
> But all linux distributions I've used, save perhaps gentoo, DO use
> raidstart with /etc/raidtab. How do you configure it so the kernel
> assembles the array for you? /etc/fstab?

I'll have to add some debug echos to be sure, but it looks like Fedora 
Core 1 uses raidstart (from /etc/rc.d/rc.sysinit) only if the kernel 
didn't auto-start the devices.

----------------------------------------------------------------------
 Jon Lewis *jlewis@lewis.org*|  I route
 Senior Network Engineer     |  therefore you are
 Atlantic Net                |  
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________

