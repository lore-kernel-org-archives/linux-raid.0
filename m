From: Guillaume Filion <gfk@logidac.com>
Subject: Re: Crooked raid [solved]
Date: Sun, 20 Nov 2005 22:50:11 -0500
Message-ID: <1bd0060a40e1a6e948474946b5e0ebd5@logidac.com>
References: <200511161541.jAGFfBjZ027253@cichlid.com> <437B60B3.5030601@logidac.com> <437BC6F3.5070704@logidac.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <437BC6F3.5070704@logidac.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I finally solved my problem by booting with knoppix and recreating the=20
raid from scratch.

 From memory, the process might have looked like that:
boot with knoppix as single user
mdadm --zero-superblock /dev/hdg2
mdadm --zero-superblock /dev/hdg
mdadm --zero-superblock /dev/hdc2
mdadm --zero-superblock /dev/hdc
mdadm --create /dev/md0 --level 1 --raid-devices=3D2 missing /dev/hdg2
reboot in single user mode with /dev/hdc2 as root
mdadm --assemble /dev/md0 /dev/hdg2
mount /dev/md0 /mnt/md0 [mkinitrd needs /dev/md0 to be mounted to=20
create a initrd.img that will load the raid correctly]
mkinitrd -o /boot/initrd-raid.img
edit lilo.conf to make an entry with /dev/md0 as root and uses=20
initrd-raid.img
lilo -v
reboot and test this new lilo entry.
if it works, reboot with knoppix as single user
mount /dev/hdc2 /mnt/hdc2
mount /dev/md0 /mnt/md0
rsync -auHx --progress --exclude=3D/mnt/hdc2/proc/ /mnt/hdc2/* /mnt/md0=
/
[wait about 5 hours....]
edit /mnt/md0/etc/fstab to make /dev/md0 as root
reboot with the lilo entry that mounts /dev/md0 as root
mdadm /dev/md0 -a /dev/hdc2
[wait a while until the raid is in sync]
mkinitrd -o /boot/initrd.img
reboot, to be sure that it works.

After playing a lot with initrd and lilo, I think that the reason that=20
md0 was trying to boot from hdc was that it was configured that way in=20
initrd.img. I've since overwritten that file, but if I had to redo it,=20
I would take a look at it:
mount /boot/initrd.img /mnt/inirtd -o loop
cat /mnt/initrd/script
There should be a line in there that starts with:
mdadm -A /dev/md/0 ...

Anyway, I certainly learned a lot from that experience! :-)

Cheers,
GFK's
--=20
Guillaume Filion, ing. jr
Logidac Tech., Beaumont, Qu=E9bec, Canada - http://logidac.com/
PGP Key and more: http://guillaume.filion.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
