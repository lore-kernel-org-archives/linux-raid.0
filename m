From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 1/1] add display of hours remaining to finish resync
Date: Wed, 2 Nov 2011 10:32:46 +1100
Message-ID: <20111102103246.3f7a9a31@notabene.brown>
References: <1320184427.6471.70.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/F_XQmaXCzP0HLlTpICUIwe9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320184427.6471.70.camel@oxygen.netxsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Adamski <k@adamski.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/F_XQmaXCzP0HLlTpICUIwe9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 01 Nov 2011 17:53:47 -0400 Krzysztof Adamski <k@adamski.org> wrote:

> This is my first patch, so please be gentle.

Always.

>=20
> This patch adds the display of the number of hours till the completion
> of resync of an array in the /proc/mdstat display.
>=20
> Example: [>....................]  resync =3D  3.3% (98633240/2928311808)
> finish=3D1026.1min (17h) speed=3D45957K/sec

Thanks.
While I can see the attraction of this I am always cautious of making
unnecessary changes to /proc/mdstat.
It is very likely that people have ad-hoc scripts and programs which parse
the output and do something with it.
While I think it is unlikely that the change you have suggested will break
any such script, I cannot be at all sure that it won't break one.
And I really don't like breaking things.

There certainly is value in having a way to see at a glance the over-all
status of md.  Currently that is
    watch cat /proc/mdstat
(I run that whenever I am testing).
However if we want to improve it, I think it would be best to write a
separate program that gathers data from there /proc/mdstat
and/or /sys/block/md*/md/  and presents nicely-formatted output.

mdtop??

Thanks,
NeilBrown

>=20
> Signed-off-by: Krzysztof Adamski <k@adamski.org>
>=20
> # diff -Naru drivers/md/md.c-orig  drivers/md/md.c
> --- drivers/md/md.c-orig        2011-10-25 01:11:12.000000000 -0400
> +++ drivers/md/md.c     2011-11-01 17:37:35.000000000 -0400
> @@ -6351,8 +6351,8 @@
>         rt *=3D dt;
>         rt >>=3D 5;
> =20
> -       seq_printf(seq, " finish=3D%lu.%lumin", (unsigned long)rt / 60,
> -                  ((unsigned long)rt % 60)/6);
> +       seq_printf(seq, " finish=3D%lu.%lumin (%luh)", (unsigned long)rt /
> 60,
> +                  ((unsigned long)rt % 60)/6, (unsigned long)rt / 60 /
> 60);
> =20
>         seq_printf(seq, " speed=3D%ldK/sec", db/2/dt);
>  }
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/F_XQmaXCzP0HLlTpICUIwe9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrCBnjnsnt1WYoG5AQJkkRAAsttrku5PPE324FTTe5rI8eAklLoLudFb
7NzOzBL3/o1hq9qrDYo/9y96NAMlYOWvYHRTflXajy63L8AZepzTRz5T1yBgB09U
Zpwmtup5OLA7d3pavwlpHZ5MRk/lxXbtU5cVGZfzyaf3WeYTCDD1dGoV4wdNodQA
+JJg0wWDfpLJy1dJrW+G00MMmy1gPt/xJz7gihDTlDlJGgJWYd0eMSuf6e7fTJmR
VtnR49r3HpwpchNdpIh4UPb9U+CuhACd3CbIo56Q5kqgukkxc10aCOQ7prBl+7xL
Pt+HIYKooBo5dWm/g9rk4tVygYmBt748zu29FkFzwt/4GsKNckeE84UtLzl/unu5
nt0AKgok7I6C/RdyyVaQttvAHKk3piSLmdg7jbYPKwlUGghB1CiA1j25X7uWC/Rg
/w7pWpkX+VsNP8PhAav9u6y9OocBwLudRBWMw+czllp8uEEFxas+5a68FYus2gZC
YO8jJuQC8B8Hz1mUW1rU08ocnympx1/l4e93s74rxQmNVrQA5TLcVwtNTZOxTnmQ
XBiXVTN34Meas31VVnKZUpTOgtAvkz6sc47hQVZSKEXqzaQrmyPkBNLaVNTUUMtR
aSzrbWJwq+8eqG29dxpFtmEzBhWg6IeCmdOaH/kf6wID7df6THIXFPsh7P7EH+Cw
Znsz34K/9a4=
=exzw
-----END PGP SIGNATURE-----

--Sig_/F_XQmaXCzP0HLlTpICUIwe9--
