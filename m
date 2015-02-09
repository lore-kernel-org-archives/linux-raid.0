From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Upgrading storage server
Date: Mon, 09 Feb 2015 23:35:57 +1100
Message-ID: <54D8A9AD.3060700@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

After making a whole string of mistakes in building a iSCSI server about 
2 years ago, I'm now looking to replace it without all the wrong 
turns/mistakes. I was hoping you could all offer some advice on hardware 
selection/choices.

The target usage as above is an iSCSI server as the backend to a bunch 
of VM's. Currently I have two identical storage servers, using 7 x SSD 
with Linux MD Raid, then using LVM to divide it up for each VM, and then 
DRBD on top to sync the two servers together, on the top is ietd to 
share the multiple DRBD devices out. The two servers have a single 
10Gbps connection between them for DRBD to sync the data. They also have 
a second 10Gbps ethernet for iscsi to use, with a pair of 1Gbps for 
management (on board). I have 8 x PC's running Xen with 2 x 1Gbps 
ethernet for iSCSI and one 1Gbps ethernet for the "user"/management LAN.

Current hardware of the storage servers are:
7 x Intel 480GB SSD Model SSDSC2CW480A3
1 x Intel 180GB SSD Model SSDSC2CT180A4  (for the OS)
1 x LSI Logic SAS2308 PCI-Express (8 x SATA connections)
1 x Intel Dual port 10Gbps 82599EB SFI/SFP+ Ethernet
1 x Intel Xeon CPU E3-1230 V2 @ 3.30GHz
Motherboard Intel S1200 
http://ark.intel.com/products/67494/Intel-Server-Board-S1200BTLR

What I'm hoping to achieve is to purchase two new (identical) servers, 
using current recommended (and well supported for the new few years) 
parts, and then move the two existing servers to a remote site, 
combining with DRBD proxy to give a full, "live" off-site backup 
solution. (Note, by backup I mean Disaster Recovery, not backup).

I would also like to be able to grow the total size of the data further 
if needed, currently I have 7 x 480G in RAID5, which is likely somewhat 
sub-optimal. Options include moving to larger size SSD, or at perhaps 
splitting into 2 x RAID5 arrays. The advantage of larger SSD's would be 
a smaller "system", with lower complexity, while using more smaller 
drives would provide (potentially) better performance, since each drive 
(regardless of size) has the same overall performance (both throughput 
and IOPS).

I would appreciate any advise or suggestions you can make to help me 
avoid the many mistakes I made last time.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

