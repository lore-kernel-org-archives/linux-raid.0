From: Zoltan Szecsei <zoltans@geograph.co.za>
Subject: Array read 3 time slower to read after data fully loaded
Date: Thu, 18 Nov 2010 07:30:14 +0200
Message-ID: <4CE4B9E6.1040802@geograph.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
Can anyone please explain this to me?

=46or the last >30 hours I have been loading some 2.5TB of 200-400MB ti=
ff=20
images, from another PC on our internal network, onto this new array.
Yesterday, during this load process, I copied 10 of these files (about=20
2.5GB) from the array onto the /home directory of the same system.

It took 33 seconds, equating to some 75MB/s.

This morning I came in to find that the load process had finished, so I=
=20
deleted the 10 test files from /home, and redid the identical copy test=
=20
(using bash-history, so: identical).

It took 123 seconds, equating to some 20MB/s.

Que? (as in Manuel from Faulty Towers :-)  )


Thanks & regards,
Zoltan


root@gs0:/home/geograph# uname -a
Linux gs0 2.6.32-25-generic #45-Ubuntu SMP Sat Oct 16 19:52:42 UTC 2010=
=20
x86_64 GNU/Linux
root@gs0:/home/geograph# mdadm -V
mdadm - v3.1.4 - 31st August 2010
root@gs0:/home/geograph# lvm version
   LVM version:     2.02.54(1) (2009-10-26)
   Library version: 1.02.39 (2009-10-26)
   Driver version:  4.15.0
root@gs0:/home/geograph# df  #ext4
=46ilesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdi7            426559760   9494844 395396872   3% /home
/dev/mapper/geo_vg0-geo_lvm0
                      11536635672 2530042680 8889387468  23% /mnt/geo_l=
vm0
root@gs0:/home/geograph#


--=20

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Zoltan Szecsei PrGISc [PGP0031]
Geograph (Pty) Ltd.
P.O. Box 7, Muizenberg 7950, South Africa.

65 Main Road, Muizenberg 7945
Western Cape, South Africa.

34=B0 6'16.35"S 18=B028'5.62"E

Tel: +27-21-7884897  Mobile: +27-83-6004028
=46ax: +27-86-6115323     www.geograph.co.za
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D



-----
No virus found in this message.
Checked by AVG - www.avg.com
Version: 10.0.1153 / Virus Database: 424/3262 - Release Date: 11/17/10

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
