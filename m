From: "Francisco Zafra" <fzafra@gmail.com>
Subject: RE: Recovery raid5 after sata cable failure.
Date: Mon, 18 Jul 2005 10:36:04 +0200
Message-ID: <42db6a24.41ee84a1.3e8b.ffffa62b@mx.gmail.com>
References: <17114.55130.211770.531178@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17114.55130.211770.531178@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I already tried that:

root@Torero-2:~ # cat /proc/mdstat
Personalities : [linear] [raid5] 
md0 : active raid5 sdg1[6] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
      1367507456 blocks level 5, 512k chunk, algorithm 2 [8/7] [UUUUUUU_]
      
unused devices: <none>
root@Torero-2:~ # mdadm /dev/md0 -r /dev/sdh1
mdadm: hot remove failed for /dev/sdh1: No such device or address
root@Torero-2:~ # mdadm /dev/md0 -a /dev/sdh1
mdadm: Cannot open /dev/sdh1: Device or resource busy
root@Torero-2:~ # 

With no luck :(

Paco. 

> -----Mensaje original-----
> De: Neil Brown [mailto:neilb@cse.unsw.edu.au] 
> Enviado el: lunes, 18 de julio de 2005 0:11
> Para: Francisco Zafra
> CC: linux-raid@vger.kernel.org
> Asunto: Re: Recovery raid5 after sata cable failure.
> 
> On Sunday July 17, fzafra@gmail.com wrote:
> > Hi all,
> >  
> >     I have raid5 array working without problem for some 
> months. A SATA 
> > cable failed and de raid5 works fine keeping the superblock 
> > persistent, but now, I can't get the old device inserted 
> into the array.
> ...
> > 
> > 	And I try to re-add the old disk in this way:
> > 
> > root@Torero-2:/mnt/raid5 # mdadm /dev/md0 -a /dev/sdh1   
> > mdadm: Cannot open /dev/sdh1: Device or resource busy
> > 
> > 	What is wrong? What I am doing bad? Sdh1 is absolutely 
> unused, so I 
> > don't understand the error "resource busy"
> 
> Well, it definitely is busy...
> 
> Maybe it is still part of md0, but marked as 'faulty'.
> If so (cat /proc/mdstat would tell you) you need to remove it first.
>   mdadm /dev/md0 -r /dev/sdh1
>   mdadm /dev/md0 -a /dev/sdh1
> 
> NeilBrown
> 

