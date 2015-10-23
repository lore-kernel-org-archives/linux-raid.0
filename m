From: Neil Brown <neilb@suse.de>
Subject: Re: Hung RAID5 array with discard
Date: Fri, 23 Oct 2015 15:42:57 +1100
Message-ID: <87y4euxkj2.fsf@notabene.neil.brown.name>
References: <CANHB05vDxWqfST41hXgfApthHuxdSuyJYCKqS4jkOa7OZ0kpsA@mail.gmail.com> <CANHB05sb44ZD-31ceEWWSY0XdhWaU-Pq+NFRQSm-1qafHx1G2g@mail.gmail.com> <20150323135754.02afa72e@notabene.brown> <562909AC.7040003@kieser.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <562909AC.7040003@kieser.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Kieser <peter@kieser.ca>, Terry Hardie <thardie@instartlogic.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Peter Kieser <peter@kieser.ca> writes:

> FYI I ran into this problem in 3.18.22 when forcing RAID5 TRIM support=20
> w/ raid456.devices_handle_discard_safely on Intel DC S3500 SSDs.

Can you please be precise about the problem you experienced.
Complete kernel messages are a minimum.
Anything interesting that might have been happening at the time might
help.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWKbrRAAoJEDnsnt1WYoG51I4QAML9Z6FcEzreNbvR+SZYsxw6
10AyYTAtNmbo+v7416FytFQYbdj5ye5xDeJ2nmq9OZBwVQOnAz4vN2kZpHB1nYnq
/m8B+MGnJEn+4ZMrC34WieHx3Jxj/11Z/hethMV0QX7MTHQKFAsQzE/EpXp5UDXs
BO6S0C+XpM4c+3f+gWMkxIu0szK/4cjyNokS6cmcHhbHSxMS3su0H1HvXnjKMJsi
t+yq6K3hqyhIkbnIoz15Ghk76dTOO1QsOOALXVHxXSsD4FzMVUO3b+2cyVuWKNP8
JNtEIipG9V46xXJ56SWoI/m3ZtsdNlu5SIce1qb484CiY7MRKxLdrRn9SpBEitw/
scNa21ieGprgwqXlzgVrlbKtpfp3NSReCldmHZjmv13xAYwOAuI/PvfTXGzRqawG
oPq4now6eT084fnObqPdIHpyl2MGG1xrR2W9aHiDU/uz4ZfhjbCMHTkiwsx0defM
eZsvtaYK0Beb/bPEDPv3EV8VMHamUm3VpKW2DJDOWTwdvkkDJdDcecY8HmC92Aqc
hEcuyNxzcqqQfo6ossAZ9DQzENs7sggg6GTapdR/4YhhBM6cdYDMEco1d+8A00lE
tMEkl3kb7/oHhtVa0OhHabI9ZBFA70YLw18WD4Samui0PCroB/1HhE+7SXUnOiHW
HEe1lRmUwJt3W+MpA0y5
=Aimp
-----END PGP SIGNATURE-----
--=-=-=--
