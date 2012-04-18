From: "George Spelvin" <linux@horizon.com>
Subject: RAID6 syncing at 24 MB/s?
Date: 18 Apr 2012 00:35:40 -0400
Message-ID: <20120418043540.19923.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux@horizon.com
List-Id: linux-raid.ids

I'm putting together a 7x2TB RAID6 for a home media server, and after
encountering a fun kernel bug building the array (old kernel, a new one
fixed it), I fot things working, but now notice that each disk is syncing
at 23.8 MB/s.  hdparm -t reports they can do well over 100 MB/s each,
and the processor, while only an i3, is spending about 20% of one core
in the raid6 task.

Basicall, it was created with:
mdadm -C -l 6 -n 7 -c 128 -b internal /dev/md0 /dev/sd[b-h]
(The kernel bug was in 2.6.35, and was triggered by forgetting the
"/dev/md0"; one of the RAID ioctls it tries confused up the /dev/sd
driver quite thoroughly)

It's an Intel chipset motherboard with a jmicros 2xSATA+PATA chip,
and one port on a SiI3132 plug-in card.  And mostly cheap Caviar green
EARS drives (yes, I know about the lack of TLER).  Note that I didn't
partition the drives, so there's no risk of a 4K-unaligned partition.

A friend with his own Linux media server said he saw the exact same speed
building his RAID6 array.

The speed_limit_max is set to the default, the system is idle, and the
resultant md drive is not mounted.

Is there a web page somewhere with speed tuning suggestions?


Thank you!
