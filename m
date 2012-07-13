From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Assembly failure
Date: Fri, 13 Jul 2012 19:52:35 +0100
Message-ID: <20120713185235.GA40886@nsrc.org>
References: <20120710163345.GB29855@nsrc.org>
 <4FFC5CC0.8050808@profitbricks.com> <20120710170646.GA29962@nsrc.org>
 <4FFC68AB.4010801@profitbricks.com> <20120710185927.GA30164@nsrc.org>
 <20120711124316.206ab3d9@notabene.brown> <20120711075818.GA30527@nsrc.org>
 <20120711172742.2b8e13e9@batzmaru.gol.ad.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120711172742.2b8e13e9@batzmaru.gol.ad.jp>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Balzer <chibi@gol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

OK, after reseating drives and removing the three definitely bad ones, I
think the hardware is stable again now.

So now I have a problem with the five-drive array I had set up in the mean
time.  All five drives are there, but one is a bit behind the others in its
event count and last update time.

Here's the mdadm --examine output:

/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 149c0025:e7c5da3a:62b7a318:4ca57af7
           Name : storage1.2
  Creation Time : Wed Jul 11 14:50:06 2012
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
     Array Size : 17581590528 (8383.56 GiB 9001.77 GB)
  Used Dev Size : 5860530176 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 56e9ce91:c5df8850:2105c86d:c9c710a1

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jul 11 15:19:31 2012
       Checksum : 80c0762 - correct
         Events : 276

         Layout : left-symmetric
     Chunk Size : 1024K

   Device Role : Active device 0
   Array State : AAAAA ('A' == active, '.' == missing)
/dev/sdj:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 149c0025:e7c5da3a:62b7a318:4ca57af7
           Name : storage1.2
  Creation Time : Wed Jul 11 14:50:06 2012
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
     Array Size : 17581590528 (8383.56 GiB 9001.77 GB)
  Used Dev Size : 5860530176 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : db72c8d7:672760b4:572dc944:fc7c151b

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jul 11 15:29:52 2012
       Checksum : 11ec5fef - correct
         Events : 357

         Layout : left-symmetric
     Chunk Size : 1024K

   Device Role : Active device 1
   Array State : .AAAA ('A' == active, '.' == missing)
/dev/sdk:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 149c0025:e7c5da3a:62b7a318:4ca57af7
           Name : storage1.2
  Creation Time : Wed Jul 11 14:50:06 2012
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
     Array Size : 17581590528 (8383.56 GiB 9001.77 GB)
  Used Dev Size : 5860530176 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : b12fefdd:74914e6e:9f3ca2bd:8b433e34

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jul 11 15:29:52 2012
       Checksum : 64035caa - correct
         Events : 357

         Layout : left-symmetric
     Chunk Size : 1024K

   Device Role : Active device 2
   Array State : .AAAA ('A' == active, '.' == missing)
/dev/sdl:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 149c0025:e7c5da3a:62b7a318:4ca57af7
           Name : storage1.2
  Creation Time : Wed Jul 11 14:50:06 2012
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
     Array Size : 17581590528 (8383.56 GiB 9001.77 GB)
  Used Dev Size : 5860530176 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : db387f8a:383c26f4:4012a3ec:12c7679e

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jul 11 15:29:52 2012
       Checksum : 2f9569c2 - correct
         Events : 357

         Layout : left-symmetric
     Chunk Size : 1024K

   Device Role : Active device 3
   Array State : .AAAA ('A' == active, '.' == missing)
/dev/sdm:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 149c0025:e7c5da3a:62b7a318:4ca57af7
           Name : storage1.2
  Creation Time : Wed Jul 11 14:50:06 2012
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
     Array Size : 17581590528 (8383.56 GiB 9001.77 GB)
  Used Dev Size : 5860530176 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : ac50fe77:91ce387a:e819a38d:4d56a734

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jul 11 15:29:52 2012
       Checksum : da66aace - correct
         Events : 357

         Layout : left-symmetric
     Chunk Size : 1024K

   Device Role : Active device 4
   Array State : .AAAA ('A' == active, '.' == missing)

Now, a simple assemble fails:

    root@dev-storage1:~# mdadm --assemble /dev/md/storage1.2 /dev/sd{b,j,k,l,m}
    mdadm: /dev/md/storage1.2 assembled from 4 drives - not enough to start the array while not clean - consider --force.
    root@dev-storage1:~# cat /proc/mdstat
    Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
    md127 : inactive sdj[1](S) sdm[4](S) sdl[3](S) sdk[2](S) sdb[0](S)
          14651327800 blocks super 1.2
           
    unused devices: <none>

(Well, md127 exists, but I don't know how to "start" it).
So let's try using --force as it suggests:

    root@dev-storage1:~# mdadm -S /dev/md127
    mdadm: stopped /dev/md127
    root@dev-storage1:~# mdadm --assemble --force /dev/md/storage1.2 /dev/sd{b,j,k,l,m}
    mdadm: /dev/md/storage1.2 has been started with 4 drives (out of 5).
    root@dev-storage1:~# cat /proc/mdstatPersonalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
    md127 : active raid6 sdj[1] sdm[4] sdl[3] sdk[2]
          8790795264 blocks super 1.2 level 6, 1024k chunk, algorithm 2 [5/4] [_UUUU]
          bitmap: 22/22 pages [88KB], 65536KB chunk

    unused devices: <none>
    root@dev-storage1:~# 

Now I have a 4-drive degraded RAID6, /dev/sdb isn't even listed (even though
I gave it on the command line).  Is this correct?  Is the next thing to do
to add the 5th drive into it manually?

    root@dev-storage1:~# mdadm --manage --re-add /dev/md127 /dev/sdb
    mdadm: re-added /dev/sdb
    root@dev-storage1:~# cat /proc/mdstat
    Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4]
    [raid10] 
    md127 : active raid6 sdb[0] sdj[1] sdm[4] sdl[3] sdk[2]
          8790795264 blocks super 1.2 level 6, 1024k chunk, algorithm 2 [5/4]
    [_UUUU]
          [>....................]  recovery =  1.1% (32854540/2930265088)
    finish=952.5min speed=50692K/sec
          bitmap: 22/22 pages [88KB], 65536KB chunk

    unused devices: <none>

That seems to have worked, can someone just confirm that's the right
sequence of things to do though. This is a test system, next time I do this
might be for real :-)

Cheers,

Brian.
