From: Mirko Benz <mirko.benz@web.de>
Subject: RAID 0 over HW RAID
Date: Wed, 10 May 2006 15:37:26 +0200
Message-ID: <4461EC96.9040704@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

We want to combine two HW RAID controllers with RAID 0 using MD and see 
some performance issues.

Setup:
- Linux 2.6.16-64 bit, Dual XEON, 1 GB RAM
- 2 RAID controllers: ARECA with 7 SATA disks each (RAID5)
- SW RAID 0 over the two HW RAID controllers
- stripe size is always 64k

Measured with IOMETER (MB/s, 64 kb block size with sequential I/O).
one HW RAID controller:    
- R: 360 W: 240
two HW RAID controllers:    
- R: 619  W: 480 (one IOMETER worker per device)
MD0 over two  HW RAID controllers:
- R 367 W: 433 (one IOMETER worker over md device)

Read throughput is similar to a single controller. Any hint how to 
improve that?
Using a larger block size does not help.

We are considering using MD to combine HW RAID controllers with battery 
backup support for better data protection. In this scenario md should do 
no write caching. Is it possible to use something like O_DIRECT  with md?

Regards,
Mirko

