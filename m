From: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Subject: Re: RAID1 VS RAID5
Date: Mon, 27 Oct 2003 16:34:14 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310271634.14657.dusty@strike.wu-wien.ac.at>
References: <1067179519.1222.107.camel@cala> <200310271201.10418.dusty@strike.wu-wien.ac.at> <Pine.LNX.4.56.0310271321170.5277@unicorn.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0310271321170.5277@unicorn.drogon.net>
Content-Disposition: inline
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 27 October 2003 14:40, Gordon Henderson wrote:
> On Mon, 27 Oct 2003, Hermann Himmelbauer wrote:
> > Well - I have an old Dual P-II-266 System with an onboard SCSI-Cont=
roller
> > with 3 Ultra SCSI-disks connected, building a RAID5. I did a simple=
 Test
> > with "hdparm -tT" to provide you with numbers:
> >
> > /dev/sdb:
> >  Timing buffer-cache reads:   128 MB in  1.46 seconds =3D 87.67 MB/=
sec
> >  Timing buffered disk reads:  64 MB in  5.07 seconds =3D 12.62 MB/s=
ec
>
> It's possibly the "old Dual P-II-266" that may be slowing things down
> here.

I also thought this at first. But looking at the system load with e.g. =
"top"=20
or a graphic CPU-monitor the CPU load is only ~ 15%. When reading from =
a=20
single drive, the load is higher, something like 25%. Moreover the most=
=20
CPU-hungry application is the "hdparm"-Utility. The raid5d uses only ~ =
2%.

> On one of my systems: (Dual Athlon 2.4 with 2 Promise PCI IDE cards a=
nd 4
> drives):
> /dev/hdg6:
>  Timing buffer-cache reads:   128 MB in  0.48 seconds =3D266.67 MB/se=
c
>  Timing buffered disk reads:  64 MB in  1.49 seconds =3D 42.95 MB/sec
> /dev/md4:
>  Timing buffer-cache reads:   128 MB in  0.50 seconds =3D256.00 MB/se=
c
>  Timing buffered disk reads:  64 MB in  0.97 seconds =3D 65.98 MB/sec
>
> On another server (Dual PIII/Xeon 700MHz with SCSI drives)
> /dev/sdc6:
>  Timing buffer-cache reads:   128 MB in  0.59 seconds =3D216.95 MB/se=
c
>  Timing buffered disk reads:  64 MB in  3.39 seconds =3D 18.88 MB/sec
> /dev/md4:
>  Timing buffer-cache reads:   128 MB in  0.57 seconds =3D224.56 MB/se=
c
>  Timing buffered disk reads:  64 MB in  0.75 seconds =3D 85.33 MB/sec

That's interesting: both systems are 4-disk RAID5 arrays. The first gai=
ns ~50%=20
read performance, the second gains ~ 470% (!) - probably there is cachi=
ng=20
involved.

Probably hdparm is not the best tool for benchmarking RAIDs...
> So my advice is that if you want speed, be prepared to spend the =A3=A3=
=A3 to
> get that speed (and I don't consider these servers particularly fast,=
 but
> they are fast enough for my application which is NFS & Samba serving =
a
> small company of engineers (software/hardware) via a single 100MB/sec
> Ethernet interface).

Well, 5MB/s are o.k. for my server and my application - anyway it's=20
interesting why this happens.

		Best Regards,
		Hermann

--=20
x1@aon.at
GPG key ID: 299893C7 (on keyservers)
=46P: 0124 2584 8809 EF2A DBF9  4902 64B4 D16B 2998 93C7

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
