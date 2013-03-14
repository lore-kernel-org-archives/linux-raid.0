From: Joel Young <jdy@cryregarder.com>
Subject: RAID 0 of Two RAID 5s Stays Up When Component RAID fails
Date: Thu, 14 Mar 2013 01:33:52 +0000 (UTC)
Message-ID: <loom.20130314T022616-853@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

What should the output be for the following sequence:

dd if=/dev/zero of=i1 bs=1M count=100
dd if=/dev/zero of=i2 bs=1M count=100
dd if=/dev/zero of=i3 bs=1M count=100
dd if=/dev/zero of=i4 bs=1M count=100
dd if=/dev/zero of=i5 bs=1M count=100
dd if=/dev/zero of=i6 bs=1M count=100
losetup /dev/loop1 i1
losetup /dev/loop2 i2
losetup /dev/loop3 i3
losetup /dev/loop4 i4
losetup /dev/loop5 i5
losetup /dev/loop6 i6
mdadm --create /dev/md0 --level=5 --raid-devices=3 \
    /dev/loop1 /dev/loop2 /dev/loop3
mdadm --create /dev/md1 --level=5 --raid-devices=3 \
    /dev/loop4 /dev/loop5 /dev/loop6
mdadm --create /dev/md2 --level=0 --raid-devices=2 \
    /dev/md0 /dev/md1
mdadm /dev/md0 --fail /dev/loop0
mdadm /dev/md0 --fail /dev/loop1
mdadm --detail /dev/md0
mdadm --detail /dev/md2
dd if=/dev/zero of=/dev/md2 bs=1M

Shouldn't /dev/md2 be failed at this point?  Shouldn't the 
dd get an error?  No error was reported.  /dev/md2 is writable.  
Where are the writes going?

What am I missing?

This is running on fedora 18.  We saw the problem with production arrays on
fedora 17.

mdadm version: mdadm - v3.2.6 - 25th October 2012

kernel:  3.7.9-201.fc18.x86_64

Thanks,

Joel

