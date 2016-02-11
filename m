From: NeilBrown <nfbrown@novell.com>
Subject: Re: mdadm bad blocks list
Date: Thu, 11 Feb 2016 15:15:53 +1100
Message-ID: <878u2rx4p2.fsf@notabene.neil.brown.name>
References: <56A9102D.4030304@prgmr.com> <87twly1jc7.fsf@notabene.neil.brown.name> <56B0172B.8020808@prgmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56B0172B.8020808@prgmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sarah Newman <srn@prgmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 02 2016, Sarah Newman wrote:

> On 01/27/2016 07:19 PM, NeilBrown wrote:
>> On Thu, Jan 28 2016, Sarah Newman wrote:
>>=20
>>> Kernel: CentOS 6 Xen4CentOS 3.18.21-17
>>> mdadm: CentOS 6 v3.3.2
>>>
>>> With the above behavior, I consider the bad blocks list to be actively =
harmful. If it's expected behavior in the current version, please consider
>>> disabling the bad blocks list by default.
>>=20
>> You can do this yourself by putting
>>=20
>>   CREATE bbl=3Dno
>>=20
>> in /etc/mdadm.conf.  That doesn't help others though.
>
> FYI, I tried adding that line and if it is present when trying to add to =
an array that currently has a bad blocks list, I get the error message
>
> md: sdi1 does not have a valid v1.0 superblock, not importing!
>
> Is this expected?

No, that looks like a bug.

If would be helpful to see complete "mdadm --examine" output of the
device that you tried to add, and a device that is already in the array.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWvAr5AAoJEDnsnt1WYoG5fKwP/3oFsua+SgJVyc2rsr8CjRF/
gSMz6ZmAaK/Nw7jVFVir4gPb1/oCoWpAGsgbR7ckSq9E1vcExR53fpWOdmujVTYE
lzMR0LqLC8skg/1Gmp+mAtruIiLhugZfpaeVT7UGyCrj6df3XZebSj92kws2tF2s
RSTaPlFtx6ZezefBEVDQYscsl/3rbU6iT0lJ1espAvY4OAhOFvitsFrHaRSAJ8M5
EKzSpiiMghLGLHNMwCDDnYdJVy4mKmfc7oyBhFlBrG5j1fFh68h21W4FkhHSTgb2
pvOU7kElFIX2ijBFv+kgVL/ovUS8RCp/Uw1nCXVgYKzx+uBiE2wu/1xJ3yNJa3CT
apIUOEcT6i89XmGKMSdpZJiacHa8W6ldhm9VpyS1Zli1f8Mrzps86ZZ551Z6+ysh
qz6Imlh/GDepBhCbW4oPW2qh7t6pkYM1GJpHz2yP0KI5TxiX9T4pMHmEAP797WiO
Ko2f/o7aGESgA5gVXJEDJqYcJvac7XR8BaqyBdE/KJzMapZWg20xvRjBylJtm2iW
SEPx2UViiERQuczeq7dIK+4nM7f4MbV1hGK+Qq8rFOWqUhAlpxDT+c4O/2mMHaKK
s8v3UE0sPIST4wWJby8sKahTntPzyb7mgDr6xkdN/PqrofDGCfdPR4IQyd050fpz
nhNfaUYpqafEdGYPAkhC
=q3cs
-----END PGP SIGNATURE-----
--=-=-=--
