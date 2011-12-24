From: Philip Hands <phil@hands.com>
Subject: Re: RAID1 seems not to be able to scrub pending sectors shown by smart
Date: Sat, 24 Dec 2011 15:30:40 +0000
Message-ID: <87vcp60yxr.fsf@poker.hands.com>
References: <87hb0r2kvq.fsf@poker.hands.com> <CAAMCDedN7nBrt7nLoUq2v26ZoX21ab+htowc3r2A=nOAvfF42A@mail.gmail.com> <878vm32dan.fsf@poker.hands.com> <4EF5001F.8050409@gmail.com> <8762h62sgb.fsf@poker.hands.com> <4EF5E161.5010001@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EF5E161.5010001@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Transfer-Encoding: quoted-printable

Hi Phil,

On Sat, 24 Dec 2011 09:27:45 -0500, Phil Turmel <philip@turmel.org> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> Hi Philip,
...
> > Well, given that something appears to be blocking in a fairly
> > disastrous way on the read that's not coming back, I was wondering if
> > there might be some way of having a timeout on those reads that if one
> > gets no response for long enough (say 10 seconds) reacts by getting the
> > data from elsewhere, and overwriting the slow sector.
>=20
> Have you set up TLER or SCTERC on these drives?

The WD Caviar Black model doesn't appear to support that, judging by the:

  Warning: device does not support SCT Error Recovery Control command

in the smartctl output.  As for TLER, threads like this:

  http://www.eggxpert.com/forums/thread/602903.aspx

suggest that there used to be a DOS utility for doing it, but that WD
have since disabled the ability to set that -- and TBH the chances of me
scheduling down time, and working out how to boot DOS on a system with
no floppy, which is in a co-lo centre where I generally am not, are slim
to say the least -- I'd be more likely to simply replace the disks if
that's the only solution, since I'm not impressed with them so far.

> I suspect you haven't, as these long delays on read errors are typical
> of default error handling on consumer drives.

That's my understanding too.

Unfortunately, this enlightenment only came to me after I'd already
bought the el-cheapo drives, rather than the overly expensive RAID-ready
model.

You may say that I deserve what I'm getting, but I'm rather used to
Linux being able to get the best out of cheap hardware, and was hoping
that this would be another example where that could be made to be the case.

> Can you show the complete "smartctl -x" output for this failing drive?

  http://hands.com/~phil/tmp/sheikh.hands.com-smartctl-e-sde--20111224

Cheers, Phil.
=2D-=20
|)|  Philip Hands [+44 (0)20 8530 9560]    http://www.hands.com/
|-|  HANDS.COM Ltd.                    http://www.uk.debian.org/
|(|  10 Onslow Gardens, South Woodford, London  E18 1NE  ENGLAND

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCgAGBQJO9fAgAAoJENBLo6ABJdXAVhYP/1JBuZs1EPFbphG67ZqcS+Qu
PNlCEwOHVSBwGNFgjwmryrwrEbRgz/wWv3BnB87HJ2pFXT1shZnz/lKfg3/fsG3+
+QZdeXFG91gnf3c5ZDF2NI2gH9/v0ycRpG/FrgKr4+DGTB8+hdzkzLtsgtIfLdNq
8cBspo2QLs1eM7zLITABMGLw5aRq9/0dYptD9YU6jxxdz/gvgCxqOFDCl2LkB9HR
xOJ4b22qAzxV75zEDrkmUMzwghMmgb/k5/9IF1VgrdqKyxauM/wqLAGvQkyraaHb
y5vF9vEVrJqHFQpmQcWjPmGm1z1VEbBJNrzPrb9mrt/0Wm+MeNeY3WNikaEDkwoH
NLyWlYhtZkeqlJSnb6SPOpNbjfedClOKa4k5h/4kVkJVBzVCqjn/VcupcpiR47Bq
wvQFYsoXDxbtlph07kDuxZpXcdbG/PKHVLfSaOOp1avLfKS09+mVaGfgOeIxKqWl
0CMQmIuaOCjKUnU47q6H1bh+QIrX+R36R3jE6c83xquXqJ49sEPDcgZsMKZNMF2X
HaCW2LCsZrGIMa2KySlajYtbiMcqBrgj4MsQk7fRZ6V2NSmrrriwBjgvIP2tTyZu
XT8HSJHkQYrHdjjpDNXD2oh0IUtPYGIGVeq3nGJQIpxHU3urD3ezPG/JkJIiepim
4CuO9vg3GNil6yTHaZ2J
=1wC6
-----END PGP SIGNATURE-----
--=-=-=--
