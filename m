From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: question regarding the output of "mdadm --examine /dev/hdxx"
Date: Fri, 24 Jan 2003 14:16:07 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E313C97.1090100@fl.priv.at>
Reply-To: Linux RAID Mailing Liste <linux-raid@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux RAID Mailing Liste <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi!

Can someone enlight me why "mdadm --examine" prints out the
current examined disk as "this". I see no real sense behind this.
Mdadm already states at the top of the output which device it
examined.

# mdadm --examine /dev/hda1
/dev/hda1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : c8756d0c:a668883a:6751424c:5fddb03d
   Creation Time : Tue Jan 21 01:05:23 2003
      Raid Level : raid1
     Device Size : 40209024 (38.35 GiB 41.22 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0

     Update Time : Fri Jan 24 14:07:39 2003
           State : clean, no-errors
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 5dfc8bc1 - correct
          Events : 0.17


       Number   Major   Minor   RaidDevice State
this     0       3        1        0      active sync   /dev/hda1
    0     0       3        1        0      active sync   /dev/hda1
    1     1      22        1        1      active sync   /dev/hdc1

# mdadm --examine /dev/hdc1
/dev/hdc1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : c8756d0c:a668883a:6751424c:5fddb03d
   Creation Time : Tue Jan 21 01:05:23 2003
      Raid Level : raid1
     Device Size : 40209024 (38.35 GiB 41.22 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0

     Update Time : Fri Jan 24 14:07:39 2003
           State : clean, no-errors
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 5dfc8bd6 - correct
          Events : 0.17


       Number   Major   Minor   RaidDevice State
this     1      22        1        1      active sync   /dev/hdc1
    0     0       3        1        0      active sync   /dev/hda1
    1     1      22        1        1      active sync   /dev/hdc1

-- 
MfG / Regards
Friedrich Lobenstock
____________________________________________________________________
Friedrich Lobenstock         FL226-RIPE             Internetservices
URL: http://www.fl.priv.at/                     Email: fl@fl.priv.at
____________________________________________________________________

