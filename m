From: Andre Noll <maan@systemlinux.org>
Subject: Re: Raid6 array crashed-- 4-disk failure...(?)
Date: Wed, 17 Sep 2008 10:25:10 +0200
Message-ID: <20080917082510.GB17300@skl-net.de>
References: <48CE250C.8000603@ultratux.net> <20080915125951.GA17966@skl-net.de> <48CE9811.60307@ultratux.net> <20080916082509.GA17300@skl-net.de> <48CFF1E9.30006@ultratux.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48CFF1E9.30006@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: Maarten <maarten@ultratux.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19:50, Maarten wrote:
> >While looking at the logs I found a plenty of those:
> >
> >	set_rtc_mmss: can't update from 150 to 43
> >
> >And indeed this machine started to have serious problems with its
> >clock since last weekend. I found it off by 12 hours yesterday and it
> >is still runing much too fast so that ntp is not working any more. I'm
> >currently setting the time with a script in 10min intervals...
> >
> >Were you also seeing such messages during/after the hard disk failures?
>=20
> Nope, nothing there.
> Strange your clock is so erratic. Maybe the BIOS battery is dead, then=20
> again I would not be surprised it runs off mains when powered up.

I don't think it's the battery because this machine is only one year
old. Moreover, AFAIK, the battery-powered clock is only used during
system boot and I haven't rebooted the box yet. It's up for 113 days
now with no problems at all until last weekend. So I'd rather guess
it's a software-related problem, perhaps something like an integer
overflow in the timer code.

> >You could use jbod mode (or create single-disk "raid arrays") with
> >Areca or 3ware controllers and use software raid on top of that.
>=20
> True, but then that would kind of defeat the whole purpose of the fairly=
=20
> expensive card.

You'd still profit from the battery unit contained in such cards and
the (hopefully) better driver.

> In that case a better investment might be a sort of servergrade
> motherboard which has 6 good onboard controllers and at least two
> separate PCI buses for the add-on cards. (For the price of one 12 port
> Areca you can already buy a bare bones low-range server...).

Well, the box I have troubles with contains such a servergrade board
with 6 onboard SATA controllers ;) Fortunately, we have a couple
of unused 3ware cards lying around, so I prefer to use these in
the future.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFI0L7mWto1QDEAkw8RAgGvAKCExtTI9iu5kjUxPefW/yUqw2iLBwCfc9qm
PZZNogG6aUdDhvGVA8soCE4=
=gFNy
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--
