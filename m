From: "saeed bishara" <saeed.bishara@gmail.com>
Subject: Linux RAID migration
Date: Tue, 7 Aug 2007 11:16:20 +0300
Message-ID: <c70ff3ad0708070116k20605787pf897f9eccc93cd65@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
 I'm looking for a method for doing RAID migration while keeping the
data available.
the migrations I'm interested with are:
1. Single drive ->RAID1/RAID5
2. RAID1 -> RAID5.

the mdadm and kernel doesn't seem to provide built-in and crash-proof
solution. but I found that RAID5 on 2 drives in degraded mode looks
like a RAID1 (mirroring), and since linux supports RAID5 reshape, then
I can use it to do the migration from RAID1 to  RAID5 with 3 drives or
more.
- can I really assume that RAID 5 on 2 hdds (degraded mode) will
function as raid 5?
- how to build raid while keeping the contents of an existing drive available?

saeed
