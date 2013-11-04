From: Karsten Hohmeier <karsten.hohmeier@tu-ilmenau.de>
Subject: More distinct events for mdadm - check vs. error case
Date: Mon, 04 Nov 2013 11:10:48 +0100
Message-ID: <527772A8.4020602@tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everybody,

I have a design/usability question regarding the events generated for mdadm.
When my Debian box runs the monthly array checks every first Sunday of a
month, I can observe the following in my logs:

Nov  3 00:57:01 kvmbox kernel: [115379.938671] md: data-check of RAID
array md0
Nov  3 00:57:01 kvmbox kernel: [115379.938675] md: minimum _guaranteed_
 speed: 1000 KB/sec/disk.
Nov  3 00:57:01 kvmbox kernel: [115379.938677] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
data-check.
Nov  3 00:57:01 kvmbox kernel: [115379.938679] md: using 128k window,
over a total of 976759672k.
Nov  3 00:57:01 kvmbox mdadm[2628]: RebuildStarted event detected on md
device /dev/md/0
Nov  3 01:30:21 kvmbox mdadm[2628]: Rebuild20 event detected on md
device /dev/md/0
Nov  3 02:20:21 kvmbox mdadm[2628]: Rebuild48 event detected on md
device /dev/md/0
Nov  3 02:53:41 kvmbox mdadm[2628]: Rebuild65 event detected on md
device /dev/md/0
Nov  3 03:27:02 kvmbox mdadm[2628]: Rebuild80 event detected on md
device /dev/md/0
Nov  3 04:19:54 kvmbox kernel: [127553.046807] md: md0: data-check done.
Nov  3 04:19:54 kvmbox mdadm[2628]: RebuildFinished event detected on md
device /dev/md/0

I know this is harmless and that the operation would switch from 'check'
to 'repair' if anything were wrong on the discs. But from a user/system
administrator standpoint I would really appreciate it if there would be
CheckStarted and corresponding CheckXX progress events so that my
management scripts could distinguish the 'check' rebuild from a rebuild
that was caused by an error (and not trigger the acoustic alarm on my
server every 1st Sunday each month).

Or should I ignore all the rebuild events? Can I rely on other events
being passed to my scripts before a rebuild will happen in case of an
actual error? What is the best practice here?

Best wishes

Karsten Hohmeier
