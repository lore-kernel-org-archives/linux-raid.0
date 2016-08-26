From: Chris Murphy <lists@colorremedies.com>
Subject: Re: bootsect replicated in p1, RAID enclosure suggestions?
Date: Thu, 25 Aug 2016 21:21:30 -0600
Message-ID: <CAJCQCtRwF1XCNQRxibFGZ0SVQ8=RKo1birv5ZWZBvZGpuu0ndQ@mail.gmail.com>
References: <20160823050947.GL32250@subspacefield.org> <CAJCQCtSY=D-ASQ22km8GJjfju4jUgJSOBTAH5+XveCZq1BvT7w@mail.gmail.com>
 <20160825062501.GN32250@subspacefield.org> <CAJCQCtSWOwf6pHD2O7CtaNwF4BDbHO+hh7XrXpcaRsqPkvmFrQ@mail.gmail.com>
 <20160826025012.GO32250@subspacefield.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160826025012.GO32250@subspacefield.org>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Aug 25, 2016 at 8:50 PM,  <travis@subspacefield.org> wrote:

>
>> So I'd say it's something else.
>
> Do you have any idea what that could be?

User error, you even suspect it yourself later...



> In fact, I decided to grep around for /dev/sdd1 and /dev/sde1 which seem
> to get trounced (but not /dev/sd[bc]1) and what do you know:
>
> # grep -R /dev/sde1 /etc/
> /etc/lvm/cache/.cache:          "/dev/sde1",
>
> That certainly looks promising.  I wonder if you just solved my problem
> without hardware upgrade.

That just contains a listing of LVM devices, I don't think that's
related to this problem.




>> > I've certainly encountered this "GPT outside cylinder 0" on these two
>> > drives before,
>>
>> Keep in mind cylinders are gone, they don't exist anymore. Drives all
>> speak in LBAs now. *shrug* The GPT typically involves LBAs 0, 1 and 2
>> at least, more if there are more than 4 partitions.
>
> Shorthand for "before partition 1".

Unreliable. By convention most tools used to start it at LBA 63 which
*was* based on CHS, but that's the Pleistocene (again). It's been many
years, maybe nearing a decade, since a tool would default to that.
First, 62 sectors isn't big enough to embed a bootloader these days.
Second, it's not 4096 byte aligned for 4K sector drives, which now
pretty much every hard drive is, except some higher end SCSI/SAS
drives come with the option of 512 byte physical sectors still. But
these are quickly vanishing. Macs typically start the first partition
at LBA 40, and on Windows and Linux these days it's usually LBA 2048
(1MiB gap to the first partition).



>
>> I don't recognize the above stuff, so I'm not sure what it is. I'd
>> usually expect it to be zeros if it's not a boot drive.
>
> It was used as a raw disk in an encrypted RAID before.

OK



>> It is common. I prefer gdisk, which has a nomenclature similar to
>> fdisk. The nomenclature of parted is confusing.
>
> I think somewhere in learning parted and repartitioning all the disks,
> I managed to type /dev/sdX1 instead of /dev/sdX when creating the
> partitions.

Bingo. That would do it.

The thing to get in the habit of when retasking anything, be it a
drive, a partition, or logical volume:

1. Tear down with wipefs -a from most recent structure created (file
system) to the first; or
2. Full disk encryption. If you merely luksFormat, you've obliterated
all the previous signatures, effectively, so no need for a tear down;
or
3. hdparm ATA secure erase; or
4. write zeros with something like badblocks.


-- 
Chris Murphy
