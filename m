From: "Miguel Angel Martinez Ezquerro" <scsmaezm@sc.ehu.es>
Subject: RE: Booting a disk (mirrored) in other system
Date: Fri, 4 Jul 2003 12:14:34 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000201c34215$12e91f00$6296e39e@sc.ehu.es>
References: <1057244833.23796.28.camel@cinshrlnxws01.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1057244833.23796.28.camel@cinshrlnxws01.shermfin.com>
To: 'Andrew Rechenberg' <arechenberg@shermanfinancialgroup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you very much for  your answer. The system is running now ok.=20

Thanks again.

	Miguel Angel.

> -----Mensaje original-----
> De: linux-raid-owner@vger.kernel.org=20
> [mailto:linux-raid-owner@vger.kernel.org] En nombre de Andrew=20
> Rechenberg
> Enviado el: jueves, 03 de julio de 2003 17:07
> Para: Miguel Angel Martinez Ezquerro
> CC: linux-raid@vger.kernel.org
> Asunto: Re: Booting a disk (mirrored) in other system
>=20
>=20
> The AIC79xx has a different driver.  You have to add the=20
> driver to your initrd so that you can boot off those drives.
>=20
> Basically just modify /etc/modules.conf so that your=20
> 'scsiadapter' line has aic79xx instead of aic7xxx, run a=20
> mkinitrd and make a new initrd file (with a different name as=20
> to not overwrite your current one).  Then what I would do=20
> would be add another boot line to your grub.conf file and use=20
> the new initrd.  Then when you boot your new box choose the=20
> boot line with the new initrd and you should be fine.
>=20
> Make sure to make that the default boot image if everything works out=
=2E
>=20
> Good luck,
> Andy.
>=20
> On Thu, 2003-07-03 at 03:14, Miguel Angel Martinez Ezquerro wrote:
> > I have installed RedHat 9.0 in a system with RAID1=20
> (mirror). I have a=20
> > SCSI AIC-7899 controller and a System Pentium III Xeon and=20
> two disks=20
> > of 36 Gb. Each disk has 3 partitions /, /var and /users and its
> > corresponding mirror in the other disk.=20
> > =20
> > I have acquired another identical system to the previous=20
> one, with the=20
> > same processor and disks, with the exception that the  SCSI=20
> controller=20
> > in the new system is AIC-7902. If I attempt to boot RedHat=20
> in this new=20
> > system with the disks of the previous one it doesn't work at all.
> > =20
> > Has somebody had this problem? Is it possible to define the=20
> two  SCSI=20
> > drivers in oneself Kernel in order to be able to pull up the system=
=20
> > with the same disks in any it schemes?
> > =20
> > Thanks in advance and  greetings
> >=20
> > Saludos,
> >                 M.A.
> >=20
> > ------------------------------------------------------------------
> > Miguel =C1ngel Mart=EDnez Ezquerro      |   Universidad del Pa=EDs =
Vasco
> > CIDIR Guip=FAzcoa (UPV/EHU)           |   E-mail: scsmaezm@sc.ehu.e=
s
> > P.M Lardiz=E1bal,1 (Ed. F.Inform=E1tica)|   Tel...: +34 943 018005
> > 20018 San Sebasti=E1n (SPAIN )        |   Fax...: +34 943 219306
> > ------------------------------------------------------------------
> >=20
> >=20
> >=20
> >=20
> > -
> > To unsubscribe from this list: send the line "unsubscribe=20
> linux-raid"=20
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
> >=20
> -
> To unsubscribe from this list: send the line "unsubscribe=20
> linux-raid" in the body of a message to=20
> majordomo@vger.kernel.org More majordomo info at =20
http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
