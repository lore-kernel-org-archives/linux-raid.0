From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: RAID detection and activation w/o auto detection
Date: Tue, 30 Apr 2002 21:47:41 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0204302142570.14713-100000@filesrv1.baby-dragons.com>
References: <Pine.LNX.4.44.0204302130320.14713-100000@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0204302130320.14713-100000@filesrv1.baby-dragons.com>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


	Hello Neil ,  OK mia culpa .  But I don't see what good the echo
	below does for us then ,  as in ...

~# more ./mdadm.conf
/dev/hd* /dev/sd*
ARRAY /dev/md0 level=raid5 num-devices=3 UUID=b285b144:ae0b561b:b5b55686:ed216a4c

	Without the DEVICE in front of '/dev/hd* /dev/sd*' they are
	meaningless .  Right ?  Tia ,  JimL

On Tue, 30 Apr 2002, Mr. James W. Laferriere wrote:
> 	Hello Neil ,  An suggestion for -D function of mdadm
> 	please allow use of  '-c/--config='  ?
> 	I tried the suggestion below .  But I did not want to overwrite
> 	the /etc version of mdadm.conf , cause it works .  So I tried to
> 	use the -c option & mdadm replies with the below .  Tia ,  JimL
> ~# mdadm -V
> mdadm - v0.8.2 - 11 April 2002
> ~# echo '/dev/hd* /dev/sd*' > ./mdadm.conf
> ~# mdadm -Dsb -c ./mdadm.conf >> ./mdadm.conf
> mdadm: option c not valid in misc mode
> ~# mdadm -Dsb --config=./mdadm.conf >> ./mdadm.conf
> mdadm: option c not valid in misc mode

> On Tue, 30 Apr 2002, Neil Brown wrote:
> > On Monday April 29, bo@sosnetwork.net wrote:
> > > Hello,
> > > How to detect and activate the RAID manually without
> > > "auto detection"(0xFD in partition type)?
> > > I tried with "mdadm -R" or "mdadm -A", but it did not work.
> >
> > echo '/dev/hd* /dev/sd*' > /etc/mdadm.conf
> > mdadm -Dsb >> /etc/mdadm.conf
> >
> > # look at /etc/mdadm.conf and make sure that it looks ok.
> >
> > # add  "mdadm -As" to an appropriate startup script.
> >
> > Note that this won't work for assembling the root filesystem.
> > To do that, you either need an init-ramdisk which runs "mdadm -As", or
> > use kernel parameters to start the root device.e.g.
> >
> >   append="root=/dev/md0 md=0,/dev/hda1,/dev/hdc1"
> >
> > NeilBrown

       +------------------------------------------------------------------+
       | James   W.   Laferriere | System    Techniques | Give me VMS     |
       | Network        Engineer |     P.O. Box 854     |  Give me Linux  |
       | babydr@baby-dragons.com | Coudersport PA 16915 |   only  on  AXP |
       +------------------------------------------------------------------+

