From: Francis Moreau <francis.moro@gmail.com>
Subject: MD array keeps resyncing after rebooting
Date: Tue, 23 Jul 2013 11:46:16 +0200
Message-ID: <CAC9WiBjm5-RJ=CfpXMG7CCBp7StzWDuhp5XyFs4hAW3sxX7Gfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Martin Wilck <mwilck@arcor.de>
List-Id: linux-raid.ids

Hello,

I'm using a RAID1 with DDF metadata format. The array has been
initialized by the bios and contains my root partition.

After booting I waited for the RAID1 array to finish syncing then rebooting.

Then I rebooted but the sync restarts again:

# cat /proc/mdstat
Personalities : [raid1]
md126 : active raid1 sdb[1] sda[0]
      975585280 blocks super external:/md127/0 [2/2] [UU]
      [=>...................]  resync =  7.3% (71783424/975585280)
finish=112.1min speed=134299K/sec

md127 : inactive sdb[1](S) sda[0](S)
      2354608 blocks super external:ddf

unused devices: <none>

Could anybody tell me what's happening ?

Thanks
--
Francis
