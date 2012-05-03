From: Nikolay Kichukov <hijacker@oldum.net>
Subject: create raid10 md raid which hangs on auto-read-only with resync=PENDING
Date: Thu, 03 May 2012 12:04:49 +0300
Message-ID: <4FA24A31.3020703@oldum.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi all,
I have recently included one more drive in my system and has switched from raid0 to raid10 on 3 devices/partitions.

I have created the raid as follows:

mdadm --create /dev/md3 --verbose --raid-devices=3 --level=raid10 --name=cryptdata  --layout=o2 --chunk=2M /dev/sda3
/dev/sdb3 /dev/sdf3
mdadm: size set to 319434752K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md3 started.


Information about the array:

mdadm --detail /dev/md3
/dev/md3:
        Version : 1.2
  Creation Time : Thu May  3 11:42:57 2012
     Raid Level : raid10
     Array Size : 479152128 (456.96 GiB 490.65 GB)
  Used Dev Size : 319434752 (304.64 GiB 327.10 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Thu May  3 11:42:57 2012
          State : clean, resyncing (PENDING)
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : offset=2
     Chunk Size : 2048K

           Name : hanna64:cryptdata  (local to host hanna64)
           UUID : a7cc8eb7:8555b1bd:2856b686:829861be
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3
       2       8       83        2      active sync   /dev/sdf3


And under /proc/mdstat:

cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10]
md3 : active (auto-read-only) raid10 sdf3[2] sdb3[1] sda3[0]
      479152128 blocks super 1.2 2048K chunks 2 offset-copies [3/3] [UUU]
      	resync=PENDING


The resync was not started due to the array being in auto-read-only mode.

I googled the issue and found out that to be able to start the resync one should issue:

mdadm --readwrite /dev/mdx
(ref.: http://wiki.xtronics.com/index.php/Raid )

I have done it and it started resyncing:
cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10]
md3 : active raid10 sdf3[2] sdb3[1] sda3[0]
      479152128 blocks super 1.2 2048K chunks 2 offset-copies [3/3] [UUU]
      [=>...................]  resync =  6.2% (29748096/479152128) finish=120.3min speed=62220K/sec



Is this intended feature for 1.2 metadata?

Kernel: 3.1.0-1-amd64
mdadm: 3.2.3-2
Distro: Debian testing

Cheers,
- -Nik
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPokoxAAoJEDFLYVOGGjgXb3cH/2cnkl+Q0q+vA+8z32XQwD28
dnpohM0nlQe99in2D1fjkI0Bsnt3tYz0bjZALHxOPybEWH+U3X1WOztTx/UdfKmL
fXTv8hFLscIsdvOK/JThkRdob99EEPbkZlnzCuTrIQDPJSj1v/kY7AG/9HxLCnT+
8KDZpkEyd9usSQZC/sUie2B/cG5VDir74sFc/ggr3UsZCFtBGPJuILCjlWAu6XcH
SCV2FTvJt/Ahay3/IuzBvNRBys7OcOFKck/oGGgW2Ki5FUeehWGWbWVbYEiQ4pZR
TPbPwrY84v6OS2Baqm8kZIr8j6UPFzPuErxGqhxq7e+btGx8aKklzbJn3dQCQck=
=IVpx
-----END PGP SIGNATURE-----
