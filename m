From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: stuck tasks
Date: Mon, 12 Apr 2010 11:40:59 +0100
Message-ID: <hputbs$qq2$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi - I'm not getting any joy with Fedora's bugzilla. Has anyone seen 
problems like this with Fedora 12? Our systems have recently been getting 
stuck while rsyncing data onto an MD device:

https://bugzilla.redhat.com/show_bug.cgi?id=578549

INFO: task kthreadd:2 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kthreadd      D 0000000000000002     0     2      0 0x00000000
 ffff88007dbfd4c0 0000000000000046 0000000000000000 0000000a00000000
 ffff880000000001 ffff880079f9b800 ffff88007dbfdfd8 ffff88007dbfdfd8
 ffff88007dbf1b38 000000000000f980 0000000000015740 ffff88007dbf1b38
Call Trace:
 [<ffffffff8107c30d>] ? ktime_get_ts+0x85/0x8e
 [<ffffffff810d604d>] ? sync_page+0x0/0x4a
 [<ffffffff810d604d>] ? sync_page+0x0/0x4a
 [<ffffffff814546f5>] io_schedule+0x43/0x5d
 [<ffffffff810d6093>] sync_page+0x46/0x4a
 [<ffffffff81454c48>] __wait_on_bit+0x48/0x7b
 ...

Several processes end up stuck in a D state:
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         2  0.0  0.0      0     0 ?        D    Mar31   0:07 [kthreadd]
root        14  0.0  0.0      0     0 ?        D    Mar31   9:38 [async/mgr]
root        17  0.0  0.0      0     0 ?        D    Mar31   0:00 [bdi-
default]
root        34  0.0  0.0      0     0 ?        D    Mar31  10:06 [kswapd0]
root      5509  0.0  0.3  50732  7900 ?        D    Apr09   0:03 rsync -
raHSx --stats --whole-file --numeric-ids --link-
dest=/xback2_back1/YY/20100407-000501 --exclude=/lost+found --
exclude=.mozilla/*/*/Cache/* XX:/XX_data1/data/YY/ 
/xback2_back1/YY/20100409-000502/
root     17457  0.0  0.2  61920  5756 ?        D    Apr11   0:00 python 
/data/soft3/backup/diskbackup/diskbackup.py 
/data/soft3/backup/diskbackup/main.cfg
root     18402  0.0  0.0      0     0 ?        D    Apr09   0:11 [flush-9:0]
root     20259  0.0  0.1   4284  3424 ?        DN   Apr11   0:00 
/usr/sbin/prelink -av -mR -q

It only seems to affect our MD systems. The kernel is 
2.6.32.10-90.fc12.x86_64. The systems have 3ware 96xx controllers. This 
kernel does have the issue when there are lots of aio processes.

The two affected systems have different file systems: xfs and ext3.

Jeremy


