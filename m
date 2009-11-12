From: Doug Ledford <dledford@redhat.com>
Subject: Re: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 20:35:52 -0500
Message-ID: <4AFB6678.4030601@redhat.com>
References: <20091111150155475.WWUI3390@cdptpa-omta03.mail.rr.com> 	<4AFB2026.2010001@redhat.com> <babafd2f0911111346y1dc42030g92a11f172bc32620@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC439E4D04B9B4FA2BBB552AD"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <babafd2f0911111346y1dc42030g92a11f172bc32620@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ben DJ <bendj095124367913213465@gmail.com>
Cc: Leslie Rhorer <lrhorer@satx.rr.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC439E4D04B9B4FA2BBB552AD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/11/2009 04:46 PM, Ben DJ wrote:
> Hi,
>=20
> On Wed, Nov 11, 2009 at 12:35 PM, Doug Ledford <dledford@redhat.com> wr=
ote:
>> Yes, very incorrect.  You can use grow to add an internal bitmap later=
,
>=20
> Is that true for RAID-10, as well?  I understood "--grow" with RAID-10
> wasn't fully capable -- yet.

I don't know.  I never heard anything about raid-10 and grow not being
compatible.  I'd just set up a couple fakes devices using loopback,
create a raid-10, and then try it ;-)


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigC439E4D04B9B4FA2BBB552AD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr7ZngACgkQg6WylM+/8ZTNkACeI6hbmg+a9V5x8/MYNkuOAqG/
iRYAn3ATxX1/IrLfoLTcxj3Go8HuMEyG
=ODmv
-----END PGP SIGNATURE-----

--------------enigC439E4D04B9B4FA2BBB552AD--
