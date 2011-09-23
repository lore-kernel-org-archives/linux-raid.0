From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: potentially lost largeish raid5 array..
Date: Thu, 22 Sep 2011 22:49:12 -0600
Message-ID: <201109222249.12892.tfjellstrom@shaw.ca>
References: <201109221950.36910.tfjellstrom@shaw.ca> <20110923143210.583e11ec@notabene.brown>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110923143210.583e11ec@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On September 22, 2011, NeilBrown wrote:
> On Thu, 22 Sep 2011 19:50:36 -0600 Thomas Fjellstrom <tfjellstrom@shaw.ca>
> 
> wrote:
> > Hi,
> > 
> > I've been struggling with a SAS card recently that has had poor driver
> > support for a long time, and tonight its decided to kick every drive in
> > the array one after the other. Now mdstat shows:
> > 
> > md1 : active raid5 sdf[0](F) sdh[7](F) sdi[6](F) sdj[5](F) sde[3](F)
> > sdd[2](F) sdg[1](F)
> > 
> >       5860574208 blocks super 1.1 level 5, 512k chunk, algorithm 2 [7/0]
> > 
> > [_______]
> > 
> >       bitmap: 3/8 pages [12KB], 65536KB chunk
> > 
> > Does the fact that I'm using a bitmap save my rear here? Or am I hosed?
> > If I'm not hosed, is there a way I can recover the array without
> > rebooting? maybe just a --stop and a --assemble ? If that won't work,
> > will a reboot be ok?
> > 
> > I'd really prefer not to have lost all of my data. Please tell me
> > (please) that it is possible to recover the array. All but sdi are still
> > visible in /dev (I may be able to get it back via hotplug maybe, but
> > it'd get sdk or something).
> 
> mdadm --stop /dev/md1
> 
> mdadm --examine /dev/sd[fhijedg]
> mdadm --assemble --verbose /dev/md1 /dev/sd[fhijedg]
> 
> Report all output.
> 
> NeilBrown

Hi, thanks for the help. Seems the SAS card/driver is in a funky state at the 
moment. the --stop worked*. but --examine just gives "no md superblock 
detected", and dmesg reports io errors for all drives.

I've just reloaded the driver, and things seem to have come back:

root@boris:~# mdadm --examine /dev/sd[fhijedg]
/dev/sdd:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : 7d0e9847:ec3a4a46:32b60a80:06d0ee1c
           Name : natasha:0
  Creation Time : Wed Oct 14 08:55:25 2009
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 1953524904 (931.51 GiB 1000.20 GB)
     Array Size : 11721148416 (5589.08 GiB 6001.23 GB)
  Used Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : c36d428a:e3bf801a:409009e1:b75207ed

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Sep 22 19:21:04 2011
       Checksum : 1eb2e3e5 - correct
         Events : 1241766

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAA.A ('A' == active, '.' == missing)
/dev/sde:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : 7d0e9847:ec3a4a46:32b60a80:06d0ee1c
           Name : natasha:0
  Creation Time : Wed Oct 14 08:55:25 2009
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 1953524904 (931.51 GiB 1000.20 GB)
     Array Size : 11721148416 (5589.08 GiB 6001.23 GB)
  Used Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 9c5ced42:03179de0:5d9520a0:9da28ce4

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Sep 22 19:21:04 2011
       Checksum : 54167ee2 - correct
         Events : 1241766

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAA.A ('A' == active, '.' == missing)
/dev/sdf:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : 7d0e9847:ec3a4a46:32b60a80:06d0ee1c
           Name : natasha:0
  Creation Time : Wed Oct 14 08:55:25 2009
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 1953524904 (931.51 GiB 1000.20 GB)
     Array Size : 11721148416 (5589.08 GiB 6001.23 GB)
  Used Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 6622021f:ad59cbf8:6395788e:0c78edca

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Sep 22 19:21:04 2011
       Checksum : 1d125cc8 - correct
         Events : 1241766

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAA.A ('A' == active, '.' == missing)
/dev/sdg:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : 7d0e9847:ec3a4a46:32b60a80:06d0ee1c
           Name : natasha:0
  Creation Time : Wed Oct 14 08:55:25 2009
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 1953524904 (931.51 GiB 1000.20 GB)
     Array Size : 11721148416 (5589.08 GiB 6001.23 GB)
  Used Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : d566a663:226e4f40:b5b688fb:1c538e7e

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Sep 22 19:21:04 2011
       Checksum : c9ebb20e - correct
         Events : 1241766

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAA.A ('A' == active, '.' == missing)
/dev/sdh:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : 7d0e9847:ec3a4a46:32b60a80:06d0ee1c
           Name : natasha:0
  Creation Time : Wed Oct 14 08:55:25 2009
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
     Array Size : 11721148416 (5589.08 GiB 6001.23 GB)
    Data Offset : 432 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 5507b034:a8b38618:a849baa2:a2dfdeb1

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Sep 22 19:21:04 2011
       Checksum : 4daeb793 - correct
         Events : 1241766

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAAAA.A ('A' == active, '.' == missing)
/dev/sdi:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : 7d0e9847:ec3a4a46:32b60a80:06d0ee1c
           Name : natasha:0
  Creation Time : Wed Oct 14 08:55:25 2009
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
     Array Size : 11721148416 (5589.08 GiB 6001.23 GB)
    Data Offset : 432 sectors
   Super Offset : 0 sectors
          State : active
    Device UUID : 9f036406:e5783077:4d9fe524:1966e68e

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Sep 22 19:19:51 2011
       Checksum : dd3e54d8 - correct
         Events : 1241740

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAAA ('A' == active, '.' == missing)
/dev/sdj:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : 7d0e9847:ec3a4a46:32b60a80:06d0ee1c
           Name : natasha:0
  Creation Time : Wed Oct 14 08:55:25 2009
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 1953524904 (931.51 GiB 1000.20 GB)
     Array Size : 11721148416 (5589.08 GiB 6001.23 GB)
  Used Dev Size : 1953524736 (931.51 GiB 1000.20 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 1c7f3eb5:94fc143b:7ec49dec:fc575fea

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Sep 22 19:21:04 2011
       Checksum : 732f6b75 - correct
         Events : 1241766

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAA.A ('A' == active, '.' == missing)

root@boris:~# mdadm --assemble --verbose /dev/md1 /dev/sd[fhijedg]
mdadm: looking for devices for /dev/md1
mdadm: /dev/sdd is identified as a member of /dev/md1, slot 2.
mdadm: /dev/sde is identified as a member of /dev/md1, slot 3.
mdadm: /dev/sdf is identified as a member of /dev/md1, slot 0.
mdadm: /dev/sdg is identified as a member of /dev/md1, slot 1.
mdadm: /dev/sdh is identified as a member of /dev/md1, slot 6.
mdadm: /dev/sdi is identified as a member of /dev/md1, slot 5.
mdadm: /dev/sdj is identified as a member of /dev/md1, slot 4.
mdadm: added /dev/sdg to /dev/md1 as 1
mdadm: added /dev/sdd to /dev/md1 as 2
mdadm: added /dev/sde to /dev/md1 as 3
mdadm: added /dev/sdj to /dev/md1 as 4
mdadm: added /dev/sdi to /dev/md1 as 5
mdadm: added /dev/sdh to /dev/md1 as 6
mdadm: added /dev/sdf to /dev/md1 as 0
mdadm: /dev/md1 has been started with 6 drives (out of 7).


Now I guess the question is, how to get that last drive back in? would: 

mdadm --re-add /dev/md1 /dev/sdi 

work?

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
