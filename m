From: Andrei Badea <andrei.badea@movzx.net>
Subject: Weird RAID 1 performance
Date: Sat, 18 Sep 2004 23:11:44 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <414CA490.9010205@movzx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF867FE762E416FD53B3C801A"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF867FE762E416FD53B3C801A
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I have a RAID 1 whose write performance I tested by writing a 10 GB file 
to it:

dd if=/dev/zero of=/mnt/data/zeros bs=1024 count=...

Looking at GKrellM I noticed the CPU usage is very jumpy, going from a 
few to 99 percent (but usually is roughly rovers around 50 percent). 
Moreover, the transfer regularly stops for a few seconds (the CPU usage 
is then about 2 percent). The average data transfer rate was 16 MB/s, 
while the disks alone can make almost 25 MB/s.

Is this normal behavior? Can the write performance be tuned (to be less 
"jumpy")?

The reason I'm asking is that I'm encoutering hangs when video capturing 
to this RAID using mencoder and huffyuv. I'm not experiencing the hangs 
when capturing to another partition (not RAID). Neither did I experience 
  hangs during the dd copy.

Maybe the RAID 1 is just not suited for video capture?

The filesystem is ext3 and /etc/raidtab is:

raiddev /dev/md0
         raid-level              1
         nr-raid-disks           2
         nr-spare-disks          0
         persistent-superblock   1
         device                  /dev/hde1
         raid-disk               0
         device                  /dev/hdg1
         raid-disk               1

Thank you for help.

Andrei

-- 
andrei.badea@movzx.net # http://movzx.net # ICQ: 52641547

--------------enigF867FE762E416FD53B3C801A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFBTKSQpU04Z80csh8RAtwlAJ9vg1plclEYa3ZX8h+Jzwrtznat1wCgpxRO
aQypHbplTkUtd16bs6Hb+kQ=
=HHbB
-----END PGP SIGNATURE-----

--------------enigF867FE762E416FD53B3C801A--
