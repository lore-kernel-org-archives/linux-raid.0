From: "Francisco Zafra" <fzafra@gmail.com>
Subject: RE: Recovery raid5 after sata cable failure.
Date: Mon, 18 Jul 2005 11:56:58 +0200
Message-ID: <42db7d1e.6cc951d1.55b4.ffffb383@mx.gmail.com>
References: <17115.31017.434682.374811@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17115.31017.434682.374811@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil, 
Since some hours I am trying to solved it with the last version:
root@Torero-2:~ # mdadm --version
mdadm - v2.0-devel-2 - DEVELOPMENT VERSION NOT FOR REGULAR USE - 7 July 2005

With the same results :(

I really don't think it is locked I dd it in act of desperation and I have
no problems:
root@Torero-2:~ # dd if=/dev/zero of=/dev/sdh bs=1k count=1000
1000+0 records in
1000+0 records out
1024000 bytes transferred in 0.417862 seconds (2450570 bytes/sec)

No locked or anything... I have really get out of ideas with this...

Thanks for all your help.

Paco.


> -----Mensaje original-----
> De: Neil Brown [mailto:neilb@cse.unsw.edu.au] 
> Enviado el: lunes, 18 de julio de 2005 11:41
> Para: Francisco Zafra
> CC: linux-raid@vger.kernel.org
> Asunto: RE: Recovery raid5 after sata cable failure.
> 
> On Monday July 18, fzafra@gmail.com wrote:
> > I already tried that:
> > 
> > root@Torero-2:~ # cat /proc/mdstat
> > Personalities : [linear] [raid5]
> > md0 : active raid5 sdg1[6] sdf1[5] sde1[4] sdd1[3] sdc1[2] 
> sdb1[1] sda1[0]
> >       1367507456 blocks level 5, 512k chunk, algorithm 2 [8/7] 
> > [UUUUUUU_]
> >       
> > unused devices: <none>
> > root@Torero-2:~ # mdadm /dev/md0 -r /dev/sdh1
> > mdadm: hot remove failed for /dev/sdh1: No such device or address 
> > root@Torero-2:~ # mdadm /dev/md0 -a /dev/sdh1
> > mdadm: Cannot open /dev/sdh1: Device or resource busy
> 
> 
> Uhm, you might have a buggy version of mdadm.  If you have 
> 1.10.0, get an upgrade.
> 
> Otherwise either sdh1 or sdh must be:
>   open by some process with O_EXCL
>   open via a /dev/raw/* device
>   part of an md device (which it obviously isn't)
>   part of a dm device
>   mounted as a filesystem
>   an external-journal device for a jfs or ext3 or xfs filesystem
>   in use as a swap device
>   open for writing under a security level of 1 (whatever that means..)
>   an mtd device that is open
> 
> (those are all the places that I can find that take an 
> exclusive lock  on a block device).
> 
> NeilBrown
> 

