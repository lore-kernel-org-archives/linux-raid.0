From: Gordon Henderson <gordon@drogon.net>
Subject: Re: RAID1 VS RAID5
Date: Mon, 27 Oct 2003 13:40:45 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0310271321170.5277@unicorn.drogon.net>
References: <1067179519.1222.107.camel@cala> <200310270933.37564.dusty@strike.wu-wien.ac.at>
 <Pine.LNX.4.56.0310270916270.5277@unicorn.drogon.net>
 <200310271201.10418.dusty@strike.wu-wien.ac.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310271201.10418.dusty@strike.wu-wien.ac.at>
To: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 27 Oct 2003, Hermann Himmelbauer wrote:

> Well - I have an old Dual P-II-266 System with an onboard SCSI-Contro=
ller with
> 3 Ultra SCSI-disks connected, building a RAID5. I did a simple Test w=
ith
> "hdparm -tT" to provide you with numbers:
>
> /dev/sdb:
>  Timing buffer-cache reads:   128 MB in  1.46 seconds =3D 87.67 MB/se=
c
>  Timing buffered disk reads:  64 MB in  5.07 seconds =3D 12.62 MB/sec

It's possibly the "old Dual P-II-266" that may be slowing things down
here.

On one of my systems: (Dual Athlon 2.4 with 2 Promise PCI IDE cards and=
 4
drives):

=46rom /proc/mdstat

md4 : active raid5 hdk6[3] hdi6[1] hdg6[2] hde6[0]
      176055936 blocks level 5, 32k chunk, algorithm 0 [4/4] [UUUU]

Single drive:

/dev/hdg6:
 Timing buffer-cache reads:   128 MB in  0.48 seconds =3D266.67 MB/sec
 Timing buffered disk reads:  64 MB in  1.49 seconds =3D 42.95 MB/sec

The array:

/dev/md4:
 Timing buffer-cache reads:   128 MB in  0.50 seconds =3D256.00 MB/sec
 Timing buffered disk reads:  64 MB in  0.97 seconds =3D 65.98 MB/sec

On another server (Dual PIII/Xeon 700MHz with SCSI drives)

md4 : active raid5 sdd6[3] sdc6[1] sdb6[2] sda6[0]
      23663424 blocks level 5, 32k chunk, algorithm 0 [4/4] [UUUU]

Single drive:

/dev/sdc6:
 Timing buffer-cache reads:   128 MB in  0.59 seconds =3D216.95 MB/sec
 Timing buffered disk reads:  64 MB in  3.39 seconds =3D 18.88 MB/sec

The array:

/dev/md4:
 Timing buffer-cache reads:   128 MB in  0.57 seconds =3D224.56 MB/sec
 Timing buffered disk reads:  64 MB in  0.75 seconds =3D 85.33 MB/sec

The array in this case is 4 disks, connected 2 disks to an on-board dua=
l
Adaptec controller (It's a Dell 6xxx box)

It also has 2 PCI adaptec 7xxx cards connected to an external box with =
8
drives:

md6 : active raid5 sdl2[7] sdh2[6] sdk2[5] sdg2[4] sdj2[3] sdf2[2] sdi2=
[1] sde2[0]
      62918016 blocks level 5, 32k chunk, algorithm 0 [8/8] [UUUUUUUU]

Single drive:

/dev/sdk2:
 Timing buffer-cache reads:   128 MB in  0.58 seconds =3D220.69 MB/sec
 Timing buffered disk reads:  64 MB in  4.00 seconds =3D 16.00 MB/sec

The array:

/dev/md6:
 Timing buffer-cache reads:   128 MB in  0.57 seconds =3D224.56 MB/sec
 Timing buffered disk reads:  64 MB in  1.03 seconds =3D 62.14 MB/sec

fast RAID array!

So my advice is that if you want speed, be prepared to spend the =A3=A3=
=A3 to
get that speed (and I don't consider these servers particularly fast, b=
ut
they are fast enough for my application which is NFS & Samba serving a
small company of engineers (software/hardware) via a single 100MB/sec
Ethernet interface).

Gordon
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
