From: Michal Soltys <soltys@ziu.info>
Subject: Re: Create software RAID from active partition
Date: Mon, 01 Sep 2008 22:03:09 +0200
Message-ID: <48BC4A7D.8020907@ziu.info>
References: <c8ce53500809010532h5444a8cckcb1d2cb57d3dc281@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c8ce53500809010532h5444a8cckcb1d2cb57d3dc281@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Guyver <michael.guyver@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

What do:

mdadm -E /dev/sda1
mdadm -E /dev/sdb1
mdadm -E /dev/sda2
mdadm -E /dev/sdb2

show, if anything ?

If they report they belonged once to an array with superblock positioned 
at the end (so either 0.9 or 1.0), you could create RAID1 array missing 
one component. In your case, something like:

umount /dev/mapper/VolGroup00-LogVol00
umount /dev/mapper/VolGroup00-LogVol01
vgchange -an VolGroup00

mdadm  -C /dev/md/1 -l1 -n2 -e0 /dev/sdb2 missing

-e0 assuming it was v0.9 superblock
-e1.0 assuming it was v1.0

and then:

mdadm /dev/md/1 --add /dev/sda2

..wait for resync, then:

vgscan --mknodes
vgchange -ay

..should use /dev/md/1 - but  doublecheck /etc/lvm/lvm.conf as well.


Of course it's potentially risky, so doublecheck everything and if it's 
possible somehow (considering remote location), backup /dev/sdb2 first 
(actually, you could use /dev/sda2 for that, as it's unused at this 
moment anyway).


/dev/sd{a,b}1 case will be difficult w/o physical access, if they were 
part of another raid1 array.
