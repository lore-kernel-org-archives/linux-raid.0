From: jlewis@lewis.org
Subject: Re: powersupply for 16disks +dual xeon
Date: Sat, 1 Feb 2003 14:54:14 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0302011449420.12785-100000@redhat1.mmaero.com>
References: <Pine.LNX.4.44.0302012036370.3772-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0302012036370.3772-100000@uplift.swm.pp.se>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 1 Feb 2003, Mikael Abrahamsson wrote:

> You should try to fit another powersupply to drive the disks. ATX 
> powersupplies can be made powermanently on by shorting ping 14 and 15 (I 
> think it was, there is a FAQ page out there I found on when I was looking 
> a month back). If you don't want to do this, get yourself an AT power 
> supply.

So can this trick (connecting 14 to 15) be used as a work-around for brain 
damaged motherboards that won't power-on after power-loss to keep a system 
always on?
 
> I run 10 disks off of a 350W power supply (dual 1.13GHz pIII board) and it 
> has worked fine, I think you're not too far off the limit. Perhaps that 
> 550W will do the trick.

We have a dual PIII server with 2 9gb and 8 36gb drives running on a 450W 
supply (IIRC), but those are all SCSI drives with various spin-up delays.

On another system we were using to test a large RAID array, we just rigged 
up an AT power supply to half of the disks.  That works fine on the bench, 
but is a little sloppy if you're trying to build a production server.

----------------------------------------------------------------------
 Jon Lewis *jlewis@lewis.org*|  I route
 System Administrator        |  therefore you are
 Atlantic Net                |  
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________

