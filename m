From: Paul Waldo <pwaldo@waldoware.com>
Subject: Strange IO stats on RAID1?
Date: Wed, 30 Aug 2006 08:09:19 -0400
Message-ID: <44F57FEF.7000400@waldoware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I have an IMAP mail server where mail messages are stored on a RAID1 array.  
The access on that array (/dev/md3) has seemed slow, so I did some investigating.  
"iostat -x /dev/hd[bd] /dev/md3" shows this:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          14.34   47.03   13.99   19.64    0.00    5.00

Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
hdb          1.05  34.88 35.48  2.60 1531.23  299.85   765.62   149.93    48.08     0.20    5.38   3.07  11.69
hdd          0.70  34.83 41.08  2.65  963.12  299.85   481.56   149.93    28.88     0.15    3.49   1.65   7.24
md3          0.00   0.00 78.31 36.98 2494.35  295.85  1247.18   147.93    24.20     0.00    0.00   0.00   0.00




Here  is my /proc/mdstat for md3:

md3 : active raid1 hdb1[0] hdd1[1]
      12699264 blocks [2/2] [UU]


Observations:
- Stats for raw disks writes are similar
- Stats for reads on hdd are about half that of hdd

I may be (or probably am) way off base on this, but I would think that 
read requests to each disk would be balanced, providing roughly the same 
level of read activity on each disk.  Is that correct?  
Are there any tuning suggestions for increasing performance?

Thanks in advance!

Paul

