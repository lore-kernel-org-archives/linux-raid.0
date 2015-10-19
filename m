From: Neil Brown <neilb@suse.de>
Subject: RE: [PATCH v2 0/6] mdadm support for journal device of RAID-4/5/6
Date: Mon, 19 Oct 2015 13:11:40 +1100
Message-ID: <87lhazli8z.fsf@notabene.neil.brown.name>
References: <1444369906-1804157-1-git-send-email-songliubraving@fb.com> <C709E4D363AAB64590BFAC54D4C478AA0104B94E0A@PRN-MBX02-4.TheFacebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C709E4D363AAB64590BFAC54D4C478AA0104B94E0A@PRN-MBX02-4.TheFacebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Song Liu <songliubraving@fb.com> writes:

> Hi Neil,=20
>
> Could you please share some insights about kernel and mdadm patches for=20
> journal device in RAID-4/5/6? What shall we do next to move this approach=
=20
> ahead?=20

I hadn't been looking at the mdadm patches until I was fairly
comfortable with the kernel code.  I think we have reached that state
now and I have just looked at your mdadm patches.
These seem quite sensible and thorough - thanks.  I have applied them to
by 'master' branch.

Would you be able to write a few test scripts to go in the 'tests'
directory?
Some of your changelog comment demonstrated how some commands would work
and others would give useful error messages.  If there were test scripts
which confirmed the code continues to do that (and maybe more) that
would be great.

Also a section of the md.4 man page (similar to "BITMAP WRITE-INTENT
LOGGING" and "BAD BLOCK LIST") which gave a general outline of the
purpose, value, and possible costs, of using a journal would be really
helpful.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWJFFcAAoJEDnsnt1WYoG5vj0P/iVhLFAW6O3XbosekUmoBVhz
unyYWcsBmJ0SwAo17GYnDJovKLVDJ2GXqwRk1laOTHXSG39OJB0t9BgPxzEQEPuq
8eUqEhJSyGimgQhmv+Q7y3qWJpQ4GR38/dPxGivZJC6EiQLonFdfAXTHZMZEpQ6N
RyrbIcg+GFK70VzpHS39aeHB6eyNM7yDCGaY6d0Vhic94C4L/t15pvrBgzo5/09m
3XAbIwqh7uKSbhSrveizk+MnLkqWkn5/KDBzuaPHT4nLSXsIZ3Fd0JwpRvm6tAeu
p/Y4DCMCGt9LR9mntnVtjR9TFHcBrzQ4w4cu2VIi0u60DbEATe7BB4vr1MLIfNuS
5Hn9OieMWnukFCvEsFbKtr/7MqN+Kt0qFpkshT2elOiVN4Fvbs+icdOuLD2dwTUE
WJXy2mI+9g6FT4ae+hpR2SHlI442r3bzY4Dt+/7gfUuUvA9gnPzhf1XRnDjE+wdm
uZ2ZSIqYC5EP4wTzQvkotxvaqJmn2vOKhs2TmimwkoDY4KXAsSO2uaOqjynC1GB3
MdJMLtEH2bb6frT1jljGFBeFa9x6yPCHCNCFTMukV7KHJhjOBn0UxRE+SP60IJn4
E9UhWQuTPSwGmeyU9l60Z36AIIbTZLLdUCvklwj7hCgO74F7cCHb5AFNkPbsGENm
8teOQMzlQMErfevjvrsq
=Zsah
-----END PGP SIGNATURE-----
--=-=-=--
