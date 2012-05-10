From: Daniel Pocock <daniel@pocock.com.au>
Subject: thanks md raid
Date: Thu, 10 May 2012 18:54:10 +0000
Message-ID: <4FAC0ED2.2000201@pocock.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I'm glad my RAID1 worked as expected... just hoping I don't encounter
any read timeouts on the non-TLER drive before my rebuild finishes:


# mdadm --manage --add -v /dev/md2 /dev/sdb2
mdadm: added /dev/sdb2

# cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 sdb2[3] sda2[2]
      976510840 blocks super 1.2 [2/1] [_U]
      [>....................]  recovery =  1.9% (19032256/976510840)
finish=350.1min speed=45575K/sec

unused devices: <none>




# iostat -k 1 -x /dev/sd[ab]

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           1.63    0.00   20.65    0.00    0.00   77.72

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00 1584.00    0.00 101376.00     0.00
128.00     2.84    1.80   0.39  61.60
sdb               0.00     3.00    0.00 1584.00     0.00 101568.00
128.24    27.72   17.70   0.63  99.60
