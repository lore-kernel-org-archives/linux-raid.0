From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: mdadm 3.1.1: level change won't start
Date: Wed, 23 Dec 2009 17:47:43 -0600
Message-ID: <0B.0F.01470.82CA23B4@cdptpa-omtalb.mail.rr.com>
References: <73e903670912202039y1a38df60qdbfbb8623c3f8856@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903670912202039y1a38df60qdbfbb8623c3f8856@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Michael Evans' <mjevans1983@gmail.com>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> >> Three questions -
> >>
> >> 1. What does the stuff about "metadata format 1.10 unknown" mean?
> >> Notice the "super 1.1" vs. "metadata 1.01" vs. "metadata format 1.=
10"
> >> disrepancy between mdsat, --detail and --grow output.
> >>
> >> 2. Am I doing something wrong? :)
> >>
> >> 3. How can I get more info about what is causing the failure to
> >> initialize the growth?
> >>
> >> Thanks!
> >>
> >> -- Kristleifur
> >>
> >>
> >> (P.s., I'm cc-ing this directly to Neil Brown as the maintainer of
> >> mdadm. I hope that isn't rude of me.)
> >> --
> >
> >
> > I thought there were three metadata variants for 1.x: 1.0 1.1 and 1=
=2E2
> > =A0Maybe the extra 1 or 0 at the end refers to a reshape in progres=
s?
> >
>=20
> Thanks for the reply. FWIW, I intended the array to have metadata
> format 1.1 when I created it. I've noticed these "1.01" messages
> before, so I believe it's not due to the reshape. However, I'm
> thinking the funny metadata might be interfering with the reshape
> somehow.

	I'm getting the same thing on one of my systems and not on the
other:

RAID-Server:/etc/rcS.d# mdadm -V
mdadm - v2.6.7.2 - 14th November 2008
RAID-Server:/etc/rcS.d# mdadm --detail --scan
ARRAY /dev/md0 level=3Draid6 num-devices=3D10 metadata=3D01.02 spares=3D=
1
name=3DRAID-Server:0 UUID=3D5ff10d73:a096195f:7a646bba:a68986ca

Backup:/etc/initramfs-tools# mdadm -V
mdadm - v2.6.7.2 - 14th November 2008
Backup:/etc/initramfs-tools# mdadm --detail --scan
mdadm: metadata format 01.02 unknown, ignored.
mdadm: metadata format 01.02 unknown, ignored.
mdadm: metadata format 01.02 unknown, ignored.
mdadm: metadata format 01.00 unknown, ignored.
ARRAY /dev/md0 level=3Draid5 num-devices=3D8 metadata=3D01.02 name=3D'B=
ackup':0
UUID=3D940ae4e4:04057ffc:5e92d2fb:63e3efb7
ARRAY /dev/md3 level=3Draid1 num-devices=3D2 metadata=3D01.02 spares=3D=
1
name=3D'Backup':3 UUID=3D3615c4a2:33786b6d:b13863d9:458cd054
ARRAY /dev/md2 level=3Draid1 num-devices=3D2 metadata=3D01.02 spares=3D=
1
name=3D'Backup':2 UUID=3Dd45ff663:9e53774c:6fcf9968:21692025
ARRAY /dev/md1 level=3Draid1 num-devices=3D2 metadata=3D01.00 name=3D'B=
ackup':1
UUID=3Dd6a2c60b:7345e957:05aefe0b:f8d1527f

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
