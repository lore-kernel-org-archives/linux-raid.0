From: Bostjan Skufca <bostjan@a2o.si>
Subject: Raid 1 vs Raid 10 single thread performance
Date: Wed, 10 Sep 2014 23:24:11 +0200
Message-ID: <CAEp_DRAVPBvA34kgdjWqO6f6489SbmHQf-dFXC_SwSQd8e0C2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a simple question:
- Where is the code that is used for actual RAID 10 creation? In
kernel or in mdadm?


Explanation:

I was dissatisfied with single-threaded RAID 1 sequential read
performance (basically boils down to the speed of one disk). I figured
that instead of using level 1 I could create RAID level 10 and use two
equally-sized partitions on each drive (instead of one).

It turns out that if array is created properly, it is capable of
sequential reads at almost 2x single device speed, as expected (on
SSD!) and what would anyone expect from ordinary RAID 1.

What does "properly" actually mean?
I was doing some benchmarks with various raid configurations and
figured out that the order of devices submitted to creation command is
significant. It also makes raid10 created in such mode reliable or
unreliable to a device failure (not partition failure, device failure,
which means that two raid underlying devices fail at once).

Sum:
- if such array is created properly, it has redundancy in place and
performs as expected
- if not, it performs as raid1 and fails with one physical disk failure

I am trying to find the code responsible for creation of RAID 10 in
order to try and make it more inteligent about where to place RAID 10
parts if it gets a list of devices to use, and some of those devices
are on the same physical disks.

Thanks for hints,
b.



PS: More details about testing is available here, but be warned, it is
still a bit hectic to read:
http://blog.a2o.si/2014/09/07/linux-software-raid-why-you-should-always-use-raid-10-instead-of-raid-1/
