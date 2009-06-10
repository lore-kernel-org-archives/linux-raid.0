From: Kyler Laird <kyler-keyword-linuxraid.6e1399@lairds.com>
Subject: "cannot start dirty degraded array"
Date: Wed, 10 Jun 2009 16:03:10 -0400
Message-ID: <20090610200310.GF18313@lairds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm in a bind.  I have three RAID6s on a Sun X4540.  A bunch of disks
threw error all of a sudden.  Two arrays came back (degraded) on reboot
but the third is having problems.  

	root@00144ff2a334:/tmp# mdadm -E /dev/sdag                                                                                       
	/dev/sdag:                                                                                                                       
		  Magic : a92b4efc                                                                                                       
		Version : 00.90.00                                                                                                       
		   UUID : fe5c8175:b45887a9:0fe23972:c126e925 (local to host 00144ff2a334)                                               
	  Creation Time : Mon Apr 27 22:14:16 2009
	     Raid Level : raid6
	  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
	     Array Size : 12697912448 (12109.67 GiB 13002.66 GB)
	   Raid Devices : 15
	  Total Devices : 16
	Preferred Minor : 2

	    Update Time : Sun Jun  7 07:28:53 2009
		  State : clean
	 Active Devices : 15
	Working Devices : 16
	 Failed Devices : 0
	  Spare Devices : 1
	       Checksum : fb439997 - correct
		 Events : 0.16

	     Chunk Size : 16K

	      Number   Major   Minor   RaidDevice State

Here's the dmesg output when I try to assemble using "mdadm --assemble
/dev/md2 /dev/sda[g-v]".


	[ 3469.703048] md: bind<sdag>
	[ 3469.703305] md: bind<sdai>
	[ 3469.703554] md: bind<sdaj>
	[ 3469.703806] md: bind<sdak>
	[ 3469.704043] md: bind<sdal>
	[ 3469.704294] md: bind<sdam>
	[ 3469.704544] md: bind<sdan>
	[ 3469.775701] md: bind<sdao>
	[ 3469.775946] md: bind<sdap>
	[ 3469.776198] md: bind<sdaq>
	[ 3469.776453] md: bind<sdar>
	[ 3469.776695] md: bind<sdas>
	[ 3469.776953] md: bind<sdat>
	[ 3469.777204] md: bind<sdau>
	[ 3469.777442] md: bind<sdav>
	[ 3469.777698] md: bind<sdah>
	[ 3469.777762] md: kicking non-fresh sdag from array!
	[ 3469.777766] md: unbind<sdag>
	[ 3469.801894] md: export_rdev(sdag)
	[ 3469.801898] md: md2: raid array is not clean -- starting background reconstruction
	[ 3469.825589] raid5: device sdah operational as raid disk 1
	[ 3469.825591] raid5: device sdau operational as raid disk 14
	[ 3469.825593] raid5: device sdat operational as raid disk 13
	[ 3469.825594] raid5: device sdas operational as raid disk 12
	[ 3469.825595] raid5: device sdar operational as raid disk 11
	[ 3469.825596] raid5: device sdaq operational as raid disk 10
	[ 3469.825597] raid5: device sdap operational as raid disk 9
	[ 3469.825598] raid5: device sdao operational as raid disk 8
	[ 3469.825599] raid5: device sdan operational as raid disk 7
	[ 3469.825600] raid5: device sdam operational as raid disk 6
	[ 3469.825601] raid5: device sdal operational as raid disk 5
	[ 3469.825602] raid5: device sdak operational as raid disk 4
	[ 3469.825603] raid5: device sdaj operational as raid disk 3
	[ 3469.825604] raid5: device sdai operational as raid disk 2
	[ 3469.825606] raid5: cannot start dirty degraded array for md2
	[ 3469.825674] RAID5 conf printout:
	[ 3469.825675]  --- rd:15 wd:14
	[ 3469.825676]  disk 1, o:1, dev:sdah
	[ 3469.825677]  disk 2, o:1, dev:sdai
	[ 3469.825678]  disk 3, o:1, dev:sdaj
	[ 3469.825679]  disk 4, o:1, dev:sdak
	[ 3469.825679]  disk 5, o:1, dev:sdal
	[ 3469.825680]  disk 6, o:1, dev:sdam
	[ 3469.825681]  disk 7, o:1, dev:sdan
	[ 3469.825682]  disk 8, o:1, dev:sdao
	[ 3469.825683]  disk 9, o:1, dev:sdap
	[ 3469.825684]  disk 10, o:1, dev:sdaq
	[ 3469.825685]  disk 11, o:1, dev:sdar
	[ 3469.825685]  disk 12, o:1, dev:sdas
	[ 3469.825686]  disk 13, o:1, dev:sdat
	[ 3469.825687]  disk 14, o:1, dev:sdau
	[ 3469.825689] raid5: failed to run raid set md2
	[ 3469.825751] md: pers->run() failed ...

I ran a check of the disks' SMART data and they seem to be alright.
We're getting ready to ship the entire unit to a data recovery center
but I'd really like to know if there's something simple we can do first.
I've been frantically reading about this issue but none of the simple
solutions seem to work for me.  I welcome suggestions.

Thanks!

--kyler
