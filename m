From: lilha@legend.com.cn
Subject: some question in SoftRaid
Date: Thu, 23 May 2002 17:08:22 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <OF3F6026D2.567B40AF-ON48256BC2.00308831@legend.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hello,everyone.i am a freshman in linux raid.

i want to know some limits about raid,i try to find it in Raid-Howto and
Raid-FAQ,etc..
but i cann't find it.

Follow is my question:

1.Raid 0,1,5 must install in differ disk?right?
RAID-0 and RAID-1 need at lest 2 disk
RAID-5 need at lest 3 disk,is it right?
then is there any requrement about the partition Type(such as
primary,logical or extend partition )?

2.can i setup raid0,1,5 in the partition which has different size?
such as:
/dev/hda1 500M
/dev/hdc1 600M
can i setup raid-0 or raid-1?i try it,but failed.

3.how can I remove raid from disk?
such as,i have md0(RAID 0),it use /dev/hda2 and /dev/hdc2
now i want to these partitions don't use raid,i want to release these
partition
then how can I do?


thanks a lot.

Regards, echo

