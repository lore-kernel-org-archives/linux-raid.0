From: Richard Massa <ramassa@ucdavis.edu>
Subject: raid5 two disk temp failure
Date: Fri, 13 Aug 2004 13:40:51 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040813134051.B3328@tictactoe.unixboxen.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--H1spWtNR+x+ondvy
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I've got a 6 disk raid5 array that just failed because some little elf loos=
ened the cable going=20
to two of the disks in a scsi enclosure.  Both of them got kicked.

Using mdadm -a /dev/md2 gives a segfault in both versions 1.6.0 and 1.7.0.

I can query the array using mdadm just fine, the output is attached.=20

Anyone know what is going on?  I can attach a strace if that helps...

Thanks,
Richard

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="t.txt"

root@aske:/tmp/mdadm-1.6.0# mdadm -Q --examine /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 92a6f7c4:4327b1f9:04f5c750:691edd28
  Creation Time : Fri Jun 25 22:06:08 2004
     Raid Level : raid5
    Device Size : 195358336 (186.31 GiB 200.05 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 2

    Update Time : Fri Aug 13 19:58:01 2004
          State : dirty
 Active Devices : 4
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 7bc34bee - correct
         Events : 0.43642

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1
   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      faulty   /dev/sde1
   5     5       8       81        5      faulty   /dev/sdf1

--y0ulUmNC+osPPQO6--

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBHSdSxxcYbGc/L9URAvkkAJsH52kU90cLb+MNE78qQZVUKHrOcgCeMDN1
DMjK1cxiTOw82m31eC6XmjU=
=MWet
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
