From: =?ISO-8859-1?Q?Ask_Bj=F8rn_Hansen?= <ask@develooper.com>
Subject: raid10 messed up filesystem, lvm lv ok
Date: Sat, 19 Jan 2008 03:44:52 -0800
Message-ID: <CA0AD0CD-9AB2-4468-BE7E-807650317101@develooper.com>
Mime-Version: 1.0 (Apple Message framework v915)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everyone,

I mentioned[1] my trouble with the multipath detection code on the  
Fedora rescue mode messing up my raid yesterday.

My raid6 partitions recovered fine, but the raid10 device (/ 
sd[abc...k]5) somehow got messed up.

When I assemble the drive it says all 9 drives and 2 spares are ok/ 
clean and the event counter is the same for each drive.  The volume  
group on the device is detected/started ok - but maybe that's just  
from the /etc/lvm/backup file?

However, fsck.ext3 (with or without specifying the alternate  
superblock) can't see the file systems in the logical volumes.

I suspect that maybe the layout of the md device got messed up?  How  
can I find out if that's the case?  Would it be possible to recover  
from (assuming all the data still is on some of the disks).

Secondary question: I'm doing a "dd if=/dev/sdX5 bs=256k > /backup/ 
sdX5" for each disk -- is there a way to run mdadm on the copies and  
experiment on those?    (It took ~forever to copy a terabyte of the  
raw partitions).

Any help is greatly appreciated.

As a sidenote: I guess I learned my lesson about having an odd number  
of drives in a raid10 too (if I understand it correctly then it  
roughly doubles the chance that a secondary problem ruins the day).


  - ask

[1] http://marc.info/?l=linux-raid&m=120065542429935&w=2

-- 
http://develooper.com/ - http://askask.com/


