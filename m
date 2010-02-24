From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: emergency call for help: raid5 fallen apart
Date: Wed, 24 Feb 2010 17:53:27 +0100
Message-ID: <4B855987.1010605@xunil.at>
References: <4B853DB7.1060406@xunil.at> <4B854040.5080603@xunil.at> <20100224152228.GB11039@cthulhu.home.robinhill.me.uk> <4B85467C.5020008@xunil.at> <4B855621.5010000@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B855621.5010000@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 24.02.2010 17:38, schrieb Stefan G. Weichinger:

> I now have md4 on sda4 and sdb4 ... xfs_repaired ... and sync the data
> to a plain new xfs-partition on sdc4 ... just to get current data out of
> the way.


Status now, after another reboot because of a failing md4:

why degraded? How to get out of that and re-add sdc4 or sdd4 ?
What about that device 2 down there??


server-gentoo ~ # mdadm -D /dev/md4
/dev/md4:
        Version : 00.90.03
  Creation Time : Tue Aug  5 14:14:16 2008
     Raid Level : raid5
     Array Size : 291820544 (278.30 GiB 298.82 GB)
  Used Dev Size : 145910272 (139.15 GiB 149.41 GB)
   Raid Devices : 3
  Total Devices : 2
Preferred Minor : 4
    Persistence : Superblock is persistent

    Update Time : Wed Feb 24 17:41:15 2010
          State : clean, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : d4b0e9c1:067357ce:2569337e:e9af8bed
         Events : 0.198

    Number   Major   Minor   RaidDevice State
       0       8        4        0      active sync   /dev/sda4
       1       8       20        1      active sync   /dev/sdb4
       2       0        0        2      removed

