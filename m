From: "Renaud (Ron) OLGIATI" <renaud@olgiati-in-paraguay.org>
Subject: Raid1 after new MB
Date: Wed, 6 May 2020 14:09:40 -0400
Message-ID: <20200506140940.39670aed@olgiati-in-paraguay.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


I have just booted my box after putting in a new MBn old one died peacefully during the night.

My HDs were configured at the BIOS level as hardware RAID1, and in the PCLinuxOS system with mdadm.

I only learned later (on this list) that it was not necessary to configur HW RAID1 at the BIOS level.

Booting the box, and without configuring the RAID1 at the BIOS level, the box booted normally, but only the priùmary partitions of the two HD pairs work properly:

~ $ cat /proc/mdstat 
Personalities : [raid1] 
md7 : active raid1 sdc1[0] sdd1[1]
      1953382464 blocks super 1.2 [2/2] [UU]
      bitmap: 1/15 pages [4KB], 65536KB chunk

md6 : active raid1 sda10[0]
      248640 blocks super 1.2 [2/1] [U_]
      
md5 : active raid1 sda9[0]
      446840832 blocks super 1.2 [2/1] [U_]
      bitmap: 4/4 pages [16KB], 65536KB chunk

md4 : active raid1 sda8[0]
      15616000 blocks super 1.2 [2/1] [U_]
      
md3 : active raid1 sda7[0]
      12686336 blocks super 1.2 [2/1] [U_]
      
md2 : active raid1 sda6[0]
      242496 blocks super 1.2 [2/1] [U_]
      
md1 : active raid1 sda5[0]
      8198144 blocks super 1.2 [2/1] [U_]
      
md0 : active raid1 sda1[0] sdb1[1]
      4389888 blocks super 1.2 [2/2] [UU]
      
unused devices: <none>

So I went to the BIOS, to activate the hardware RAID1, get a warning that all data will be lost; so did not do it., 

What should I do to restore the RAID volumes md1 to md6 ?
 
Cheers,
 
Ron.
-- 
                 Une illusion perdue est une vérité trouvée .
                                    
                   -- http://www.olgiati-in-paraguay.org --
 
