From: Larry Owen <larryowen@cis.uab.edu>
Subject: Failed RAID6
Date: Fri, 24 Feb 2012 11:56:39 -0600 (CST)
Message-ID: <1217710129.60911.1330106199149.JavaMail.root@zimbra.cis.uab.edu>
References: <1788692158.60895.1330105517283.JavaMail.root@zimbra.cis.uab.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1788692158.60895.1330105517283.JavaMail.root@zimbra.cis.uab.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We have a raid6 array with 3 "failed" discs.  However, smart 
status for all drives is ok.  I'm also not seeing any io errors
in my logs (except when the discs were initially dropped). I 
also tried reading raw data from one of the failed drives, 
using dd.  I was able to get data, still no io errors.

We're thinking about trying to re-add or assemble --force,
in hopes of getting it up to recover some data (did I mention
the users put important data on here knowing it was not backed
up).

Our main concern is that we add the discs and the system start 
rebuilding.  Any suggestions on how we should proceed?

Thanks,
Larry Owen

################### MDADM OUTPUT ##############################

mdadm --detail /dev/md0 
/dev/md0:
        Version : 1.2
  Creation Time : Tue Feb  1 16:25:03 2011
     Raid Level : raid6
  Used Dev Size : 1953512960 (1863.02 GiB 2000.40 GB)
   Raid Devices : 22
  Total Devices : 21
    Persistence : Superblock is persistent

    Update Time : Wed Feb 22 23:42:11 2012
          State : active, FAILED, Not Started
 Active Devices : 19
Working Devices : 21
 Failed Devices : 0
  Spare Devices : 2

         Layout : left-symmetric
     Chunk Size : 512K

           Name : kddm-nas:0  (local to host kddm-nas)
           UUID : 9fc31e38:7723974a:1f37af62:5a75ec91
         Events : 5412

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       2       8       48        2      active sync   /dev/sdd
       3       8       64        3      active sync   /dev/sde
       4       8       80        4      active sync   /dev/sdf
       5       8       96        5      active sync   /dev/sdg
       6       8      112        6      active sync   /dev/sdh
       7       0        0        7      removed
       8       8      144        8      active sync   /dev/sdj
       9       8      160        9      active sync   /dev/sdk
      10       8      176       10      active sync   /dev/sdl
      11       0        0       11      removed
      12       8      208       12      active sync   /dev/sdn
      13       8      224       13      active sync   /dev/sdo
      14       8      240       14      active sync   /dev/sdp
      15       0        0       15      removed
      16      65       16       16      active sync   /dev/sdr
      17      65       32       17      active sync   /dev/sds
      18      65       48       18      active sync   /dev/sdt
      19      65       64       19      active sync   /dev/sdu
      20      65       80       20      active sync   /dev/sdv
      21      65       96       21      active sync   /dev/sdw

      22      65      112        -      spare   /dev/sdx
      23      65      128        -      spare   /dev/sdy



