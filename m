From: Victor <linux-raid@vitoni.de>
Subject: missing superblock on RAID5
Date: Mon, 13 Oct 2003 17:59:14 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F8ACBD2.CA1B8CBD@vitoni.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

At the time I created the RAID array I thought it had superblocks,
however if I use mdadm I get these results:

# mdadm --query /dev/md0
/dev/md0: 230.08GiB raid5 4 devices, 0 spares. Use mdadm --detail for
more detail.
/dev/md0: No md super block found, not an md component.

If  the array really shouldn't have a superblock, is it possible to add
one (maybe marking a device faulty and readding it and repeating this
for each device)?


Thanks in advance,

Victor


