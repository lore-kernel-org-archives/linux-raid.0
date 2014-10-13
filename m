From: Weedy <weedy2887@gmail.com>
Subject: mdadm: /dev/sdX2 has wrong raid level.
Date: Sun, 12 Oct 2014 22:03:40 -0400
Message-ID: <CAFE24U0enjmtxwWHYbdz-9KiXaGfvsa3_2MnyvOMngMsMG-QQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My server rebooted for some reason. Possibly disk/cable related.
The superblocks on my raid0s now think they are raid4s. Can I reverse this?

# mdadm --assemble -v -f --config=/etc/mdadm.conf /dev/md1 /dev/sd[ab]2
mdadm: looking for devices for /dev/md1
mdadm: /dev/sda2 has wrong raid level.
mdadm: /dev/sdb2 has wrong raid level.

# mdadm --examine -v /dev/sda2
/dev/sda2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : de492a9a:c62a01a3:eb511bbd:ead87a3a
           Name : alice:1  (local to host alice)
  Creation Time : Tue Jul 31 00:25:03 2012
     Raid Level : raid4
   Raid Devices : 3

 Avail Dev Size : 20240876 (9.65 GiB 10.36 GB)
     Array Size : 20239360 (19.30 GiB 20.73 GB)
  Used Dev Size : 20239360 (9.65 GiB 10.36 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=492 sectors
          State : active
    Device UUID : 436eeacc:5abe6b33:8c9f1de1:9031c001

    Update Time : Sat Apr 26 23:56:01 2014
       Checksum : c9dfcb49 - correct
         Events : 43295

     Chunk Size : 32K

   Device Role : Active device 0
   Array State : AA. ('A' == active, '.' == missing, 'R' == replacing)

# mdadm --examine -v /dev/sdb2
/dev/sdb2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : de492a9a:c62a01a3:eb511bbd:ead87a3a
           Name : alice:1  (local to host alice)
  Creation Time : Tue Jul 31 00:25:03 2012
     Raid Level : raid4
   Raid Devices : 3

 Avail Dev Size : 20240876 (9.65 GiB 10.36 GB)
     Array Size : 20239360 (19.30 GiB 20.73 GB)
  Used Dev Size : 20239360 (9.65 GiB 10.36 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=492 sectors
          State : active
    Device UUID : 6a01ee1d:312826ad:4be6e47a:60d5b684

    Update Time : Sat Apr 26 23:56:01 2014
       Checksum : b15bb2d7 - correct
         Events : 43295

     Chunk Size : 32K

   Device Role : Active device 1
   Array State : AA. ('A' == active, '.' == missing, 'R' == replacing)
