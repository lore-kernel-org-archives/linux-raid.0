From: Ming Zhang <mingz@ele.uri.edu>
Subject: unbalance?
Date: Sat, 08 Oct 2005 12:25:59 -0400
Message-ID: <1128788759.5431.20.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi folks

I met a strange scenario here. i have a 4 sata disk raid0. i ran dd
write with 512K request size and got this.

it looks like 1 disk has particular low utilization compared with
others.

any idea? thanks!

ming

-----------------------------------------
avg-cpu:  %user   %nice    %sys %iowait   %idle
           0.00    0.00   15.84    6.44   77.72

Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await  svctm  %util
hda          0.00   0.00  0.00  0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00
sda        4648.51   0.00 309.90  0.00 39667.33    0.00 19833.66
0.00   128.00     0.91    2.95   2.95  91.49
sdb        4648.51   0.00 309.90  0.00 39667.33    0.00 19833.66
0.00   128.00     0.90    2.90   2.90  89.90
sdc        4648.51   0.00 309.90  0.00 39667.33    0.00 19833.66
0.00   128.00     0.25    0.79   0.79  24.55
                ~~~~~~~~

sdd        4646.53   0.00 311.88  0.00 39667.33    0.00 19833.66
0.00   127.19     0.95    3.03   3.03  94.65
md0          0.00   0.00 19833.66  0.00 158669.31    0.00 79334.65
0.00     8.00     0.00    0.00   0.00   0.00


