From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: striping of a 4 drive raid10
Date: Sun, 27 Jan 2008 20:11:35 +0000
Message-ID: <18332.58743.852744.907807@tree.ty.sabi.co.UK>
References: <20080127193345.GA5426@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080127193345.GA5426@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Sun, 27 Jan 2008 20:33:45 +0100, Keld J=F8rn Simonsen
>>> <keld@dkuug.dk> said:

keld> Hi I have tried to make a striping raid out of my new 4 x
keld> 1 TB SATA-2 disks. I tried raid10,f2 in several ways:

keld> 1: md0 =3D raid10,f2 of sda1+sdb1, md1=3D raid10,f2 of sdc1+sdd1,=
 md2 =3D raid0
keld>    of md0+md1
keld> 2: md0 =3D raid0 of sda1+sdb1, md1=3D raid0 of sdc1+sdd1, md2 =3D=
 raid01,f2
keld>    of md0+md1
keld> 3: md0 =3D raid10,f2 of sda1+sdb1, md1=3D raid10,f2 of sdc1+sdd1,=
 chunksize of=20
keld>    md0 =3Dmd1 =3D128 KB,  md2 =3D raid0 of md0+md1 chunksize =3D =
256 KB
keld> 4: md0 =3D raid0 of sda1+sdb1, md1=3D raid0 of sdc1+sdd1, chunksi=
ze
keld>    of md0 =3D md1 =3D 128 KB, md2 =3D raid01,f2 of md0+md1 chunks=
ize =3D 256 KB

These stacked RAID levels don't make a lot of sense.

keld> 5: md0=3D raid10,f4 of sda1+sdb1+sdc1+sdd1

This also does not make a lot of sense. Why have four mirrors
instead of two?

Instead, try 'md0 =3D raid10,f2' for example. The first mirror of
will be striped across the outer half of all four drives, and
the second mirrors will be rotated in the inner half of each
drive.

Which of course means that reads will be quite quick, but writes
and degraded operation will be slower.

Consider this post for more details:

  http://www.spinics.net/lists/raid/msg18130.html

[ ... ]
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
