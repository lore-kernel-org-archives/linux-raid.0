From: merlin hughes <merlin@merlin.org>
Subject: RAID 5 / kernel 2.5.47 performance
Date: Sat, 16 Nov 2002 19:46:19 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021117004619.1C00686719@primary.mx.nitric.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

With the recent md updates, I can now boot 2.5.47 with linux
RAID 5 devices - thanks for the good work. However, (synthetic)
performance has dropped considerably; I was wondering if this
is expected:

2xAthlon 2000 MP, 5xSCSI RAID 5

2.4.19 (non-smp)
  block output: 57MBs-1, 80% CPU
  block input: 92MBs-1, 89%CPU

2.4.19 (smp)
  block output: 65MBs-1, 92% CPU
  block input: 77MBs-1, 90% CPU

2.5.47 (smp)
  block output: 49MBs-1, 99% CPU
  block input: 58MBs-1, 99% CPU

The change from non-smp to smp makes sense (I think);
SMP locking hurts read(), but the extra CPU power helps
write() parity computation.

However, 2.5.47 pushes up CPU usage somewhat, and drops
performance substantially.. To see if this was fs-related
I tried I/O on the raw md device; however again I saw a
drop from 83MBs-1 (2.4.19 smp) to 67MBs-1 (2.5.47 smp).

I also tried a 2-drive RAID 1 configuration and performance
"improves" from 40MBs-1 (2.4.19 smp) to 41MBs-1 (2.5.47 smp)
however that's probably within the margin of error. This
suggests (to me) that the problem is localized to RAID 5.

Finally, I tried doing a kernel compile and, while I can't
read the figures I wrote down, performance was worse.

merlin
