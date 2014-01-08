From: Fred Damstra <fred.damstra@gmail.com>
Subject: Copying Data off a Failed RAID
Date: Wed, 8 Jan 2014 14:27:13 -0500
Message-ID: <CAEEtA5uECz=5cbheeiLKy5O7M7csK8T4N_4xm+KKCjktskU=ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I appear to have 2 (of 5) drives in my RAID-5 that are in the process
of failing.  After one of the drives was removed from the array, I
reassembled and it initiated a rebuild.  While the rebuild process was
running (or possibly when it was complete), there were read errors/bad
sectors on a second drive and the OS marked it as failed.

I'd like to get the array operational enough to copy whatever data
exists onto a new external NAS.  I'd rather not have to invest in a
replacement drive.

I'm pretty sure I can --assemble --force and have a working array
(though probably with some corruption), but what I don't know is how
to copy the data off and force the kernel to ignore I/O errors (that
is, not take the array off-line during the process do to read errors).

Rather than replacing drives for the array, I'd like to transfer
whatever data is intact over to an external NAS.  I can live with data
corruption, since the data is available off-site, but it would be nice
to rescue the bulk of the data and only have to restore what gets
corrupted rather than transferring all of the data over my Internet
connection.

I appreciate any help you can give.  For completeness, here is a copy
of mdadm --examine /dev/sd[abcde]1:

/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e6ebf415:39a410b6:e31b6a66:14144d11
           Name : io:1  (local to host io)
  Creation Time : Thu Sep  5 11:45:52 2013
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 2930012160 (1397.14 GiB 1500.17 GB)
     Array Size : 5858846720 (5587.43 GiB 5999.46 GB)
  Used Dev Size : 2929423360 (1396.86 GiB 1499.86 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 57726c49:5d4905bb:b397782e:710280ec

    Update Time : Tue Jan  7 14:41:09 2014
       Checksum : 3f8c5210 - correct
         Events : 562642

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : A.AA. ('A' == active, '.' == missing)
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e6ebf415:39a410b6:e31b6a66:14144d11
           Name : io:1  (local to host io)
  Creation Time : Thu Sep  5 11:45:52 2013
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 2930012160 (1397.14 GiB 1500.17 GB)
     Array Size : 5858846720 (5587.43 GiB 5999.46 GB)
  Used Dev Size : 2929423360 (1396.86 GiB 1499.86 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 3695aadc:5e666ce5:948e6903:45aa3b75

    Update Time : Tue Jan  7 14:41:09 2014
       Checksum : 5ade30aa - correct
         Events : 562642

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : A.AA. ('A' == active, '.' == missing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e6ebf415:39a410b6:e31b6a66:14144d11
           Name : io:1  (local to host io)
  Creation Time : Thu Sep  5 11:45:52 2013
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 2930012160 (1397.14 GiB 1500.17 GB)
     Array Size : 5858846720 (5587.43 GiB 5999.46 GB)
  Used Dev Size : 2929423360 (1396.86 GiB 1499.86 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 0eede877:ace15d39:a1c72cdb:bedd8153

    Update Time : Tue Jan  7 14:41:09 2014
       Checksum : 177053 - correct
         Events : 562642

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : A.AA. ('A' == active, '.' == missing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e6ebf415:39a410b6:e31b6a66:14144d11
           Name : io:1  (local to host io)
  Creation Time : Thu Sep  5 11:45:52 2013
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 2929424384 (1396.86 GiB 1499.87 GB)
     Array Size : 5858846720 (5587.43 GiB 5999.46 GB)
  Used Dev Size : 2929423360 (1396.86 GiB 1499.86 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 9081f762:29ea8ace:ae4924f0:38db4aff

    Update Time : Tue Jan  7 14:41:09 2014
       Checksum : 410a94de - correct
         Events : 562642

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : A.AA. ('A' == active, '.' == missing)
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e6ebf415:39a410b6:e31b6a66:14144d11
           Name : io:1  (local to host io)
  Creation Time : Thu Sep  5 11:45:52 2013
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 2929424384 (1396.86 GiB 1499.87 GB)
     Array Size : 5858846720 (5587.43 GiB 5999.46 GB)
  Used Dev Size : 2929423360 (1396.86 GiB 1499.86 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 4eb7c2a6:bb0fd1c3:6621ff4c:c900a8d3

    Update Time : Tue Jan  7 11:42:10 2014
       Checksum : ab54c372 - correct
         Events : 562622

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAA ('A' == active, '.' == missing)
