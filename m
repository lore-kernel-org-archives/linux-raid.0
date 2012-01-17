From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: RAID6, failed device, unresponsive system?
Date: Tue, 17 Jan 2012 11:25:07 +0000
Message-ID: <CADNH=7FyxQ=C=gdirjpTsc5q0tJ2=SSXtryRM36icTH=ncC_0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi list,

This is the setup:

8x 2TB HDDs partitioned 2048 sectors in, then almost filled (left 2GB
or so at the end), so md0 consists of /dev/s[b-h]1 , 64KB chunk size.
I got an email from mdadm saying that sdb1 has failed, so I SSH in.
The array is in "checking" state (guessing it's my weekly cron job
that kicked in), but it's at 38KB/s so I attempt to "echo idle >
md0/sync_action", but that hangs. I decide to check the SMART details
of sdb, and it is indeed very broken, RMA is now in progress. So this
is where I'm at. I've stopped all services relating to the mount point
of md0, and trying to unmount but it doesn't work, it just sits there.
I can't even cat /proc/mdstat , that hangs as well. I'll leave this
for a few hours before I get home. If it's not responsive by the time
I get home (cat /proc/mdstat for example) then I'll just disconnect
the bad HDD and boot to single user mode to check the array status.

Why is the system unresponsive, shouldn't it still be OK after a drive failure?


Best regards,
Mathias
