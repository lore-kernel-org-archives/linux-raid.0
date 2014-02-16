From: Eivind Sarto <eivindsarto@gmail.com>
Subject: mdadm assemble bug?
Date: Sun, 16 Feb 2014 13:33:33 -0800
Message-ID: <FB13B1B1-A319-49CB-A981-4A47EBD81F63@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/mixed; boundary="Apple-Mail=_49E847E9-0F99-4E66-8894-861B5063441E"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Apple-Mail=_49E847E9-0F99-4E66-8894-861B5063441E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

Neil,

After I fail an active drive in a raid5 volume, and then cleanly shut =
down the volume, it cannot be started
again without a =97force.

Reproduce:
1) create volume: mdadm -C /dev/md0 -l 5 -c 16 -n 3 /dev/sd[abc]
2) write data to /dev/md0 while failing a drive: mdadm -f /dev/md0 =
/dev/sda
3) md0 is not in degraded mode, sda has failed, sda superblock is =
=93active=94.
4) cleanly stop volume: mdadm -S /dev/md0
5) attempt to start volume: mdadm -v -A /dev/md0 /dev/sd[abc]
mdadm: looking for devices for /dev/md0
mdadm: /dev/fioa is identified as a member of /dev/md0, slot 0.
mdadm: /dev/fiob is identified as a member of /dev/md0, slot 1.
mdadm: /dev/fioc is identified as a member of /dev/md0, slot 2.
mdadm: added /dev/fioa to /dev/md0 as 0 (possibly out of date)
mdadm: added /dev/fioc to /dev/md0 as 2
mdadm: added /dev/fiob to /dev/md0 as 1
mdadm: /dev/md0 assembled from 2 drives - not enough to start the array =
while not clean - consider =97force.

mdadm never attempts to RUN_ARRAY.

Since the failed drive was in =93active=94 state when it was failed, =
mdadm assumes that the entire volume
is not clean when it attempts to assemble.  I looks like mdadm does not =
count the failed drive as =93available=94 while
assembling, but at the same time allows it to prevent the volume from =
being =93clean=94.
The logic in util.c:enough() thinks the volume does not have enough =
drive to be started:
/* clean=3D0, avail_disks=3D2, raid_disks=3D3 */
    case 5:
                if (clean)
                        return avail_disks >=3D raid_disks-1;
                else
                        return avail_disks >=3D raid_disks;

Is this a bug?
This happens with both mdadm-3.2.6 and latest version from github.
I have attached output from =93mdadm -E=94 for each drive.

-eivind=

--Apple-Mail=_49E847E9-0F99-4E66-8894-861B5063441E
Content-Disposition: attachment;
	filename=mdadm.out
Content-Type: application/octet-stream;
	name="mdadm.out"
Content-Transfer-Encoding: 7bit

/dev/sda:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 1809f414:ee071ff1:3dbdb06a:fdf74d16
           Name : ion:0  (local to host ion)
  Creation Time : Sat Feb 15 17:45:09 2014
     Raid Level : raid5
   Raid Devices : 3
 Avail Dev Size : 1249737856 (595.92 GiB 639.87 GB)
     Array Size : 1249737568 (1191.84 GiB 1279.73 GB)
  Used Dev Size : 1249737568 (595.92 GiB 639.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : e60447a0:2d5ea561:6df86a5a:b014c85d
    Update Time : Sat Feb 15 17:47:24 2014
       Checksum : 5f8b1e36 - correct
         Events : 3
         Layout : left-symmetric
     Chunk Size : 16K
   Device Role : Active device 0
   Array State : AAA ('A' == active, '.' == missing)

/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 1809f414:ee071ff1:3dbdb06a:fdf74d16
           Name : ion:0  (local to host ion)
  Creation Time : Sat Feb 15 17:45:09 2014
     Raid Level : raid5
   Raid Devices : 3
 Avail Dev Size : 1249737856 (595.92 GiB 639.87 GB)
     Array Size : 1249737568 (1191.84 GiB 1279.73 GB)
  Used Dev Size : 1249737568 (595.92 GiB 639.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : c60d358d:252bb1e4:65e0ddcc:3dcebc3e
    Update Time : Sat Feb 15 17:47:40 2014
       Checksum : 22ed95a5 - correct
         Events : 5
         Layout : left-symmetric
     Chunk Size : 16K
   Device Role : Active device 1
   Array State : .AA ('A' == active, '.' == missing)

/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 1809f414:ee071ff1:3dbdb06a:fdf74d16
           Name : ion:0  (local to host ion)
  Creation Time : Sat Feb 15 17:45:09 2014
     Raid Level : raid5
   Raid Devices : 3
 Avail Dev Size : 1249737856 (595.92 GiB 639.87 GB)
     Array Size : 1249737568 (1191.84 GiB 1279.73 GB)
  Used Dev Size : 1249737568 (595.92 GiB 639.87 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 828efb54:6a7d509e:d08d0456:f476e2df
    Update Time : Sat Feb 15 17:47:40 2014
       Checksum : ce9fbec8 - correct
         Events : 5
         Layout : left-symmetric
     Chunk Size : 16K
   Device Role : Active device 2
   Array State : .AA ('A' == active, '.' == missing)

# ./mdadm -v -A /dev/md0 /dev/sd[abc]
mdadm: looking for devices for /dev/md0
mdadm: /dev/fioa is identified as a member of /dev/md0, slot 0.
mdadm: /dev/fiob is identified as a member of /dev/md0, slot 1.
mdadm: /dev/fioc is identified as a member of /dev/md0, slot 2.
mdadm: added /dev/fioa to /dev/md0 as 0 (possibly out of date)
mdadm: added /dev/fioc to /dev/md0 as 2
mdadm: added /dev/fiob to /dev/md0 as 1
mdadm: /dev/md0 assembled from 2 drives - not enough to start the array while not clean - consider --force.

--Apple-Mail=_49E847E9-0F99-4E66-8894-861B5063441E
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii




--Apple-Mail=_49E847E9-0F99-4E66-8894-861B5063441E--
