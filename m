From: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Subject: Re: powersupply for 16disks +dual xeon
Date: Sat, 1 Feb 2003 16:05:51 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1030201155522.7035A-100000@Maggie.Linux-Consulting.com>
References: <Pine.GSO.4.30.0302011507070.27656-100000@multivac.sdsc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.30.0302011507070.27656-100000@multivac.sdsc.edu>
To: "Peter L. Ashford" <ashford@sdsc.edu>
Cc: Stephan van Hienen <stephan@a2000.nu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya

On Sat, 1 Feb 2003, Peter L. Ashford wrote:

> Stephan,
> 
> > today tried to put 16 disks (15*ide7200 +1*scsi7200) in a intel sc5200
> > case
> > (which has an 450W powersupply)
> >
> > when i try to powerup the system, the powersupply goes off after 3 seconds
> > i think this is because off the spinupp for the disks
> >
> > any tips how to fix this ?
> > (as far as i know there is no spinup delay for ide disks)
> > maximum powersupply i found is 550W, not much more than i have in my
> > system
> >
> > (i need an 24pin xeon powersupply)
> >
> > (disks are WD180GB (which asks 15W for spinup)

225W      15 drives * 15
50-75W ?  dual xeon 
30-50W    motherboard

seems like there's plenty of power ... just not at 12V to spin the
drives ...

	-
	- maximum power/current is used to spin the drives up
	- and if the ps is designed incorrectly... it will take 
	- current away from +3.3 and +5v ... screwing up the mb
	- ( measure the voltage w/ a storage scope to be safe )
	-

	- if you can add a separate 12V power supply for powering the
	disks.. you'd be in biz..

	- you'd have to power up the disks first ..
	and for shutdown, you'd have to shut off the mb first

	- or add a simple RC circuit to delay drive spin ups
	and than allow the soft "power-on" to the motherboard

- simple resister + cap ... for each 2 or 4 hard drives  
  ( y-power cables )   - say 10K + 470uf   and another one at 470K + 470uf
	- probably allow for 5-10 second delays of disk power ups

	and until the drives is powered up.. the mb should wait
	befor it powers up

- you'd need a separate resistor/cap/transistor for the
  soft "power-on" signal
	- the last thing to do ... for the system to start its
	real boot process

lot cheaper than the $600 dual power supplies
	and marginal 500W supply that can't handle the 12 drives


-- and for motherboards that does NTO boot up by itself
   add a 470uf capacitor across the power-on sig and now it boots by 
   itself


-- and there's places that advertise free PCB for 3-5 pieces ( 2 layers )
	-- never called um though

c ya
alvin


