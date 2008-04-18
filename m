From: Rick Bragg <lists@gmnet.net>
Subject: Software/ Hardware RAID info
Date: Fri, 18 Apr 2008 23:22:19 +0000
Message-ID: <1208560939.7243.146.camel@isis>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am new to setting up RAID arrays, and I have experimented in the past
with software only RAID, but now I have a new Dell PowerEdge 1900 with a
SAS RAID controller daughter card.  

My question is: What is the difference in tools that I will use to
create and manage this hardware array?  Can I still use all the same
techniques and tools such as mdadm, LVM2, and GParted to manage my
array? or is it all in the bios.

Another question is how should I format these disks?  Typically I would
use a root file system, and a swap file system that is twice the size of
my memory.  Since all four of my disks are used for hardware RAID, can I
partition this into 2 array's? one for my root, and the other for
swap...

Any advice into setting this up is greatly appreciated.

Thanks
Rick

