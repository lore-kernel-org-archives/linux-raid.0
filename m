From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: md extension to support booting from raid whole disks.
Date: Fri, 01 May 2009 23:33:35 +0200
Message-ID: <87d4asld8w.fsf@frosties.localdomain>
References: <1240574900.4507.2076.camel@ezra>
	<87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com>
	<e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>
	<1240957153.18303.689.camel@ezra>
	<18935.35747.471257.202356@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18935.35747.471257.202356@notabene.brown> (Neil Brown's message
	of "Wed, 29 Apr 2009 09:05:07 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Daniel Reurich <daniel@centurion.net.nz>, Dan Williams <dan.j.williams@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> On Wednesday April 29, daniel@centurion.net.nz wrote:
>> On Tue, 2009-04-28 at 11:24 -0700, Dan Williams wrote:
>> 
>> > 
>> > ...or use a metadata format that your platform bios understands and
>> > provides an int 13h vector.  See the new external metadata formats
>> > supported by the mdadm devel-3.0 branch.
>> 
>> I don't think a metadata format is the right way either.  
>> 
>> What we need is a new version of the superblock with the first cylinder
>> (32kb on 512b sectors x64 sectors per cylinder) being set aside for the
>> bootloader, the superblock and w-i bitmap go in the second cylinder, and
>> the raid data area starting in the 3rd cylinder.  
>> 
>> It should be the bootloaders responsibility to install the bootloader
>> onto the disks 1st cylinder, but md/mdadm would have to replicate it on
>> resync or adding of a new disk.  However we could consider remapping the
>> bootloader 
>
> While I agree with Dan that having a BIOS which understands RAID is a
> good way to make this sort of thing "just work", I would be nice if it
> could work for people without the bios too.
>
> v1.x metadata has explicit knowledge of where the start of the data
> is, so it is quite possible to leave the first few (dozen) sectors
> unused (let's not talk about cylinders this century - OK?).
> So mdadm could grow a --grub flag to use with --create which arranged
> for data/bitmap to not use the first (say) 512 sectors of any device.
> (1.1 and 1.2 would still use reserved blocks for the superblock).
> [I can cut you a patch to experiment with if you like]
>
> grub could then write whatever it wants to write to any of these
> sectors.

Actualy there you touch a verry good point. How is grub supposed to
write the data anyway? Initially I thought the proposal was to have

sda	sdb	sdc	sdd	md0
0       0       0       0       0 (raid1)
1       1       1       1       1
2       2       2       2       2
3       3       3       3       3
..
meta    meta    meta    meta    -
meta    meta    meta    meta    -
64      65      66      xor     64-66 (raid5)
67      68      69      xor     67-69
...

I.e. at the begining of the md0 device there would be a chunk with
raid1 that is also at the begining of the raw devices. Then the
metadata followed by normal raid5 stripes. Grub would then install to
/dev/md0 and get automatically replicated across all disks.

Now I was against that because that seems awfully complicated for the
code and only works with an FS that leaves space for the bootloader.



What you are talking about is just moving the metadata back more (from
the 4k in 1.2 format to 256k or whatever) and starting the raid5 just
a little bit later on the disk. The only change (so far) would be
increasing the offset where to start.

> That only leaves the question of what happens when a spare is added to
> the array - how does the grub data get written to the space on the
> spare.
> I would rather that grub were responsible for this, than for md to
> treat that unused space as RAID1.
> We already have a notification system based on "mdadm --monitor" to
> process events.  We could possibly plug grub in to that somehow so
> that it gets told to re-write all it's special blocks every time
> something significant changes in the array.
>
> NeilBrown

But now, indeed, how does this work with grub? Grub can't write to
/dev/md0 there, that wouldn't be bootable at all. And if grub writes
to /dev/sda then it doesn't get replicated.

I see two solutions for the initial write:

1) grub initialy writes to all component devices (which already exists
   in some bootloaders)
2) mdadm --copy-reserved /dev/md0 /dev/sda
   After grub installs on /dev/sda it tells mdadm to copy the reserved
   block too all devices.

Also 2 solutions for what to do on changes:

A) mdadm --add copies the first 256k to new devices when syncing
   (possibly sparse too.) The reserved 256k would basically become
   part of the superblock. As such --zero-zuperblock would wipe them
   too. I'm assuming bootloaders can live with identical data on all
   devices.
B) Grub register itself as hook so it can trigger a copy comand on any
   significant change. (possibly run option 2 above)


I think options 1+A are easiest for both md and bootloaders to
implement.

MfG
        Goswin

PS: I'm using grub here as example for any bootloader.
