From: jlewis@lewis.org
Subject: Re: powersupply for 16disks +dual xeon
Date: Sat, 1 Feb 2003 20:31:37 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0302012028210.12785-100000@redhat1.mmaero.com>
References: <Pine.LNX.4.44.0302020102410.3772-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0302020102410.3772-100000@uplift.swm.pp.se>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 2 Feb 2003, Mikael Abrahamsson wrote:

> > So can this trick (connecting 14 to 15) be used as a work-around for brain 
> > damaged motherboards that won't power-on after power-loss to keep a system 
> > always on?
> 
> I don't know, but I wouldnt suggest it and I wouldnt do it on a production 
> system without extensive testing first. I haven't seen the behaviour you 
> suggest above in motherboards since a PPRO200-board way back, all newer 
> boards I have worked with have an option in Power Save-settings as to what 

Unfortunately, alot of cheaper boards have this problem.  Some of the
lower end (either Tyan or Asus, don't remember which) have this.  I was
looking at turning some IBM PC300 (Celeron) systems (really small desktop
cases)  into small dedicated DNS servers, but they also apparently can't 
be set to power-on after power-loss....But I guess I'm drifting way off 
topic now.

----------------------------------------------------------------------
 Jon Lewis *jlewis@lewis.org*|  I route
 System Administrator        |  therefore you are
 Atlantic Net                |  
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________

