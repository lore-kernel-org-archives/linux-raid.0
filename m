From: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Subject: Re: 3ware 7500-8 confusion
Date: Sat, 22 Feb 2003 23:33:33 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1030222233112.1049A-100000@Maggie.Linux-Consulting.com>
References: <1045980219.2132.16.camel@gregdell>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1045980219.2132.16.camel@gregdell>
To: Gregory Leblanc <gleblanc@linuxweasel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya greg, maurice

thanx for the reply....
	- its formatting 1.4TB now...

duhhh.... guess i'm getting too old and too late for this...

i got confused since i had dinitially done a
	fdisk /dev/sda  ... /dev/sdh  and
	created partitions just to make sure everythng worked

than i did the 3dm configure stuff...


thanx
alvin

> > 
> > http://localhost:1080
> > 	- shows the list of drives in the raid
> > 	- shows the other info abut the 3ware card
> 
> Sounds like you've got things set up correctly.
> 
> > but now that i wanna use the hw raid, and want to do:
> > 	fdisk /dev/md0
> > 	mke2fsc -j -m 1 /dev/md0
> > 	mount /dev/md0 /Raid
> > 
> > but there is no such thing as /dev/md0 ... *pout*
> 
> Err, right, there isn't.  /dev/md? is only for software RAID devices. 
> If you've got the 3ware kernel modules loaded, then your 3ware RAID
> device should show up as /dev/sd?  dmesg should have more info, or
> /proc/scsi.
> 

