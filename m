From: Dmitrijs Ledkovs <xnox@debian.org>
Subject: Re: Prevent Autodetection
Date: Tue, 11 Jun 2013 11:34:21 +0100
Message-ID: <CANBHLUiMrt2CDxjVwwTmFS-W9+vZc6vOBHPW6PjFqOZv_egWeA@mail.gmail.com>
References: <1370943382.26636.39.camel@watermelon.coderich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1370943382.26636.39.camel@watermelon.coderich.net>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Laager <rlaager@wiktel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

On 11 June 2013 10:36, Richard Laager <rlaager@wiktel.com> wrote:
> I have a virtualization host running on an MD root filesystem. I also
> have two whole disks allocated to a virtualized guest which is doing an
> MD RAID1. The host is seeing the array (i.e. it shows up
> in /proc/mdstat). I'd like to prevent this, if for no other reason than
> if there's a problem with that array, it prevents (or at least delays)
> booting the host.
>
> I've tried setting "AUTO +1.x homehost -all" "AUTO homehost -all" and
> even "AUTO -all" in /etc/mdadm/mdadm.conf. I'm updating the initrd and
> rebooting after each change. I've tried "msdos" as well as GPT labels on
> the disks used by the guest. In every case I've tried, it's still
> imported.
>
> I'm running Ubuntu 12.04 "Precise" on both the host and the guest.
>
> $ uname -a
> Linux HOSTNAME 3.2.0-45-generic #70-Ubuntu SMP Wed May 29 20:12:06 UTC
> 2013 x86_64 x86_64 x86_64 GNU/Linux
>
> $ mdadm --version
> mdadm - v3.2.5 - 18th May 2012
>
> Does this suggest the initrd scripts are broken on Ubuntu, am I doing
> something wrong, or is it just not possible to prevent this
> autodetection?
>
> Thanks for any insight you can provide!

Please unpack initrd [1] and check mdamd.conf there, as the initramfs
hook may generate mdadm.conf from scratch. [2]
You may want to further adjust mdadm.conf via
/etc/initramfs-tools/hooks to make it the way you need it, and make
your changes persist across kernel/initrd upgrades.

[1] cd `mktemp -d` && gzip -dc /boot/initrd.img-`uname -r` | cpio -ivd
&& cat etc/mdadm/mdadm.conf
[2] see /usr/share/initramfs-tools/hooks/mdadm

Regards,

Dmitrijs.
