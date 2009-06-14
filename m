From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: "cannot start dirty degraded array"
Date: Sun, 14 Jun 2009 20:32:22 -0300
Message-ID: <18997.34950.565094.141137@fisica.ufpr.br>
References: <20090610200310.GF18313@lairds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090610200310.GF18313@lairds.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kyler Laird (kyler-keyword-linuxraid.6e1399@lairds.com) wrote on 10 June 2009 16:03:
 >I'm in a bind.  I have three RAID6s on a Sun X4540.  A bunch of disks
 >threw error all of a sudden.  Two arrays came back (degraded) on reboot
 >but the third is having problems.  
...
 >Here's the dmesg output when I try to assemble using "mdadm --assemble
 >/dev/md2 /dev/sda[g-v]".
 >
 >
 >	[ 3469.703048] md: bind<sdag>
 >	[ 3469.703305] md: bind<sdai>
 >	[ 3469.703554] md: bind<sdaj>
 >	[ 3469.703806] md: bind<sdak>
 >	[ 3469.704043] md: bind<sdal>
 >	[ 3469.704294] md: bind<sdam>
 >	[ 3469.704544] md: bind<sdan>
 >	[ 3469.775701] md: bind<sdao>
 >	[ 3469.775946] md: bind<sdap>
 >	[ 3469.776198] md: bind<sdaq>
 >	[ 3469.776453] md: bind<sdar>
 >	[ 3469.776695] md: bind<sdas>
 >	[ 3469.776953] md: bind<sdat>
 >	[ 3469.777204] md: bind<sdau>
 >	[ 3469.777442] md: bind<sdav>
 >	[ 3469.777698] md: bind<sdah>
 >	[ 3469.777762] md: kicking non-fresh sdag from array!
 >	[ 3469.777766] md: unbind<sdag>
 >	[ 3469.801894] md: export_rdev(sdag)
 >	[ 3469.801898] md: md2: raid array is not clean -- starting background reconstruction
 >	[ 3469.825589] raid5: device sdah operational as raid disk 1
 >	[ 3469.825591] raid5: device sdau operational as raid disk 14
 >	[ 3469.825593] raid5: device sdat operational as raid disk 13
 >	[ 3469.825594] raid5: device sdas operational as raid disk 12
 >	[ 3469.825595] raid5: device sdar operational as raid disk 11
 >	[ 3469.825596] raid5: device sdaq operational as raid disk 10
 >	[ 3469.825597] raid5: device sdap operational as raid disk 9
 >	[ 3469.825598] raid5: device sdao operational as raid disk 8
 >	[ 3469.825599] raid5: device sdan operational as raid disk 7
 >	[ 3469.825600] raid5: device sdam operational as raid disk 6
 >	[ 3469.825601] raid5: device sdal operational as raid disk 5
 >	[ 3469.825602] raid5: device sdak operational as raid disk 4
 >	[ 3469.825603] raid5: device sdaj operational as raid disk 3
 >	[ 3469.825604] raid5: device sdai operational as raid disk 2
 >	[ 3469.825606] raid5: cannot start dirty degraded array for md2

You can try to use mdadm -A -f /dev/md2 <list of devices> to force the
array to assemble. Should work if all disks stopped simultaneously.
