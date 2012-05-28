From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/4] Move setup code to a function and introduce
 matching cleanup argument
Date: Mon, 28 May 2012 10:56:41 +1000
Message-ID: <20120528105641.7dd20b5f@notabene.brown>
References: <1337959448-5299-1-git-send-email-Jes.Sorensen@redhat.com>
	<1337959448-5299-5-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4VLwYV9PNaC4BeruHPyixli"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1337959448-5299-5-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/4VLwYV9PNaC4BeruHPyixli
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 May 2012 17:24:08 +0200 Jes.Sorensen@redhat.com wrote:

> @@ -231,7 +233,7 @@ do_test() {
>      if [ "$savelogs" =3D=3D "1" ]; then
>        cp $targetdir/log $logdir/$_basename.log
>      fi
> -    if [ "$_fail" =3D=3D "1" -a $"exitonerror" =3D=3D "1" ]; then
> +    if [ "$_fail" =3D=3D "1" -a "$exitonerror" =3D=3D "1" ]; then
>        exit 1
>      fi
>    fi

I merged this fix back into the previous patch that introduced the bug :-)

Otherwise - all applied,
Thanks.

I'll definitely be using the --no-error option!

NeilBrown


--Sig_/4VLwYV9PNaC4BeruHPyixli
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8LNSTnsnt1WYoG5AQI5QQ/+PbRhQwzrzP5k3HMwcfaDf93ZDSN2Qz8g
KLAyHX/o2v4Mgz8m9VbdrRls5saIKLiv/1C1yw3ZIKqQIbuiikBS6N+tmGes6xpX
wbUnCSxjLAXPl8LMH3AZ5glDIJzSleIfSQpCBnEl4q0uflehHTTx8hu2ijdFuNw0
K0Q3SmvSQDJwcC1hm9l8A4aCFiSCe1axItRMZDPnOAMsavDNuaKPeNTDqioZOopq
tMpZ+MNBnWyVNqhlEnYYet57vohjqeJ+j8qzP92wdtYJGoESiQASwzHfIgTAfwQb
tRR/YjzWqAvTzSizkiLx2jVaiPKc306dEQe4V/jH3S3/KyLqK7by0GZwm8+7w0y0
ID6BsX5ApafoX9d3wYNM3/z7KTx3kU+eLriCbhVc/ZfJOqyg79VpPMMdFmAuOI3d
5w74ueGYGGWF5lIPNSYO67y2Kley8kNbZwpfUvaOSyyMNa2KVMfuGY5+20yfVDws
TL+UHSVnyF+8PME3nW7wnQ9yJ0NRoSDjbjhrdZm28X56QzYwaoqWVcEnZ/AZqgo7
F+Yoza1Rw+GH1jWvPmrAkUcfmnAwdqY/IE6saYxHTfE9abCLuXcqohDprOhVoRYk
kHS1wMgdFnx2b0scuTkTAm2uYaZ4oFIsCk3YT7tqjaxNPhX9kjW+X+sAmwmRyDdR
yhy42IG1sBE=
=Y73j
-----END PGP SIGNATURE-----

--Sig_/4VLwYV9PNaC4BeruHPyixli--
