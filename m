From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: md extension to support booting from raid whole disks.
Date: Mon, 27 Apr 2009 17:08:22 +0200
Message-ID: <87hc0axhg9.fsf@frosties.localdomain>
References: <1240574900.4507.2076.camel@ezra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1240574900.4507.2076.camel@ezra> (Daniel Reurich's message of
	"Sat, 25 Apr 2009 00:08:20 +1200")
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Daniel Reurich <daniel@centurion.net.nz> writes:

> Hi,
>
> I have got linux successfully booting from a raid5 whole disk set with /
> & /boot filesystems on that raid5 disk set.  This is possible thanks to
> grub2 (with some hacking to make it install correctly.)
>
> The downside I found is that the system won't boot if the 1st disk is
> missing, as that contains the boot sector and core.img that grub
> requires to boot.  The linux kernel also get unhappy about the partition
> table of the first disk saying the volume is larger then the geometry of
> the physical first disk.
>
> I was wondering if it was worth extending the md superblock to make it
> easier for booting raided whole disks.  There are several ideas I had
> thought of that would make this achieveable:

Or grub2 could be thought to install itself into all MBRs of all
drives in a raid set.

> A first cylinder which needs to be mirrored across all the devices.
> This would be for the Volume/Master Boot record + Boot Sector Code.
> Grub2 bootsector + core.img should fit in here at (or least enough of it
> to bring grub up with the appropriate raid drivers.)
>
> We could include a dummy partition table with the whole disk in the 1st
> partition labeled as something like linux-raid (0xfd) or Non-FS data
> (0xda).
>
> The second cylinder has the md superblock and write intent bitmap, and
> the raid volume starts at the beginning of the 3rd cylinder.
>
> This would allow for this scheme to work with booting of all whole disk
> raid arrays of all levels using grub2, without any significant changes
> required in grub2.

That part I really like. I'm just not sure how complicated the code
for this would be compared to teaching grub2 to handle this case
itself.

> Thanks for the awesomeness that is linux software raid.

MfG
        Goswin
