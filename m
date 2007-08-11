From: Michal Soltys <nozo@ziu.info>
Subject: mdadm (on partitionable arrays) and partition uevents
Date: Sat, 11 Aug 2007 14:05:39 +0200
Message-ID: <46BDA613.1020604@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

During doing some tests, I've found a slight delay of partition related 
uevents, when raid devices are assembled/stopped.

For example - consider md/d0 with 1 partition created. The array is unassembled.

1) mdadm -A /dev/md/d0

will generate "change" even properly for md/d0, but "add' uevent for its 
partition, will be delayed until some next mdadm operation or some partition 
related operation - fdisk, etc.

2) mdadm -S /dev/md/d0

Analogously, "remove" for partitions will be run on some later mdadm 
command, or even unsuccessful attempt to fdisk that array.

To not cause any potential conflicts, mdadm.conf had symlinks=no, and mdadm 
was used only with directory based names, whereas udev had no custom rules 
regarding any md devices (so only standard /dev/md_d[0-9]* and /dev/md[0-9]* 
were created).

Tested under udev 114, mdadm 2.6.2 on two different systems (one arch 64bit, 
the other 32bit).

I'm not actually sure if it's even a bug in the first place, or if it has 
anything to do with mdadm, but reporting it nonetheless.
