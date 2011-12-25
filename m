From: Philip Hands <phil@hands.com>
Subject: Re: RAID1 seems not to be able to scrub pending sectors shown by smart
Date: Sun, 25 Dec 2011 15:07:53 +0000
Message-ID: <87liq01ygm.fsf@poker.hands.com>
References: <87hb0r2kvq.fsf@poker.hands.com> <CAAMCDedN7nBrt7nLoUq2v26ZoX21ab+htowc3r2A=nOAvfF42A@mail.gmail.com> <878vm32dan.fsf@poker.hands.com> <4EF5001F.8050409@gmail.com> <8762h62sgb.fsf@poker.hands.com> <4EF5E161.5010001@turmel.org> <4EF5F5C0.6050908@gmail.com> <4EF66D45.3020802@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EF66D45.3020802@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 24 Dec 2011 19:24:37 -0500, Phil Turmel <philip@turmel.org> wrote:
> On 12/24/2011 10:54 AM, Roger Heflin wrote:
> > On my Seagates I turned down the SCTERC to really low (ie .2 seconds)
> > and from what I could see it did not make an obvious difference in
> > the length of the time that the system paused, the pauses appeared to
> > stay at about 30 seconds...which I guess implies that the actual read
> > failed timeout was being hit rather than the disk returning an error
> > in a reasonable time...from the log each time it was forcing a
> > re-write it appeared to be 8 sections of 8 sector each so 32k of
> > data, 64 sectors.    I seem to remember there is a way to turn down
> > the disk op timeout...but at least on my system turning it down lower
> > would mean that the disks might not have enough time to spinup out of
> > a sleep...
>=20
> On the drives I've checked closely, any SCTERC setting below 6.5 seconds
> is discarded and treated as zero (no limit).  Setting timeouts in the
> driver stack below the timeout in the drive is counterproductive, as
> drives won't abandon the error recovery attempt to reply to the controlle=
r's
> next command.  So the drive gets kicked out of the array as completely
> failed (unresponsive) instead of dealing with the localized read
> error.

Well, that's fair enough, but I'm guessing that it would be relatively
cheap to notice the fact that the read took _ages_ to return, and treat
that as a failure of sorts, even if the drive eventually claims success.

Then, at least the sector would be rewritten, which would either solve
the problem by refreshing the data, or provoke the sector to be re-mapped
if the physical sector was really damaged.  That way you'd not be
constantly bumping into the same pending sectors, provoking extended
read attempts, and thus degrading the whole system's performance.

Alternatively, some way of nudging mdadm into rewriting a sector in one
device from wherever it's stored elsewhere in a RAID, could be combined
with something looking for read failures in the logs, without needing to
add any extra checks to the normal operational code.

Cheers, Phil.
=2D-=20
|)|  Philip Hands [+44 (0)20 8530 9560]    http://www.hands.com/
|-|  HANDS.COM Ltd.                    http://www.uk.debian.org/
|(|  10 Onslow Gardens, South Woodford, London  E18 1NE  ENGLAND

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCgAGBQJO9zxJAAoJENBLo6ABJdXAj4QQAIyk9IaFHqZvtu0QV8KyQDVF
/zlv996cqhKmnbFG4nrFyg3m43KB/iYdORg9vix7uyLR/KXpJ7MSRRcVEMd9X3XR
mtG4joUiR1lha87xdvPjA85MHSj0pBM/XuESfDgr8UG18COxt7S6f6fEdXinZsxx
/BuKwvmetvuEWE75dMxlarNVD4i2attGwouTMp5TxCLy+4GsPDhULPzFXGLvPye1
juMaNyJ3BDzY6xQV1yTFh1LswRKtYvN9PVf78Uky437CtDrxax5Afro2x4gXTt1A
yfysvxYJhPMdpsNZVMG8edgrAgYBTqs9Y9KmNlWxMzV1tlE8a584shuwrZ0bNFpZ
JjDu3nqaa+iS64kURRGfNQbAF3D8co80uoBuyoCm3ib1nLtEGWFVFPmAIHifre5T
SqPF+nvSTjBdNvxTe6Zz9zp1T93toNhU4CbKC6a8J3Fdhm9x/Xx7RH9Yj2H6T0RJ
4lNfE8swax21R7CjFVnQKW1/mvKMo+p1dTJmJsWCe7xUcLNxHLCEL4EtHRE4FQ8J
cTmBVlj5rH9eCF8m9fkuVuwKr44lXfY4bXPporyc4MOPun/3D4LqSJXhPKl3/D0B
88Bwf5y7GTKXx+slO0y2BvFtDQ0i167KTfgRN7UFsW4DJyzK+L3aLKPVCjkKXnRp
UY704+FGkxjhrn4cLBUL
=qAcE
-----END PGP SIGNATURE-----
--=-=-=--
