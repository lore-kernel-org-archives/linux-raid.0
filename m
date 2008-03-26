From: bressen@mirror.to (Andrew K. Bressen)
Subject: Re: uuids missing
Date: Wed, 26 Mar 2008 17:03:03 -0400
Message-ID: <0qprth19mg.fsf@lanconius.mirror.to>
References: <0q3aqd3i9p.fsf@lanconius.mirror.to> <47EA7AA4.4050305@tmr.com>
	<0qy7851fzk.fsf_-_@lanconius.mirror.to> <47EAA789.2030901@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47EAA789.2030901@tmr.com> (Bill Davidsen's message of "Wed, 26
 Mar 2008 15:44:09 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


To recap config:
md0, a  60MB unused raid on hda1 and hdc1
md1, a 300GB raid with root fs on hda2 and hdc2

/dev/sde, not a raid disk. It used to be a raid disk, but went through
repartition, pvcreate, and had a bunch of lv's made on it. 
The system doesn't try to assemble it into a raid device. 

With sde on motherboard controller (as hdb or hdd), 
initramfs crashes trying to mount it as root. 

With sde in a usb shoebox (sde), system boots fine, 
including starting & mounting volumes on sde. 

blkid shows a uuid for hda1 and hdc1 and md0
mdadm shows a uuid for md0 that is _different_ from the uuid reported by blkid

Why on earth would mdadm uuid's and blkid uuid's differ on an md device? 

blkid does not show a uuid for hda2 and hdc2 and md1; what the heck? 
mdadm shows a uuid for md1.

Why doesn't blkid show uuid's for these devices? 

blkid does not show a uuid for sde1
that doesn't seem odd since it is not raid'ed.
pvscan does show a uuid for sde1, which makes sense since the pv
probably has it's own uuid. 

I do not believe I am using the old raidtools.

> You *might* find joy through changing the partition type of the old
> disk if it's old self-assembling raid. Maybe retype it from fd (Linux

Disktype is linux, and I also tried it as type swap. 
I can  try it as lvm later, but if it initramfs tried to mount
a swap disk as root, I suspect partition label doesn't figure
in to this. Though I certainly could be wrong on that. 

>> So the old disk, the root raid partitions, and the md device for root,
>> all have no uuids. How do I add them? Did they used to be there
>> and need to be recovered from someplace?

> No, I would worry about changing it now, maybe Neil has a clue what's
> safe. For now let's see if the partition type change fixes things.

  --thanks for the continued thoughts!
  --akb

