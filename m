From: NeilBrown <neilb@suse.de>
Subject: Re: unable to assemble (mostly?) clean array
Date: Mon, 9 Dec 2013 10:55:07 +1100
Message-ID: <20131209105507.0273bf9e@notabene.brown>
References: <CACw0PsYr+u=YqXQJtUBLDzoppXPWCoRRLUqvgPLE4_L+V68iZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/L_K4FRmRvXEPXzEbPMqmeoA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACw0PsYr+u=YqXQJtUBLDzoppXPWCoRRLUqvgPLE4_L+V68iZw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Hoover <ch@murgatroid.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/L_K4FRmRvXEPXzEbPMqmeoA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 8 Dec 2013 15:32:42 -0800 Christopher Hoover <ch@murgatroid.com>
wrote:

> hi folks,
>=20
> what's the safest way to get this array back into r/o mode?
>=20
> thanks,
> -ch
> ch@murgatroid.com
>=20
>=20
> ch@snaggle:~$ sudo mdadm --examine /dev/sd[defg]1 | egrep 'Event|^/dev/sd'
>=20
> /dev/sdd1:
>=20
>          Events : 286024
>=20
> /dev/sde1:
>=20
>          Events : 286011
>=20
> /dev/sdf1:
>=20
>          Events : 286024
>=20
> /dev/sdg1:
>=20
>          Events : 286024
>=20
> ch@snaggle:~$ sudo mdadm --assemble --force  /dev/md0 /dev/sdd1
> /dev/sde1 /sdg1
>=20
> mdadm: cannot open device /sdg1: No such file or directory
>=20
> mdadm: /sdg1 has no superblock - assembly aborted

You missed a "/dev" there!

Did you try just giving all the devices to mdadm and letting it pick the be=
st?

 mdadm --assemble --force /dev/md0 /dev/sd[defg]1

?

NeilBrown

--Sig_/L_K4FRmRvXEPXzEbPMqmeoA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUqUG2znsnt1WYoG5AQKniA/5ARYIlBzF79E/rqTtIcxaL6pzsBjFbk+W
Qck6tg5uw4VzUjF3osrdSMnkhiQ0iQKZZIrsALnlKntOTkY/GY1g5yAu4PJjQfNF
/Szg7qTF0yhiBMs1kZEaWYSNpnRBrIedLZdKQ/SxxmPpn7sJU30xXZnpN/r3/EWi
002x5vrXHFyc+ATNJNdMBRZf1izTTrerUZHMQLcjalQFmFrmjsq3oJ2BQT/VdB2T
z6xtoZqNCg1gty0yvMlEqnw+G4HMI4a8Jf6JBjsskww8IkRf0oLqAGic+3DQXhVZ
Jk/N5Qtdb4AxnXwmxKe+KC4b6A5o2A6WsbDWdlT13Lh5UDBiovUsuFIW4zC+jV2J
Pk4K7KyCHoDNeTcJ0W5Uh+nW1i3iJW6bcNN7s3uWxvls41y16ry6xZbe8UIQH+ZV
dIvLVPuHw3sc6OXoSdByp92MG04XA+2i+8fVpInLRLWanj8lCNDe9aMuPe7U2Pt9
YH+RYCgADqL5v0QZzPXxMSDFwd2mG3SLBxmhhw16vPuUlgu9DBZ+p/JMcHESJgf8
uJWI6rkgeSo3Vo3KxM19tM/Md5TpY2YEZ0Dk602L1VBaXv9Mz0CdyRq+HbBrL7Hy
A/W3O/8jxmGDk/UilB7BLhi+CicIOdbrBOldcxxr/aOPi116r+Lk26JSQW5RplCL
ERe//XKVwYw=
=6rPM
-----END PGP SIGNATURE-----

--Sig_/L_K4FRmRvXEPXzEbPMqmeoA--
