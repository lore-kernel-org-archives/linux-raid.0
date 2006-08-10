From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: way too high reconstruction speed - bug?
Date: Thu, 10 Aug 2006 11:48:25 +0200
Message-ID: <44DB00E9.8020000@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I noticed that I have a wrong reconstruction speed when looking at 
/proc/mdstat:

# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10]
md11 : active raid10 sda2[0] sdd2[3] sdc2[2] sdb2[1]
       779264640 blocks super 1.0 64K chunks 2 near-copies [4/4] [UUUU]
       [===>.................]  resync = 16.4% (127955392/779264640) 
finish=4.1min speed=2588238K/sec


2588238K/sec is about 100 more to what I used to see before.


Should I start to worry?

I'm using kernel 2.6.16.27 on ARM CPU.

[42949428.580000] md: bind<sdb2>
[42949428.580000] md: bind<sdc2>
[42949428.590000] md: bind<sdd2>
[42949428.590000] md: bind<sda2>
[42949428.590000] md: md11: raid array is not clean -- starting 
background reconstruction
[42949428.620000] raid10: raid set md11 active with 4 out of 4 devices
[42949428.630000] md: syncing RAID array md11
[42949428.630000] md: minimum _guaranteed_ reconstruction speed: 1000 
KB/sec/disc.
[42949428.640000] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for reconstruction.
[42949428.650000] md: using 128k window, over a total of 779264640 blocks.
[42949428.650000] md: resuming recovery of md11 from checkpoint.



-- 
Tomasz Chmielewski
http://wpkg.org
