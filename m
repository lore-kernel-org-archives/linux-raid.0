From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: md lock issue, I suppose
Date: Mon, 21 Jun 2010 22:42:08 +0200
Message-ID: <20100621204208.GA29830@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

still playing with my wild bunch of RAID-6.

I'm more or less finished with a script adding
an HDD to the different arrays.

The script, originally, was going thru the different
arrays, collecting the partition size, creating the
partition (on the new disk), adding the partition
to the corresponding RAID volume.

Something like:

for v in raid_devices
  find start end part
  parted /dev/sdX mkpart part start end
  mdadm --add $v /dev/sdXpart
end

This works only for the first partition.

The issue seems to be that, after the "--add", the
device is locked and the partition table *cannot*
be updated (the kernel cannot).
The consequence is that the successive "parted",
while succeeding, report a failure (not a problem),
and the /dev/sdXpart does not appear. This means
it will not be added to the next device.

In other words, the script starts with /dev/sdX.
It creates /dev/sdX1.
It adds /dev/sdX1 to the RAID.
It creates /dev/sdX2...
/dev/sdX2 does not appear, the add fails...
...

Is this intended behaviour? Or a bit aggressive locking?

Any possible solution not involving stopping the RAIDs?

Thanks a lot, if you need more info, please let me know.

bye,

-- 

piergiorgio
