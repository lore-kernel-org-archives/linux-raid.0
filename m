From: "Peter L. Ashford" <ashford@sdsc.edu>
Subject: Re: powersupply for 16disks +dual xeon
Date: Sat, 1 Feb 2003 15:10:15 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.30.0302011507070.27656-100000@multivac.sdsc.edu>
References: <Pine.LNX.4.53.0302011823430.6789@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.53.0302011823430.6789@ddx.a2000.nu>
To: Stephan van Hienen <stephan@a2000.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stephan,

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
>
> (disks are WD180GB (which asks 15W for spinup)

Someone already suggested a 550W PS.  The alternate path is the 460W
redundant from Zippy.  These are a bit pricey, but they have three 230W
modules.  The system should be able to run on two modules, but would
require all three for initial power on.

Adding a slave power supply should work, but you'll have to make sure that
all voltages have adequate load.  Most switching power supplies require a
minimum load to function properly.

Good luck.
				Peter Ashford

