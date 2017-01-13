From: NeilBrown <neil@brown.name>
Subject: Re: regarding mdadm
Date: Fri, 13 Jan 2017 17:23:02 +1100
Message-ID: <87vatjfph5.fsf@notabene.neil.brown.name>
References: <CAC8PVF-W8dcALXWm4S1qOXoZuimTd_9YhbO9Wg_WihtSpjrJog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC8PVF-W8dcALXWm4S1qOXoZuimTd_9YhbO9Wg_WihtSpjrJog@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sushant Patil <srpatil2259@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Jan 13 2017, Sushant Patil wrote:

> Hi Neil,
>
> This is Sushant from India(Maharashtra).
> I am studying mdadm command (package), its awesome tool to manage RAID.
> but there is lack of documentation related to help and also there is lack
> of explanation regarding examples and hands-on(experiments) on internet.
> so I am facing difficulty in studying and applying this mdadm tool.
> sir I request you to send me some kind of documentation related to examples
> related  to commands with various modes like create ,assemble,monitor etc.
>
> I tried with one link which is "
> http://www.cse.unsw.edu.au/~neil/source/mdadm/"  given in book "Managing
> RAID on Linux" but it is not working.
>
> so sir please send me something related to examples of managing RAID with
> mdadm.

Think for a minute about what you are asking of me.....

You haven't given me any hint about what sort of problem you are having,
but you want me to guess what sort of help you want.
For the thousands of pages about mdadm on the internet, you have told me
that you have looked at just one, and found it wasn't helpful.

Seriously, what do you expect of me?  Do you think I have some secret
stack of example and I have haven't put on the internet for you to find,
but I'll just give them to you when you ask?  Or maybe you think I'll
spend hours writing up some examples just for you.

I recommend you start by reading the man pages:

 man md
 man mdadm
 man mdadm.conf

and then if that isn't enough, look at the test scripts in
the mdadm source tree, in the 'tests' directory.

Or maybe just use good "mdadm examples"

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlh4ckYACgkQOeye3VZi
gbkrzhAAsLJvX9QmMhxDOzDPEkawf0mUE/K35mBzFFw+GNv+G2iNom9jakMHoBJk
BHZk8nRyWIUcm6o4G8QBo3++olOZiYdzHFEAZns51hKes5iXb3pM26nrOyb6V1pL
itPVPpdvDakbNIe8mBKIKezF3QL5Q/u3LSP4YMQ7NNNtNS/fEn10truXLq0KF0Vd
f64V7C0S79dpdggxpUVfkHNO67R8rbcim5xYvWN/T7eGDpgRVeokuec5DyAef+fI
ZodDuHYXfd81xDmhmKrTEmIFkS70L57uvq/Hav/UF8XlYCeP2S7YeFKoGnrFCkjV
n6QRLnIyW+xvVSsbd8NPhoTMMv8pWL2CJLlvYXSpOj3obzr/N6VbIvmW5+GxT6QA
SP1cxGQ7E5CEXGSMB5IHwsxNuXPepSs802ECvDgR3D33Z1dzr8S8zqPbbOWRFYM5
b9l8qs0ExGfFZ0U0T7eWimLeRbNzhK79f9+7hGf7kbLvJHvZM4v71XT3wBt5rWz6
nWh4Lywgzx17S8NeeoJj717XeNmXty0toz/p2+f5fnbBgQz+YwogOuBJwNg238U5
9Gu4g81lkbglaKegG3ZKsw5esHUyaKGhj2Fvxpjp8kHshc6H+UCEET0yPw5yKHKz
Nh/rC1qEU/WvIhjXDs4lfNfwz4UhKxAAJgSTjIGyJXWnn6VBAZ0=
=DIpo
-----END PGP SIGNATURE-----
--=-=-=--
