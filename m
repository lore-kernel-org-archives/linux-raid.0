From: Patrik Jonsson <patrik@ucolick.org>
Subject: Re: forcing a read on a known bad block
Date: Tue, 11 Apr 2006 15:15:56 -0700
Message-ID: <443C2A9C.7000908@ucolick.org>
References: <Pine.LNX.4.64.0604092000020.29514@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2206837C755018A486BA422D"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0604092000020.29514@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2206837C755018A486BA422D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

hi dean,

dean gaudet wrote:
> 
> the other disk was in a raid5 ... 5 disk raid5, so 20% chance of the bad 
> block being in parity.  i copied the kernel code to be sure, and sure 
> enough the bad block was in parity... just bad luck :)  so i can't force a 
> read there any way that i know of...

well, for raid5 you can use 'echo repair > /sys/block/mdx/md/sync_action'

This does a 'simulated reconstruction' and has triggered this for me in
the past. (For some reason 'check' instead of 'repair' did not, even
though it should have tried to read all the blocks then, too...)

That said, I have one disk in an 8-disk raid5 that says 'current pending
sector 1', and another that says 'offline uncorrectable 1', and they
have been doing so for months. Neither SMART extended tests or full
raid5 resyncs have either failed or fixed this, so I don't know what's
up with that...

cheers,

/Patrik

--------------enig2206837C755018A486BA422D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (MingW32)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFEPCqcT+KvsdUW5p8RAmcOAJ98q+2+rBfGTdeLXStlGnEOWx5vFQCfTHH4
YCaM08yTMPeYor1XXTCcwyc=
=53vY
-----END PGP SIGNATURE-----

--------------enig2206837C755018A486BA422D--
