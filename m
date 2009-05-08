From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: md extension to support booting from raid whole disks.
Date: Fri, 08 May 2009 23:50:51 +0200
Message-ID: <87fxff462s.fsf@frosties.localdomain>
References: <20090503013342770.VMBT19475@cdptpa-omta01.mail.rr.com>
	<e13f0e541934a0966f213f6da13d83da.squirrel@neil.brown.name>
	<1241406283.17240.26.camel@ezra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1241406283.17240.26.camel@ezra> (Daniel Reurich's message of
	"Mon, 04 May 2009 15:04:43 +1200")
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Daniel Reurich <daniel@centurion.net.nz> writes:

>> My own "ideal" would be
>>  - simple boot loader in first sector of every drive that loaded a
>>    'second stage' linearly off the early sectors of the disk.
>>  - the 'second stage' is a linux kernel plus initramfs which finds
>>    the root filesystem loads the final kernel and initramfs, and
>>    uses kexec to boot into it.
>> 
> Why not have it boot into the real linux kernel instead of kexec from a
> boot linux kernel into the real one?  This would save the maintenance of

Because the boot kernel is simple with just the disk drivers in it. I
build it once and install it and never have to touch it again.

The real kernel on the other hand is potentially much bigger and will
run under thread of being hacked. It is important to update it
regulary with security fixes or newer versions. When updating it is
crucial to have the old version available as backup. Having a choice
of kernels to boot is crucial.

> a boot kernel as well as the real one.  Even a simple first stage
> bootloader would allow for the selection of between multiple boot images
> if there was enough reserved space to have multiple images available.
> Of course this would require a userspace tool to emebed them.

Ok, how much space? 10MB? 100MB? 1GB? 10GB? I think people would kill
you if you reserve 1GB on their 8GB SSD disks. On the other hand 10MB
would only fit one kernel and initrd if at all. I have a 300MB rescue
system as initrd in my /boot. That would have to fit in the reserved
space too.

Ergo we need 2 stages. One small stage to get access to all the disk
space and present a menu and then boot the real deal from there.

> This whole discussion seems to revolve around where the complexity of
> the boot process should be best located, and the answer this in my view
> atleast.
>
> I have asked whether grub2 also has support to access disks across
> multiple controllers, and the response I got was that grub2 has modules
> for using scsi and ata for disk access, and these can be embedded in the
> stage 1 bootimage, so access to disks across controllers may indeed be
> possible.  I will run some tests myself to see if this is the reality.
>
>> Thus the final stage of the boot loader can understand any filesystem,
>> any raid level, any combination of controllers.
>> 
>> The area that stores the second stage would be written rarely, and
>> always written as a whole - no incremental updates.  So much of the
>> power of md/raid1 would not be necessary.  Having some tool that
>> installed the boot loader and second stage on every bootable device would
>> seem an adequate solution.
>
> But the benefit of md/raid1 of this boot area would be that if the a
> disk that is booted from is out of sync with the others for some reason,
> yet has enough know how to assemble raid1 (even if it's limited to disks
> that are on only 1 controller), and get it's second stage boot image and
> linux kernel etc, off the raid1 volume rather than the boot disk, we
> effectively remove one of the aforementioned modes of failure.

If the system crashes during the installation of the bootloader then
it will 99.99999% not work no matter what you do. The probability that
it crashes just in the moment when disk 1 has finished writing but
disk 2 has not is so miniscule that we can ignore it. If it crashes
while installing the bootloader then you have to installit again from
a rescue medium.

Note that with grub you basically never need to install it a second
time.

>> Whether this space were kept free by traditional partitioning,
>> or by the filesystem or raid or whatever "knowing" to leave the first
>> few meg free is of relatively little interest to me.  I can see advantages
>> both ways.
>> 
> I'd personally like to see the back of the MSDOS v2/v3 style partiton
> tables when it's not required  (and use lvm on a raided whole disk set.
> Both grub2 and linux kexec methods already could do this in theory.
>
>> So I still plan to offer a "--reserve-space=2M" option for mdadm to
>> allow the first 2M of each device to not used for raid data.  Whether
>> any particular usage of this option is viable or not, is a different
>> question altogether.

How exactly would that layout be then?

Block  0   bootblock
Block  1   raid metadata
Block  x   2M reserved space
Block x+2M start of raid data

Like this?

> Would it be better to allow for the creation of a metadata or superblock
> that described the on disk layout ala intel matrix style, so that we
> could have a whole disk raid, which appears as X number of md devices,
> so that one could ask for a layout of 256M raid1 volume + 20G raid10 +
> the rest of the disk as raid5 or whatever takes the users fancy.  I'd
> imagine that this could just be an additional option to mdadm --create.
> This may or may not need a superblock extension that defines the raid
> volumes layout either in the superblock, just a metadata block like one
> would expect from an intel matrix raid or similar 3rd party metadata
> format that the mdadm 3 is said to support.

Wouldn't it be easier to use lvm there and implement the missing raid
levels for the lvm userspace and device-mapper?

MfG
        Goswin
