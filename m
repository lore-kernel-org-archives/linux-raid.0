From: NeilBrown <neilb@suse.de>
Subject: Re: What happens with array when external write-intent bitmap
 fails?
Date: Mon, 22 Sep 2014 13:37:13 +1000
Message-ID: <20140922133713.53a1ff27@notabene.brown>
References: <CAA91j0X2WSyF_QuZdoWWNgDCZV7TKJbhQmq_vOrygqzkg3yK8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/TFR7Jga+lgHaDvoj/EYeb.e"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA91j0X2WSyF_QuZdoWWNgDCZV7TKJbhQmq_vOrygqzkg3yK8g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/TFR7Jga+lgHaDvoj/EYeb.e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 16 Sep 2014 17:42:13 +0400 Andrei Borzenkov <arvidjaar@gmail.com>
wrote:

> Theoretically write-intent is optional, so if it fails it would be
> possible to simply discard it and continue. But I have seen statement
> that if external write-intent bitmap file is not available at time of
> assembly, starting of array fails.
>=20
> Thank you for clarification.

What exactly did you want clarified?

I suggest the best thing to do is to use "losetup" to create some loop-back
devices.  Then use mdadm to create an array using those devices.
Then simulate the failure mode that you are concerned about and see what
happens.

If you find that the documentation does not agree with reality, please
consider posting details.

Thanks,
NeilBrown

>=20
> -andrei
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/TFR7Jga+lgHaDvoj/EYeb.e
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVB+ZaTnsnt1WYoG5AQKd/g//T79ps6X+EW2lmlmdCjanbZA4bPBEMwZI
FXOY2PYRaskOeAYvDS0oylhFcjZzOSLegRRy7fFLYFAHZSMF2aExtf2rnjJxYL1d
drtoVvLmbtjwL6rQRAePD1XG+ER59OzFbJCiavqe+plXBel8lMiYNK1ikpEgau3z
XoRPE75DRqAA+UkANCC6kPB28KJqnJY2lddMvEnjzQn4ZnD3i8T9CxiBSEfwqAtD
Q9oITwgL0jA6pNq3L9rpPr4ur3UKvQW/ygAKSvyJvGxQejk4zmz5qWmGtzh1K+RD
JiytHj7hFxngDAP5UxVXInmCCN74Sgi7xBX/Gdy31B8OgRpZ2Q7a2s90rrFXTIV7
s7Ooq0Rm3act3/m8CqX/7ZPFaXbymi3htQ8aPLaHYZaW1njHiH4zSH2NeV5F5FvS
rHN7rzD6SDhEzBWnoGBiWGA3YiWjia4yetLBHrzVugeJgmXwKgJolBSRTiXQtGzO
351VDDXR277vlugUBzNCYNttmZUC83QkuzeVYvzZMkLSYVWXqoNLXUa4/SzdK+k2
5BLLKhDJLJKkYk4u/fwpOGqqxeCvQq44H09zoM/bO4u0c1mIqUK2nyiQw56m6UQM
lPG+eamuGSh0XU2aPRfRjBZVVQ73xAoVz5N1dBvnhsI39t+13V9nXNx6ouuCkQ1i
EjaZKFtKd6I=
=dQWG
-----END PGP SIGNATURE-----

--Sig_/TFR7Jga+lgHaDvoj/EYeb.e--
