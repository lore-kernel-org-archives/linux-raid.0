From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm: ioctl(GET_DISK_INFO) question
Date: Sat, 28 Apr 2012 08:09:11 +1000
Message-ID: <20120428080911.10fe2f47@notabene.brown>
References: <CAGRgLy4p0aiZD92dJsV3tdcZyPaJ=8Nc6CKWVcQU20QtMb6MBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SnOsaQWsfKrRjhYc.OH+c6="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4p0aiZD92dJsV3tdcZyPaJ=8Nc6CKWVcQU20QtMb6MBQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/SnOsaQWsfKrRjhYc.OH+c6=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Apr 2012 17:14:28 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hello,
>=20
> what is the reason that in some places (like Detail()), the code tests
> for all desc_nrs possible (value read from superblock or MaxDisks
> macro):
> for (d =3D 0; d < max_disks; d++) {
>     disc.number =3D d;
>     ioctl(fd, GET_DISK_INFO, &disk)
>=20
> and in other places (like Monitor()), the loop goes only up to :
> array.raid_disks + array.nr_disks.

Bug.

>=20
> After all, disk.number (which is rdev->desc_nr in kernel) is merely a
> position of the disk entry in the dev_roles[] array in the superblock,
> and has no relation to the raid slot of the disk. Shouldn't the code
> always check max_disks possible?

Yes.

Thanks,
NeilBrown


--Sig_/SnOsaQWsfKrRjhYc.OH+c6=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5sZBznsnt1WYoG5AQJbTRAAtJ+DaxV3H2z9Tvqw6sLnYSjquxB1O6Aw
pJ/jQjcPCoJSnz7sfXtiqmhcgGUqpdHIBi+a80xNf0ifWcuIfLBrDOkH4qROkW1d
YoeIoajFCKBkgh0DViEI0S4lf+5O+WB2oa2QGrRuvlVRmKTvT7rJuQ+0OBw7ZhW3
liKllrmM+pnCdoUf6L2lp9aahVBTGHe1WaJaxeLYrLVzBiUIICnYqKhdfMyMR80+
xuwSBm3bbHkqK61yDOQbsMgHbI3UkVq0sWBHYzNMGmjixzN946yGph7wNfa4GLQi
iAwY+6jL0KdOSZ66uJlqAJQ2ysrn4L+KXnzUX/3YuLw3rs4jrs8BkjEeK+Rl8KoT
E+LViAmMDdD4HUVO3hIJZPx9vC0Hgr5687UVK8qs0twbBPFadd+Moqpw2b6UeEDC
cMRSZzw89mik310k1HQNC8Oc9sXGCkjrPfsyikCezZYNw6SmB2C9Dy36m9XEtmrb
hr2/uW71uAg7ebzNhLByDt/8Yj0ll5w4v/nFebR3CIRCJ0aEjOrykJkX80+/rw9l
DvI37YV/xZc0H19GpXlqo4pUJ8fo0SHe9L3+/smLPlhr7mpCaiL3MRQU89TOXWVa
iQOK9xYlKw4yussHgXWNDzBfRig12/I32Mcfz7tEAdJvSspCznl4Uwqi3OdGjJX7
U9CxDOb+4bQ=
=r1mK
-----END PGP SIGNATURE-----

--Sig_/SnOsaQWsfKrRjhYc.OH+c6=--
