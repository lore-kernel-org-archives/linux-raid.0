From: Phil Susi <psusi@ubuntu.com>
Subject: Zombie dm device?
Date: Mon, 17 Apr 2017 15:50:45 -0400
Message-ID: <3cf28b7e-9716-3595-018a-fecb32b61751@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After running the parted test suite I seem to have a zombie md device:

root@devserv:~# mdadm -D /dev/md99
/dev/md99:
        Version :
     Raid Level : raid0
  Total Devices : 0

          State : inactive

    Number   Major   Minor   RaidDevice


Why is this thing still hanging around, and how do you get rid of it?  I
tried mdadm --stop /dev/md99 but it didn't get rid of it.  I also can't
find any mdadm switch or a delete file or similar in the sysfs node.

root@devserv:~# uname -a
Linux devserv 4.4.0-72-generic #93-Ubuntu SMP Fri Mar 31 14:07:41 UTC
2017 x86_64 x86_64 x86_64 GNU/Linux
