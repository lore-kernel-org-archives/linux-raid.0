From: Richard Scobie <richard@sauce.co.nz>
Subject: Check/repair on composite RAID
Date: Sat, 09 Sep 2006 17:01:41 +1200
Message-ID: <45024AB5.4050703@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

If I have a RAID 10, comprising a RAID 0, /dev/md3 made up of RAID1, 
/dev/md1 and RAID1, /dev/md2 and I do an:

echo repair > /sys/block/md3/md/sync_action

will this run simultaneous repairs on the the underlying RAID 1's, or 
should seperate repairs be done to md1 and 2?

Thanks for any assistence.

Regards,

Richard
