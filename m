From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm and raid10 question
Date: Wed, 17 Mar 2004 21:46:14 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16472.11382.2607.886692@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.58.0403171026040.907@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Holger Kiehl on Wednesday March 17
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday March 17, Holger.Kiehl@dwd.de wrote:
> Hello
> 
> I have a problem with setting up a raid10 array with mdadm. With raidtools
> it runs fine, but this might be because I have been using it for a very
> long time.
> 
> The array consists of 6 SCSI disk /dev/sd[abcdef]1 and creating and
> starting the raid1 is no proplem. Creating the raid0 is also no problem
> but starting it after it is stopped does not work.
> 
> Here my /etc/mdadm.conf:
> 
> DEVICE /dev/hda[2356] /dev/hde[2356]
> DEVICE /dev/sd[abcdef]1
> ARRAY /dev/md0 level=raid1 num-devices=2 UUID=758b2a4e:74f182df:282c9a7e:0246977b
> ARRAY /dev/md1 level=raid1 num-devices=2 UUID=728311df:5491265a:29de2fa5:a1042914
> ARRAY /dev/md2 level=raid1 num-devices=2 UUID=37bd8c5a:9e7efc91:e7537d56:b56c8eef devices=/dev/hda6,/dev/hda5,/dev/hde6,/dev/hde5,/dev/sdd1,/dev/sda1 spare-group=group1
> ARRAY /dev/md3 level=raid1 num-devices=2 UUID=01bc8c7b:c3eb887e:79eb423d:bd46305f devices=/dev/sde1,/dev/sdb1 spare-group=group1
> ARRAY /dev/md4 level=raid1 num-devices=2 UUID=72fe4455:cc7965b5:4fe2f4d0:2a5523ce devices=/dev/sdf1,/dev/sdc1 spare-group=group1
> ARRAY /dev/md5 level=raid0 num-devices=3 UUID=c1565e2b:12c85143:d2fcffa2:12791897 devices=/dev/md2,/dev/md3,/dev/md4
> 
> Doing a "mdadm -A /dev/md5" I get:
> 
>    mdadm: no devices found for /dev/md5
> 
> md5 should be the raid0 consisting of the three raid1's (md2, md3, md4).
> What am I doing wrong?

You need

    DEVICE /dev/md?

or similar in mdadm.conf
(and you probably don't want the devices= entries at all).


NeilBrown
