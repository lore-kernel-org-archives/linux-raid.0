From: Jeffrey Paul <sneak@datavibe.net>
Subject: Re: powersupply for 16disks +dual xeon
Date: Sat, 1 Feb 2003 13:30:10 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0302011327180.2908-100000@datavibe.net>
References: <Pine.LNX.4.53.0302011823430.6789@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.53.0302011823430.6789@ddx.a2000.nu>
To: Stephan van Hienen <stephan@a2000.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 1 Feb 2003, Stephan van Hienen wrote:

> today tried to put 16 disks (15*ide7200 +1*scsi7200) in a intel sc5200
> case
> (which has an 450W powersupply)
>
> when i try to powerup the system, the powersupply goes off after 3 seconds
> i think this is because off the spinupp for the disks
>
> any tips how to fix this ?
> (as far as i know there is no spinup delay for ide disks)
> maximum powersupply i found is 550W, not much more than i have in my
> system
>
> (i need an 24pin xeon powersupply)

You could try hacking together another powersupply to run some of the
harddisks... I'm not sure of the ATX pinouts, but it shouldn't be too hard
to hack up a 12vdc relay or array of relays to one of the 12VDC pins on a
molex connector of the existing power supply to turn on the second power
supply, kind of slaving it to the first.

Let me know if you need further data on doing this, it's a websearch away.

-j

--------------------------------------------------------
  Jeffrey Paul      -datavibe-      sneak@datavibe.net
 aim: x736e65616b   phone: 130*21*16749 or 877-748-3467
--------------------------------------------------------

