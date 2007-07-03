From: Michael Frotscher <infomails@tronserver.dyndns.org>
Subject: Re: RAID5 not being reassembled correctly after device swap
Date: Tue, 3 Jul 2007 21:29:10 +0200
Message-ID: <200707032129.10787.infomails@tronserver.dyndns.org>
References: <200707012321.48346.infomails@tronserver.dyndns.org> <200707031916.50502.infomails@tronserver.dyndns.org> <468A98D5.9090206@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <468A98D5.9090206@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I forgot, in case it's of any help. 
mdadm -D gives after reassembly:

/dev/md3:
        Version : 00.90.03
  Creation Time : Sun Jan 14 21:17:53 2007
     Raid Level : raid5
     Array Size : 20980736 (20.01 GiB 21.48 GB)
    Device Size : 10490368 (10.00 GiB 10.74 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Tue Jul  3 21:21:53 2007
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 4K

           UUID : 36bbe21d:f49e8b5d:f504154c:a6f12a51
         Events : 0.6995604

    Number   Major   Minor   RaidDevice State
       0       3        3        0      active sync   /dev/hda3
       1       3       67        1      active sync   /dev/hdb3
       2      22        3        2      active sync   /dev/hdc3

and after the next boot:

/dev/md3:
        Version : 00.90.03
  Creation Time : Sun Jan 14 21:17:53 2007
     Raid Level : raid5
     Array Size : 20980736 (20.01 GiB 21.48 GB)
    Device Size : 10490368 (10.00 GiB 10.74 GB)
   Raid Devices : 3
  Total Devices : 2
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Tue Jul  3 21:27:08 2007
          State : clean, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 4K

           UUID : 36bbe21d:f49e8b5d:f504154c:a6f12a51
         Events : 0.6995718

    Number   Major   Minor   RaidDevice State
       0       3        3        0      active sync   /dev/hda3
       1       3       67        1      active sync   /dev/hdb3
       2       0        0        2      removed

Any ideas on why the drive keeps being removed?
-- 
YT,
Michael
