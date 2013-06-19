From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Optimal value for bitmap-chunk option
Date: Wed, 19 Jun 2013 10:38:38 +0600
Message-ID: <20130619103838.7c3fb6e0@natsu>
References: <51C057F9.3020005@qwarta.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//ojbf6g84OJnvb4sC6wRLSJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51C057F9.3020005@qwarta.ru>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?0KDQvtC80LDQvSDQkNC70LXQutGB0LXQtdCy?= <r.alekseev@qwarta.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_//ojbf6g84OJnvb4sC6wRLSJ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Jun 2013 16:52:09 +0400
=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B5=D0=B5=
=D0=B2  <r.alekseev@qwarta.ru> wrote:

> Hello,
>=20
> I want to speed up rebuilding process of the raid to do that I'm going
> to apply the command:
>=20
> mdadm --grow --bitmap=3Dinternal --bitmap-chunk=3DNNNN /dev/mdX
>=20
> But I don't know how to calculate optimal value of bitmap-chunk option.
> How can I do that?

It's just the minimum granularity of pieces that get rebuilt after unclean
shutdowns. E.g. if your array decides it's "dirty" in 5 different areas, wi=
th
a 16MB chunk the rebuild will process 5*16MB, but with a 128MB it will rebu=
ild
5*128MB. On modern systems the difference in time required to do the rebuild
between these two will be negligible. But having a larger size helps
noticeably in everyday operation (makes writes faster). So there is nothing=
 to
"calculate" really, just use a reasonably large size like 128 or 256 MB.

https://raid.wiki.kernel.org/index.php/Write-intent_bitmap
http://techblog.tgharold.com/2013/01/mdadm-using-bitmaps-to-speed-up-rebuil=
ds.html
http://blog.liw.fi/posts/write-intent-bitmaps/ (the 1st comment)

--=20
With respect,
Roman

--Sig_//ojbf6g84OJnvb4sC6wRLSJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHBNc4ACgkQTLKSvz+PZwjKpQCfckXwud7Sbgg5XECZ2hcIltfK
KlcAn2xWH4BZNVU10bjjL/MQ7357Mflk
=44SF
-----END PGP SIGNATURE-----

--Sig_//ojbf6g84OJnvb4sC6wRLSJ--
