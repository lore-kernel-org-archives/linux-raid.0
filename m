From: Lasse Jensen <fafler@gmail.com>
Subject: RAID 5 with bad blocks
Date: Fri, 17 Sep 2010 12:52:26 +0200
Message-ID: <AANLkTi=iwMUvYyHOde63FbzfWtHVH1w7X8kBhJBhcXF3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a software RAID 5 array consisting of 3 1.5 tb drives. A couple
of days ago the array went offline. I turned the server off to
investigate and noticed one of the SATA power connectors had fallen
out of the drive. I rebooted and tried to bring the array back up with

mdadm -Af -vv /dev/md0 /dev/sdb /dev/sdc /dev/sdd

It brought the array back with sdc and sdd, sdb being the one where
the connector fell out. I used

mdadm -a /dev/md0 /dev/sdb

to re-add sdb to the array and it started rebuilding. But sdc have bad
blocks and both sdb and sdc get offlined at some point in (atleast 35%
into) the process. mdadm --examine /dev/sdb told me the drive had been
offlined for 5 days and i think the reason the array crashed was due
to the bad blocks on sdc, not sdb loosing power. How do i proceed from
here? On which device should i run badblocks? The raw device or the
array? I have a encrypted LVM container and a ext4 filesystem on top
of the array.


--
Lasse Jensen (fafler at gmail dot com)
