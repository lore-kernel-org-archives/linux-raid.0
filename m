From: Daniel Sanabria <sanabria.d@gmail.com>
Subject: missing arrays after OS upgrade
Date: Tue, 24 Mar 2015 22:48:56 +0000
Message-ID: <CAHscji03jWu3EF0KUG45Hv4Y2t5beJmEoe9uWMfR=wGz_dkBbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

One of our servers went trough an OS upgrade (from fedora20 to
fedora21) and althou some of the arrays seem to be auto-detected one
of them seem to be missing.

I have some info related to the array in question:

115 /dev/md2:
116         Version : 0.90
117   Creation Time : Mon Feb 11 07:54:36 2013
118      Raid Level : raid5
119      Array Size : 511999872 (488.28 GiB 524.29 GB)
120   Used Dev Size : 255999936 (244.14 GiB 262.14 GB)
121    Raid Devices : 3
122   Total Devices : 3
123 Preferred Minor : 2
124     Persistence : Superblock is persistent
125
126     Update Time : Sun Mar 22 18:23:38 2015
127           State : clean
128  Active Devices : 3
129 Working Devices : 3
130  Failed Devices : 0
131   Spare Devices : 0
132
133          Layout : left-symmetric
134      Chunk Size : 64K
135
136            UUID : 2cff15d1:e411447b:fd5d4721:03e44022 (local to
host lamachine)
137          Events : 0.478
138
139     Number   Major   Minor   RaidDevice State
140        0       8        3        0      active sync   /dev/sda3
141        1       8       18        1      active sync   /dev/sdb2
142        2       8       34        2      active sync   /dev/sdc2

I haven't taken any actions to try to re-assemble the array and wanted
to check for ideas/suggestions here first.

Any advice you might regarding the steps to take to get the array up
and runnign again is higy appreciated.

Thanks in advance,

Daniel
