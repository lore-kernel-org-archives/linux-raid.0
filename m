From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Raid 5 to 6 reshape q
Date: Sat, 2 Jan 2010 00:52:13 -0800 (PST)
Message-ID: <625563.35920.qm@web51308.mail.re2.yahoo.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys, thanks for your help getting me going with this over the last week. I kicked it off last night and all is well.

The only Q i have is it seems to be abit slow? When i kicked it off it insisted that i give a backup file --backup-file that i set to /root/backupfile and now the reshape seems to be constantly accessing my md3 as well as the md4 (the one that is being reshaped) i have set the min and max that is used when i am rebuilding the array/testing

cat /sys/block/md4/md/sync_speed_min
200000 (local)
cat /sys/block/md4/md/sync_speed_max
7168000 (local)

but still the speed is abit slow?

md4 : active raid6 sdg1[4] sdf1[0] sde1[1] sdd1[2] sdc1[5] sdb1[3] sda1[6]
      2441919680 blocks super 0.91 level 6, 64k chunk, algorithm 18 [7/6] [UUUUUU_]
      [===>.................]  reshape = 17.9% (87600896/488383936) finish=2881.3min speed=2317K/sec

vg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.03    0.00   13.42   41.82    0.00   44.73

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
hda              31.65         0.00        11.50          0        689
hdc              31.67         0.00        11.51          0        690
sda              77.35         0.00         2.33          0        139
sdb              80.05         4.59         2.33        275        139
sdc              82.28         4.59         2.33        275        139
sdd             135.65         4.59         2.33        275        139
sde              81.72         4.59         2.33        275        139
sdf              83.80         4.59         2.33        275        139
sdg              78.52         4.59         2.33        275        139
md3            2904.82         0.00        11.35          0        680
md4               0.00         0.00         0.00          0          0

As you can see lots of write access to md3 and low level read/write to the constituent drives of md4 

Does this seem ok? or is it slow (like i suspect!) 

-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its own.'

***********
Please note, I am phasing out jd_hardcastle AT yahoo.com and replacing it with jon AT eHardcastle.com
***********

-----------------------


      
