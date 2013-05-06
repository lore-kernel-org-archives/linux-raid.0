From: Marek Becka <marek.becka@superhosting.cz>
Subject: mdadm fails to assemble arrays with quotes in name
Date: Mon, 06 May 2013 19:34:35 +0200
Message-ID: <5187E9AB.4040904@superhosting.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

By accident I have created an array with simple quotes in name:

mdadm --assemble /dev/md0 --name=\'newname\':0 --update=name /dev/sdb1 
/dev/sdd1

My mdadm.conf contains following line:

ARRAY /dev/md/0 metadata=1.2 UUID=0324aa8b:e17efd1a:bae27dd0:66fc7573 
name='newname':0

Mdadm fails to assemble this array. After removing the name from 
mdadm.conf, everything works fine.

mdadm  --assemble --scan -v 2>&1 | grep sd[bd]1
mdadm: no RAID superblock on /dev/sdd1
mdadm: no RAID superblock on /dev/sdb1
mdadm: /dev/sdd1 has wrong uuid.
mdadm: /dev/sdb1 has wrong uuid.
mdadm: /dev/sdd1 has wrong name.
mdadm: /dev/sdb1 has wrong name.

I'm using mdadm - v3.2.5 - 18th May 2012 and kernel version 3.4.35. The 
superblock contains:

mdadm  --examine /dev/sdb1
/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 0324aa8b:e17efd1a:bae27dd0:66fc7573
            Name : 'newname':0
   Creation Time : Thu Apr 11 17:54:28 2013
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 2097128 (1024.16 MiB 1073.73 MB)
      Array Size : 1048564 (1024.16 MiB 1073.73 MB)
     Data Offset : 24 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : e9094b42:d1f2e7e4:71b7a626:77e008aa

     Update Time : Sat Apr 13 00:53:27 2013
        Checksum : afddd58 - correct
          Events : 36


    Device Role : Active device 0
    Array State : AA ('A' == active, '.' == missing)

mdadm  --examine /dev/sdd1
/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 0324aa8b:e17efd1a:bae27dd0:66fc7573
            Name : 'newname':0
   Creation Time : Thu Apr 11 17:54:28 2013
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 2097128 (1024.16 MiB 1073.73 MB)
      Array Size : 1048564 (1024.16 MiB 1073.73 MB)
     Data Offset : 24 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : a841cc4e:b37b0765:70225714:71c65fdd

     Update Time : Sat Apr 13 00:53:27 2013
        Checksum : b8a5eef2 - correct
          Events : 36


    Device Role : Active device 1
    Array State : AA ('A' == active, '.' == missing)

