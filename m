From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: what happens to raid when more disks are added?
Date: Wed, 07 May 2003 12:37:23 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EB93643.D55A2AD5@SteelEye.com>
References: <3EB929C3.6040400@cc.kuleuven.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Herta Van den Eynde <herta.vandeneynde@cc.kuleuven.ac.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Herta Van den Eynde wrote:
 
> To linux, they are known as devices sd[c-h], which have been configured
> as raid 0+1:
> 
> # cat /proc/mdstat
> Personalities : [raid0] [raid1]
> read_ahead 1024 sectors
> md2 : active raid1 md1[1] md0[0]
>       106679168 blocks [2/2] [UU]
> 
> md0 : active raid0 sde1[2] sdd1[1] sdc1[0]
>       106679232 blocks 8k chunks
> 
> md1 : active raid0 sdh1[2] sdg1[1] sdf1[0]
>       106679232 blocks 8k chunks
> 
> unused devices: <none>

It's generally thought to be better to set this up as a RAID 1+0 (three
raid1 devices striped together) but maybe there's a reason why you've
opted for the RAID 0+1? (there's one less md device, I guess)...

 
> When I need to add extra disks, e.g. in slots 3 and 12, I assume that
> the disk in slot 3 will get device name /dev/sdf, and the disks in slots
> 9 through 12 will subsequently be known as /dev/sd[g-j].  How will that
> affect the raid 0+1 config?

You may want to think about using the autodetection feature of md (or
mdadm's UUID capability)... these would allow you to avoid messing
things up if your drive letters shift on you...

--
Paul
