From: Jessie Evangelista <jessie.evangelista@gmail.com>
Subject: raid10n2/xfs setup guidance on write-cache/barrier
Date: Thu, 15 Mar 2012 08:30:55 +0800
Message-ID: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I want to create a raid10,n2 using 3 1TB SATA drives.
I want to create an xfs filesystem on top of it.
The filesystem will be used as NFS/Samba storage.

mdadm --zero /dev/sdb1 /dev/sdc1 /dev/sdd1
mdadm -v --create /dev/md0 --metadata=1.2 --assume-clean
--level=raid10 --chunk 256 --raid-devices=3 /dev/sdb1 /dev/sdc1
/dev/sdd1
mkfs -t xfs -l lazy-count=1,size=128m -f /dev/md0
mount -t xfs -o barrier=1,logbsize=256k,logbufs=8,noatime /dev/md0
/mnt/raid10xfs

Will my files be safe even on sudden power loss? Is barrier=1 enough?
Do i need to disable the write cache?
with: hdparm -W0 /dev/sdb /dev/sdc /dev/sdd

I tried it but performance is horrendous.

Am I better of with ext4? Data safety/integrity is the priority and
optimization affecting it is not acceptable.

Thanks and any advice/guidance would be appreciated
