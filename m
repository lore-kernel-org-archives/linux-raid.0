From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 syncing at 24 MB/s?
Date: Wed, 18 Apr 2012 15:37:48 +1000
Message-ID: <20120418153748.2cbaef35@notabene.brown>
References: <20120418150502.41d6305d@notabene.brown>
	<20120418052235.27608.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/289TgZtPWvvcNyTyqX+delD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120418052235.27608.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/289TgZtPWvvcNyTyqX+delD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On 18 Apr 2012 01:22:35 -0400 "George Spelvin" <linux@horizon.com> wrote:

> > Can you try an experiment for me (if you don't have anything useful on =
the
> > array yet)?
> >=20
> > Stop the array.  Recreate it exactly the same way as before, and see if=
 it
> > goes faster.  I think it might - at least until it got up to where it w=
as up
> > to.
>=20
> Um, unfortunately, I do (I didn't actually make the posting until after
> the sync finished), but it should actually be non-destructive to do that
> to an existing array, right?
>=20
> It's just like deleting and re-creating a partition; as long as you're
> *damn* sure you kept the parameters the same, it's a no-op.  Right?

Should be - yes.  But some times it is best not to play with fire.
Up to you....

Alternately, look at /proc/diskstats for the member devices.

The first 4 numbers relate to reads (iOs, Merges, Sectors, ticks) and the n=
ext
4 to writes.

You will probably see about  3 times as many reads as writes.

RAID6 resync reads the whole stripe, checks the parity blocks, and if they
are wrong it writes them out.

If most of them are good - you should see streaming writes at the full speed
of the disk/bus/slowest-part.

If lots are not correct (which can be expected on a new array), you get lot
of=20
    read - seek-backwards - write

sequences, which slow things down a lot.

NeilBrown


>=20
> I still have the data on the backup drives, so it's "only" a day's
> lost work if I fry it (I did some reorganization as well as simple bulk
> copying), so it's not *deadly* dangerous...
>=20
> Thank you for the response!


--Sig_/289TgZtPWvvcNyTyqX+delD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT45TLDnsnt1WYoG5AQL/ExAAhdbcNldqQ6710wtid+9stNk1iu04EFzE
fCdDZP90klwQ1FNvPS7lKgeJ4SCFwGYVM0hJ0RdnjaTXPkgjxWtY5AJQIA8F/QhU
QKhKzoTINRJQBcY/DNJJ+vU/6BJUtHloVKxAHKlB0aBpTkjf9c0Sqcl7ci1aR/S2
n1TQCjyuqj/Ro5QtcmQjWhLmyPc0s5ynbhDgbm2vkMalffV37vUhwMEYv8UtnVth
FKaGorrdz2E1/Y+79kKj9Ch78nMW1LyGfCvobfcUL59peAx8vkpx0csOgbrzXejv
QWjtqEEYfTOAJDJJfi/FPerojA3OE8D+VSGa77RXqwJL9tf93CR5/u2QiKF0nRUH
D19yeVI2qpDL6na719dvypfKRdbDu09F4HuoHjYjUXBD77bK+WDpUP6GKHOT+Kq7
YcyDbiRYWlQTNZ7II4hywYpBWOvrFWEBRfFD/x7kz3fX5nR4SICv1RENMAEDtsSG
ZO1W2GTKpiCT3PMG1by3gz9bq8ImKDUUdL5iHn7KjadL2KjpRXjaf0jT2Rq6YOzQ
UX26BZW+Q3/8oYbGcRCa0zo7S2h5H4Hd0sY2Gz8PWlJAylS9ou8LP4SykhXFY8Rx
zDoYOxWFGO0EmDZ4laJ8ZAj1QOIFpNu0tlaob5YRQaQUd0XmbtGNDR6ZoN7spEYN
cwKAVTboaSM=
=FLgR
-----END PGP SIGNATURE-----

--Sig_/289TgZtPWvvcNyTyqX+delD--
