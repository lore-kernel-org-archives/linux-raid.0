From: Doug Ledford <dledford@redhat.com>
Subject: Re: latest version of mdadm for RedHat 5.3
Date: Fri, 12 Aug 2011 13:31:35 -0400
Message-ID: <4E456377.6030506@redhat.com>
References: <4E43FAA8.5050509@Oracle.com> <4E43FC96.6020308@Oracle.com> <20110812070759.2849ba0b@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE02A6B77585767410282A67F"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110812070759.2849ba0b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: John Papa <John.Papa@Oracle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE02A6B77585767410282A67F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 8/11/2011 5:07 PM, NeilBrown wrote:
> On Thu, 11 Aug 2011 09:00:22 -0700 John Papa <John.Papa@Oracle.com> wro=
te:
>=20
>> On 8/11/2011 8:52 AM, John Papa wrote:
>>> Greetings,
>>>
>>> A customer is running RedHat 5.3 and has inquired regarding
>>> the latest version of mdadm for that version of RedHat.
>>>
>>> I am having some difficulty responding to the customer with
>>> the degree of confidence required for this production environment.
>>>
>>> Is mdadm version 3.2.2 compatible with RedHat version 5.3?
>>>
>>> Thank you in advance for considering this inquiry
>=20
> In theory all later versions of mdadm are compatible with all kernels. =
 Later
> versions add features, remove bugs, and sometimes add bugs.
>=20
> The real question is probably "Has it been tested" or "is someone willi=
ng to
> provide support".   Maybe you should ask Redhat??

It's a little bit more complex than that.  The mdadm package in rhel is
responsible for boot up bring up of md raid arrays, and between rhel5
and rhel6 we changed boot loaders, changed init scripts, changed over to
doing udev incremental assembly, and a host of other things.  I have
resisted the urge to put mdadm 3.x on rhel5 because it behaves
differently and the particular quirks of mdadm 2.6 might or might not be
relied upon by those boot scripts.  So, my latest build for rhel5 is
mdadm-2.6.9-3.  Now, whether or not even just that much of an update
would work with something as old as rhel5.3 with its (I'm sure) not
updated mkinitrd or initscripts is another question.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigE02A6B77585767410282A67F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk5FY3cACgkQQ9aEs6Ims9gjMgCeJRQiIuVgJHbthrZ+eNXTbICh
bocAoNRW/nspEqLhv91BMZMPml3MqdtB
=HDzv
-----END PGP SIGNATURE-----

--------------enigE02A6B77585767410282A67F--
