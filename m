From: Another Sillyname <anothersname@googlemail.com>
Subject: Re: Installing Linux directly onto RAID6 Array...........
Date: Tue, 26 May 2015 14:18:40 +0100
Message-ID: <CAOS+5GH-2ueJj+1A6gtNPQBP96Fm2WeUnMqZ2Fdw-EfbUN8daA@mail.gmail.com>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com>
	<555294A0.6040703@websitemanagers.com.au>
	<CAOS+5GEP6+7OAHkqQjeyGHAB5u-_-Vq2JWGpcOemYHdCjmR5Lg@mail.gmail.com>
	<CAOS+5GHKwQRPfNAw0EpSjjDUt=9PmjjrkUg+dhGxFS+uOWWVug@mail.gmail.com>
	<alpine.DEB.2.02.1505241032210.9487@uplift.swm.pp.se>
	<CAOS+5GEZN5d41tGxN+PP6S3ynSWnrXaNK+27rxJyXa-zw1KFaw@mail.gmail.com>
	<20150526182933.52c6c37e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150526182933.52c6c37e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Excepting that by incorporating the mdadm.conf into the initramfs I
don't need to assemble the manually array as the information is
already there.  I don't have to risk a superblock overwrite as you go
on to state as I already have the mdguid info......anyway I'm not
certain my way will work....that's the point of doing the testing.


On 26 May 2015 at 09:29, NeilBrown <neilb@suse.de> wrote:
> On Sun, 24 May 2015 10:08:59 +0100 Another Sillyname
> <anothersname@googlemail.com> wrote:
>
>> I suspect you're correct in that I'll end up with the boot partitions
>> being in RAID1 and the data in RAID6, however I am seriously
>> considering having the boot in RAID6 as well...if I can integrate the
>> mdadm.conf into the initramfs properly I can't see a reason not to do
>> this?
>
> mdadm.conf is largely a non-issue.  You don't need an mdadm.conf to assemble
> your array.  All the raid configuration lives in the raid metadata.
> All you need is for your initrd to know what device contains your root
> filesystem (preferably by UUID) so that when mdadm finds that array, the
> initrd code can mount it for you.
>
> I believe that GRUB2 can load an initrd and kernel from a filesystem on an
> mdraid device, but I don't know where the boot sector would load GRUB2 from.
>
> md's v1.2 metadata leaves 4K at the start of each device.  If GRUB2 fits in
> there, then it could certainly load, assemble the RAID6, then pull the files
> off your root filesystem.  But I doubt it.
>
> If GRUB tries to put the boot loader anywhere else, there is a good chance
> that md could over-write it, as it believes that it owns all the space after
> 4K.
>
> According to the documentation, GRUB2 either places the second stage in the
> first 32K before the first partition, or in the filesystem at specific block
> locations.
> The first cannot work if md uses the whole device (works fine if md uses
> partitions).
> The second cannot work with RAID6 as the blocks are in locations on one
> device.  This only really work for RAID1.
>
> So feel free to try, and do report any results, but I doubt you'll get it to
> work reliably.
>
> NeilBrown
>
>>
>> Had a look at the metadata=0.9 option but reading the info on mdadm
>> metadata I think I'd prefer to have the metadata at the start of the
>> drive, also it looks like metadata=1.2 has extra functionality that I
>> may want to use later.
>>
>> On 24 May 2015 at 09:36, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
>> > On Sun, 24 May 2015, Another Sillyname wrote:
>> >
>> >> So I now have 5 partitions.
>> >>
>> >> a  -  bios_boot
>> >> b  -  efi
>> >> c  -  boot
>> >> d  -  root
>> >> e  -  swap
>> >>
>> >> I'll be adding one more when I'm happy this is working.
>> >>
>> >> f  -  home
>> >>
>> >> 3.  Using the methods above I have now created a bootable fedora
>> >> system, on a single drive in preparation to now RAID the required
>> >> partitions.  However my concern comes regarding the mdadm metadata,
>> >> simplistically metadata=1.2 apparently writes it's superblock to 4k
>> >> after the start of the device, this is exactly where my efi partition
>> >> (b above) starts, so my concern is will this superblock overwrite or
>> >> mess with my current partition table?
>> >>
>> >> 4.  If the next stage works then I think what I'll actually end up
>> >> doing is......
>> >>
>> >> scrub what I have now.
>> >>
>> >> create the arrays before running the Fedora Live installer (this
>> >> assumes the installer will see /md[x] devices and allow them to be
>> >> used to install to). Then incorporate the mdadm.conf data into the
>> >> initramfs and regenerate initramfs.
>> >>
>> >> Ideas/Thoughts/Criticisms?
>> >
>> >
>> > You don't want to run MD on the entire drive in this case, you most likely
>> > want to create multiple RAID1 and RAID6 mirrors. RAID1 your boot, root and
>> > swap, then run RAID6 on your home partition. Use use superblock type that
>> > creates the superblock at the end for the RAID1 partitions.
>> >
>> > Also, you don't want to refer to "sda" when booting, you want to use
>> > UUID=<uuid> in fstab, crypttab etc.
>> >
>> > --
>> > Mikael Abrahamsson    email: swmike@swm.pp.se
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
