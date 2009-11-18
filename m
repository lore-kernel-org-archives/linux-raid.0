From: Erwan MAS <erwan@mas.nom.fr>
Subject: Raid10 layout
Date: Wed, 18 Nov 2009 14:38:03 +0100
Message-ID: <20091118133803.GH1863@voyageur.mas.nom.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello ,

I use md rai10 in 3 configurations :
- with 2 devices in f2 layout
- with 3 devices in f2 layout
- with 4 devices in f2 layout

With the help of ( http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10 ) , 
i had validated the layout for 2 / 3 devices .
Aka i read the block on the md device an i compare to each block on each physical devices .

With my configuration with 4 devices , the comparaison does not work .

Can someone explain me how to calculate the position of each chunk ?


My output of my md device :

/dev/md2:
        Version : 00.90.03
  Creation Time : Sun Jul  5 17:08:11 2009
     Raid Level : raid10
     Array Size : 527348736 (502.92 GiB 540.01 GB)
  Used Dev Size : 263674624 (251.46 GiB 270.00 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Wed Nov 18 14:35:41 2009
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=1, far=2
     Chunk Size : 256K

           UUID : e383a648:2d866213:bef1cd83:48bb11be
         Events : 0.7603331

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       35        1      active sync   /dev/sdc3
       2       8       19        2      active sync   /dev/sdb3
       3       8       51        3      active sync   /dev/sdd3




-- 
     ____________________________________________________________
    / Erwan MAS                                                 /\
   | mailto:erwan@mas.nom.fr                                   |_/
___|________________________________________________________   |
\___________________________________________________________\__/
