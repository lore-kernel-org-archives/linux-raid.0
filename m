From: John Lange <john.lange@bighostbox.com>
Subject: Re: AW: Raid 1 vs 5 ?
Date: Fri, 07 May 2004 00:52:02 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1083909121.4287.19.camel@localhost>
References: <FA095C015271B64E99B197937712FD0227A85D@freedom.grz.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FA095C015271B64E99B197937712FD0227A85D@freedom.grz.icomedias.com>
To: Martin Bene <martin.bene@icomedias.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you Martin. You have some really great insights there.

A couple of things about the raid sets confused me:

> Each disk partitioned alike:
> 	1	30MB 
> 	2	1/2 size_of_swap_
> 	5	rest_of_disk
> 
> Now you can create mds on the disk:
> 	md0	raid1 sda1 sda2 sda3 sda4
> 	md1	raid1 sda1 sdb1
> 	md2	raid1 sdc1 sdd1
> 	md3	raid5 sda5 sdb5 sdc5 sdd5

First, why do we skip sdx3 and sdx4 on each disk and go directly to sdx5
for partition numbers?

Second, I'm very confused by the way you divided up the raid sets....
I'm thinking you erred? I'm such a newb its possible I really don't
understand whats going on so hopefully you can verify.

md0: did you mean sda1 sdb1 sdc1 sdd1 ?
md1: did you mean sda2 sdb2 ?
md2: did you mean sdc2 sdd2 ?
md3: did you mean sda5 sdb5 sdc5 sdd5 ?

And last, is it possible to build the system from the beginning on RAID?
I'm using slackware. I see there is a section in the how-to for
converting a red hat system after the fact but obviously it would be
easier if I didn't have to do that.

Thanks very much Martin.

John Lange

On Fri, 2004-05-07 at 00:10, Martin Bene wrote:
> > Which one is the better choice and what are the trade offs? Or is
> > another configuration more sensible? I'm under the impression that you
> > shouldn't (can't?) boot from RAID 5.
> 
> Depends very much on what you're going to do with the system - I've
> found a high performnce impact of raid5 for database applicaions with
> frequent updates (where you end up with lots of small writes scattered
> allover the partition). If write speed isn't too important, the space
> savings may well make raid5 more attractive.
> 
> True, you can't boot directly off raid5, but you can have a /boot on
> raid1 and the rest of the system on raid5. Also, you definitely should
> consider putting swap on raid1: otherwise a failure of the swap disk
> will bring you system down.(don't put swap on raid5 - same performance
> issue as mentioned above.)
> 
> A minimal configuration for 4 disks optimized for max space could be
> like this, though you might want seperate raid5s for /, /usr, /var.  
> 
> Each disk partitioned alike:
> 	1	30MB 
> 	2	1/2 size_of_swap_
> 	5	rest_of_disk
> 
> Now you can create mds on the disk:
> 	md0	raid1 sda1 sda2 sda3 sda4
> 	md1	raid1 sda1 sdb1
> 	md2	raid1 sdc1 sdd1
> 	md3	raid5 sda5 sdb5 sdc5 sdd5
> 
> 	md0	/boot
> 	md1	swap
> 	md2	swap
> 	md3	/
> 
> You've got a small 4-disk raid1 as /boot, so each of our disks can be
> bootable.
> Swap is on 2 2-disk raid1 partitions so your system can survive failure
> of a disk used for swap.
> Main data storage is on 4-disk raid5.
> 
> Bye, Martin
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

