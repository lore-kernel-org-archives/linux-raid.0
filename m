From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: SMART, RAID and real world experience of failures.
Date: Fri, 6 Jan 2012 06:42:22 +0600
Message-ID: <20120106064222.38c0f1b5@natsu>
References: <4F063808.6040000@crc.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/H_ixVYiYZZO1bipsyZWaLQt"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F063808.6040000@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/H_ixVYiYZZO1bipsyZWaLQt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 06 Jan 2012 10:53:44 +1100
Steven Haigh <netwiz@crc.id.au> wrote:

> So, in the spirit of experimentation, I did the following:
> # mdadm /dev/md2 --manage --fail /dev/sdd
> # mdadm /dev/md2 --manage --remove /dev/sdd
> # dd if=3D/dev/zero of=3D/dev/sdd bs=3D10M
> # mdadm /dev/md2 --manage --add /dev/sdd

Congratulations on doing absolutely the right thing, IMO :)

> Has the sector with the read failure been remapped and hidden from view?

More likely the drive decided the sector wasn't bad, after all. E.g. by ove=
rwriting the sector and thus allowing the drive to throw away old user data=
 from it, you have also let the drive to rewrite the ECC or system area of =
that sector, or whatever they have today in hard drives on the low level.

If it was indeed remapped, then the logic would also require an increase in=
 Reallocated_Sector_Ct; but SMART attribute readings do have a lot of pecul=
iarities, many of which are also vendor-specific.

> Is it still (more?) likely to fail in the near future?

In my experience not at all, unless you start getting stuff like this every=
 week.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/H_ixVYiYZZO1bipsyZWaLQt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8GQ28ACgkQTLKSvz+PZwi/vwCfWQDSHpqkiw1aVzmkyN6XRmyT
MMkAn29pPXZPgcMBVQD6JGYaYuj6OAaJ
=Mro0
-----END PGP SIGNATURE-----

--Sig_/H_ixVYiYZZO1bipsyZWaLQt--
