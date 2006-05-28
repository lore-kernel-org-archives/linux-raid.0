From: Patrik Jonsson <patrik@ucolick.org>
Subject: Re: "Readonly" entry in your TODO list
Date: Sat, 27 May 2006 18:44:41 -0700
Message-ID: <44790089.2040902@ucolick.org>
References: <E1Fk9OW-0005ra-00@spoon.trix.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFC5A240ABAF5133D617E3BB5"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1Fk9OW-0005ra-00@spoon.trix.com>
Sender: linux-raid-owner@vger.kernel.org
To: steve@trix.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFC5A240ABAF5133D617E3BB5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Steve Haehnichen wrote:
> Halfway through rebuilding, it found a read error on one drive!  This
> isn't shouldn't have been surprising, since some of the data is two
> years old had not been read in some time.
=2E..
> Anyway, just a vote here for readonly assembly.  The second one on
> your todo list: "don't kick drives on read errors" would have probably
> been useful as well.
=2E..
> The lesson I learned is that it's good hygiene to simply read all data
> on the drives now and then to 'prompt' any drive failures before there
> exists more than one at a time.  I intend to 'dd' read all of /dev/md0
> once a week or so in the background, in addition to the smartctl tests
> which did not detect this.

As someone who has been hit by this in the past, too, I'd like to
emphasize that
1. The raid5 read error correction works!
2. The raid5 "check" mode is very useful as a data exerciser. It's
running once a week as a cron job on my machine.

With these two features, my raid5 drive kicks have dropped to zilch.
(Small number statistics, but still...) If I were you, I'd update to a
kernel which supports this asap.

cheers,

/Patrik




--------------enigFC5A240ABAF5133D617E3BB5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFEeQCNT+KvsdUW5p8RAkvWAJ9M5z93d3C/9n5jhlo/vogQ2K9C0ACgkA/v
jcaKDZTUaGZBVj6jCfN0hDk=
=+/U+
-----END PGP SIGNATURE-----

--------------enigFC5A240ABAF5133D617E3BB5--
