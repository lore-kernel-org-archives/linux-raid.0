From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Re: Best tool to partition Drives with new sector geometry - (WAS:
 Need Help with crashed RAID5 (that was rebuilding and then had SATA error on
 another drive))
Date: Sun, 18 Sep 2016 16:29:39 -0500
Message-ID: <03f24dac-c34b-31d0-a514-0d9c99e07fd2@gmail.com>
References: <CADDTLRB9z6J0F6+uO3k-u74qnjZxiagbNLWrg_tP5GSZt-Vd5A@mail.gmail.com>
 <57BBDA5B.3020706@gmail.com> <57BBDC15.5030301@gmail.com>
 <b8c6a380-7e6a-fda9-5834-b85271b26892@websitemanagers.com.au>
 <57BC61F7.8070102@gmail.com>
 <aca4e83f-9a3f-c200-7c16-3b5d9df52c1e@websitemanagers.com.au>
 <57BE450B.4030700@gmail.com>
 <56e86db5-456d-e9c1-339d-ba8903fe5dde@websitemanagers.com.au>
 <57BE52BC.6040908@gmail.com>
 <933228e0-bce4-ffad-f48d-034bf89bc07f@websitemanagers.com.au>
 <57BF9965.1020403@gmail.com> <57C0856D.8050209@youngman.org.uk>
 <57C32D8E.9030102@gmail.com>
 <3b008fb0-1fb3-f12f-d973-3657de6e6923@websitemanagers.com.au>
 <57C38EF5.7020005@gmail.com> <57C41A47.5050506@youngman.org.uk>
 <e6180f36-f246-b4ad-ef53-8012e583b09e@gmail.com>
 <CAJCQCtQAazjCmXfSgbcJNDxtM2pHRcqbmEo1j=Og-dQRPEAzaQ@mail.gmail.com>
 <484e25ca-0a8e-f666-b1c8-ebc92a49f999@gmail.com>
 <57DEE853.4060001@youngman.org.uk>
 <4e08d03d-6759-84fd-6467-3bb2d1d9d320@gmail.com>
 <57DF055E.9060102@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57DF055E.9060102@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/18/2016 04:21 PM, Wols Lists wrote:
> On 18/09/16 20:58, Benjammin2068 wrote:
>> Aha! That's what I needed to know.
>>
>> I was wondering if I can make a partition (I think) that's 3/4 of a block larger (3072bytes) than the original /dev/sdX1's on the old HD103SJs drives.
> Good. It's a bit like string logic - if the buffer is bigger than the
> string everything's fine, but if the string is bigger than the buffer,
> well, ooopppssssss.
>
> Basically, I think the root cause of all this mess is that drive
> sectors/blocks/whatever used to be 512 bytes. So, obviously, it made
> sense to have sector 0 be the boot sector, and your first partition
> started in sector 1. If your drives are small, you don't want to waste
> space.
>
> Then the new drives came along with 4K sectors. Aarghh. Put an old-style
> partition scheme on a new-style drive, and every OS 4K block would start
> in the 2nd 512-byte block of a 4K drive sector. So every disk write from
> the OS would force the drive to read two sectors from disk, overlay the
> OS block over them, and write them both back. Not nice. And the latest
> drives refuse to do that!

hah.. yea.. I remember when it happened (and why). (I still have a seagate ST-251 40MB MFM HD sitting in a box with my Atari software on it. Right  now, it's Schrodinger's drive. It still working as long as I don't pull it out and test it. LoL....)

Drive companies claimed (and maybe rightfully so) that the 512B sector with all the seeks required to read data was wasteful. (considering the armature movement needed for scattered files and people who didn't defrag their drives.)

Also, the number of sectors that could be numbered on a drive was an issue with the sizes of drives coming out.

a 2^32 sectors @ 512bytes = 2,199,023,255,552 <-- doesn't that number ring a bell. ;)

So they moved to bigger sector sizes.

> Which is one of the reasons why modern partitioning programs start the
> first partition - iirc - at the start of the 3rd megabyte of the disk.
> Leaving plenty of space for the boot/startup code.

Yup. Now with all the bootloaders...

>
> So it's not worth replicating your old partitions directly on the new
> drives. Just make sure the new drives are the same size (or a bit
> larger) than the old ones, and move the data across. Bit like copying a
> string :-)

Sounds good. I was more worried about the specifics of the partition and how mdadm sees a larger sized partition -- NOT just a larger sized drive. (on which a same size partition could be built)

Thanks again,

 -Ben


