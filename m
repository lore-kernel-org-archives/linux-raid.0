From: Redwood Hyd <redwoodhyd@gmail.com>
Subject: raid5 + dm-crypt WRITE perf., higher rrqm/s - kernel 3.10.16
Date: Tue, 17 Dec 2013 12:50:36 +0530
Message-ID: <CADOhdu=rxGCWv7CCigR-dLJYeU0uPdh4Vuan0TOAT9OED=247g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,
I am trying to match the WRITE throughput for  512K chunk size to
WRITE throughput I am getting with 32K chunk size.

My setup is :  iozone (4k rec) -> ext4 -> dm-crypt dev mapper + raid5 (4 disks).

In my past experience 512K  chunk size was not very off from 32K chunk
size on kernel 2.6.32 for above situation.

From iostats it seems  that 512K  is slow because of  higher rrqm/s on
the physical disks behind raid5 device (last 4 columns are from iostat
-x on physical disks behind raid5)

Chunk-size  iozon MB/s  Avgrq-sz   r/s    rMB/s    rrqm/s
512K     25 MBps     976       ~60  ~7.00   ~1800
32K     39 MBps      63   ~20  ~0.55   ~100

Question: Is it that partial stripe  happening and causing more reads here ?
Question:  Can someone suggest some code hacks or config changes such
that even with 512K iozone writes to ext4/dm-crypt/raid5 device is
close to 39 MBps?
Or otherwise more pointers into code to understand and conclude will be helpful
Question: Are the changes in dm-crypt or block layer (since 2.6.32)
causing  higher  r/s rMB/s rrqm/s etc. ?  How to tune it now?

To compare here are same numbers (lower rrqm/s) if I remove dm-crypt :

Chunk-size  iozon MB/s  Avgrq-sz      r/s    rMB/s      rrqm/s
512K        81 MBps          976      ~12     ~0.41     ~100
32K         89 MBps          63      ~01     ~0.04     ~4

Quesiton: Why  dm-crypt causing higher r/s rMB/s rrqm/s ( higher these
lower write MB/s) ?


regards
--rh
