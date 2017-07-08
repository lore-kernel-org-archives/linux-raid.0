From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: My MD is too big to resize ext4.
Date: Sat, 8 Jul 2017 13:12:11 -0500
Message-ID: <ae47b321-07d1-2157-c217-844447e51ce2@gmail.com>
References: <6c827d07-19d8-017b-ca95-5e6f84b7821a@gmail.com>
 <20170708065040.GA3682@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170708065040.GA3682@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/08/2017 01:50 AM, Andreas Klauer wrote:
> On Fri, Jul 07, 2017 at 07:41:13PM -0500, Ram Ramesh wrote:
>> On the web, I only found one solution that required upgrading kernel to
>> some very recent one (not in my distro) and getting the bleeding edge
>> resize2fs. This makes me nervous. Is there a solution that avoids this.
> Well, if that works nowadays, then just go for it (LiveCD).
> For details you should ask the ext4 mailing list I guess.
>
> You can assemble your RAID in read-only mode and then use
> overlays for a non-destructive test run. To make really extra sure
> you could even export it via NBD/KVM to see if the old kernel
> is able to mount it.
>
> IIRC, btrfs also has a migration path (ext4 to btrfs converter)
> and then you could grow that. But then you're stuck with btrfs.
>
>> My filesystem is on md0 drive so I guess partitioning and making into 2x
>> 12TB ext4 will not work. I am not even sure if we can partition md like
>> any other disk.
> Adding a partition table or LVM header would shift the start position.
> So it would involve moving/shifting all your data in-place or using
> a conversion to LVM. (We just had that in the thread above yours,
> subject "linear device of two arrays")
>
> If your RAID has a large enough data offset, you could shift that
> to add some extra space at the start of the RAID, but it has to
> be done with great care (must be aligned to whatever your RAID
> layout is so data will be intact and not garbled).
>
> All in-place operations are kind of hackish/dangerous.
>
> I actually prefer using several smaller filesystems over one gigantic one.
> It's all great until your one and only filesystem goes corrupt.
>
> Regards
> Andreas Klauer

Thanks. After thinking a bit more, I also like several smaller ext4/mds 
than large one. Since this is a mythtv machine, it can share multiple 
mount point and distribute data smartly (in its own sense).

In order to create several md devices out of the 6x6TB drives I have, I 
have to do the following. Let me know if this sounds possible.

    1. My MD uses partitions sd{b,c,d,e,f,g}1 instead of full disks. So 
I can create partitions on the drive instead of on the MD.
    2. This means I need to shrink my current md device to smaller size 
(say 12TB-14TB) - need to check my current
          active ext4 data size. It is definitely less than 16TB.
    3. Repartition the disks to create sd{b-g}2 for the reamining unused 
6xnTB area.
    4. Created md1 with sd{b-g]2 to get md1.
    5. Mount and use md1.

Do you see every step here reasonably safe to try on a 
unmounted/readonly md disks.

Ramesh
