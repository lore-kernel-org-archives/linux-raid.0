From: Martin Ziler <martin.ziler@googlemail.com>
Subject: degraded raid 6 (1 bad drive) showing up inactive, only spares
Date: Thu, 7 Jun 2012 13:55:32 +0200
Message-ID: <B5902F16-9C82-4072-BD67-FC6D6488ADB7@googlemail.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everybody,

I am running a 9-disk raid6 without hot spares. I already had one drive go bad, which I could replace and continue using the array without any degraded raid messages. Recently I had another drive going bad by the smart-info. As it wasn't quite dead I left the array as was without really using it all that much waiting for a replacement drive I ordered. As I booted the machine up in order to replace the drive I was greeted by an inactive array with all devices showing up as spares.

md0 : inactive sdh2[0](S) sdi2[7](S) sde2[6](S) sdd2[5](S) sdf2[1](S) sdg2[2](S) sdc1[9](S) sdb2[3](S)
      15579088439 blocks super 1.2

mdadm --examine confirms that. I already searched the web quite a bit and found this mailing list. Maybe someone in here can give me some input. Normally a degraded raid should still be active. So I am quite surprised that my array with only one drive missing goes inactive. I appended the info mdadm --examine puts out for all the drives. However the first two should probably suffice as only /dev/sdk differs from the rest. The faulty drive - sdk - is still recognized as a raid6 member, wheres all the others show up as spares. With lots of bad sectors sdk isn't accessible anymore. 


/dev/sdk2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
           Name : server:0  (local to host server)
  Creation Time : Mon Jul 25 23:40:50 2011
     Raid Level : raid6
   Raid Devices : 9

 Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
     Array Size : 27172970496 (12957.08 GiB 13912.56 GB)
  Used Dev Size : 3881852928 (1851.01 GiB 1987.51 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 882eb11a:33b499a7:dd5856b7:165f916c

    Update Time : Fri Jun  1 20:26:45 2012
       Checksum : b8c58093 - correct
         Events : 623119

         Layout : left-symmetric
     Chunk Size : 4096K

   Device Role : Active device 8
   Array State : AAAAAAAAA ('A' == active, '.' == missing)


/dev/sdh2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
           Name : server:0  (local to host server)
  Creation Time : Mon Jul 25 23:40:50 2011
     Raid Level : -unknown-
   Raid Devices : 0

 Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 44008309:1dfb1408:cabfbd0a:64de3739

    Update Time : Thu Jun  7 12:27:52 2012
       Checksum : 27f93899 - correct
         Events : 2

   Device Role : spare
   Array State :  ('A' == active, '.' == missing)

---------------------------------------------------------------------------------------------------------------

/dev/sdi2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
           Name : server:0  (local to host server)
  Creation Time : Mon Jul 25 23:40:50 2011
     Raid Level : -unknown-
   Raid Devices : 0

 Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 135f196d:184f11a1:09207617:4022e1a5

    Update Time : Thu Jun  7 12:27:52 2012
       Checksum : 9ded8f86 - correct
         Events : 2


   Device Role : spare
   Array State :  ('A' == active, '.' == missing)

/dev/sde2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
           Name : server:0  (local to host server)
  Creation Time : Mon Jul 25 23:40:50 2011
     Raid Level : -unknown-
   Raid Devices : 0

 Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 3517bcc4:2acb381f:f5006058:5bd5c831

    Update Time : Thu Jun  7 12:27:52 2012
       Checksum : 408957c0 - correct
         Events : 2


   Device Role : spare
   Array State :  ('A' == active, '.' == missing)

/dev/sdd2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
           Name : server:0  (local to host server)
  Creation Time : Mon Jul 25 23:40:50 2011
     Raid Level : -unknown-
   Raid Devices : 0

 Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 9e8b2d2c:844a009a:fd6914a2:390f10ac

    Update Time : Thu Jun  7 12:27:52 2012
       Checksum : e6bdee68 - correct
         Events : 2


   Device Role : spare
   Array State :  ('A' == active, '.' == missing)

/dev/sdf2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
           Name : server:0  (local to host server)
  Creation Time : Mon Jul 25 23:40:50 2011
     Raid Level : -unknown-
   Raid Devices : 0

 Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 87ad38ac:4ccbd831:ee5502cd:28dafaad

    Update Time : Thu Jun  7 12:27:52 2012
       Checksum : 2b7a47f6 - correct
         Events : 2


   Device Role : spare
   Array State :  ('A' == active, '.' == missing)

/dev/sdg2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
           Name : server:0  (local to host server)
  Creation Time : Mon Jul 25 23:40:50 2011
     Raid Level : -unknown-
   Raid Devices : 0

 Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : eef2f06f:28f881a5:da857a00:fb90e250

    Update Time : Thu Jun  7 12:27:52 2012
       Checksum : 393ba0f8 - correct
         Events : 2


   Device Role : spare
   Array State :  ('A' == active, '.' == missing)

/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
           Name : server:0  (local to host server)
  Creation Time : Mon Jul 25 23:40:50 2011
     Raid Level : -unknown-
   Raid Devices : 0

 Avail Dev Size : 3985162143 (1900.27 GiB 2040.40 GB)
  Used Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 4cf86fb0:6f334e2c:19e89c99:0532f557

    Update Time : Thu Jun  7 12:27:52 2012
       Checksum : a6e42bdc - correct
         Events : 2


   Device Role : spare
   Array State :  ('A' == active, '.' == missing)

/dev/sdb2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 25be3ab5:ef5f1166:d64b0e0e:4df143ed
           Name : server:0  (local to host server)
  Creation Time : Mon Jul 25 23:40:50 2011
     Raid Level : -unknown-
   Raid Devices : 0

 Avail Dev Size : 3881859248 (1851.01 GiB 1987.51 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 4852882a:b8a3989f:aad747c5:25f20d47

    Update Time : Thu Jun  7 12:27:52 2012
       Checksum : a8e25edd - correct
         Events : 2


   Device Role : spare
   Array State :  ('A' == active, '.' == missing)