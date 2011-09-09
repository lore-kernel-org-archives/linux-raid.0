From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Best strategy to incrementally replace smaller HDDs
Date: Fri, 09 Sep 2011 12:48:01 +0200
Message-ID: <1315565285.2291.25.camel@michal-laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-McANE+GaDtAgVgMlO7t3"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-McANE+GaDtAgVgMlO7t3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all, given the configuration below:
      * 8 x 1TB HDDs
      * 2 x 2TB HDDs

On which I currently have:
      * (10 x 1TB) RAID6 - persistent storage
      * (2 x 1TB) system / temporary storage etc.

I want to replace the 1TB drives for 2TB ones on an as-needed basis,
what strategy would you recommend?

     1. If I moved to 2TB RAID6 members (using RAID0 on the 1TB drives),
        I would need to replace two of the drives just to match current
        capacity. Each next 2TB drive would get me 1TB additional
        capacity (but actually I'd need to replace two to gain
        anything). That sounds to be most future-proof, but most
        expensive.
     2. If I moved to 2TB RAID5 members, that would reduce redundancy
        but replacing just two would gain me 2TB capacity. Most of the
        above still applies.
     3. If I kept to 1TB RAID6 (two on the 2TB drives), I would reduce
        the redundancy to just one drive if it was the 2TB drive that
        failed, but each new drive would gain me 1TB capacity and I only
        need to replace one-by-one. This sounds like the cheapest, but
        worst possible approach.

So, am I missing something? What do you think?
--=20
Micha=C5=82 (Saviq) Sawicz <michal@sawicz.net>

--=-McANE+GaDtAgVgMlO7t3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOae7hAAoJEGnv7NPGHSZFpM0QAJyydq2ISQTIrdVk2lvkWys8
k+YERjAU6AJsXxMmGKYuOfQDswfRe7aiq/+0qVy3NQhrQlGCUtaYL4Cm6TJcWnEf
MYrpPlcJdf/fv4+K+mKXWoyJJ32qokhlO1It1OpndeynNX7gJzeUp0QllVbh34vE
VmBpBU4J9nV9x+w4V995I+y0NV1CJsX35LF1siT6XEnyzBdoumwQpZbNdZLOtnzx
Ib1sCTN78KJ2I6o+q1vfj/NLdSCzs5wXHRgZ1Xq51TUMo+ibX84MtiOuT/Y6vnsV
ycMd6JM8/OzOkl7PgI+2y9Qqrackr+ZiYIUpXilzzv6r+VMcG8EgrSDga3YxyCaX
wlE51VPtY9NaULYgdmM57Ld+tCPylQNELAhrbH8lddkjTMtYFuVQuNmA0sSftDai
zfGKrdcyV9sbNBEOgD7VswfjHwrNcMV/plzd7NlaMw4+sSnOQzSTilGUsaDPVoP8
ku17eQdWGsv67QTnIR6c6FvdgvfGU9htMMc65AXGyUpqampT9wWJ1C5olRoYm0Yo
i7aoZdN6XKgZRUttb/j3wOaysYGdrn8QQvnexxK4ooJ4qKYTgQOJp9nV8KwF74ow
TOUFh36WhBlMBoMeMnhvSoOCdZVPeDmgu+elp+aODZd+dCUXKuqVxENYGe7hfhXX
QmDwsCAE7rzSqWQv+T3R
=NEbE
-----END PGP SIGNATURE-----

--=-McANE+GaDtAgVgMlO7t3--

