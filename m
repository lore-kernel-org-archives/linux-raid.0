From: "Tomasz Nowak" <tnowak-p@netventure.pl>
Subject: Bug(?) in raid10 (raid10,f2 - lvm2 - xen)
Date: Thu, 24 Apr 2008 17:41:24 +0200
Message-ID: <fuq9nl$k5g$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-2";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This bug comes ouf if you:

1. create a raid10,f2 device (ie /dev/md1)
2. set it as pv for vg
3. set a lv on that vg
4. export this /dev/vg/lv to xen domU as "disk" (ie xvdb)
   (that is the recommended way, feature of exporting
   devices as partitions will be dropped in the future
   probably)

As soon as domU get its hands on /dev/xvdb creating
a partition (xvdb1) there's a lot of filesystem
related errors, such as:
[...]
kernel: Buffer I/O error on device xvdb1, logical block 22
kernel: Buffer I/O error on device xvdb1, logical block 23
kernel: Buffer I/O error on device xvdb1, logical block 24
[...]

domU reports then:
[...]
raid10_make_request bug: can't convert block across chunks or bigger than 
256k 41952765 4
raid10_make_request bug: can't convert block across chunks or bigger than 
256k 41954301 4
raid10_make_request bug: can't convert block across chunks or bigger than 
256k 41954813 4
raid10_make_request bug: can't convert block across chunks or bigger than 
256k 41955325 4
[...]

Raid10,f2 is great (+80% read perfomance bust on my 2 disks only),
but unfortunably unusable as lvm backed xen device for the time
being.

PS. Centos 5.1 if that matters.

-- 
Tomek


