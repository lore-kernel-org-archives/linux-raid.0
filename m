From: akb+lists.linux-raid@mirror.to (Andrew K. Bressen)
Subject: uuids missing
Date: Wed, 26 Mar 2008 14:45:35 -0400
Message-ID: <0qy7851fzk.fsf_-_@lanconius.mirror.to>
References: <0q3aqd3i9p.fsf@lanconius.mirror.to> <47EA7AA4.4050305@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47EA7AA4.4050305@tmr.com> (Bill Davidsen's message of "Wed, 26
 Mar 2008 12:32:36 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Bill Davidsen <davidsen@tmr.com> writes:
> You have stale configuration somewhere which causes the drive to be
> mounted.

I checked uuid's using blkid, I get the following: 

hda1 and hdc1, which are md0, have the same uuid, and md0 its own uuid. 

hda2 and hdc2, which are md1 (rootfs) HAVE NO UUID, nor does md1!
The pv and lv's on md1 do have uuid.

The old disk ALSO has no uuid on its partition (/dev/sde1), 
though it does have them for its pv and lv's. 

So the old disk, the root raid partitions, and the md device for root,
all have no uuids. How do I add them? Did they used to be there
and need to be recovered from someplace? 

(in re questions earlier, 1: I don't use uuid's in my fstab, 
I use /dev/mapper/vgname-lvname, but I don't think that can be relavent 
since the problem occurs in initramfs before the filesystem 
containing the fstab gets mounted. 2: I did not zero
anything on the old drive because I didn't think anything would survive
a repartition, pvcreate, lvcreate, and putting stuff on the drive)

  --thanks much for more clues!
  --akb

