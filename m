From: Roberto Spadim <roberto@spadim.com.br>
Subject: doubts about sdd raid1 and cfs
Date: Sat, 13 Jun 2015 16:42:56 -0300
Message-ID: <CAH3kUhFLHdJ6T_RHaL2AyFHuH3Ta90DLhj8TKM5jZ_31mY2OCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi guys, i`m setting up a new server, it have
1) 2x 256gb sdd
Samsung SSD 850 PRO 256GB, EXM02B6Q
500118192 sectors, multi 1: LBA48 NCQ (depth 31/32)
2)1tb hdd
Hitachi HUA722010CLA330, JP4OA3EA
1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32)

i`m plannig a raid1 with ssd and hdd, hdd being a "write-mostly", and
750gb of hdd i will use to backup or other useless files

i have somedoubts about the setup..
i use xfs at filesystem, should i consider TRIM command at filesystem?
the problem is hdd being part of raid1 setup with others ssd, could
the ssd receive the TRIM and the hdd too?
any idea is wellcome

-- 
Roberto Spadim
