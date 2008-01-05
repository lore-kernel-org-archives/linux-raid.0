From: Nagilum <nagilum@nagilum.org>
Subject: Re: PROBLEM: RAID5 reshape data corruption
Date: Sun, 06 Jan 2008 00:31:46 +0100
Message-ID: <20080106003146.y9ccz1ra4ggg84wo@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_3ji3h23lh4sg";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_3ji3h23lh4sg
Content-Type: text/plain;
	charset=ISO-8859-2;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from neilb@suse.de ---------
      Date: Fri, 4 Jan 2008 09:37:24 +1100
      From: Neil Brown <neilb@suse.de>
Reply-To: Neil Brown <neilb@suse.de>
   Subject: Re: PROBLEM: RAID5 reshape data corruption
        To: Nagilum <nagilum@nagilum.org>
        Cc: linux-raid@vger.kernel.org, Dan Williams
<dan.j.williams@intel.com>, "H. Peter Anvin" <hpa@zytor.com>


>> I'm not just interested in a simple behaviour fix I'm also interested
>> in what actually happens and if possible a repair program for that
>> kind of data corruption.
>
> What happens is that when reshape happens while a device is missing,
> the data on that device should be computed from the other data devices
> and parity.  However because of the above bug, the data is copied into
> the new layout before the compute is complete.  This means that the
> data that was on that device is really lost beyond recovery.
>
> I'm really sorry about that, but there is nothing that can be done to
> recover the lost data.

Thanks a lot Neil!
I can confirm your findings, the data in the chunks is the data from =20
the broken device. Now to my particular case:
I still have the old disk and I haven't touched the array since.
I just run a dd_rescue -r (reverse) on the old disk and as I expected =20
most of it (>99%) is still readable. So what I want to do is read the =20
chunks from that disk - starting at the end down to the 4% point where =20
the reshape was interrupted due to the disk read error - and replace =20
the chunks on md0.
That should restore most of the data.
Now in order to do so I need to know how to calculate the different =20
positions of the chunks.
So for the old disk I have:
nas:~# mdadm -E /dev/sdg
/dev/sdg:
           Magic : a92b4efc
         Version : 00.91.00
            UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
   Creation Time : Sat Sep 15 21:11:41 2007
      Raid Level : raid5
   Used Dev Size : 488308672 (465.69 GiB 500.03 GB)
      Array Size : 2441543360 (2328.44 GiB 2500.14 GB)
    Raid Devices : 6
   Total Devices : 7
Preferred Minor : 0

   Reshape pos'n : 118360960 (112.88 GiB 121.20 GB)
   Delta Devices : 1 (5->6)

     Update Time : Fri Nov 23 20:05:50 2007
           State : active
  Active Devices : 6
Working Devices : 7
  Failed Devices : 0
   Spare Devices : 1
        Checksum : 9a8358c4 - correct
          Events : 0.677965

          Layout : left-symmetric
      Chunk Size : 16K

       Number   Major   Minor   RaidDevice State
this     3       8       96        3      active sync   /dev/sdg

    0     0       8        0        0      active sync   /dev/sda
    1     1       8       16        1      active sync   /dev/sdb
    2     2       8       32        2      active sync   /dev/sdc
    3     3       8       96        3      active sync   /dev/sdg
    4     4       8       64        4      active sync   /dev/sde
    5     5       8       80        5      active sync   /dev/sdf
    6     6       8       48        6      spare   /dev/sdd

the current array is:

nas:~# mdadm -Q --detail /dev/md0
/dev/md0:
         Version : 00.90.03
   Creation Time : Sat Sep 15 21:11:41 2007
      Raid Level : raid5
      Array Size : 2441543360 (2328.44 GiB 2500.14 GB)
   Used Dev Size : 488308672 (465.69 GiB 500.03 GB)
    Raid Devices : 6
   Total Devices : 6
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Sat Jan  5 17:53:54 2008
           State : clean
  Active Devices : 6
Working Devices : 6
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 16K

            UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
          Events : 0.986918

     Number   Major   Minor   RaidDevice State
        0       8        0        0      active sync   /dev/sda
        1       8       16        1      active sync   /dev/sdb
        2       8       32        2      active sync   /dev/sdc
        3       8       48        3      active sync   /dev/sdd
        4       8       64        4      active sync   /dev/sde
        5       8       80        5      active sync   /dev/sdf

At the moment I'm thinking about writing a small perl program that =20
will generate me a shell script or makefile containing dd commands =20
that will copy the chunks from the drive to /dev/md0. I don't care if =20
that will be dog slow as long as I get most of my data back. (I'd =20
probably go forward instead of backward to take advantage of the =20
readahead, after I've determined the exact start chunk.)
For that I need to know one more thing.
Used Dev Size is 488308672k for md0 as well as the disk, 16k chunk size.
488308672/16 =3D 30519292.00
so the first dd would look like:
  dd if=3D/dev/sdg of=3D/dev/md0 bs=3D16k count=3D1 skip=3D30519291 seek=3DX

The big question now being how to calculate X.
Since I have a working testcase I can do a lot of testing before =20
touching the real thing. The formula to get X will probably contain a =20
5 for the 5(+1) devices the raid spans now, a 4 for the 4(+1) devices =20
the raid spanned before the reshape, a 3 for the device number of the =20
disk that failed and of course the skip/current chunk number.
Can you help me come up with it?
Thanks again for looking into the whole issue.

Alex.

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


--=_3ji3h23lh4sg
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHgBNhAKWN2UY+sLwRAvxYAJoCBOaIrRASx2OuVsqiFz0COmKdKwCfZj6l
EvcNeycl17prHdXHy+F9St4=
=f8S9
-----END PGP SIGNATURE-----

--=_3ji3h23lh4sg--
