From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: 2.6.0-test1-bk2 ate my root raid
Date: Thu, 24 Jul 2003 09:21:57 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16159.6293.395295.30625@gargle.gargle.HOWL>
References: <20030723203425.GA22680@drunk.brewdrinkers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Thomas on Wednesday July 23
To: Thomas <thomas@zimres.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday July 23, thomas@zimres.net wrote:
> I tested 2.6.0-test1-bk2 out, and it wouldn't boot using 
> my devfs name. No real problem there, as I've seen the workaround--
> use the huge ugly devfs name (or hex'ed numbers)--I've got a backup root
> partition (I've got to learn to type one of these days if I play with
> root). Boot using the backup partition, 
> "2.6.0-test1-bk2 root=/dev/hdc1 init=/bin/bash" and notice that 
> the new kernel doesn't see my promise controler (odd that, half
> of the raid is on that "lost" drive"). 
> 
> Boot back into 2.4.21; I get a quick kernel panic (no root)
> but can't tell why as once you've panic'ed you can't scroll up. I've
> got a Knoppix cd, so all will be well. Boot that, and load the md 
> modules and got the following, and here I'm a bit stumped :"
>  [events: 0000001d]
> md: bind<hda1,1>
>  [events: 0000001c]
> md: bind<hde1,2>
> md: hde1's event counter: 0000001c
> md: hda1's event counter: 0000001d
> md: superblock update time inconsistency -- using the most recent one
> md: freshest: hda1
> md: bug in file md.c, line 1475


I think your best bet is to get mdadm and assemble the array
with
   mdadm -A /dev/md0 --force /dev/hda1
   mdadm /dev/md0 --add /dev/hde1

and wait for the rebuild.

I'll try to see if I can figure out what is causing the oops.

NeilBrown
