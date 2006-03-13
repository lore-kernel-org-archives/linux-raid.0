From: Patrik Jonsson <patrik@ucolick.org>
Subject: raid5 hang on get_active_stripe
Date: Mon, 13 Mar 2006 14:36:48 -0800
Message-ID: <4415F400.5030808@ucolick.org>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>	 <Pine.LNX.4.56.0603061156140.26994@lion.drogon.net> <5d96567b0603060456h5f2c3cc8me790c86b74e1f854@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFF0E91E8719892486AA6BB0F"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0603060456h5f2c3cc8me790c86b74e1f854@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFF0E91E8719892486AA6BB0F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi all,

I just experienced some kind of lockup accessing my 8-drive raid5
(2.6.16-rc4-mm2). The system has been up for 16 days running fine, but
now processes that try to read the md device hang. ps tells me they are
all sleeping in get_active_stripe. There is nothing in the syslog, and I
can read from the individual drives fine with dd. mdadm says the state
is "active".

I'm not sure what to do now. Is it safe to try to reboot the system or
could that cause the device to get corrupted if it's hung in the middle
of some important operation?

Ideas appreciated,

/Patrik

--------------enigFF0E91E8719892486AA6BB0F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (MingW32)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFEFfQBT+KvsdUW5p8RAoqdAJ9ivlNSybWuwEgqxLcoqWOPSQcyggCggi9Y
EbNL6cdMfDa0tN1yDk+IabY=
=TFbe
-----END PGP SIGNATURE-----

--------------enigFF0E91E8719892486AA6BB0F--
