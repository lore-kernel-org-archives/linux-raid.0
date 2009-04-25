From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sat, 25 Apr 2009 02:40:24 -0500
Message-ID: <20090425074027510.YPAD9976@cdptpa-omta03.mail.rr.com>
References: <CBD259F5-4214-4C0C-A1D7-16ABC0A2BA89@redhat.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CBD259F5-4214-4C0C-A1D7-16ABC0A2BA89@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Doug Ledford' <dledford@redhat.com>
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> On Apr 24, 2009, at 12:52 AM, Leslie Rhorer wrote:
> > I've done some reading, and it's been suggested a 128K chunk size
> > might be a
> > better choice on my system than the default chunk size of 64K, so I
> > intend
> > to create the new array on the raw devices with the command:
> >
> > mdadm --create --raid-devices=10 --metadata=1.2 --chunk=128 --level=6
> > /dev/sd[a-j]
> 
> Go with a bigger chunk size.  Especially if you do lots of big file
> manipulation.  During testing (many years ago now, admittedly) with
> Dell for some benchmarks, it was determined that when using linux
> software raid, larger chunk sizes would tend to increase performance.
> In those tests, we settled on a 2MB chunk size.  I wouldn't recommend
> you go *that* high, but I could easily see 256k or 512k chunk sizes.

I went ahead and selected 256K.  There's something a little odd, though.
mdadm is reporting a device size of 2T.  These are 1T drives.  The overall
array size is correct but the device size is goofy.  I hope this doesn't
cause any problems.  As I believe I mentioned before (or maybe it was on
another list), I once had problems with ext3 trying to read beyond the
physical end of the array.

RAID-Server:/Backup/Personal_Folders# mdadm -Dt /dev/md0
/dev/md0:
        Version : 01.02
  Creation Time : Sat Apr 25 01:17:12 2009
     Raid Level : raid6
     Array Size : 7814098944 (7452.11 GiB 8001.64 GB)
  Used Dev Size : 1953524736 (1863.03 GiB 2000.41 GB)
   Raid Devices : 10
  Total Devices : 10
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sat Apr 25 01:20:47 2009
          State : active, resyncing
 Active Devices : 10
Working Devices : 10
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 256K

 Rebuild Status : 0% complete

           Name : RAID-Server:0  (local to host RAID-Server)
           UUID : 5ff10d73:a096195f:7a646bba:a68986ca
         Events : 1

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      active sync   /dev/sdb
       2       8       32        2      active sync   /dev/sdc
       3       8       48        3      active sync   /dev/sdd
       4       8       64        4      active sync   /dev/sde
       5       8       80        5      active sync   /dev/sdf
       6       8       96        6      active sync   /dev/sdg
       7       8      112        7      active sync   /dev/sdh
       8       8      128        8      active sync   /dev/sdi
       9       8      144        9      active sync   /dev/sdj


