From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch mdadm] Add hot-unplug support to mdadm
Date: Tue, 13 Apr 2010 12:27:22 -0400
Message-ID: <4BC49B6A.1080408@redhat.com>
References: <4BBA1289.4010705@redhat.com>	<20100407113035.3ca437f2@notabene.brown>	<4BBBE7D2.6090608@redhat.com>	<20100409093153.690ea963@notabene.brown> <20100409103330.37d9dff5@notabene.brown> <4BC43938.2020109@unart.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD02553717F648B048EF2D0D8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BC43938.2020109@unart.cz>
Sender: linux-raid-owner@vger.kernel.org
To: =?windows-1252?Q?Tom=E1=9A_Dul=EDk?= <dulik@unart.cz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD02553717F648B048EF2D0D8
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/13/2010 05:28 AM, Tom=E1=9A Dul=EDk wrote:
> Hi Doug,
>=20
> first of all: thanks for your work on hot-unplug!
> I am new to Linux RAID, have been using HW RAID before but after my LSI=

> controller burned to ashes I decided I don't want to see HW RAID ... ev=
er.
>=20
> First thing I found weird on Linux RAID was the missing support for dea=
d
> device removal.
> I spent last 3 weeks trying to write various scripts for UDEV "remove"
> and mdadm "Fail" events handling, but finally I found the same thing
> like you - it is not possible to remove dead device from an array,
> because the events are issued too late. The only way to remove dead
> device is reboot, which is not what I would expect as solution in Linux=

> world.
>=20
> So I downloaded your code from Neil's git
> (http://neil.brown.name/git?p=3Dmdadm;a=3Dshortlog;h=3Drefs/heads/hotun=
plug)
> and also applied the "Minor incremental fixup" mentioned in your messag=
e
> below.
>=20
> The compiled mdadm works OK for normal operations (--fail, --remove,
> --add), but crashes with Segmentation fault for the "--incremental
> --fail" operation if I use it for a disk that I have just disconnected.=

> Here is what I've got:

[ snip ]

Thanks for the report.  You aren't likely doing anything wrong.  Neil
rewrote significant portions of my code and I suspect there is a
lingering issue in there.  I would have caught it already if I hadn't
ended up taking some time off sick.  But, I'm back and working on it
now, so I'll send an updated patch to the list soon.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigD02553717F648B048EF2D0D8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvEm2oACgkQg6WylM+/8ZQE6ACgnASIHhmqqSvRZYif0PP8OXNu
sI0AniQYYeIGP7ypSt2b6mYrbDIw/1us
=cjtw
-----END PGP SIGNATURE-----

--------------enigD02553717F648B048EF2D0D8--
