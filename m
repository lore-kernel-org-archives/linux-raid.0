From: jlewis@lewis.org
Subject: Re: Adding a mirror to a RAID1 Device
Date: Wed, 26 Nov 2003 18:09:49 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311261749510.1140-100000@redhat1.mmaero.com>
References: <16323.53577.411117.6469@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16323.53577.411117.6469@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 26 Nov 2003, Neil Brown wrote:

> Just 
>    power down the machine
>    move the drives
>    power up again
> 
> all is done.... unless you are using raidstart, but that is
> universally a mistake.

That was amazing.  My Promise (Ultra100TX2) card arrived today.  I did a 
shutdown, put the card in, moved hda and hdc onto it, powered up, and it 
booted right up.  The kernel did notice that the md device members' device 
names had changed, but it found them and "just worked".  

Again, this was Red Hat's Fedora Core 1, with all partitions being RAID1 
and a pair of WD ATA100 160gb drives.

----------------------------------------------------------------------
 Jon Lewis *jlewis@lewis.org*|  I route
 Senior Network Engineer     |  therefore you are
 Atlantic Net                |  
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________

