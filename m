From: NeilBrown <neilb@suse.de>
Subject: Re: Questions regarding bad block management
Date: Tue, 25 Feb 2014 16:59:17 +1100
Message-ID: <20140225165917.38896dd1@notabene.brown>
References: <CAFvQSYTXWG7q92nkENw5p4EDEmEPO85qf28-9m3K2eFhAZK9gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/S3COKe/MplzASYNN4U40AJL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFvQSYTXWG7q92nkENw5p4EDEmEPO85qf28-9m3K2eFhAZK9gQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/S3COKe/MplzASYNN4U40AJL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 26 Jan 2014 22:03:45 +0100 Clemens Eisserer <linuxhippy@gmail.com>
wrote:

> Hi,
>=20
> I've seen several SD cards used in my raspberry pi develop bad blocks
> which can not be read or written anymore.
> I thought raid couldn't help here as it would flag the whole device as
> "bad" once it can not write a block anymore, however recently I
> learned linux-raid is now capable of handling bad blocks.
>=20
> I've been searching a bit, however didn't find a lot of information,
> so I would be greateful if somebody could answer the following
> questions:
>=20
> 1. Is the badblock-code contained in the stable 3.12 kernel?

Yes.  Not sure if it will help you though.

>=20
> 1. Using a raid1 with badblock management, is it possible for
> linux-raid to automatially repair errors transparently?
> So if a block goes bad, does linux-raid silently replace it without
> user intervention.

When raid1 get a read failure it will read the data from another device and
write it to the failing device.  If that works it assumes the block has been
repaired.
If it fails and a bad-block-log is configured, then the address of the bad
block is stored in the bad-block-log and raid1 won't try reading from there
again.  It will always read from the other device.

>=20
> 2. What happens in case a replaced block fails again? Is this supported?

Yes.  raid1 will simply over-write it again.

But I think  you want md/raid1 to remap the bad blocks.  It doesn't do that.
It assumes the underlying device will do any remapping needed.

NeilBrown


>=20
> Any pointer to documentation about bad-block handling would be highly
> appriciated.
>=20
> Thanks, Clemens
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/S3COKe/MplzASYNN4U40AJL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUwwxNTnsnt1WYoG5AQL2tg//Q40U9QJW+JHuRFtwbuGrWPhjpJAg9jFC
hqRMpAN1rInlQy+9HsOWweUXSKnOjxRhC3ezXrFWz+IMn15NvPHTwRWDzpWl2+Me
wKwxZU4o05knHGwbTHzZG7IVkfZ6Yj6SWpMPxYKmkAjz1v3NG0rzwafjzA7YXJxc
fELRIuycX9B2ePy5D1I0R57BKGLF+PiPHDJFmH0inshY4UylfveUIf67TtZYUYKV
z1g6rieky0sPY6B4K2PiXYCuQn+FkY6mkSPpRT8VI2IixrFN4YNKTE4w/sZSZKDb
4CLQVuTMy4EQXPmHK1/fZzDAfnrbu7Jo9FpwWunZGm1HCNaTUIUzFHNY0ZP5hJ5R
IZIkvEkFMvz8PRN1TCON4vEVKQyz+yhyuRBL041uDzF7pq5rud1eEj2Ge4IuQ3v9
b5Y8yUtfbk442anDntTjOkF1jOqCm0hO9ZKJKM1C5/fkpwC+ahsBL/BwB+QwIGys
dcJkjVSXvBa6bthDxC9tYprut1W+fALXFck6NkCb4izQ8Bhssv+i0u7NAWqFw1op
AJdssh//UK/7ywC7O2iSS0YCo2GIt+8NYX3B1wk6Q6C5dD7GuZiI5LVdtFZESxVc
m4vw8Ji2MaZLr843GfXGgOCVkF3PKqe7PiyLSnPWZJEPVBH/F+0lRF98duMV2jGa
bGoSJl+k6qs=
=ChUN
-----END PGP SIGNATURE-----

--Sig_/S3COKe/MplzASYNN4U40AJL--
