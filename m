From: Serge Torop <tsp@peterlink.ru>
Subject: resize new raid problem
Date: Wed,  9 Aug 2006 13:55:56 +0400
Message-ID: <eIi4Rs4Pcs@buratino.peterlink.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello, all.

I need to install softw. RAID1 to working RedHat EL4.


I used "rescue mode" for creating RAID arrays.

what do I do?:

1. install my own initrd for normal booting
2. change the disk partition type to "Linux Auroraid"
on /dev/hda, dev/hdc

3. create RAID1, by using "mkraid --really-force /dev/md2"

I need to resize new /dev/md0 after creating, for this I use:

resize2fs /dev/md2 and see a error messge:

resize2fs 1.39
/resize2fs: relocation error: - /resize2fs: undefined symbol: ext2fs_open2

Can I resolve this problem (resize2fs bug?)?
(may be using mdadm?)


ps. this bug I found in RHEL4, on RHEL3, Redhat9 all was ok.
-- 

Serge P. Torop
St.Petersburg, Russia

