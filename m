From: pdi <pdi@otenet.gr>
Subject: constant array_state active after specific jobs
Date: Thu, 23 Mar 2017 10:46:43 +0200
Message-ID: <20170323104643.6cca7986@hal9.pdi.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Greetings all,

The problem in a nutshell is that an array is clean after boot, until
some specific jobs switch it to active where it remains until reboot.

A similar problem was discussed, and solved, in 
https://www.spinics.net/lists/raid/msg46450.html. However, AFAICT,
it is not the same issue.

I would be grateful for any insights as to why this happens and/or how
to prevent it.

The relevant info follows, please let me know if anything further might
help.

Many thanks in advance.

- uname -a
  Linux hostname 4.4.38 #1 SMP Sun Dec 11 16:03:41 CST 2016 x86_64
  Intel(R) Core(TM)2 Duo CPU E8400 @ 3.00GHz GenuineIntel GNU/Linux
- mdadm -V
  mdadm - v3.3.4 - 3rd August 2015
- Desktop drives without sct/erc,
  with timeout mismatch correction as per
  https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
- /dev/md9 is a raid10 array, 4 devices, far=2,
  with various dirs used as samba and nfs shares
- The array is in *constant* array_state active
- mdadm -D /dev/md9 | grep 'State :'
  State : active
- cat /sys/block/md9/md/array_state
  active
- watch -d 'grep md9 /proc/diskstats'
  remain unchanged
- uptime
  load average: 0.00, 0.00, 0.00
- cat /sys/block/md9/md/safe_mode_delay
  0.201
- echo 0.1 > /sys/block/md9/md/safe_mode_delay
  array_state remains active
- echo clean > /sys/block/md9/md/array_state
  echo: write error: Device or resource busy
- reboot (with or without prior check)
  array_state clean
- After reboot, array remains clean until some specific
  jobs put it in constant active state. Such jobs so far
  identified:
  - echo check > /sys/block/md9/md/sync_action
  - run an rsnapshot job
  - start a qemu/kvm vm
- Other jobs, like text/doc editing, multimedia playback,
  etc retain array_state clean


