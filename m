From: "Cal Webster" <kc130iseo@coastalnet.com>
Subject: RE: RAID5 problems
Date: Mon, 19 Aug 2002 15:45:26 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NDBBIAKEEKGGEIKCBKNAGECEDCAA.kc130iseo@coastalnet.com>
References: <4534.198.30.180.62.1029775167.squirrel@mail.kc8apf.net>
Reply-To: <cwebster@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4534.198.30.180.62.1029775167.squirrel@mail.kc8apf.net>
To: Rick Altherr <kc8apf@kc8apf.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sounds like your label is being overwritten. Be sure that you do not use
cylinder 0 in your partition. Start it on cyl 1.

Here is an excerpt from the "fdisk" man page on our Sparc running Aurora
Linux:


       A BSD/SUN type disklabel can describe  8  partitions,  the
       third of which should be a `whole disk' partition.  Do not
       start a partition that  actually  uses  its  first  sector
       (like  a  swap  partition)  at cylinder 0, since that will
       destroy the disklabel.

--Cal Webster

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Rick Altherr
> Sent: Monday, August 19, 2002 10:39 AM
> To: linux-raid@vger.kernel.org
> Subject: RAID5 problems
>
>
> I am brand new to software RAID on linux so please bear with me.
>
> I have (4) 23GB SCSI drives on an Adaptec 2940UW controller in an
> alphastation 600.  I created BSD disklabels on all the drives and
> partitioned them as one partition per drive.  I made a raidtab containing
> all 4 partitions as members of a single RAID5 array.  I ran mkraid
> /dev/md0 and the raid array was created and functioned.
>
> This is where the problem lies.  If I stop the RAID array using raidstop
> /dev/md0 and run fdisk on each drive, it reports that each drive has a BSD
> disklabel with a single partition.  However, if I format the RAID array
> using mke2fs -b 4096 -R stride=8, stop the array with raidstop, and check
> each drive with fdisk, the disklabel is removed on the second and third
> drives only.  The first and fourth are fine though.
>
> Trying to start the array again with raidstart fails and mkraid will not
> recreate the array until I create disklabels on the second and third
> drives.
>
> I have not tried any other filesystems as ext2 is the only one my kernel
> currently supports.
>
> Any ideas?
> --
> Rick Altherr
> KC8APF
> kc8apf@kc8apf.net
>
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

