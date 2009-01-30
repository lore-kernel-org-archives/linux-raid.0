From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Subject: raid1 state always "active"
Date: Fri, 30 Jan 2009 05:25:51 -0200
Message-ID: <vkma56-v06.ln1@tux.abusar.org.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

	I have this raid1 array, but the State field is always
"active". Shouldn't it be "clean"? Is there something wrong with this
output? Thanks.

	***

/dev/md2:
        Version : 0.90
  Creation Time : Sat Jul 21 18:04:17 2007
     Raid Level : raid1
     Array Size : 243689920 (232.40 GiB 249.54 GB)
  Used Dev Size : 243689920 (232.40 GiB 249.54 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Fri Jan 30 05:21:39 2009
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 0faf7268:0b90ad9f:c3c0f7e8:e4fa2b72
         Events : 0.49049

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2

-- 
Linux 2.6.28: Erotic Pickled Herring
http://u-br.net


