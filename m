From: Jim Schatzman <james.schatzman@futurelabusa.com>
Subject: Why does MD overwrite the superblock upon temporary disconnect?
Date: Mon, 20 Sep 2010 20:49:48 -0600
Message-ID: <20100921025058.79B24E3096C@mail.futurelabusa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have seen quite a number of people writing about what happens to their SATA RAID5 arrays when several drives get accidentally unplugged. Especially with port multipliers and external drive boxes with eSata cables, this can happen rather easily.

In my case, an 8-drive RAID6 array had this happen to it. Even though the array was not in active use at the time, MD immediately marked the 4 temporarily-disconnected drives as "Spare". No combination of "assemble" options seems able to fix this. 4 drives still have "active slot N" status; the other 4 are "spare", wiping out the slot metadata. Apparently, you have to use "create" to recreate the metadata, marking two slots as "missing" (for RAID 6); check the resulting RAID data; then add the "missing" drives back in. Presumably, you should write down the slot numbers or this may be difficult.

This procedure works, but for a 12 TB array, the resyncs take a long time. 1 second of cable disconnect for 2 days of resync.

I have some questions-

1) When MD detects that so many drives are offline that the RAID can't function, why not just put the RAID in "stop" state and avoid changing any metadata? Yes, I know that there is a risk of data corruption, but isn't minor data corruption often better than total data loss? 

2) Couldn't there be a way to put the RAID back together tentatively (with all 8 drives), check the parity, and go with the result if the parity is o.k.? That would save some time as compared to resyncing two disks from scratch.

3) In my case, I am more concerned about catastrophic data loss than 100% up time. I want to have the raids assembled with "--no-degraded". Is it possible to tell the kernel to do this, or would it be better to specify "AUTO -1.x" in mdadm.conf and use a cron.reboot script to start the RAID? 

4) Also, would "--no-degraded" help prevent MD from overwriting the metadata (switching drives to "spare" state)?

Thanks!

Jim






 

