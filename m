From: Christian Balzer <chibi@gol.com>
Subject: Re: MD Raid10 recovery results in "attempt to access beyond end of
 device"
Date: Fri, 22 Jun 2012 17:42:57 +0900
Message-ID: <20120622174257.03a17e81@batzmaru.gol.ad.jp>
References: <20120622160632.7dfbbb9d@batzmaru.gol.ad.jp>
	<20120622180748.5f78339c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120622180748.5f78339c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,

On Fri, 22 Jun 2012 18:07:48 +1000 NeilBrown wrote:

> On Fri, 22 Jun 2012 16:06:32 +0900 Christian Balzer <chibi@gol.com>
> wrote:
> 
> > 
> > Hello,
> > 
> > the basics first:
> > Debian Squeeze, custom 3.2.18 kernel.
> > 
> > The Raid(s) in question are:
> > ---
> > Personalities : [raid1] [raid10] 
> > md4 : active raid10 sdd1[0] sdb4[5](S) sdl1[4] sdk1[3] sdj1[2] sdi1[1]
> >       3662836224 blocks super 1.2 512K chunks 2 near-copies [5/5]
> > [UUUUU]
> 
> I'm stumped by this.  It shouldn't be possible.
> 
> The size of the array is impossible.
> 
> If there are N chunks per device, then there are 5*N chunks on the whole
> array, and there are are two copies of each data chunk, so
> 5*N/2 distinct data chunks, so that should be the size of the array.
> 
> So if we take the size of the array, divide by chunk size, multiply by 2,
> divide by 5, we get N = the number of chunks per device.
> i.e.
>   N = (array_size / chunk_size)*2 / 5
> 
> If we plug in 3662836224 for the array size and 512 for the chunk size,
> we get 2861590.8, which is not an integer.
> i.e. impossible.
> 
Quite right, though I never bothered to check that number of course,
pretty much assuming after using Linux MD since the last millennium that
it would get things right. ^o^

> What does "mdadm --examine" of the various devices show?
> 
They looks all identical and sane to me:
---
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2b46b20b:80c18c76:bcd534b5:4d1372e4
           Name : borg03b:3  (local to host borg03b)
  Creation Time : Sat May 19 01:07:34 2012
     Raid Level : raid10
   Raid Devices : 5

 Avail Dev Size : 2930269954 (1397.26 GiB 1500.30 GB)
     Array Size : 5860538368 (2794.52 GiB 3000.60 GB)
  Used Dev Size : 2930269184 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : fe922c1c:35319892:cc1e32e9:948d932c

    Update Time : Fri Jun 22 17:12:05 2012
       Checksum : 27a61d9a - correct
         Events : 90893

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAA ('A' == active, '.' == missing)

/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2b46b20b:80c18c76:bcd534b5:4d1372e4
           Name : borg03b:3  (local to host borg03b)
  Creation Time : Sat May 19 01:07:34 2012
     Raid Level : raid10
   Raid Devices : 5

 Avail Dev Size : 2930269954 (1397.26 GiB 1500.30 GB)
     Array Size : 5860538368 (2794.52 GiB 3000.60 GB)
  Used Dev Size : 2930269184 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : e7f5da61:cba8e3f7:d5efbd3d:2f4d3013

    Update Time : Fri Jun 22 17:12:55 2012
       Checksum : dc88710 - correct
         Events : 90923

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAA ('A' == active, '.' == missing)

/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2b46b20b:80c18c76:bcd534b5:4d1372e4
           Name : borg03b:3  (local to host borg03b)
  Creation Time : Sat May 19 01:07:34 2012
     Raid Level : raid10
   Raid Devices : 5

 Avail Dev Size : 2930269954 (1397.26 GiB 1500.30 GB)
     Array Size : 5860538368 (2794.52 GiB 3000.60 GB)
  Used Dev Size : 2930269184 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : eea0d414:382d5ac4:851772a2:af72eceb

    Update Time : Fri Jun 22 17:13:10 2012
       Checksum : caa903cc - correct
         Events : 90933

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAA ('A' == active, '.' == missing)

/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2b46b20b:80c18c76:bcd534b5:4d1372e4
           Name : borg03b:3  (local to host borg03b)
  Creation Time : Sat May 19 01:07:34 2012
     Raid Level : raid10
   Raid Devices : 5

 Avail Dev Size : 2930269954 (1397.26 GiB 1500.30 GB)
     Array Size : 5860538368 (2794.52 GiB 3000.60 GB)
  Used Dev Size : 2930269184 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : ffcfc875:77d830a0:14575bdc:c339a428

    Update Time : Fri Jun 22 17:13:34 2012
       Checksum : 7e14e4e9 - correct
         Events : 90947

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAA ('A' == active, '.' == missing)

/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x2
     Array UUID : 2b46b20b:80c18c76:bcd534b5:4d1372e4
           Name : borg03b:3  (local to host borg03b)
  Creation Time : Sat May 19 01:07:34 2012
     Raid Level : raid10
   Raid Devices : 5

 Avail Dev Size : 2930269954 (1397.26 GiB 1500.30 GB)
     Array Size : 5860538368 (2794.52 GiB 3000.60 GB)
  Used Dev Size : 2930269184 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
Recovery Offset : 1465135104 sectors
          State : clean
    Device UUID : e86f53a3:940ce746:25423ae0:da3b179f

    Update Time : Fri Jun 22 17:13:49 2012
       Checksum : 23fbd830 - correct
         Events : 90953

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAA ('A' == active, '.' == missing)
---

I verified that these are identical to the ones on the other machine which
survived a resync event flawlessly. 

The version of mdadm in Squeeze is: mdadm - v3.1.4 - 31st August 2010

I created a pretty similar setup last year with 5 2TB drives each and
using a 3.0.7 kernel. That array size is nicely divisible...

I have a sinking feeling that the "fix" for this will be a rebuild of the
RAIDs on a production cluster. >.<

Christian

> NeilBrown
> 
> 
> >       
> > md3 : active raid10 sdh1[7] sdc1[0] sda4[5](S) sdg1[3] sdf1[2] sde1[6]
> >       3662836224 blocks super 1.2 512K chunks 2 near-copies [5/4]
> > [UUUU_] [=====>...............]  recovery = 28.3%
> > (415962368/1465134592) finish=326.2min speed=53590K/sec ---
> > 
> > Drives sda to sdd are on nVidia MCP55 and sde to sdl on SAS1068E, sdc
> > to sdl are identical 1.5TB Seagates (about 2 years old, recycled from
> > the previous incarnation of these machines) with a single partition
> > spanning the whole drive like this:
> > ---
> > Disk /dev/sdc: 1500.3 GB, 1500301910016 bytes
> > 255 heads, 63 sectors/track, 182401 cylinders
> > Units = cylinders of 16065 * 512 = 8225280 bytes
> > Sector size (logical/physical): 512 bytes / 512 bytes
> > I/O size (minimum/optimal): 512 bytes / 512 bytes
> > Disk identifier: 0x00000000
> > 
> >    Device Boot      Start         End      Blocks   Id  System
> > /dev/sdc1               1      182401  1465136001   fd  Linux raid
> > autodetect ---
> > 
> > sda and sdb are new 2TB Hitachi drives, partitioned like this:
> > ---
> > Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
> > 255 heads, 63 sectors/track, 243201 cylinders
> > Units = cylinders of 16065 * 512 = 8225280 bytes
> > Sector size (logical/physical): 512 bytes / 512 bytes
> > I/O size (minimum/optimal): 512 bytes / 512 bytes
> > Disk identifier: 0x000d53b0
> > 
> >    Device Boot      Start         End      Blocks   Id  System
> > /dev/sda1   *           1       31124   249999360   fd  Linux raid
> > autodetect /dev/sda2           31124       46686   124999680   fd
> > Linux raid autodetect /dev/sda3           46686       50576
> > 31246425   fd  Linux raid autodetect /dev/sda4           50576
> > 243201  1547265543+  fd  Linux raid autodetect ---
> > 
> > So the idea is to have 5 drives per each of the two Raid10s and one
> > spare on that (intentionally over-sized) fourth partition of the
> > bigger OS disks.
> > 
> > Some weeks ago a drive failed on the twin (identical everything, DRBD
> > replication of those 2 RAIDs) of the machine in question and everything
> > went according to the book, spare took over and things got rebuild, I
> > replaced the failed drive (sdi) later:
> > ---
> > md4 : active raid10 sdi1[6](S) sdd1[0] sdb4[5] sdl1[4] sdk1[3] sdj1[2]
> >       3662836224 blocks super 1.2 512K chunks 2 near-copies [5/5]
> > [UUUUU] ---
> > 
> > Two days ago drive sdh on the machine that's having issues failed:
> > ---
> > Jun 20 18:22:39 borg03b kernel: [1383395.448043] sd 8:0:3:0: Device
> > offlined - not ready after error recovery Jun 20 18:22:39 borg03b
> > kernel: [1383395.448135] sd 8:0:3:0: rejecting I/O to offline device
> > Jun 20 18:22:39 borg03b kernel: [1383395.452063] end_request: I/O
> > error, dev sdh, sector 71 Jun 20 18:22:39 borg03b kernel:
> > [1383395.452063] md: super_written gets error=-5, uptodate=0 Jun 20
> > 18:22:39 borg03b kernel: [1383395.452063] md/raid10:md3: Disk failure
> > on sdh1, disabling device. Jun 20 18:22:39 borg03b kernel:
> > [1383395.452063] md/raid10:md3: Operation continuing on 4 devices. Jun
> > 20 18:22:39 borg03b kernel: [1383395.527178] RAID10 conf printout: Jun
> > 20 18:22:39 borg03b kernel: [1383395.527181]  --- wd:4 rd:5 Jun 20
> > 18:22:39 borg03b kernel: [1383395.527184]  disk 0, wo:0, o:1, dev:sdc1
> > Jun 20 18:22:39 borg03b kernel: [1383395.527186]  disk 1, wo:0, o:1,
> > dev:sde1 Jun 20 18:22:39 borg03b kernel: [1383395.527189]  disk 2,
> > wo:0, o:1, dev:sdf1 Jun 20 18:22:39 borg03b kernel: [1383395.527191]
> > disk 3, wo:0, o:1, dev:sdg1 Jun 20 18:22:39 borg03b kernel:
> > [1383395.527193]  disk 4, wo:1, o:0, dev:sdh1 Jun 20 18:22:39 borg03b
> > kernel: [1383395.568037] RAID10 conf printout: Jun 20 18:22:39 borg03b
> > kernel: [1383395.568040]  --- wd:4 rd:5 Jun 20 18:22:39 borg03b
> > kernel: [1383395.568042]  disk 0, wo:0, o:1, dev:sdc1 Jun 20 18:22:39
> > borg03b kernel: [1383395.568045]  disk 1, wo:0, o:1, dev:sde1 Jun 20
> > 18:22:39 borg03b kernel: [1383395.568047]  disk 2, wo:0, o:1, dev:sdf1
> > Jun 20 18:22:39 borg03b kernel: [1383395.568049]  disk 3, wo:0, o:1,
> > dev:sdg1 Jun 20 18:22:39 borg03b kernel: [1383395.568060] RAID10 conf
> > printout: Jun 20 18:22:39 borg03b kernel: [1383395.568061]  --- wd:4
> > rd:5 Jun 20 18:22:39 borg03b kernel: [1383395.568063]  disk 0, wo:0,
> > o:1, dev:sdc1 Jun 20 18:22:39 borg03b kernel: [1383395.568065]  disk
> > 1, wo:0, o:1, dev:sde1 Jun 20 18:22:39 borg03b kernel:
> > [1383395.568068]  disk 2, wo:0, o:1, dev:sdf1 Jun 20 18:22:39 borg03b
> > kernel: [1383395.568070]  disk 3, wo:0, o:1, dev:sdg1 Jun 20 18:22:39
> > borg03b kernel: [1383395.568072]  disk 4, wo:1, o:1, dev:sda4 Jun 20
> > 18:22:39 borg03b kernel: [1383395.568135] md: recovery of RAID array
> > md3 Jun 20 18:22:39 borg03b kernel: [1383395.568139] md: minimum
> > _guaranteed_  speed: 20000 KB/sec/disk. Jun 20 18:22:39 borg03b
> > kernel: [1383395.568142] md: using maximum available idle IO bandwidth
> > (but not more than 500000 KB/sec) for recovery. Jun 20 18:22:39
> > borg03b kernel: [1383395.568155] md: using 128k window, over a total
> > of 1465134592k. ---
> > 
> > OK, spare kicked, recovery underway (from the neighbors sdg and sdc),
> > but then: ---
> > Jun 21 02:29:29 borg03b kernel: [1412604.989978] attempt to access
> > beyond end of device Jun 21 02:29:29 borg03b kernel: [1412604.989983]
> > sdc1: rw=0, want=2930272128, limit=2930272002 Jun 21 02:29:29 borg03b
> > kernel: [1412604.990003] attempt to access beyond end of device Jun 21
> > 02:29:29 borg03b kernel: [1412604.990009] sdc1: rw=16,
> > want=2930272008, limit=2930272002 Jun 21 02:29:29 borg03b kernel:
> > [1412604.990013] md/raid10:md3: recovery aborted due to read error Jun
> > 21 02:29:29 borg03b kernel: [1412604.990025] attempt to access beyond
> > end of device Jun 21 02:29:29 borg03b kernel: [1412604.990028] sdc1:
> > rw=0, want=2930272256, limit=2930272002 Jun 21 02:29:29 borg03b
> > kernel: [1412604.990032] md: md3: recovery done. Jun 21 02:29:29
> > borg03b kernel: [1412604.990035] attempt to access beyond end of
> > device Jun 21 02:29:29 borg03b kernel: [1412604.990038] sdc1: rw=16,
> > want=2930272136, limit=2930272002 Jun 21 02:29:29 borg03b kernel:
> > [1412604.990040] md/raid10:md3: recovery aborted due to read error ---
> > 
> > Why it would want to read data beyond the end of that device (and
> > partition) is a complete mystery to me, if anything was odd with this
> > Raid or its superblocks, surely the initial sync should have stumbled
> > across this as well?
> > 
> > After this failure the kernel goes into a log frenzy:
> > ---
> > Jun 21 02:29:29 borg03b kernel: [1412605.744052] RAID10 conf printout:
> > Jun 21 02:29:29 borg03b kernel: [1412605.744055]  --- wd:4 rd:5
> > Jun 21 02:29:29 borg03b kernel: [1412605.744057]  disk 0, wo:0, o:1,
> > dev:sdc1 Jun 21 02:29:29 borg03b kernel: [1412605.744060]  disk 1,
> > wo:0, o:1, dev:sde1 Jun 21 02:29:29 borg03b kernel: [1412605.744062]
> > disk 2, wo:0, o:1, dev:sdf1 Jun 21 02:29:29 borg03b kernel:
> > [1412605.744064]  disk 3, wo:0, o:1, dev:sdg1 ---
> > repeating every second or so, until I "mdadm -r"ed the sda4 partition
> > (former spare).
> > 
> > On the next day I replaced the failed sdh drive with another 2TB
> > Hitachi (having only 1.5TB Seagates of dubious quality lying around),
> > gave it the same single partition size as the other drives and added
> > it to md3.
> > 
> > The resync failed in the same manner:
> > ---
> > Jun 21 20:59:06 borg03b kernel: [1479182.509914] attempt to access
> > beyond end of device Jun 21 20:59:06 borg03b kernel: [1479182.509920]
> > sdc1: rw=0, want=2930272128, limit=2930272002 Jun 21 20:59:06 borg03b
> > kernel: [1479182.509931] attempt to access beyond end of device Jun 21
> > 20:59:06 borg03b kernel: [1479182.509933] attempt to access beyond end
> > of device Jun 21 20:59:06 borg03b kernel: [1479182.509937] sdc1: rw=0,
> > want=2930272256, limit=2930272002 Jun 21 20:59:06 borg03b kernel:
> > [1479182.509942] md: md3: recovery done. Jun 21 20:59:06 borg03b
> > kernel: [1479182.509948] sdc1: rw=16, want=2930272008,
> > limit=2930272002 Jun 21 20:59:06 borg03b kernel: [1479182.509952]
> > md/raid10:md3: recovery aborted due to read error Jun 21 20:59:06
> > borg03b kernel: [1479182.509963] attempt to access beyond end of
> > device Jun 21 20:59:06 borg03b kernel: [1479182.509965] sdc1: rw=16,
> > want=2930272136, limit=2930272002 Jun 21 20:59:06 borg03b kernel:
> > [1479182.509968] md/raid10:md3: recovery aborted due to read error ---
> > 
> > I've now scrounged up an identical 1.5TB drive and added it to the Raid
> > (the recovery visible in the topmost mdstat). 
> > If that fails as well, I'm completely lost as to what's going on, if it
> > succeeds though I guess we're looking at a subtle bug. 
> > 
> > I didn't find anything like this mentioned in the archives before, any
> > and all feedback would be most welcome.
> > 
> > Regards,
> > 
> > Christian
> 


-- 
Christian Balzer        Network/Systems Engineer                
chibi@gol.com   	Global OnLine Japan/Fusion Communications
http://www.gol.com/
