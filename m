From: Yeechang Lee <ylee@pobox.com>
Subject: A few questions before assembling Linux 7.5TB RAID 5 array
Date: Thu, 21 Dec 2006 10:49:10 -0800
Message-ID: <slrneollp6.4ps.ylee@pobox.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[Also posted to comp.sys.ibm.pc.hardware.storage,comp.arch.storage,alt.comp.hardware.pc-homebuilt,comp.os.linux.hardware.]

I'm shortly going to be setting up a Linux software RAID 5 array using
16 500GB SATA drives with one HighPoint RocketRAID 2240 PCI-X
controller (i.e., the controller will be used for its 16 SATA ports,
not its "hardware" fakeraid). The array will be used to store and
serve locally and via gigabit Ethernet large, mostly high-definition
video recordings (up to six or eight files being written to and/or
read from simultaneously, as I envision it). The smallest files will
be 175MB-700MB, the largest will be 25GB+, and most files will be from
4GB to 12GB with a median of about 7.5GB. I plan on using JFS as the
filesystem, without LVM.

A few performance-related questions:

* What chunk size should I use? In previous RAID 5 arrays I've built
  for similar purposes I've used 512K. For the setup I'm describing,
  should I go bigger? Smaller?
* Should I stick with the default of 0.4% of the array as given over
  to the JFS journal? If I can safely go smaller without a
  rebuilding-performance penalty, I'd like to. Conversely, if a larger
  journal is recommended, I can do that.
* I'm wondering whether I should have ordered two RocketRAID 2220
  (each with eight SATA ports) instead of the 2240. Would two cards,
  each in a PCI-X slot, perform better? I'll be using the Supermicro
  X7DVL-E
  (<URL:http://www.supermicro.com/products/motherboard/Xeon1333/5000V/X7DVL-E.cfm>)
  as the motherboard.

-- 
<URL:http://www.pobox.com/~ylee/>			PERTH ----> *

Homemade 2.8TB RAID 5 storage array:
<URL:http://groups.google.ca/groups?selm=slrnd1g04a.5mt.ylee%40pobox.com>
