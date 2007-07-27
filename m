From: Frank van Maarseveen <frankvm@frankvm.com>
Subject: raid1 resync data direction defined?
Date: Fri, 27 Jul 2007 15:07:13 +0200
Message-ID: <20070727130713.GA12058@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm experimenting with a "live" migration of /dev/sda1 using mdadm -B
and network block device as in:

	mdadm -B -ayes -n2 -l1 /dev/md1 /dev/sda1 \
		--write-mostly -b /tmp/bitm$$ --write-behind /dev/nbd1

/dev/sda1 is to be migrated. During the migration the local system
mounts from /dev/md1 instead. Stracing shows that data flows to the
remote side. But when I do

	echo repair >/sys/block/md1/md/sync_action

then the data flows in the other direction: the local disk is written
using data read from the remote side.

If that would happen in the first command then it would destroy all
data instead of migrating it so I wonder if this behavior is defined:
Do mdadm --build and mdadm --create always use the first component device
on the command-line as the source for raid1 resync?

-- 
Frank
