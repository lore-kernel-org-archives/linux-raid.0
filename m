From: Sebastian Kuzminsky <seb@highlab.com>
Subject: Re: Raid sync observations
Date: Tue, 20 Dec 2005 11:14:21 -0700
Message-ID: <E1Eom0D-0008NR-W7@highlab.com>
References: <E1Eol86-0008Ju-3J@highlab.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <E1Eol86-0008Ju-3J@highlab.com> 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sebastian Kuzminsky <seb@highlab.com> wrote:
> Question 1: Why didnt the raid sync I/O show up with vmstat?
> 
> Question 2: Why was it limited to 17 MB per second?  The maximum was
> left at the default, 200 MB/s.  The min was also at the default, 1 MB/s.
> I get 60 MB/s per disk with "hdparm -tT" (that's using one disk at a time,
> but still).  The checksumming code does > 3 GB/s.

Some more info...  vmstat doesnt see it, but "iostat -m" does:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    3.96    0.00    0.00   96.04
Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
hda               0.00         0.00         0.00          0          0
hde               0.00         0.00         0.00          0          0
hdg               0.00         0.00         0.00          0          0
hdi               0.00         0.00         0.00          0          0
hdk               0.00         0.00         0.00          0          0
sda             201.00        18.06         8.56         18          8
sdb             184.00        18.06         8.62         18          8
sdc             209.00        18.06         8.59         18          8
sdd             151.00        17.16         9.00         17          9
md0               0.00         0.00         0.00          0          0
md1               0.00         0.00         0.00          0          0


hda is the system disk, hd[egik] are PATA disks that make up md0, and
sd[abcd] are SATA disks that make up md1.  md0 is idle, md1 is syncing.

This all makes more sense now - it's only getting 18 MB/s because it's
spending all that time writing.

But wait, why is it only writing half as much as it reads?  This is a
4-disk RAID-6, as I understand it, it should read 2 strips and write 2
strips per stripe.


-- 
Sebastian Kuzminsky
