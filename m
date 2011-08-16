From: Harald Nikolisin <hochglanz@gmail.com>
Subject: Device utilization with RAID-1
Date: Tue, 16 Aug 2011 02:39:47 +0200
Message-ID: <4E49BC53.8040604@googlemail.com>
Reply-To: hochglanz@googlemail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Since a long time I'm unhappy with the performance of my RAID-1 system.
Investigation with atop and iostat unveils that the disk utilization is
always on a certain level although nothing happens on the system. In the
case of reading or writing files the utilization boosts always to 100%
for a long time. Very ugly examples are "Firefox starting" or "zypper
updates".
That is snapshot of the output of iostat:


Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
avgrq-sz avgqu-sz   await  svctm  %util
sda               0,00     0,00    0,00    7,33     0,00    43,33    
5,91     0,33   43,18  33,32  24,43
sdb               0,00     0,00    0,00    7,33     0,00    43,33    
5,91     0,35   45,59  39,73  29,13
md0               0,00     0,00    0,00    0,67     0,00     5,33    
8,00     0,00    0,00   0,00   0,00
md1               0,00     0,00    0,00    0,33     0,00     5,33   
16,00     0,00    0,00   0,00   0,00
md2               0,00     0,00    0,00    0,33     0,00     1,00    
3,00     0,00    0,00   0,00   0,00
md3               0,00     0,00    0,00    0,00     0,00     0,00    
0,00     0,00    0,00   0,00   0,00
md4               0,00     0,00    0,00    0,00     0,00     0,00    
0,00     0,00    0,00   0,00   0,00
md5               0,00     0,00    0,00    0,33     0,00     0,67    
2,00     0,00    0,00   0,00   0,00

I checked with mdadm if a resync happens or so, but this is not the
case. The state says "active" on all RAID devices - btw. what is the
difference to "clean" ?

thanks for any hints,
  harald
