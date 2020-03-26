From: Alexander Shenkin <al@shenkin.org>
Subject: Raid-6 won't boot
Date: Thu, 26 Mar 2020 17:07:54 +0000
Message-ID: <7ce3a1b9-7b24-4666-860a-4c4b9325f671@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I have an older (14.04) Ubuntu system with / mounted on a raid6
(/dev/md2) and /boot on a raid1 (/dev/md0).  I recently added my 7th
disk, and everything seemed to be going well.  I added the partition to
/dev/md0 and it resynced fine.  I added the partition to /dev/md2, and
everything seemed fine there as well.  Then, while it was resyncing
/dev/md2, the transfer speed got very slower, and started going slower. 
7kb/sec... 4kb/sec... 1kb/sec... and then eventually the system just
stopped responding.  Now, on power up, i just get a cursor on the screen.

I surely need to boot with a rescue disk of some sort, but from there,
I'm not sure exactly when I should do.  Any suggestions are very welcome!

Thanks,

Allie
