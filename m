From: Andy Arvai <arvai@scripps.edu>
Subject: mkraid problem with 2+TB devices
Date: Tue, 14 Sep 2004 23:33:50 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200409150633.XAA16537@astra.scripps.edu>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


There's a problem with mkraid creating a raid device where the
individual devices are each over 2TB:

  [root@rad7 3dm2]# mkraid --really-force /dev/md0
  DESTROYING the contents of /dev/md0 in 5 seconds, Ctrl-C if unsure!
  handling MD device /dev/md0
  analyzing super-block
  couldn't get device size for /dev/sdb -- File too large
  mkraid: aborted.
  (In addition to the above messages, see the syslog and /proc/mdstat as well
   for potential clues.)

The kernel (2.6.8-1) is able to read the device, although with a warning:

  Aug 26 16:38:59 localhost kernel: sdb : very big device. try to use READ CAPACITY(16).
  Aug 26 16:38:59 localhost kernel: SCSI device sdb: 4687368192 512-byte hdwr sectors (2399933 MB)
 
I assume mkraid needs to do something like use READ CAPACITY(16).
There's a similar problem with mdadm and I've discussed this with Neil
Brown who plans to fix it. I don't know if mkraid is being actively
maintained, but if someone does come up with a patch soon, then
I would be willing to try it.

Andy
