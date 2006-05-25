From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: 4 disks in raid 5: 33MB/s read performance?
Date: Thu, 25 May 2006 15:58:48 +0200
Message-ID: <200605251558.48397.Dexter.Filmore@gmx.de>
References: <200605221746.38122.Dexter.Filmore@gmx.de> <17522.17186.715844.748238@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17522.17186.715844.748238@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> On Monday May 22, Dexter.Filmore@gmx.de wrote:
> > I just dd'ed a 700MB iso to /dev/null, dd returned 33MB/s.
> > Isn't that a little slow?
> > System is a sil3114 4 port sata 1 controller with 4 samsung spinpoi=
nt
> > 250GB, 8MB cache in raid 5 on a Athlon XP 2000+/512MB.
>
> Yes, read on raid5 isn't as fast as we might like at the moment.
>
> It looks like you are getting about 11MB/s of each disk which is
> probably quite a bit slower than they can manage (what is the
> single-drive read speed you get dding from /dev/sda or whatever).
>
> You could try playing with the readahead number (blockdev --setra/--g=
etra).
> I'm beginning to think that the default setting is a little low.

Changed from 384 to 1024, no improvement.

>
> You could also try increasing the stripe-cache size by writing number=
s
> to
>    /sys/block/mdX/md/stripe_cache_size

Actually, there's no directory /sys/block/md0/md/ here. Can I find that=
 in=20
proc somewhere? And what are sane numbers for this setting?

> I wonder if your SATA  controller is causing you grief.
> Could you try
>    dd if=3D/dev/SOMEDISK of=3D/dev/null bs=3D1024k count=3D1024
> and then do the same again on all devices in parallel
> e.g.
>    dd if=3D/dev/SOMEDISK of=3D/dev/null bs=3D1024k count=3D1024 &
>    dd if=3D/dev/SOMEOTHERDISK of=3D/dev/null bs=3D1024k count=3D1024 =
&
>    ...

 4112 pts/0    R      0:00 dd if /dev/sda of /dev/null bs 1024k count 1=
024
 4113 pts/0    R      0:00 dd if /dev/sdb of /dev/null bs 1024k count 1=
024
 4114 pts/0    R      0:00 dd if /dev/sdc of /dev/null bs 1024k count 1=
024
 4115 pts/0    R      0:00 dd if /dev/sdd of /dev/null bs 1024k count 1=
024
 4116 pts/0    R+     0:00 ps ax

1024+0 Datens=E4tze ein
1024+0 Datens=E4tze aus
1073741824 Bytes (1,1 GB) kopiert, 34,5576 Sekunden, 31,1 MB/s
1024+0 Datens=E4tze ein
1024+0 Datens=E4tze aus
1073741824 Bytes (1,1 GB) kopiert, 36,073 Sekunden, 29,8 MB/s
1024+0 Datens=E4tze ein
1024+0 Datens=E4tze aus
1073741824 Bytes (1,1 GB) kopiert, 40,5109 Sekunden, 26,5 MB/s
1024+0 Datens=E4tze ein
1024+0 Datens=E4tze aus
1073741824 Bytes (1,1 GB) kopiert, 40,5054 Sekunden, 26,5 MB/s

(Partly german, but I think you get it)

A single disks pumps out 65-70MB/s. Since they are on a PCI 32bit contr=
oller=20
the combined speeds when reading from all four disks at once pretty muc=
h max=20
the 133MB/s PCI limit. (I' surprised it comes so close. That controller=
 works=20
pretty well for 18 bucks.)

Dex


--=20
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C+++(++++) UL+>++++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS++(+) PE(-) Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(=
+)@=20
b++(+++) DI+++ D G++ e* h>++ r%>* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
