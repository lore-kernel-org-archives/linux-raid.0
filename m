From: Andrew Rechenberg <arechenberg@shermanfinancialgroup.com>
Subject: Re: Booting a disk (mirrored) in other system
Date: 03 Jul 2003 11:07:14 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1057244833.23796.28.camel@cinshrlnxws01.shermfin.com>
References: <8075D5C3061B9441944E1373776451181A263D@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8075D5C3061B9441944E1373776451181A263D@cinshrexc03.shermfin.com>
To: Miguel Angel Martinez Ezquerro <scsmaezm@sc.ehu.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The AIC79xx has a different driver.  You have to add the driver to your
initrd so that you can boot off those drives.

Basically just modify /etc/modules.conf so that your 'scsiadapter' line
has aic79xx instead of aic7xxx, run a mkinitrd and make a new initrd
file (with a different name as to not overwrite your current one).  The=
n
what I would do would be add another boot line to your grub.conf file
and use the new initrd.  Then when you boot your new box choose the boo=
t
line with the new initrd and you should be fine.

Make sure to make that the default boot image if everything works out.

Good luck,
Andy.

On Thu, 2003-07-03 at 03:14, Miguel Angel Martinez Ezquerro wrote:
> I have installed RedHat 9.0 in a system with RAID1 (mirror). I have a
> SCSI AIC-7899 controller and a System Pentium III Xeon and two disks
> of
> 36 Gb. Each disk has 3 partitions /, /var and /users and its
> corresponding mirror in the other disk.=20
> =20
> I have acquired another identical system to the previous one, with th=
e
> same processor and disks, with the exception that the  SCSI controlle=
r
> in the new system is AIC-7902. If I attempt to boot RedHat in this ne=
w
> system with the disks of the previous one it doesn't work at all.=20
> =20
> Has somebody had this problem? Is it possible to define the two  SCSI
> drivers in oneself Kernel in order to be able to pull up the system
> with
> the same disks in any it schemes?=20
> =20
> Thanks in advance and  greetings
>=20
> Saludos,
>                 M.A.
>=20
> ------------------------------------------------------------------
> Miguel =C3=81ngel Mart=C3=ADnez Ezquerro      |   Universidad del Pa=C3=
=ADs Vasco
> CIDIR Guip=C3=BAzcoa (UPV/EHU)           |   E-mail: scsmaezm@sc.ehu.=
es
> P.M Lardiz=C3=A1bal,1 (Ed. F.Inform=C3=A1tica)|   Tel...: +34 943 018=
005
> 20018 San Sebasti=C3=A1n (SPAIN )        |   Fax...: +34 943 219306
> ------------------------------------------------------------------
>=20
>=20
>=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
