From: "Stefan Majer" <stefan@x-cellent.com>
Subject: Setup a Raid while OS is running
Date: Thu, 4 Aug 2005 17:20:58 +0200 (CEST)
Message-ID: <47670.212.34.68.2.1123168858.squirrel@extern.x-cellent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

i have a server running on only one scsi disk. I got now one scsi disk
extra and i want to transform the actual installation to use both disks in
a raid1.
Therefore i want to mirror each partition with md.
The Question now is how to do that, if possible, without destroing the
installed OS.

I thought it should be possible to do it in the following way:

1. create the same partitions on the secondary drive
2. create a mirror for each partition with the actual installed partition
marked as "missing"
3. attach the missing partition (not sure how the specify sync direction)
4. edit fstab
5. reboot.

As u can see im afraid douing this becaus im not sure
a: how to specify sync direction and
b: if the creation of the now new superblock destroy my filesystem

So if someone have ideas, please

Greetings from munich

Stefan Majer

