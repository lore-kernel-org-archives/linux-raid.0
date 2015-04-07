From: NeilBrown <neilb@suse.de>
Subject: Re: Can't mount partitions after "mdadm --zero-superblock"
Date: Tue, 7 Apr 2015 10:52:30 +1000
Message-ID: <20150407105230.4ff9a97a@notabene.brown>
References: <F271C907-A2A7-4132-BA11-D33353AE9FFF@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/dptuojaZMlPyMjo1xMkzdqU"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F271C907-A2A7-4132-BA11-D33353AE9FFF@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eduard Rozenberg <eduardr@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/dptuojaZMlPyMjo1xMkzdqU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Apr 2015 16:45:58 -0700 Eduard Rozenberg <eduardr@pobox.com> wrot=
e:

> Hello folks,
>=20
> I previously had the following setup:
>=20
> sda & sdb partitioned w/ GPT, 7 partitions each (usr, opt, var etc...)
> 7 raid1=E2=80=99s with 2 devices for each pair of partitions (/dev/sda1 &=
 /dev/sdab1, etc)
> They=E2=80=99d been created under Slackware 13.37.
>=20
> I was trying to clean out mdadm from those partitions but keep the data s=
o I ran=20
> "mdadm --zero-superblock=E2=80=9D on each of those previously RAID1 mdadm=
 1.2 ext4=20
> partitions.

The "1.2" metadata is stored 4k from the start of the device.  The actual
data is some megabytes further in.  I don't suppose you still have the outp=
ut
of "mdadm --examine" from before you destroyed the superblocks??

>=20
> As a result I am now currently unable to mount any partition after the fi=
rst one on either
> disk. The first partition does mount. The partition table is visible and =
looks fine in gdisk.
>=20
> mount -t ext4 /dev/sdac2 /mnt
> mount: wrong fs type, bad option, bad superblock on /dev/sdac2,
> missing codepage or helper program, or other error
> In some cases useful info is found in syslog - try
> dmesg | tail or so
>=20
> I did try superblock recovery with each backup superblock that ext4 norma=
lly creates,
> but none of the superblock locations worked.
>=20
> For example:
>=20
> fsck.ext4 -b 4096000 /dev/sdac2=20
> e2fsck 1.42.8 (20-Jun-2013)
> /sbin/e2fsck: Invalid argument while trying to open /dev/sdac2
>=20
> The superblock could not be read or does not describe a correct ext2
> filesystem. If the device is valid and it really contains an ext2
> filesystem (and not swap or ufs or something else), then the superblock
> is corrupt, and you might try running e2fsck with an alternate superblock:
> e2fsck -b 8193 <device>
>=20
>=20
> Would be grateful for any advice on anything else I can try.

You need to find where the filesystem actually starts, then you need to
create some way to access it as a block device, then it should "just work".

An ext4 filesystem superblock has 0xef53 at an offset of 0x38, and the
superblock is typically 1K from the start of the partition.

So you could:
   od -x /dev/sdac2 | awk '$6 =3D=3D "ef53"'

Then subtrace 0002060 (octal) from the leading number, and that might be the
start of the partition.

Then
  losetup -o "start in decimal" /dev/loop0 /dev/sdac2

and try 'fsck' on /dev/loop0

Good luck.

NeilBrown



>=20
> Regards,
> =E2=80=94Ed--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/dptuojaZMlPyMjo1xMkzdqU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSMqTjnsnt1WYoG5AQJ2exAAlPy5nwEjGZI5LDCTKgqrhowrGV6VRKO5
q2gsivI/J0RsdNCvszh5rvCQbuoXHODXbD3eM+kq1pRmSG6f6Q0vAC6GqsK+JU+K
Rb63Hezu1pHOSkr4BXdH8yCf/nn3dHQrDyS91CM4LZMBGRFDTzA/zoTVuCMLyY1I
E0O9/H8amJbXE5GbyVJP6SvtaqgP7tZyD0qCNueywMwLIHolaeucXDBYrs9CXHoJ
FBksrh9QQ51lrLRCNVobVmoYq9nr5grLKPImmD8mc0fXE0ydvWQpzB9tDnyak/Ts
UZzlLYOC5wX6xR8ZE1cJZZK7Gtz6HhNY6YWGAh83vuTIOkY831Flx+XhYm8dTNej
YcYFz3mHIjbKYVVWGtTaHhPMSsHv2z9xxmjn+UELgC+7eu+jfWRfiQ0nItakFCy1
I5LLHmKDNsmv+glIIyRRGJ1/sV+RoAEwOQqgbUGfQiR/ht8UVIexD0zhlC0nhhDM
/jkncsSGjxVKuh2XSZUDveBFaUlsjEkg7c19/NbyHY+q+IifYcZuG87yih3of0aJ
2YIvtKj5h40bpmi7DyRp2yPe/Q9pBt9LR0kCT1d19mcXaLCi6ShMtwe/8N4oe7iS
lpvOQGydm2AJkzKgZ4f7QdHmSDkb7xlR32dBb6Rsp9Th3t5sM0S1gtz49dalKj/o
sw4ikmEEiyw=
=nrx6
-----END PGP SIGNATURE-----

--Sig_/dptuojaZMlPyMjo1xMkzdqU--
