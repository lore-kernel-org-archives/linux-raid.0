From: Jesse Burkhardt <jesse@skybuilders.com>
Subject: More: Fedora 2.0 - raid1 not working
Date: Tue, 09 Nov 2004 17:14:25 -0500
Message-ID: <41914141.6030108@skybuilders.com>
References: <419115A5.4050905@skybuilders.com> <20041109192219.GA5822@middle.of.nowhere> <41911ACB.2070604@skybuilders.com> <20041109194127.GA17963@middle.of.nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041109194127.GA17963@middle.of.nowhere>
Sender: linux-raid-owner@vger.kernel.org
To: Jurriaan <thunder7@xs4all.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A little more info - this is excerpted from dmesg:

md: Autodetecting RAID arrays.
md: autorun ...
md: considering hdd3 ...
md:  adding hdd3 ...
md: hdd1 has different UUID to hdd3
md:  adding hda3 ...
md: hda1 has different UUID to hdd3
md: created md1
md: bind<hda3>
md: bind<hdd3>
md: running: <hdd3><hda3>
md: kicking non-fresh hdd3 from array!
md: unbind<hdd3>
md: export_rdev(hdd3)
md: personality 3 is not loaded!
md :do_md_run() returned -22
md: md1 stopped.
md: unbind<hda3>
md: export_rdev(hda3)
md: considering hdd1 ...
md:  adding hdd1 ...
md:  adding hda1 ...
md: created md0
md: bind<hda1>
md: bind<hdd1>
md: running: <hdd1><hda1>
md: kicking non-fresh hdd1 from array!
md: unbind<hdd1>
md: export_rdev(hdd1)
md: personality 3 is not loaded!
md :do_md_run() returned -22
md: md0 stopped.
md: unbind<hda1>
md: export_rdev(hda1)
md: ... autorun DONE.
RAMDISK: Compressed image found at block 0
VFS: Mounted root (ext2 filesystem).
md: raid1 personality registered as nr 3
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hda1 ...
md:  adding hda1 ...
md:  adding hdd1 ...
md: hda3 has different UUID to hda1
md: hdd3 has different UUID to hda1
md: created md0
md: bind<hdd1>
md: bind<hda1>
md: running: <hda1><hdd1>
md: kicking non-fresh hdd1 from array!
md: unbind<hdd1>
md: export_rdev(hdd1)
raid1: raid set md0 active with 1 out of 2 mirrors
md: considering hda3 ...
md:  adding hda3 ...
md:  adding hdd3 ...
md: created md1
md: bind<hdd3>
md: bind<hda3>
md: running: <hda3><hdd3>
md: kicking non-fresh hdd3 from array!
md: unbind<hdd3>
md: export_rdev(hdd3)
raid1: raid set md1 active with 1 out of 2 mirrors
md: ... autorun DONE.
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hdd3 ...
md:  adding hdd3 ...
md: hdd1 has different UUID to hdd3
md: md1 already running, cannot run hdd3
md: export_rdev(hdd3)
md: considering hdd1 ...
md:  adding hdd1 ...
md: md0 already running, cannot run hdd1
md: export_rdev(hdd1)
md: ... autorun DONE.

Thanks again.


-- 

 Jesse Burkhardt, Cambridge MA
 jesse@skybuilders.com  (w) 617-876-5680
 aerogoose.com          (h) 617-354-5523

