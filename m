From: John Crisp <jcrisp@safeandsoundit.co.uk>
Subject: Re: Raid 6 recovery
Date: Sun, 5 Nov 2017 18:13:19 +0100
Message-ID: <0969e349-4744-d2a2-8b00-b80566302287@safeandsoundit.co.uk>
References: <cf135ab9-1111-65cd-1074-5259a7eb133d@safeandsoundit.co.uk>
 <59F8A47E.2000405@youngman.org.uk>
 <1f997b50-f271-a238-2d7e-1684a0c64e66@safeandsoundit.co.uk>
 <59F8BCE9.1070607@youngman.org.uk> <59FBAE95.6010206@youngman.org.uk>
 <778940c7-cd7c-bda7-4db6-1e1b605a9557@safeandsoundit.co.uk>
 <59FDB6C2.1040800@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="fpRd4Mwb6QUEAO3p5PgvtXT1XhRQiW5cA"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59FDB6C2.1040800@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fpRd4Mwb6QUEAO3p5PgvtXT1XhRQiW5cA
Content-Type: multipart/mixed; boundary="BIbWiJ1ORgNwf2Vhg8ts7eLnGuHwMwHUA";
 protected-headers="v1"
From: John Crisp <jcrisp@safeandsoundit.co.uk>
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org,
 Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
Message-ID: <0969e349-4744-d2a2-8b00-b80566302287@safeandsoundit.co.uk>
Subject: Re: Raid 6 recovery
References: <cf135ab9-1111-65cd-1074-5259a7eb133d@safeandsoundit.co.uk>
 <59F8A47E.2000405@youngman.org.uk>
 <1f997b50-f271-a238-2d7e-1684a0c64e66@safeandsoundit.co.uk>
 <59F8BCE9.1070607@youngman.org.uk> <59FBAE95.6010206@youngman.org.uk>
 <778940c7-cd7c-bda7-4db6-1e1b605a9557@safeandsoundit.co.uk>
 <59FDB6C2.1040800@youngman.org.uk>
In-Reply-To: <59FDB6C2.1040800@youngman.org.uk>

--BIbWiJ1ORgNwf2Vhg8ts7eLnGuHwMwHUA
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Thanks for continuing to mull this one :-)

On 04/11/17 13:46, Wols Lists wrote:
>>
>> I am pretty sure that is trashed, but I like to try and understand the=
se
>> things !
>>
> More for Neil, this, but I've had a nasty thought. Did you reboot at al=
l
> (as in clean shutdown, not crash and restart) at any point during this?=

> I get the impression you might not have.
>=20

That I cannot remember to be honest. As I previously mentioned I *think*
it may have fallen over or crashed during the first rebuild but my
memory of exact events back then is hazy. I can try and fire it up and
check the logs - maybe they will have some history.

> Because that *could* explain the missing superblocks! I think raid
> updates the superblock every time it moves the rebuild window, so it
> should get rewritten to disk regularly. BUT. Is it possible that it was=

> sitting in the disk cache when the system crashed?
>=20
> I find it hard to believe that's the case, but it could explain at leas=
t
> some of it (doesn't explain why those drives had mbr's, though).
>=20

I'm pretty sure the cards in use are that old they have precious little
cache in them. However that might not be the case.

I'll go check if I can see anything in any of the logs.

B. Rgds
John

--

PS - I seem to remember I should do reply to all on this list but can't
see where I might have read that ! Please let me know if that is wrong


--BIbWiJ1ORgNwf2Vhg8ts7eLnGuHwMwHUA--

--fpRd4Mwb6QUEAO3p5PgvtXT1XhRQiW5cA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAEBAgAGBQJZ/0avAAoJEE8bo8Tv0FrJf7AH/0mNqErH4MSob+J955FomyeS
I7SeJDpxlYZlfI+YoXjOLGixQ7UUq6a9+wf0MIYGMrdvfRDsexxRZ/G8dNv6iYLd
qFm9+7mHXHMNPp/uYfIyfleFebSFqqO5c93CJvKtBdwH3ZJtD42awh1E0bzyAenA
83K4TfgnSV/eOMXZiJ96r+osqosLa8ucBRiNKMj7E/2X0EiFqx6EHmtVWSiUlNNP
h6EKzsz91dC61wYA/przGs0M5RwPgOHjQANyqWa5te/XYOO5XrpF9aR0fkO0U7K/
MssBnckrhhssv/aQSbobZgBWUhkruYx/WFptYgpnMfq3vuRlawR+U8U56qLRa68=
=ul6V
-----END PGP SIGNATURE-----

--fpRd4Mwb6QUEAO3p5PgvtXT1XhRQiW5cA--
