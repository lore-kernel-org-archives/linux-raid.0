From: Jim Schatzman <james.schatzman@futurelabusa.com>
Subject: Re: Why won't mdadm start several RAIDs that appear to be
  fine? (more info)
Date: Thu, 30 Dec 2010 16:32:29 -0700
Message-ID: <20101230233318.49098E30991@mail.futurelabusa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

My /etc/mdadm.conf file contains

DEVICE partitions
AUTO -1.x
ARRAY /dev/md0 metadata=0.90 spares=1 UUID=6c5f2fe8:b54cb47f:132783e8:19cdff95
ARRAY /dev/md3 metadata=1.2 name=l1.fu-lab.com:3 UUID=038e1a1d:f04cc12e:7ca649d2:15ef9dff
ARRAY /dev/md2 metadata=1.2 name=l1.fu-lab.com:2 UUID=ce4b65d9:fd8d13a8:696ebf42:6b353d25
ARRAY /dev/md1 metadata=1.2 name=l1.fu-lab.com:1 UUID=308f78bb:7e0a2a39:2b4effe3:91d69223

The above 4 RAIDs assembled correctly. The remaining 5, which my cron script attempted to assemble, did not.

My current process has worked fine many times in the past. Just didn't work this time.

I am wondering if, perhaps, two of the drives were a bit slow in coming up and mdadm didn't find them when I rebooted. Fine, but why is it now unable to find the other two partitions? Running "mdadm -A" (as detailed in the previous posting) makes no difference. Rebooting multiple times since the problem first occured has made no difference. All 4 partitions have the right UUID and they are all marked as "clean".  If my theory is correct, mdadm must have stashed some other status information somewhere that doesn't show with "mdadm -E". Why and how (and how can I fix it)?

I don't get it.

Any help would be appreciated.

Jim

