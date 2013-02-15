From: Chris Jones <cmsj@tenshu.net>
Subject: RAID10 layout question
Date: Fri, 15 Feb 2013 11:45:01 +0000
Message-ID: <A1B82B87-68E8-4E6A-BF67-B1DCD85FE376@tenshu.net>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I've got a fileserver at home with the following space disk space:

2 * 1TB SATA disks directly connected to the motherboard
1 * 1TB partition on a SATA disk directly connected to the motherboard
2 * 1TB SATA disks connected to the motherboard via a SATA Port Multiplier

So I have 4 * 1TB physical devices available, but two of them share a SATA cable.

I'm thinking that RAID10 is probably the way to go here, but I would really like to avoid the two disks 
behind the port multiplier being used to mirror the same blocks, since the multiplier is quite new and 
I don't know yet how well it will stand up over multiple years.

I've looked through the Linux RAID HOWTO and the mdadm/md man pages and I can't see a way to 
specify in a RAID10 setup that specific disks should not be used to mirror each other.

1) Am I wrong about that? Is it possible to directly influence the layout in that kind of detail?
2) Will I take a performance hit if I manually make two RAID1 sets and then a RAID0 of them?
3) Should I forget about the layout and just use RAID6?

Cheers,

Chris Jones
   cmsj@tenshu.net
    www.tenshu.net




