From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Another report of a raid6 array being maintaind by _raid5 in ps .
Date: Wed, 21 Mar 2007 21:41:29 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0703212139010.2224@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Neil ,  Someone else reported this before .  But I'd thought it 
was under a older kernel than 2.6.21-rc4 .  Hth ,  JimL

root      2936  0.0  0.0   2948  1760 tts/0    Ss   04:30   0:00 -bash
root      2965  0.3  0.0      0     0 ?        S<   04:34   0:00 [md3_raid5]
root      2977  0.0  0.0   2380   912 tts/0    R+   04:38   0:00 ps -auxww

root@(none):~# uname -a
Linux (none) 2.6.21-rc4 #2 SMP Thu Mar 22 04:19:35 UTC 2007 i686 pentium4 i386 GNU/Linux

root@(none):~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] [multipath]
md3 : active raid6 sdc1[0] sdh1[5] sdg1[4] sdf1[3] sde1[2] sdd1[1]
       573905664 blocks super 1.2 level 6, 64k chunk, algorithm 2 [6/6] [UUUUUU]
       bitmap: 0/137 pages [0KB], 512KB chunk

-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
