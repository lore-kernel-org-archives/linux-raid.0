From: Danilo Godec <danilo.godec@agenda.si>
Subject: Starting a RADI1 array after the filesystem has being used through
 LVM?
Date: Mon, 20 Feb 2012 16:22:51 +0100
Message-ID: <4F42654B.8050407@agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

one of my servers uses two iSCSI volumes in a RAID1 array with LVM on 
top. Apparently the RADI1 array wasn't properly started on the last 
reboot, but LVM still detected both partitions on physical disks as PV's 
and simply used one of them (seen as /dev/sdb1).

Unfortunately, this gone by unnoticed and has been runnig like that for 
some time.

The size of the volume is 7TB (with 5TB used), so I'd like to do with as 
little downtime as possible.

The question is - is it safe to simply stop LVM, start the array in 
degraded mode with the 'current' disk (/dev/sdb1), start LVM and then 
re-add the 'non-current' one (/dev/sda1)?

Also - how can I prevent LVM from using these two partitions directly? 
I'd rather see the server startup fail then silently do wrong...  I 
already have the 'md_component_detection = 1' option in my 'lvm.conf'.



    Thanks, Danilo

