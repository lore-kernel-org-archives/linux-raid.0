From: Darryl Barlow <darrylb@iprimus.com.au>
Subject: Software Raid Autodetection Problem
Date: Wed, 10 Sep 2003 21:19:11 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200309102119.11307.darrylb@iprimus.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am having problems with autodetection of a software raid0 array running on 
Debian unstable with kernel 2.4.21.  The Kernel was compiled with all 
necessary support as suggested by the howto (except there no longer seems to 
be a specific configuration option for autodetection).  Once loaded the array 
starts normally with raidstart --all.  I used Debian kernel sources and built 
the kernel with make-kpkg.  Debian kernel sources are set up for initrd and I 
have had no luck compiling non-initrd Debian kernels, so the kernel does use 
initrd.

Dmesg seems to indicate it is scanning for raid arrays but for some reason is 
not finding this particular one.  I might add that the partitions concerned 
are set up as type fd (Linux Raid) and the array was created with 
persistent-superblock in the raidtab.  As I would ultimately like to boot 
from the software raid I would welcome any assistance in solving this 
problem.  Incidentally, is it correct that Lilo supports booting only from a 
software raid1 and not a software raid0 array?

regards,

Darryl

