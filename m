From: name <bugtraq@telia.com>
Subject: Hardlocks with softwareraid
Date: Thu, 09 Jan 2003 06:20:38 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E1D06A6.5030604@telia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Hello

I have been trying to get some raid5sets going on my machine but have 
been running in to some problems.

I have two promise udma133 tx2 controllers (both flashed to the latest 
bios) and 5 80gb idedrives. the problem is that when i try to mkraid a set
with a drive on my second promise controller my computer hard locks, no 
crash dump or such.

I have tried different drive combinations and they work as long as i 
only use 4 drives, two on the mobo and two on one promise. Indifferent of
which of the five drives get to be the fifth drive on the second 
controller the system hard locks when i mkraid.

If i make a filesystem on the fifth drive and mount it like a normal 
drive it works like normal.

It behaves the same if i change the second 133 tx2 for a fasttrack100 
controller or shuffle the cards in different pci-slots.


My setup:
Linux sverver 2.4.20-ac2 #6 Tue Jan 7 01:09:24 CET 2003 i686 unknown
Debian 3.0
raidtools 0.9

hda: QUANTUM FIREBALLP KX20.5, ATA DISK drive   #boot drive, not used in 
raid
hdb: WDC WD800BB-00BSA0, ATA DISK drive
hdc: WDC WD800BB-53BSA0, ATA DISK drive
hde: IC35L080AVVA07-0, ATA DISK drive
hdg: WDC WD800BB-00BSA0, ATA DISK drive
hdi: WDC WD800BB-00BSA0, ATA DISK drive




