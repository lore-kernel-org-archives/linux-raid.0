From: Tobx <net@tobx.de>
Subject: Re: RAID 5 array with journal device does not automatically assemble
 at boot
Date: Tue, 14 Nov 2017 20:06:14 +0100
Message-ID: <E972B38E-F9BD-4D8D-92EC-F7697EBC69AB@tobx.de>
References: <23ACD985-211C-442C-AAE4-19F53F577849@tobx.de>
 <CAPhsuW6rtE6AcW2aVP6SLdBihrN=STmgiNg9qB5XJWCk8_rfUw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW6rtE6AcW2aVP6SLdBihrN=STmgiNg9qB5XJWCk8_rfUw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <liu.song.a23@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Song Liu wrote:
> What the version of mdadm in the test? Could you please help get the output of:
> 
> mdadm -E /dev/sd[bcde]1

# mdadm --version
mdadm - v3.4 - 28th January 2016

# mdadm -E /dev/sd[bcde]1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x200
     Array UUID : d59de5cc:02f560ed:ebcb9400:491955d7
           Name : debian:test  (local to host debian)
  Creation Time : Tue Nov 14 19:58:04 2017
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 4190175 (2045.98 MiB 2145.37 MB)
     Array Size : 4189184 (4.00 GiB 4.29 GB)
  Used Dev Size : 4189184 (2045.50 MiB 2144.86 MB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1960 sectors, after=991 sectors
          State : clean
    Device UUID : c7df7513:f0027d4a:f608541c:4bd58405

    Update Time : Tue Nov 14 19:58:15 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 4d9c3340 - correct
         Events : 20

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x200
     Array UUID : d59de5cc:02f560ed:ebcb9400:491955d7
           Name : debian:test  (local to host debian)
  Creation Time : Tue Nov 14 19:58:04 2017
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 4190175 (2045.98 MiB 2145.37 MB)
     Array Size : 4189184 (4.00 GiB 4.29 GB)
  Used Dev Size : 4189184 (2045.50 MiB 2144.86 MB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1960 sectors, after=991 sectors
          State : clean
    Device UUID : 7580b395:3ee834d1:015af317:3ac3d008

    Update Time : Tue Nov 14 19:58:15 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 557cf83a - correct
         Events : 20

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x200
     Array UUID : d59de5cc:02f560ed:ebcb9400:491955d7
           Name : debian:test  (local to host debian)
  Creation Time : Tue Nov 14 19:58:04 2017
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 4190175 (2045.98 MiB 2145.37 MB)
     Array Size : 4189184 (4.00 GiB 4.29 GB)
  Used Dev Size : 4189184 (2045.50 MiB 2144.86 MB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1960 sectors, after=991 sectors
          State : clean
    Device UUID : b281826d:ec0b43dd:92d1528a:39846b12

    Update Time : Tue Nov 14 19:58:15 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : b55455b4 - correct
         Events : 20

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x200
     Array UUID : d59de5cc:02f560ed:ebcb9400:491955d7
           Name : debian:test  (local to host debian)
  Creation Time : Tue Nov 14 19:58:04 2017
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 4190175 (2045.98 MiB 2145.37 MB)
     Array Size : 4189184 (4.00 GiB 4.29 GB)
  Used Dev Size : 4189184 (2045.50 MiB 2144.86 MB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1960 sectors, after=7 sectors
          State : clean
    Device UUID : 768b1862:228d0d40:408fab64:fcc7d884

    Update Time : Tue Nov 14 19:58:15 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 597ae224 - correct
         Events : 20

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Journal
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)

Regards,
Tobi