From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: RAID detection and activation w/o auto detection
Date: Tue, 30 Apr 2002 21:38:48 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0204302130320.14713-100000@filesrv1.baby-dragons.com>
References: <15566.4106.971348.1325@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15566.4106.971348.1325@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: bo <bo@sosnetwork.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	Hello Neil ,  An suggestion for -D function of mdadm
	please allow use of  '-c/--config='  ?

	I tried the suggestion below .  But I did not want to overwrite
	the /etc version of mdadm.conf , cause it works .  So I tried to
	use the -c option & mdadm replies with the below .  Tia ,  JimL

~# mdadm -V
mdadm - v0.8.2 - 11 April 2002

~# echo '/dev/hd* /dev/sd*' > ./mdadm.conf

~# mdadm -Dsb -c ./mdadm.conf >> ./mdadm.conf
mdadm: option c not valid in misc mode

~# mdadm -Dsb --config=./mdadm.conf >> ./mdadm.conf
mdadm: option c not valid in misc mode


On Tue, 30 Apr 2002, Neil Brown wrote:

> On Monday April 29, bo@sosnetwork.net wrote:
> > Hello,
> >
> > How to detect and activate the RAID manually without
> > "auto detection"(0xFD in partition type)?
> >
> > I tried with "mdadm -R" or "mdadm -A", but it did not work.
>
> echo '/dev/hd* /dev/sd*' > /etc/mdadm.conf
> mdadm -Dsb >> /etc/mdadm.conf
>
> # look at /etc/mdadm.conf and make sure that it looks ok.
>
> # add  "mdadm -As" to an appropriate startup script.
>
> Note that this won't work for assembling the root filesystem.
> To do that, you either need an init-ramdisk which runs "mdadm -As", or
> use kernel parameters to start the root device.e.g.
>
>   append="root=/dev/md0 md=0,/dev/hda1,/dev/hdc1"
>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

       +------------------------------------------------------------------+
       | James   W.   Laferriere | System    Techniques | Give me VMS     |
       | Network        Engineer |     P.O. Box 854     |  Give me Linux  |
       | babydr@baby-dragons.com | Coudersport PA 16915 |   only  on  AXP |
       +------------------------------------------------------------------+

