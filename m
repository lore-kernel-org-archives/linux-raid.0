From: "Tyler J. Wagner" <tyler@talia.net>
Subject: alignment of metadata 1.2 and mkfs.ext4
Date: Wed, 06 Jul 2011 08:10:46 +0100
Message-ID: <1309936246.11661.7.camel@baal>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all (well, Neil, really),

The the following, Neil states that that is no issue with alignment of
metadata 1.2 and mkfs.ext4 on 4K drives:

http://www.issociate.de/board/post/507176/filesystem_on_mdadm_raid_from_unpartioned_block_devices.html

Sorry to ask again, but I just want to clarify. Metadata 1.2 puts the
data 4K from the start of the device/partition. Does mkfs put the start
of the filesystem at 64K from the start? IE, will the following align,
without any need for options?

(create partitions starting 2048 512-byte sectors from start = 1MB)
mdadm --create /dev/md0 -v --raid-devices=4 --level=raid10
--metadata=1.2 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
mkfs.ext4 /dev/md0

And, slightly off-topic, it's not necessary to define stride and stripe
any longer?
mkfs.ext4 -E stride=16,stripe-width=32 /dev/md0

Regards,
Tyler

-- 
Tyler J. Wagner
Chief Technical Officer, Talia Ltd
http://www.talia.net
email: tyler@talia.net
mobile: +44 790 863 1442
office: +44 203 3181 500 x503
fax: +44 207 631 3343

