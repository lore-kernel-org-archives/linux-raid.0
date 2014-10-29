From: NeilBrown <neilb@suse.de>
Subject: Re: Raid1 element stuck in (S) state
Date: Thu, 30 Oct 2014 07:10:19 +1100
Message-ID: <20141030071019.1a5c57e7@notabene.brown>
References: <87k33lwq7s.fsf@muck.riseup.net>
	<20141029084224.6d92d8be@notabene.brown>
	<8761f3q8gr.fsf@muck.riseup.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/kWLmvHG2Txp8HajixUzs3P."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8761f3q8gr.fsf@muck.riseup.net>
Sender: linux-raid-owner@vger.kernel.org
To: micah <micah@riseup.net>
Cc: micah anderson <micah@debian.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kWLmvHG2Txp8HajixUzs3P.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Oct 2014 10:03:16 -0400 micah <micah@riseup.net> wrote:

> NeilBrown <neilb@suse.de> writes:
>=20
> > On Mon, 27 Oct 2014 10:18:47 -0400 micah anderson <micah@debian.org> wr=
ote:
> >
> >>=20
> >> Hi,
> >>=20
> >> i've got a raid1 setup, where one drive died, it was replaced with a n=
ew
> >> one, but its stuck in a (S) state and I can't seem to get it added into
> >> the array, /proc/mdstat looks like this:
> >>=20
> >> md3 : active raid1 sdc1[2](S) sdd1[1]
> >>       976759672 blocks super 1.2 [2/1] [_U]
> >>=20
> >> where sdc1 is the replaced drive.
> >>=20
> >> What is the right way to get this added back?
> >>
> >
> > I've a feeling this bug might have been fixed.
> > What versions of mdadm and Linux are you using?
>=20
> I'm using squeeze here, and had 3.1.4-1+8efb9d1+squeeze1 installed, I
> just installed the backport, which is 3.2.5-3~bpo60+1.

Is assume that is the version of mdadm.  You didn't say what version of Lin=
ux.


>=20
> > Are there any errors in the kernel logs when you --add the device?

You didn't answer this question either.  Are there any messages in the
kernel log: /var/log/kern.log on debian.
Or in the output of "dmesg".

>=20
> After installing the backported 3.2.5, I tried to add it, and it said:
>=20
> # mdadm --add /dev/md3 /dev/sdc1
> mdadm: Cannot open /dev/sdc1: Device or resource busy
>=20
> so I did a --remove of the drive, and then added it, it then proceeded
> to sync the array, and after that finished, it is now back in the (S)
> state.
>=20
> Can I just zero the superblock of that device and re-add it in order to
> resolve this?


If it resyncs and the is still spare, there was almost certainly some sort =
of
failure.  There really must be something in the kernel logs at that time.

NeilBrown

--Sig_/kWLmvHG2Txp8HajixUzs3P.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFFJqznsnt1WYoG5AQIHGhAAu7T94ikHgiG4QE+Pt5Ot9R03ZIyBmaLn
5zAvmkjd9FPJPLrRzejPq/bPHPGZVFHDfAZxeEaVTxF8av7IumfuunMn+2TolR0c
HTbFMqRnUGDFLQko0NGNj0t0Nt/tGO5HBAnIlux5+fOTP+grg7QOBoqfItRSPq7f
G+ZUjvWGTOp/0SI1+7OqWRnjeakaiWcjOTuNXNSSd+iTk9mR3ryzKHkJ5qNM9ll1
e4bEjn8jPUSLY6SwGjBhuDVrGijttaW+OMIYbwqEjZkWKS3MF/CXxD1Pfji0yxeo
R/w4LGopTD8LR6Elw3uUecXKPzF9Yc4GmOtYq28rWQhnn+yEkI0tP2mEzSyfg9BB
G7xNbqhYv9W+JF7g39NW6peNQwgy5r/1H90JSfAC0kVItDr4GdMplDRjzK+/9iNS
w5SSAVlaoMhu48X6mqhq1jVIHS8h6P0/qE60BZm3tfg7HYIVJnkBuqJ7wZTajuJ8
IwWYxphUGW3X0EzepQo8fTOgOrAfnMDvdLnLYD0DJDojgl1S6YfdUzVS7Ekd5Pjm
TnLnJWqJUMNamZQYzldEJiKpYX7/duMhemD5EnL6Rb6ui/pn35KqgP8QTSR9rc5z
MEss+oh/dIYIGxCNt3+ZgNP/kphkSl0YMo9V/XE03UnAB49TUymUC/lU0WUspK4W
/50wRQhQVdM=
=hAeb
-----END PGP SIGNATURE-----

--Sig_/kWLmvHG2Txp8HajixUzs3P.--
