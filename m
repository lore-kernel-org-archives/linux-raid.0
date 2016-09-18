From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Best tool to partition Drives with new sector geometry - (WAS:
 Need Help with crashed RAID5 (that was rebuilding and then had SATA error on
 another drive))
Date: Sun, 18 Sep 2016 22:21:34 +0100
Message-ID: <57DF055E.9060102@youngman.org.uk>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4e08d03d-6759-84fd-6467-3bb2d1d9d320@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjammin2068 <benjammin2068@gmail.com>, Chris Murphy <lists@colorremedies.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 18/09/16 20:58, Benjammin2068 wrote:
> Aha! That's what I needed to know.
> 
> I was wondering if I can make a partition (I think) that's 3/4 of a block larger (3072bytes) than the original /dev/sdX1's on the old HD103SJs drives.

Good. It's a bit like string logic - if the buffer is bigger than the
string everything's fine, but if the string is bigger than the buffer,
well, ooopppssssss.

Basically, I think the root cause of all this mess is that drive
sectors/blocks/whatever used to be 512 bytes. So, obviously, it made
sense to have sector 0 be the boot sector, and your first partition
started in sector 1. If your drives are small, you don't want to waste
space.

Then the new drives came along with 4K sectors. Aarghh. Put an old-style
partition scheme on a new-style drive, and every OS 4K block would start
in the 2nd 512-byte block of a 4K drive sector. So every disk write from
the OS would force the drive to read two sectors from disk, overlay the
OS block over them, and write them both back. Not nice. And the latest
drives refuse to do that!

Which is one of the reasons why modern partitioning programs start the
first partition - iirc - at the start of the 3rd megabyte of the disk.
Leaving plenty of space for the boot/startup code.

So it's not worth replicating your old partitions directly on the new
drives. Just make sure the new drives are the same size (or a bit
larger) than the old ones, and move the data across. Bit like copying a
string :-)

Cheers,
Wol
