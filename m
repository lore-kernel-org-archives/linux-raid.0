From: Nagilum <nagilum@nagilum.org>
Subject: raid5 reshape/resync
Date: Sat, 24 Nov 2007 12:02:09 +0100
Message-ID: <20071124120209.0t70rfkfswkcww0g@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_2ymyp4wbmco4";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_2ymyp4wbmco4
Content-Type: text/plain;
	charset=ISO-8859-2;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
I'm running 2.6.23.8 x86_64 using mdadm v2.6.4.
I was adding a disk (/dev/sdf) to an existing raid5 (/dev/sd[a-e] -> md0)
During that reshape (at around 4%) /dev/sdd reported read errors and =20
went offline.
I replaced /dev/sdd with a new drive and tried to reassemble the array =20
(/dev/sdd was shown as removed and now as spare).
Assembly worked but it would not run unless I use --force.
Since I'm always reluctant to use force I put the bad disk back in, =20
this time as /dev/sdg . I re-added the drive and could run the array. =20
The array started to resync (since the disk can be read until 4%) and =20
then I marked the disk as failed. Now the array is "active, degraded, =20
recovering":

nas:~# mdadm -Q --detail /dev/md0
/dev/md0:
         Version : 00.91.03
   Creation Time : Sat Sep 15 21:11:41 2007
      Raid Level : raid5
      Array Size : 1953234688 (1862.75 GiB 2000.11 GB)
   Used Dev Size : 488308672 (465.69 GiB 500.03 GB)
    Raid Devices : 6
   Total Devices : 7
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Sat Nov 24 10:10:46 2007
           State : active, degraded, recovering
  Active Devices : 5
Working Devices : 6
  Failed Devices : 1
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 16K

  Reshape Status : 19% complete
   Delta Devices : 1, (5->6)

            UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
          Events : 0.726347

     Number   Major   Minor   RaidDevice State
        0       8        0        0      active sync   /dev/sda
        1       8       16        1      active sync   /dev/sdb
        2       8       32        2      active sync   /dev/sdc
        6       8       96        3      faulty spare rebuilding   /dev/sdg
        4       8       64        4      active sync   /dev/sde
        5       8       80        5      active sync   /dev/sdf

        7       8       48        -      spare   /dev/sdd

iostat:
Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda             129.48      1498.01      1201.59       7520       6032
sdb             134.86      1498.01      1201.59       7520       6032
sdc             127.69      1498.01      1201.59       7520       6032
sdd               0.40         0.00         3.19          0         16
sde             111.55      1498.01      1201.59       7520       6032
sdf             117.73         0.00      1201.59          0       6032
sdg               0.00         0.00         0.00          0          0

What I find somewhat confusing/disturbing is that does not appear to =20
utilize /dev/sdd. What I see here could be explained by md doing a =20
RAID5 resync from the 4 drives sd[a-c,e] to sd[a-c,e,f] but I would =20
have expected it to use the new spare sdd for that. Also the speed is =20
unusually low which seems to indicate a lot of seeking as if two =20
operations are happening at the same time.
Also when I look at the data rates it looks more like the reshape is =20
continuing even though one drive is missing (possible but risky).
Can someone relief my doubts as to whether md does the right thing here?
Thanks,

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..


--=_2ymyp4wbmco4
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHSASwAKWN2UY+sLwRAmnoAJ9/1c2QQQ8JuhVj8fQ+aorZjNvECgCggoUv
B+rbfBNPDVq9p+fWLbQzbgs=
=0hof
-----END PGP SIGNATURE-----

--=_2ymyp4wbmco4--
