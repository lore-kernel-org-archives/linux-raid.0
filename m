From: Herta Van den Eynde <herta.vandeneynde@cc.kuleuven.be>
Subject: mdadm create size problem
Date: Tue, 03 May 2005 15:53:30 +0200
Message-ID: <4277825A.1070405@cc.kuleuven.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Red Hat AS 2.1 mdadm 1.11
I have two devices that used to be part of a now corrupt RAID10=20
configuration.  When I try to reuse them to create a RAID1, it only use=
s=20
about 1 third of the diskspace available.
# fdisk -l /dev/sdg

Disk /dev/sdg: 255 heads, 63 sectors, 8924 cylinders
Units =3D cylinders of 16065 * 512 bytes

    Device Boot    Start       End    Blocks   Id  System
/dev/sdg1             1      8924  71681998+  fd  Linux raid autodetect

# fdisk -l /dev/sdn

Disk /dev/sdn: 255 heads, 63 sectors, 8924 cylinders
Units =3D cylinders of 16065 * 512 bytes

    Device Boot    Start       End    Blocks   Id  System
/dev/sdn1             1      8924  71681998+  fd  Linux raid autodetect

# mdadm --create --verbose /dev/md5 --level=3D1 --raid-devices=3D2 /dev=
/sdg=20
/dev/sdn
mdadm: /dev/sdg appears to contain an ext2fs file system
     size=3D419520K  mtime=3DMon May  2 17:04:04 2005
mdadm: /dev/sdn appears to contain an ext2fs file system
     size=3D419520K  mtime=3DMon May  2 17:04:04 2005
mdadm: size set to 139904K
Continue creating array? n

If I try to add the --size option, even a size that is 139904K or less,=
=20
it tells me the size is invalid:

# mdadm --create --verbose /dev/md5 --level=3D1 --raid-devices=3D2 /dev=
/sdg=20
/dev/sdn --size=3D139904K
mdadm: invalid size: 139904K

I did reboot the system after fdisk'ing the devices.

Do I need to low-level format these devices to be able to reuse them?

Kind regards,

Herta

--=20
Herta Van den Eynde              -=3D- Toledo system management
K.U. Leuven - Ludit              -=3D- phone: +32 (0)16 322 166
                                  -=3D- 50=B051'27" N 004=B040'39" E

"I wish I were two little cats.  Then I could play together."
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
