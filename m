From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: Re: Firewire RAID bootparameters?
Date: Fri, 12 Dec 2003 14:19:52 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1071256791.13023.3009.camel@localhost.localdomain>
References: <3FD9B878.3070002@chemist.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FD9B878.3070002@chemist.com>
To: Christer =?ISO-8859-1?Q?B=E4ckstr=F6m?= <cbackstrom@chemist.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm not sure which distro you're running, but we needed a module to loa=
d
before another one and I modified the linuxrc script in our initrd imag=
e
to change the load order.

Red Hat (and probably other distros) initrd images have a script in the
initrd image to load drivers.  You can loop mount the current image, ad=
d
the modules you need, modify the script, and then copy it back into
/boot.

The initrd image in Red Hat is gzipped so this is the procedure that I
follow:

=2E *** MAKE A BACKUP COPY OF YOUR CURRENT INITRD AND BOOTLOADER CONF *=
**
=2E cp /boot/initrd.img /tmp
=2E cd /tmp
=2E mv initrd.img initrd.img.gz
=2E gunzip initrd.img=20
=2E mount -o loop initrd.img /mnt/cdrom
=2E Copy any necessary modules to /mnt/cdrom/lib
=2E Edit /mnt/cdrom/linuxrc and add a couple of lines to load your
firewire module in the proper order.
=2E umount /mnt/cdrom
=2E gzip /tmp/initrd.img
=2E cp /tmp/initrd.img.gz /boot/mynewinitrd.img

Then what I would do is make a new bootloader (LILO/GRUB) entry with al=
l
the same options except use your edited initrd image instead of the
stock one.  That way you can test it, but still be able to boot with yo=
u
known-good initrd image.

This is probably a big hack, but it worked for me :)

Hope this helps,
Andy.


On Fri, 2003-12-12 at 07:45, Christer B=C3=A4ckstr=C3=B6m wrote:
> Hi,
>=20
> I've recently bought a 160Gb firewire drive and RAID1:ed it to mirror=
 my=20
> main harddrive. Unfortunately, the md subsystem seems to load before =
the=20
> firewire in the kernel bootsequence, which mean I have to do some wei=
rd=20
> stuff to make it work. Basically, I compiled the md system as modules=
=20
> (with the SCSI patch to make it work a bit better), and hid the modul=
es=20
> in a different directory, so they wouldn't load. I later load them in=
=20
> manually rc.sysinit. This work, but is a little clumsy. Is there a wa=
y=20
> to use append any boot-parameters to lilo to make the RAID subsystem=20
> load the firewire system? Or is there another solution? Thanks,
>=20
>=20
> /Chris
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--=20

Regards,
Andrew Rechenberg
Infrastructure Team, Sherman Financial Group
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
