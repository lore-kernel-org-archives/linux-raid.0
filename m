From: Philip Cameron <pecameron@attbi.com>
Subject: Raid1 fast resync
Date: Wed, 01 Jan 2003 10:54:33 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E130F39.3000706@attbi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Do any of you know of work that is going on to improve the raid 1 resync 
speed? I am starting to evaluate approaches to reducing the time to 
resync the disks.

I am involved in a project on a fault tolerant x86 based server that has 
hot plugable scsi disks and PCI busses. There are two PCI busses and 3 
mirrrored sets of two disks. When a PCI bus is pulled all of the mirrors 
are broken so when the PCI bus is again inserted, all of the disks 
resync which takes hours. Also, during development the resync after 
crash really slows down debug.

Thanks,
Phil Cameron

