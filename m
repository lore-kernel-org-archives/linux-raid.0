From: Simon Kirby <sim@hostway.ca>
Subject: MD request counter broken on 4.0-rc5 RAID1
Date: Tue, 24 Mar 2015 17:04:03 -0700
Message-ID: <20150325000403.GA27368@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello :)

I'm seeing "iostat -x -k 1" print this after a RAID1 rebuild on 4.0-rc5.
It's not abnormal other than it's 3-disk, with one being SSD (sdc) and
the other two being write-mostly:

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdc               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
md0               0.00     0.00    0.00    0.00     0.00     0.00     0.00   345.00    0.00    0.00    0.00   0.00 100.00
md2               0.00     0.00    0.00    0.00     0.00     0.00     0.00 58779.00    0.00    0.00    0.00   0.00 100.00
md1               0.00     0.00    0.00    0.00     0.00     0.00     0.00    12.00    0.00    0.00    0.00   0.00 100.00

This was working on 3.18. Shall I bisect, or is it obvious?

It seems to just be leaking as the counters were going up gradually while
it was rebuilding.

Personalities : [linear] [raid0] [raid1] [raid10]
md1 : active raid1 sdb2[1](W) sda2[0](W) sdc2[2]
      530048 blocks [3/3] [UUU]

md2 : active raid1 sdb3[0](W) sdc3[2] sda3[1](W)
      153613440 blocks [3/3] [UUU]

md0 : active raid1 sdb1[0](W) sdc1[2] sda1[1](W)
      2104384 blocks [3/3] [UUU]

unused devices: <none>

Simo-
