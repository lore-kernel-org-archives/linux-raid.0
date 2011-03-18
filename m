From: Thomas =?utf-8?q?Carri=C3=A9?= <thocar@thocar.org>
Subject: Re: MD without LVM : should I reinstall ?
Date: Fri, 18 Mar 2011 21:59:40 +0100
Message-ID: <201103182159.40249.thocar@thocar.org>
References: <201103172232.28515.thocar@thocar.org> <AANLkTinG1RSiXZZdN+Fc__AJ14hAAua8gxySbbM_C3gZ@mail.gmail.com>
Reply-To: thocar@thocar.org
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinG1RSiXZZdN+Fc__AJ14hAAua8gxySbbM_C3gZ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?utf-8?q?Bur=C3=A9n?= <mathias.buren@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Jueves 17 Marzo 2011 23:33:02 usted escribi=C3=B3:
> On 17 March 2011 21:32, Thomas Carri=C3=A9 <thocar@thocar.org> wrote:
> > Hello,
> >=20
> > My hosting provider has a setup for me a Debian server using md RAI=
D1 but
> > it does not use LVM, should I consider re-install with LVM ?
> >=20
> > # mount | grep ' / '
> > /dev/md0 on / type ext3 (rw,errors=3Dremount-ro)
> > # fdisk -l
> >=20
> > Disk /dev/sdb: 250.1 GB, 250059350016 bytes
> > ...
> >   Device Boot      Start         End      Blocks   Id  System
> > /dev/sdb1   *           1       30155   242220006   fd  Linux raid
> > autodetect /dev/sdb2           30156       30401     1975995    5
> >  Extended /dev/sdb5           30156       30401     1975963+  82  L=
inux
> > swap / Solaris
> >=20
> > Disk /dev/sda: 250.1 GB, 250059350016 bytes
> > ...
> >   Device Boot      Start         End      Blocks   Id  System
> > /dev/sda1   *           1       30155   242220006   fd  Linux raid
> > autodetect /dev/sda2           30156       30401     1975995    5
> >  Extended /dev/sda5           30156       30401     1975963+  82  L=
inux
> > swap / Solaris
> >=20
> > Disk /dev/md0: 248.0 GB, 248033181696 bytes
> > ...
> > Disk /dev/md0 doesn't contain a valid partition table
> >=20
> > Thanks for your feedback
> > --
> > Thomas Carri=C3=A9
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> Of course not. If you wanted LVM you'd switch to it. If you don't kno=
w
> if you want it, then obviously you don't need it.

Hello,

Have a look at the command output : "Disk /dev/md0 doesn't contain a va=
lid=20
partition table"

Is it safe to ignore this warning ?

>=20
> Jesus.
>=20
> // M

--=20
Thomas Carri=C3=A9
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
