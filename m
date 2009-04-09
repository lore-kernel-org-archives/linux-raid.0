From: "Steven Ellis" <steven@openmedia.co.nz>
Subject: Re: Can't resolve mismatch_count > 0 for a raid 1 array
Date: Thu, 9 Apr 2009 12:13:14 +1200 (NZST)
Message-ID: <56400.60.234.49.2.1239235994.squirrel@webmail.stevencherie.net>
References: <F87E9034-BDD7-4D74-8117-3ED1884D4165@openmedia.co.nz>
    <49DD1C36.1000306@tmr.com> <20090408220042.GA30278@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090408220042.GA30278@teal.hq.k1024.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Thu, April 9, 2009 10:00 am, Iustin Pop wrote:
> On Wed, Apr 08, 2009 at 05:50:46PM -0400, Bill Davidsen wrote:
>> Steven Ellis wrote:
>>> I've resolved most of my raid issues by re-housing the affected system
>>> and replacing the motherboard, but across the 3 boards I've tried I
>>> always have an issue with my /dev/md1 array producing mismatch_count
>>> of 128 or 256.
>>>
>>> System is running Centos 5.2 with a Xen Dom0 kernel
>>>
>>> This md1 volume is a pair of 40GB HDs raid1 on an IDE controller which
>>> I them have a bunch of LVM's that are my Xen guests.
>>>
>>> Is there any chance that these mismatch_count values are due to swap
>>> partitions for the Xen guests?
>>
>> That's the cause, and since md code doesn't currently have a clue which
>> copy is "right" it's always a problem if you do something like suspend
>> to disk. You probably don't do that with xen images, but swap and raid1
>> almost always have a mismatch.
>
> But only because (for non-xen guests) the raid1 code and the swap code /
> data live in the same address space, and could be changed in between the
> two writes.
>
> I would be surprised if this happens for xen guests, where the address
> space is not shared; once the xen guest initiates a write, dom0 gets the
> data and writes it from its internal buffer, not the domU's one which
> could be modified.
>
> At least, that's how I think things happen.

The box has 5 Raid arrays

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md3 : active raid1 sdb1[0] sda1[1]
      976759936 blocks [2/2] [UU]

md0 : active raid1 hdb1[0] hda1[1]
      128384 blocks [2/2] [UU]

md4 : active raid1 hdb2[1] hda2[0]
      522048 blocks [2/2] [UU]

md2 : active raid5 hdh1[3] hdg1[2] hdf1[1] hde1[0]
      732587712 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md1 : active raid1 hdb3[0] hda3[1]
      38427392 blocks [2/2] [UU]

unused devices: <none>

md4 is the swap partition for the Xen Server, and md0 is the boot
partition. Neither of these have any issues.

md2 is a raid5 set that also hasn't been reporting any issues.

md3 is a new SATA based raid1 set that I had some issues with when using a
different motherboard, but doesn't produce any errors no even under
serious load.

md1 contains the root file system for my Xen server, plus the root + swap
partitions for my various Xen guests. This is the volume that is
generating the mismatch_count errors.

Now most of my Xen guests are presented with two LVM allocated partitions
out of md1, eg guest_root and guest_swap.

I do have an exception to this for one guest where I present a single LVM
partition as a virtual HD to the guest which then manages the
swap/root/home partitions itself.

I'm wondering if this presentation of a partition as a disk is the issue.

Steve



--------------------------------------------
Steven Ellis - Technical Director
OpenMedia Limited - The Home of myPVR
email   - steven@openmedia.co.nz
website - http://www.openmedia.co.nz
