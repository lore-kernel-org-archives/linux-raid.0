From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: recovery problems, might be driver-related
Date: Mon, 08 Feb 2010 07:49:03 +0100
Message-ID: <4B6FB3DF.9090208@stud.tu-ilmenau.de>
References: <4B6EC24A.9040703@stud.tu-ilmenau.de> <20100208165200.3758520a@notabene.brown>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100208165200.3758520a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown schrieb:
> On Sun, 07 Feb 2010 14:38:18 +0100
> [...]
> mdadm only checks the superblock at the start of the device to see if=
 it
> looks like an ext3 filesystem.  So if an md array has a valid filesys=
tem,
> then it is very likely that at least one of the devices in the array =
will
> appear to have a valid filesystem to mdadm.

Indeed that makes perfect sense.
>=20
>[...]
>=20
> Maybe there was meant to be another layer between the md array and th=
e
> filesystem - maybe LVM ??  If there should have been an LVM and wasn'=
t the
> filesystem would definitely look very corrupt even though the superbl=
ock
> might appear to be in the right place.
>=20

Well, there's no need to tell me - the guys in taiwan just don't do it
on their NAS Devices.  But thanks for the hint.  I recall that the
successful data-recoveries were on a Thecus N5200, which does indeed us=
e
lvm (to separate iSCSI-space, userspace, config-space, etc.)

>=20
> NeilBrown
>=20
Bottom-line: the customer's RAIDs were just f**ked, they should have ha=
d
taken drive-health more seriously... And the Vendor's code should get
"normalized" so that FS-checking in regular intervals takes place...

Thanks for the help,
Stefan H=FCbner
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
