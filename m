From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: mdadm and raid10 question
Date: Wed, 17 Mar 2004 12:51:37 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0403171150420.31494@praktifix.dwd.de>
References: <Pine.LNX.4.58.0403171026040.907@praktifix.dwd.de>
 <16472.11382.2607.886692@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16472.11382.2607.886692@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 17 Mar 2004, Neil Brown wrote:

> On Wednesday March 17, Holger.Kiehl@dwd.de wrote:
> > Hello
> > 
> > I have a problem with setting up a raid10 array with mdadm. With raidtools
> > it runs fine, but this might be because I have been using it for a very
> > long time.
> > 
> > The array consists of 6 SCSI disk /dev/sd[abcdef]1 and creating and
> > starting the raid1 is no proplem. Creating the raid0 is also no problem
> > but starting it after it is stopped does not work.
> > 
> > Here my /etc/mdadm.conf:
> > 
> > DEVICE /dev/hda[2356] /dev/hde[2356]
> > DEVICE /dev/sd[abcdef]1
> > ARRAY /dev/md0 level=raid1 num-devices=2 UUID=758b2a4e:74f182df:282c9a7e:0246977b
> > ARRAY /dev/md1 level=raid1 num-devices=2 UUID=728311df:5491265a:29de2fa5:a1042914
> > ARRAY /dev/md2 level=raid1 num-devices=2 UUID=37bd8c5a:9e7efc91:e7537d56:b56c8eef devices=/dev/hda6,/dev/hda5,/dev/hde6,/dev/hde5,/dev/sdd1,/dev/sda1 spare-group=group1
> > ARRAY /dev/md3 level=raid1 num-devices=2 UUID=01bc8c7b:c3eb887e:79eb423d:bd46305f devices=/dev/sde1,/dev/sdb1 spare-group=group1
> > ARRAY /dev/md4 level=raid1 num-devices=2 UUID=72fe4455:cc7965b5:4fe2f4d0:2a5523ce devices=/dev/sdf1,/dev/sdc1 spare-group=group1
> > ARRAY /dev/md5 level=raid0 num-devices=3 UUID=c1565e2b:12c85143:d2fcffa2:12791897 devices=/dev/md2,/dev/md3,/dev/md4
> > 
> > Doing a "mdadm -A /dev/md5" I get:
> > 
> >    mdadm: no devices found for /dev/md5
> > 
> > md5 should be the raid0 consisting of the three raid1's (md2, md3, md4).
> > What am I doing wrong?
> 
> You need
> 
>     DEVICE /dev/md?
> 
> or similar in mdadm.conf
>
Correct, that was a very obvious error on my part! Thanks!

> (and you probably don't want the devices= entries at all).
> 
Hmm, I was thinking to leave the UUID part away because the SCSI disk are
hotswap and I thought it would be much easier when you put in a new disk.
With UUID will it not refuse the new disk/partition? Does it not require
more steps when you replace a failed disk?

Also I find the devices= entry usefull in that it tells me what disks
are being used for the array. If for example the array is offline for
whatever reason, I like to have one file where all information is stored
so it can be recreated with a completely new set of disks. What is missing
is the chunk-size entry. It looks as if I do not understand the concept
of mdadm.conf :(

Holger
