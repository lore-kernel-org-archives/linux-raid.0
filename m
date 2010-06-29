From: Dave W <dave+gmane@wuertele.com>
Subject: Re: How do I determine which drive should be in which slot?
Date: Tue, 29 Jun 2010 06:26:17 +0000 (UTC)
Message-ID: <loom.20100629T082214-677@post.gmane.org>
References: <loom.20100626T070913-497@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Previously, I wrote:

> After making some changes in the bios to my boot order, my 5-drive RAID6
> stopped assembling.  Three of the five known-good drives suddenly stopped
> getting added to the right slots.  There are no disk errors in the logs and
> I can read from the drives with no problems.

Any help with this one?  My disks are fine but mdadm seems confused about which
slots they're supposed to be in.  How can I tell mdadm to put them in the right
slots?

Thanks,
Dave

# mdadm --stop /dev/md0
mdadm: stopped /dev/md0
# mdadm -v -Af /dev/md0 /dev/sd[bcdef]1
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 7.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 6.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 5.
mdadm: no uptodate device for slot 0 of /dev/md0
mdadm: no uptodate device for slot 1 of /dev/md0
mdadm: added /dev/sde1 to /dev/md0 as 3
mdadm: no uptodate device for slot 4 of /dev/md0
mdadm: added /dev/sdf1 to /dev/md0 as 5
mdadm: added /dev/sdc1 to /dev/md0 as 6
mdadm: added /dev/sdb1 to /dev/md0 as 7
mdadm: added /dev/sdd1 to /dev/md0 as 2
mdadm: /dev/md0 assembled from 2 drives and 3 spares - not enough to start the
array.
#


