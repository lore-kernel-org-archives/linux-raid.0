From: "Donghui Wen" <dhwen@protegonetworks.com>
Subject: unable to read superblock ?
Date: Mon, 9 Jun 2003 06:29:12 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <004801c32e8b$1dac5170$4300a8c0@moon>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, I have a machine setup as software-raid + ext3 + redhat ,
but this morning, it seems the file system crash. here is
the booting message, anyone has any idea how to fix it.

Thanks!

Donghui

----------------------------------------------------------------------------
------
md: adding sda1
md: created md2
md: using <sdb1> <sda1>
md: md2: raid array is not clean -- starting bacground reconstruction
RAID level 1 does not need chunck size. Continuing anyway.
md2: max total readahead window set to 124k

raid1: device sdb1 operational as mirror1
raid1: device sda1 operational as mirror 0
raid1: raid set md2 mot clean, reconstructing mirror
raid1: raid set md2 active with 2 out of 2 mirrors
md: updating md2 RAID superblock device
.
.
md: autorun DONE
mounting root filesystem
EXT3-fs: unable to read super block
mount: error 22 mounting ext3
pivotrot: oivot_root(/sysrot,/sysrot/initrd) failed :2
freing unused kernal memory: 244k fred
kernal panic: no init found. Try passing init= option to kernal

-----------------------------------------------------------

