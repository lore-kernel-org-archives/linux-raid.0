From: Doug Ledford <dledford@redhat.com>
Subject: Re: More Hot Unplug/Plug work
Date: Fri, 30 Apr 2010 09:38:30 -0400
Message-ID: <4BDADD56.1030208@redhat.com>
References: <4BD714A3.9020801@redhat.com> <905EDD02F158D948B186911EB64DB3D11C954788@irsmsx503.ger.corp.intel.com> <4BD874CB.5040803@redhat.com> <905EDD02F158D948B186911EB64DB3D11C95485F@irsmsx503.ger.corp.intel.com> <4BD8A336.7080309@redhat.com> <4BD8A50F.1030904@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF042B078607439FB5FB1CF34"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD8A50F.1030904@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Labun, Marcin" <Marcin.Labun@intel.com>, Neil Brown <neilb@suse.de>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF042B078607439FB5FB1CF34
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/28/2010 05:13 PM, Dan Williams wrote:
> Doug Ledford wrote:
>> On 04/28/2010 02:34 PM, Labun, Marcin wrote:
>>> Should an array be split (not assembled) if a domain paths are
>>> dividing array into two separate DOMAIN?
>>
>> I don't think so.  Amongst other things, this would make it possible t=
o
>> render a machine unbootable if you had a type in a domain path.  I thi=
nk
>> I would prefer to allow established arrays to assemble regardless of
>> domain path entries.
>=20
> This is what I was calling the 'enforce=3D' policy in previous mails.
> Whether to block, warn, or ignore arrays that span a domain.  I can see=

> someone wanting to have something like enforce=3Dplatform to make sure =
we
> Linux tries to assemble an array that the option-rom can't put together=
=2E

I would suggest that the proper way to handle this is to warn on
assembling an array that spans boundaries but proceed with the assembly
(including incremental), warn and require a force flag on creating an
array that spans boundaries, and warn and require the force flag to
automatically use devices that span boundaries.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigF042B078607439FB5FB1CF34
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkva3VYACgkQg6WylM+/8ZTnVACeI89pvellHVtUo/j1d8S/vTs6
8kwAniU6+9EIR6fCo54bYHizasqvRDeA
=I2pP
-----END PGP SIGNATURE-----

--------------enigF042B078607439FB5FB1CF34--
