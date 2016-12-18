From: NeilBrown <neilb@suse.com>
Subject: Re: Fwd: (user) Help needed: mdadm seems to constantly touch my disks
Date: Mon, 19 Dec 2016 09:21:08 +1100
Message-ID: <87inqgvpyj.fsf@notabene.neil.brown.name>
References: <CAJ=9zicFM+wOUhpdX1XEVm+y2gYoW3r2aTRj6gAcEkypxJULmA@mail.gmail.com> <871sxbz4yz.fsf@notabene.neil.brown.name> <CAJ=9zieRuTNiEGuB_RouqbdLGoxNkn09yiogR6rND84LtMdbxA@mail.gmail.com> <CAJ=9zifGPd+3YnP1aLwLPXjtpygRc9DsDP37CNz-VHBHn1vDOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ=9zifGPd+3YnP1aLwLPXjtpygRc9DsDP37CNz-VHBHn1vDOg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jure =?utf-8?Q?Erzno=C5=BEnik?= <jure.erznoznik@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 15 2016, Jure Erzno=C5=BEnik wrote:

> Thanks for helping Neil. I have run the suggested utilities and here
> are my findings:
>
> It is always [kworker/x:yy] (x:yy changes somewhat) or [0].
> A few lines from one of the outputs:

That's disappointing.  "kworker" could be any work queue.

It might be useful to look for large scale patterns.
What different addresses are written to?  Is there are regular pattern?
What is the period?

md doesn't use work_queues for IO so these much be coming from
elsewhere.  bcache uses a few work-queues...

NeilBrown

>
>   9,0    3        0     0.061577998     0  m   N raid5 rcw 3758609392 2 2=
 0
>   9,0    3        0     0.061580084     0  m   N raid5 rcw 3758609400 2 2=
 0
>   9,0    3        0     0.061580084     0  m   N raid5 rcw 3758609400 2 2=
 0
>   9,0    3        0     0.061580084     0  m   N raid5 rcw 3758609400 2 2=
 0
>   9,0    3        0     0.061580084     0  m   N raid5 rcw 3758609400 2 2=
 0
>   9,0    0        1     0.065333879   283  C   W 11275825480 [0]
>   9,0    0        1     0.065333879   283  C   W 11275825480 [0]
>   9,0    0        1     0.065333879   283  C   W 11275825480 [0]
>   9,0    0        1     0.065333879   283  C   W 11275825480 [0]
>   9,0    3        2     1.022155200  2861  Q   W 11275826504 + 32 [kworke=
r/3:38]
>   9,0    3        2     1.022155200  2861  Q   W 11275826504 + 32 [kworke=
r/3:38]
>   9,0    3        2     1.022155200  2861  Q   W 11275826504 + 32 [kworke=
r/3:38]
>   9,0    3        2     1.022155200  2861  Q   W 11275826504 + 32 [kworke=
r/3:38]
>   9,0    0        2     1.054590402   283  C   W 11275826504 [0]
>   9,0    0        2     1.054590402   283  C   W 11275826504 [0]
>   9,0    0        2     1.054590402   283  C   W 11275826504 [0]
>   9,0    0        2     1.054590402   283  C   W 11275826504 [0]
>   9,0    3        3     2.046065106  2861  Q   W 11275861232 + 8 [kworker=
/3:38]
>   9,0    3        3     2.046065106  2861  Q   W 11275861232 + 8 [kworker=
/3:38]
>   9,0    3        3     2.046065106  2861  Q   W 11275861232 + 8 [kworker=
/3:38]
>   9,0    3        3     2.046065106  2861  Q   W 11275861232 + 8 [kworker=
/3:38]
>   9,0    0        0     2.075247515     0  m   N raid5 rcw 3758619888 2 0=
 1
>   9,0    0        0     2.075247515     0  m   N raid5 rcw 3758619888 2 0=
 1
>   9,0    0        0     2.075247515     0  m   N raid5 rcw 3758619888 2 0=
 1
>   9,0    0        0     2.075247515     0  m   N raid5 rcw 3758619888 2 0=
 1
>   9,0    0        0     2.075250686     0  m   N raid5 rcw 3758619888 2 2=
 0
>   9,0    0        0     2.075250686     0  m   N raid5 rcw 3758619888 2 2=
 0
>   9,0    0        0     2.075250686     0  m   N raid5 rcw 3758619888 2 2=
 0
>   9,0    0        0     2.075250686     0  m   N raid5 rcw 3758619888 2 2=
 0
>   9,0    2        1     2.086924691   283  C   W 11275861232 [0]
>   9,0    2        1     2.086924691   283  C   W 11275861232 [0]
>   9,0    2        1     2.086924691   283  C   W 11275861232 [0]
>   9,0    2        1     2.086924691   283  C   W 11275861232 [0]
>   9,0    0        3     2.967340614  1061  Q FWS [kworker/0:18]
>   9,0    0        3     2.967340614  1061  Q FWS [kworker/0:18]
>   9,0    0        3     2.967340614  1061  Q FWS [kworker/0:18]
>   9,0    0        3     2.967340614  1061  Q FWS [kworker/0:18]
>   9,0    3        4     3.070092310  2861  Q   W 11275861272 + 8 [kworker=
/3:38]
>   9,0    3        4     3.070092310  2861  Q   W 11275861272 + 8 [kworker=
/3:38]
>   9,0    3        4     3.070092310  2861  Q   W 11275861272 + 8 [kworker=
/3:38]
>   9,0    3        4     3.070092310  2861  Q   W 11275861272 + 8 [kworker=
/3:38]
>   9,0    0        0     3.101966398     0  m   N raid5 rcw 3758619928 2 0=
 1
>   9,0    0        0     3.101966398     0  m   N raid5 rcw 3758619928 2 0=
 1
>   9,0    0        0     3.101966398     0  m   N raid5 rcw 3758619928 2 0=
 1
>   9,0    0        0     3.101966398     0  m   N raid5 rcw 3758619928 2 0=
 1
>   9,0    0        0     3.101969169     0  m   N raid5 rcw 3758619928 2 2=
 0
>   9,0    0        0     3.101969169     0  m   N raid5 rcw 3758619928 2 2=
 0
>   9,0    0        0     3.101969169     0  m   N raid5 rcw 3758619928 2 2=
 0
>   9,0    0        0     3.101969169     0  m   N raid5 rcw 3758619928 2 2=
 0
>   9,0    0        4     3.102340646   283  C   W 11275861272 [0]
>   9,0    0        4     3.102340646   283  C   W 11275861272 [0]
>   9,0    0        4     3.102340646   283  C   W 11275861272 [0]
>   9,0    0        4     3.102340646   283  C   W 11275861272 [0]
>   9,0    3        5     4.094666938  2861  Q   W 11276014160 + 336
> [kworker/3:38]
>   9,0    3        5     4.094666938  2861  Q   W 11276014160 + 336
> [kworker/3:38]
>   9,0    3        5     4.094666938  2861  Q   W 11276014160 + 336
> [kworker/3:38]
>   9,0    3        5     4.094666938  2861  Q   W 11276014160 + 336
> [kworker/3:38]
>   9,0    3        0     4.137869804     0  m   N raid5 rcw 3758671440 2 0=
 1
>   9,0    3        0     4.137869804     0  m   N raid5 rcw 3758671440 2 0=
 1
>   9,0    3        0     4.137869804     0  m   N raid5 rcw 3758671440 2 0=
 1
>   9,0    3        0     4.137869804     0  m   N raid5 rcw 3758671440 2 0=
 1
>   9,0    3        0     4.137872647     0  m   N raid5 rcw 3758671448 2 0=
 1
>   9,0    3        0     4.137872647     0  m   N raid5 rcw 3758671448 2 0=
 1
>   9,0    3        0     4.137872647     0  m   N raid5 rcw 3758671448 2 0=
 1

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhXC9UACgkQOeye3VZi
gbnbZRAAglvB8Kh3VVpYhf6QWxPahFrKza7GJhchM5iH0wPXa/iMdwo5BhurbFOI
5ss1eAOW4HyL6NIyVzaPc7XVb0yOnu3fgHuME5T/ZsFFV/bEmIzGVu+iExdHa41d
BpZ+mE45L06RwjU6zEEsoMWPfeGhAo2pj3LrVaCHMtlfNb/byQ/dLqoIh2ULfq3o
2Wqvq6y0etrpkpOYu1bxSOgwOF3SMy3VjmyBlB0mJA+GayGsnWqKCJsyuyMuJdVa
I76vSlH1f8pWd8YX1jcM82rprzZx5g1Bm2WNGAjZp2WYKoJyNyc4BU1gNS0aXxM7
n6KrbK3G8LKiMoXeT419W49WBgF3hvDfENXC/FHhSfLXchdjwRnlrdQh2K180uOx
LqVczqhmPNKFXIYTsuLwU388vUrZqbNFOphSPevywK1IRNnTftKcqtJQRsPG+MFX
OTJo+joeJCToLEu8d2/DRmnQGgHHKtoQ0Sr97QOFxqq9+zjlPWP3iOb4e61J1jO8
rcdckJWHjAIqRJAi6T0n96PxKXd5HvLvvQqrFnn1SNK1IM5DNQeE+RDHOTqNkbQo
6ybo6SfJwv45duql1XEx1IP853MzfFDrDoery6ReSk9pJWVW0ysALa4uiTp3OD0Z
TLvKqBf/4B/8wrUSSJZhf9TmpizvV+mT772zQB88NjeaVfBSDkE=
=AN8w
-----END PGP SIGNATURE-----
--=-=-=--
