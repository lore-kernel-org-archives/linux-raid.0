From: Oguz Yilmaz <oguzyilmazlist@gmail.com>
Subject: Adding Raid 1 to Raid 0 on Linux
Date: Fri, 30 Nov 2012 02:44:37 +0200
Message-ID: <CAAo+KFmrVi4jd=F=Umjjf4VqdV8GW4oh24S+pO2yzteMVJf1Pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a system already configured with raid 1 with 2 disks:

/dev/md1             918347072 249416692 621528596  29% /var
/dev/md0               9920532    160640   9247828   2% /tmp

# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sdc5[0] sdb5[1]
      948035712 blocks [2/2] [UU]

md0 : active raid1 sdc2[0] sdb2[1]
      10241344 blocks [2/2] [UU]

I have asked for changing this into Raid 0+1 (striped raid is
mirrored, http://en.wikipedia.org/wiki/Nested_RAID_levels#RAID_0.2B1 )

How can I change this partition into Raid 01 after adding 2 more disks
without formatting?


--
Oguz YILMAZ
