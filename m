From: Dominik Sennfelder <sennfelder@gmx.de>
Subject: Raid Failed What to to
Date: Fri, 21 May 2004 00:07:09 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40AD2C0D.10709@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

I have got a Raid 5 with 4 160 GB Disk,
On of the Disks Failed because. But I know its OK I had this for some times.
A Restart solved The Problem.
But now  Tried to raidhotremove the Drive and removed the wrong drive.
I just recongized the Problem after i raidhotadded itagain.
No the Raid tries to sync again.
Syslog gets flooded by the following

May 20 23:52:25 utgard kernel: md: syncing RAID array md0
May 20 23:52:25 utgard kernel: md: minimum _guaranteed_ reconstruction 
speed: 1000 KB/sec/disc.
May 20 23:52:25 utgard kernel: md: using maximum available idle IO 
bandwith (but not more than 200000 KB/sec) for reconstruction.
May 20 23:52:25 utgard kernel: md: using 128k window, over a total of 
156288256 blocks.
May 20 23:52:25 utgard kernel: md: md0: sync done.

a cat /proc/mdstat gibes me different output

utgard:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid5]
md1 : active raid1 hdd2[1] hdc2[0]
      79055744 blocks [2/2] [UU]
     
md0 : active raid5 hdk1[4] hdi1[3] hdg1[5](F) hde1[0]
      468864768 blocks level 5, 32k chunk, algorithm 2 [4/2] [U__U]
      [>....................]  recovery =  0.0% (128/156288256) 
finish=13024.0min speed=128K/sec
unused devices: <none>
utgard:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid5]
md1 : active raid1 hdd2[1] hdc2[0]
      79055744 blocks [2/2] [UU]
     
md0 : active raid5 hdk1[4] hdi1[3] hdg1[5](F) hde1[0]
      468864768 blocks level 5, 32k chunk, algorithm 2 [4/2] [U__U]
      [>....................]  recovery =  0.0% (128/156288256) 
finish=13024.0min speed=128K/sec
unused devices: <none>
utgard:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid5]
md1 : active raid1 hdd2[1] hdc2[0]
      79055744 blocks [2/2] [UU]
     
md0 : active raid5 hdk1[4] hdi1[3] hdg1[5](F) hde1[0]
      468864768 blocks level 5, 32k chunk, algorithm 2 [4/2] [U__U]
     
unused devices: <none>
utgard:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid5]
md1 : active raid1 hdd2[1] hdc2[0]
      79055744 blocks [2/2] [UU]
     
md0 : active raid5 hdk1[4] hdi1[3] hdg1[5](F) hde1[0]
      468864768 blocks level 5, 32k chunk, algorithm 2 [4/2] [U__U]
     
unused devices: <none>

I know that all 4 Dives should be ok, how can i recover the Raid without 
loosing data?
Does a restart help?

Thanks buliwyf








