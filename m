From: "Donghui Wen" <dhwen@protegonetworks.com>
Subject: 3ware bad write speed.
Date: Sat, 22 Mar 2003 12:45:25 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <004f01c2f0b3$f72478d0$df01010a@moon>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: swmike@swm.pp.se, maurice@harddata.com, aradford@3WARE.com, bind@swift-web.com, raid@ddx.a2000.nu
List-Id: linux-raid.ids

Hi,
 We used 3ware 7500-4 as ide raid controler on a redhat advanced server
machine.
(kernel 2.4.9-e12, lastest 3ware driver). But we got a pretty bad write
speed.


Sequential Writes
                              File  Blk   Num                   Avg
Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency
Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- -----
------  -------- -------- -----
2.4.9-e.12enterprise          1792  4096    1    8.99 6.920%     0.394
29064.03   0.00240  0.00218   130
2.4.9-e.12enterprise          1792  4096    2   10.55 17.61%     0.637
23474.59   0.00480  0.00218    60
2.4.9-e.12enterprise          1792  4096    4    1.94 11.22%     0.156
1861.13   0.00000  0.00000    17
2.4.9-e.12enterprise          1792  4096    8    0.83 7.171%     0.274
995.19   0.00000  0.00000    12

 I saw a thread (http://www.spinics.net/lists/raid/msg01762.html)
 discussing the simillar problem by your guys. The possible reason you
pointed out is:
      3ware card has its own caching mechanism to accelerate sequential
write, but combine with linux's
      own VM caching and journaling filesystem, the disk physical accesses
aren't actually sequential.

 I have several questions:

 (1) Does this problem only exists in 3ware ide raid adaptor? We test SCSI
too, it is much faster.
     If it is 3ware's driver problem, scsi raid should have the same
problem.
 (2) Has 3ware fixed this problem yet? They claim they support linux.
 (3) One solution is to setup 3ware in jbod mode and use linux
software-raid.
     what percentage of CPU used if using software-raid? It might cost too
much CPU power
     without using hardware raid.
 (4) Other than 3ware, is there any better raid card supported by linux?

 I appreciate your guys help


Donghui Wen

