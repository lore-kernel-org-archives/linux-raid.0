From: Ed W <lists@wildgooses.com>
Subject: Re: Software raid, booting and bios
Date: Sat, 21 May 2011 20:57:43 +0100
Message-ID: <4DD81937.1050701@wildgooses.com>
References: <9067914580344941270@unknownmsgid> <ir58vs$9qp$1@dough.gmane.org> <4DD6BD65.7020702@wildgooses.com> <4DD7EF40.1030506@vandervlis.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD7EF40.1030506@vandervlis.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Paul van der Vlis <paul@vandervlis.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi


>> The only other option that I think the big hosting guys use is to have a
>> netboot setup which boots everything and can also offer rescue images,
>> etc.  Beyond my skills to setup for my meagre number of servers, but if
>> you have more than a couple of machines this could be a very good solution?
> 
> I don't have much machines, but I have my own IPv4 range.
> So it is possible.

You don't actually need any range to make netboot work (kind of).  Bear
in mind I have never done this... But you arrange for netboot to boot
from some internal server and in fact try and use your firewall to stop
the machines being visible to the outside world during this process
(think about various ways you can netboot to say some 192.168.x.y range
and if required say bounce ssh off some other machine to your server in
rescue mode (I just use the IPMI port so I don't need the machine to
have any working network access at all)

>> For my needs the USB stick option is perfect
> 
> I will think about it. A little disadvantage is that it's not so easy to
> have access to the USB stick maybe (you have to open the machine).

Why would you ever need to access the USB stick?

As several other people already said - NOT being able to access it is a
bonus.. I would recommend superglue/cable-ties if you can't put the
stick inside the machine...

>> Sysrescuecd suits me because all my servers are gentoo based - clearly
>> it will work for other distros also, but you might want to evaluate
>> other rescue distros before choosing one?
> 
> I use Debian, so I think I would choose a Debian-based rescue system.

Sure - but don't get too bogged down in the source distro.  Sysrescuecd
will have a bang up to date set of binaries, likely far newer than those
on your live debian machine.  It's really a question of whether that's a
benefit or liability...

For any work on the machine you simply chroot into the live machine and
then you are using all identical binaries (in fact the live machine) and
so really all you need is a boot environment which will support your
chosen raid/lvm/cpu architecture

> 
> What still a question is for me:
> Is it better to put /boot on such an usb-stick or only the MBR?

Why pick only one?

I use a small raid 1 partition for /boot which mirrors across all 4
disks in my 1U servers.  I try and install boot sectors on all drives so
I could in theory boot off any disk

Then I customise my sysrescuecd bootloader menu to
- boot the USB stick,
- rebuild the grub bootsector
- Boot drive 1
- Boot drive 2
- ...

For icing you could backup the /boot from the disks onto the USB stick,
but I haven't done that since it can be easily rebuilt (it's just the
kernel, grub boot files and grub.conf)


> Grub2 can boot from lvm/raid, and when I would have /boot on disk I can

I don't see any reason to deviate from the "small raid 1 boot partition"
idea.  Needs only grub1 and no special handling?

> have an MBR on disks too (for the case the usb stick would fail).

I would suggest you boot from the disks first and set your USB stick as
the failover boot drive, and make sure it's boot menu picks to boot from
say disk2 as the default option?  This covers you for the case that
someone pinches disk1 and reboots the machine, but your normal process
of maintaining the boot partition on the local disks holds

The USB drive then remains read-only, so no chance to bugger it up
accidently and you can churn out dozens for a tiny budget and re-use
them for quite some years

I can think of few downsides assuming you figure out how to make the
blasted things boot (not always easy) and can fit them inside the server
or similar?

> But difficult for me to understand that things like the initrd comes
> from a software raid....

Just don't make the boot process complicated...

I'm a ludite, I build my kernel with everything needed to boot builtin,
therefore no initrd needed (unless you want root on an md partition
that's not 0.90 format?).  I can't cope with rebuilding initrds and all
that jazz...   Now you can just update bzImage to update, plus you can
boot from any disk without treating it as raid at all (it's read only,
so with a 0.90 raid format you can use disks individually with GRUB -
mount them as a raid1 to modify them and they all stay in sync)

Easy peasy

> Another way would be make a /boot on a raid1 with 3 devices: the
> harddisks and the USB stick.

I just don't see that /boot is that precious?  You probably have the
same info on every single other server you own (assuming you build same
kernels on all).  Raid1 it across all your drives, then all you need is
the "boot sector" to be copied to more than one place and you do that by
copying it to all drives, plus having a bootable USB drive.

Remember a bootable disk (say USB) can then boot the /boot partition
from any other disk.  All you are trying to do is get to the point that
grub (etc) is running and shows you some menu of choices (and picks
sensible default choices) - the rest is easy

I think you are probably not seeing how simple this really is?  Have a
read through the above again if you still think you need custom USB
sticks or some complex raid1 scenario?  It should just work very simply
and even with limited bios options, as long as you can boot from one
disk and one USB stick then you have a failover

Good luck

Ed W
