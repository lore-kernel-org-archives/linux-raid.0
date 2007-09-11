From: "Jeffrey W. Baker" <jwbaker@acm.org>
Subject: unreasonable latentcies under heavy write load
Date: Mon, 10 Sep 2007 20:38:23 -0700
Message-ID: <1189481903.16669.13.camel@hannibal>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm having some troubles with the system below:

Linux inhale 2.6.18-4-amd64 #1 SMP Thu May 10 01:01:58 UTC 2007 x86_64 GNU/Linux

md2 is a 

md2 : active raid1 sda3[0] sdb3[1]
      484359680 blocks [2/2] [UU]

sda and sdb are both

  Vendor: ATA       Model: ST3500630AS       Rev: 3.AA
  Type:   Direct-Access                      ANSI SCSI revision: 05

The problem is _extreme_ latencies under a write load, and also weird
accounting as seen in iostat.  I know I've complained about this over on
linux-mm, but with the raid1 it seems even worse than usual.  Nothing
happens on the system for literally minutes at a stretch.  It takes half
an hour to unpack a 1GB .zip archive (into a 7.4GB directory).  During
the lengthy pauses, md2_raid1 is the only process that gets any time
(normally < 1% CPU).  iostat reads weirdly (iostat -kx 10):

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.05    0.00    3.55   51.07    0.00   43.33

Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda              12.30  3495.00  5.80 89.80   916.80 14119.20   314.56   143.68 1522.19  10.46 100.04
sdb               0.00  3494.20  0.10 87.50     0.40 13920.40   317.83    25.08  274.39  10.89  95.44
md0               0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
md1               0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
md2               0.00     0.00 18.10 2425.10   904.40  9700.40     8.68     0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    5.10   49.38    0.00   45.53

Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00  2954.60  0.20 99.10     0.80 12481.20   251.40   143.49 1449.52  10.07 100.04
sdb               0.00  2954.60  0.10 99.00     0.40 12240.40   247.04    39.32  398.24  10.09 100.04
md0               0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
md1               0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
md2               0.00     0.00  0.30 16917.30     1.20 67669.20     8.00     0.00    0.00   0.00   0.00

That seems a little weird to me.  Why is sda + sdb != md2?  Is md2
really issuing 17000 writes per second over a period of ten seconds?  If
so, why?  Also:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    1.25   48.75    0.00   50.00

Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00  2805.69  0.00 104.69     0.00 11638.72   222.35    87.11  848.35   9.54  99.84
sdb               0.00  2806.29  0.00 102.50     0.00 11471.06   223.84   143.09 1400.85   9.74  99.84
md0               0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
md1               0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
md2               0.00     0.00  0.00  0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00

Is that normal?

-jwb

