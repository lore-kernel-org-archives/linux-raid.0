From: Roland 'ValiDOM' Jungnickel <vali2013@validom.de>
Subject: [Question] Fail event during reshape raid5 -> raid6
Date: Tue, 03 Sep 2013 09:20:00 +0200
Message-ID: <52258DA0.4040704@validom.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi!

I started reshaping a 3-device raid5 to a 4-device raid6. After some 
hours, I got a fail event on a harddrive which was already used in the 
raid5.

There are two different raid-groups on these harddrives, a reshape of 
the second one has not yet started.

What would you suggest?
* stop the reshape, go back to raid5 and start rebuild to the new disk 
(how?)
* just wait, hope and pray... ( there is no backup, I do not have 
harddrives to backup to as this is just to much...)

md0 : active raid6 sdc2[0] sde2[4](F) sdb2[3] sdd2[1]
       2858420224 blocks super 0.91 level 6, 64k chunk, algorithm 18 
[4/2] [UU__]
       [=>...................]  reshape =  7.8% (112662528/1429210112) 
finish=4938.2min speed=4442K/sec

md1 : active raid5 sdc1[0] sde1[2] sdb1[3](S) sdd1[1]
       1048575744 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

(md1 not mounted, sde1 will fail once used/checked and the raid5 will 
automatically start rebuild on sdb1)

Thanks!
Vali

