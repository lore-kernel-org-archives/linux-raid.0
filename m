From: "NeilBrown" <neilb@suse.de>
Subject: Re: zeroing superblocks on running systems
Date: Sun, 9 Nov 2008 07:27:22 +1100 (EST)
Message-ID: <c02075aed88c4e7e7bdf30a31cff0418.squirrel@neil.brown.name>
References: <20081108192716.GA16878@piper.oerlikon.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081108192716.GA16878@piper.oerlikon.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@madduck.net>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, November 9, 2008 6:27 am, martin f krafft wrote:
> Hi folks,
>
> I just pulled up a new machine and initially had /dev/sd[ab] as the
> source of a giant md device to serve as physical volumne in an LVM2
> volume group, but then grub2 didn't managed to obtain my trust and
> I created /dev/sd[ab]1 as /boot and /dev/sd[ab]2 for the md device
> instead.
>
> Unfortunately, I forgot to zero the superblock on /dev/sd[ab], so
> now when I call mdadm -Es, it tells me about three arrays, when
> I really only have two.
>
> But I also cannot zero the superblock while the machine is running:
>
>   khyber:/boot# mdadm --zero-superblock /dev/sda
>   mdadm: Couldn't open /dev/sda for write - not zeroing

It cannot open the device because it uses O_EXCL, and the device is in
use.
You could grab a copy of the mdadm source, replace every O_EXCL to 0

   sed -ie 's/O_EXCL/0/' *.c

then compile and run that code.  It should be able to zero the
superblock for you.
It only zeros a block that still looks like a superblock, so if the
filesystem has used that block already, it won't do anything.
This is still a tiny race - the filesystem could write to the block
between mdadm checking that it was still a superblock, and writing out
the zeros.  I suspect you are more likely to bit hit by a meteorite
though.

Do we want '--zero-superblock-die-die-die' which would avoid the
O_EXCL for you?  We cannot use "--force" as that means "write zeros
even if it doesn't look like a real superblock".
.... though I'm not really sure that is useful to keep.

NeilBrown



>
> I cannot take it down. Is there any other way in which I could
> destroy the obsolete superblocks on /dev/sd[ab]?
>
> Thanks,
>
> --
> martin;              (greetings from the heart of the sun.)
>   \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
>
> review of a chemistry paper:
>   "paper should be greatly reduced or completely oxidized."
>                                                     -- frank vastola
>
> spamtraps: madduck.bogus@madduck.net
>

