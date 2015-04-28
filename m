From: NeilBrown <neilb@suse.de>
Subject: Re: Massive RAID-1 desync
Date: Wed, 29 Apr 2015 07:39:07 +1000
Message-ID: <20150429073907.7f15d1b6@notabene.brown>
References: <1919189912.18202330.1429908372364.JavaMail.zimbra@laposte.net>
	<1810942606.18204832.1429908469113.JavaMail.zimbra@laposte.net>
	<20150425172527.21a34428@notabene.brown>
	<824955940.20886272.1430038117467.JavaMail.zimbra@laposte.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/F0w4mM8z/FkjjMG+.5MuU0c"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <824955940.20886272.1430038117467.JavaMail.zimbra@laposte.net>
Sender: linux-raid-owner@vger.kernel.org
To: Jean-Baptiste Thomas <cau2jeaf1honoq@laposte.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/F0w4mM8z/FkjjMG+.5MuU0c
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 26 Apr 2015 10:48:37 +0200 (CEST) Jean-Baptiste Thomas
<cau2jeaf1honoq@laposte.net> wrote:

> On 2015-04-25 17:25 +1000, NeilBrown wrote:
>=20
> > Perfectly normal.  Metadata is at the end, at least 64K from the end
> > and 64K aligned.
>=20
> Yes. Format 0.90.
>=20
> > And what were those messages about sda?
>=20
> The actual messages have been displaced by lockd's rambling but as I
> remember, it was this sort of thing :
>=20
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> ata1.00: BMDMA stat 0x4
> ata1.00: failed command: READ DMA EXT
> ata1.00: cmd 25/00:80:a9:54:70/00:00:74:00:00/e0 tag 0 dma 65536 in
>          res 51/40:00:25:55:70/40:00:74:00:00/e0 Emask 0x9 (media error)
> ata1.00: status: { DRDY ERR }
> ata1.00: error: { UNC }
> ata1.00: configured for UDMA/133
> ata1: EH complete

A clean "media error" on READ should involve the block being written and if
that fails, the drive ejected.  I wonder if the controller got confused.

>=20
> I ran e2fsck on copies of sda1 and sdc1. They are both heavily damaged,
> not just sdc1.

That is rather sad.  I'm having trouble  imagining any scenario that would
result in the symptoms you are seeing.  Very odd.

>=20
> Looks like I'm going to have to replace a disk and see. I'd like to
> avoid replacing two, though. Or going through more crashes. Does=20
> MD have a paranoid mode in which reading a sector from a RAID-1
> device would not return successfully until it got matching data
> from at least two components ?

As mentioned separately: no.

If it were me, I'd probably be feeling suspicious of the controller at this
point.  If it is a cheap one, maybe replace it.

NeilBrown


--Sig_/F0w4mM8z/FkjjMG+.5MuU0c
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVT/9+znsnt1WYoG5AQJXwQ/8DGb/z56uzEouFJU9sJlWKz4xCWY4bmuH
F1CAaZcxODj8fFIETGxAZScrfgp2HSuaTeCfiGT/Tv28Io6TaTSzngyRZ13uCP+E
CR89iFu1Q2wfNnLzU7GkUxK8IXdeZJVXbWFHWKAwhJROslQIHhcRFWsmSX3KY3Bu
B+StXpcyll4jqzu/5sI81JghJ9ybblzMLd9gxnNE4yGEOi4fqLDUCgMCskko7ns8
Hmvvs0PJ868rSrvMqeIbv2Kdw6i1rQiQIWX8YcP+evuWyLJlM8zPSZI0OVLcQCRl
gySZJ/+F4aC+1JdskDEZgIWr4XTi7BL3c8LDfEmrOiTOiya9sqs3lgvUUKEbOCR7
t+b68Krh4pAujwB5Q9CKcgrx9szqWh6sN49phnkMavuVwczeM/ijE4QT9r7LQ/Ny
dFcQcuJJmfLU0HafuE6rf1+nq3f0Rb6iTrDHOiO2JVTGnBani6qskyUcpf/od/vK
LxaM/IsrJQwXrCGFYF3Y+JLAZ3BgpmCmNkFx0HsmS088ZXpxnLtRtq6MSHqHoWLJ
ltIJqctk7LZnMKLle3/u+V7nZVhl+nVnHDeafD80ZgCFIV1BYs6jpkF0kTanj5QX
1OqhRQakiGZuXFRpZfVRLQNyQt8NuQg5DGaX3GM6T5DELc+yLYupsDZ7KCaPiuf5
9fW6km05F5g=
=Hs0h
-----END PGP SIGNATURE-----

--Sig_/F0w4mM8z/FkjjMG+.5MuU0c--
