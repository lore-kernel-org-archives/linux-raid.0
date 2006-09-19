From: Gaspar Bakos <gbakos@cfa.harvard.edu>
Subject: RAID-5 making big partition fails
Date: Tue, 19 Sep 2006 16:39:31 -0400 (EDT)
Message-ID: <Pine.SOL.4.58.0609191633020.24136@titan.cfa.harvard.edu>
Reply-To: gbakos@cfa.harvard.edu
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a 12 disk RAID-5 hardware RAID with an ARECA card.
This is under FC5,  2.6.17.6 kernel. The areca driver correcly reports
5Tb diskspace on this unit, shown as /dev/sdc:

# fdisk /dev/sdc
Disk /dev/sdc: 4999.9 GB, 4999998341120 bytes
255 heads, 63 sectors/track, 607881 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System

-------
However, when I am trying to create one big partition with 5Tb size:

First cylinder (1-73183, default 1): 1
Last cylinder or +size or +sizeM or +sizeK (1-73183, default 73183):

It does allow me ONLY to create a 560Gb partition.
Anyone knows the reason?

I also tried 'gparted', but the same problem.

I see the following logs in dmesg in the meantime:

sdc : very big device. try to use READ CAPACITY(16).


My kernel config is at:
http://www.cfa.harvard.edu/~gbakos/cf7/config

Help appreciated.

Cheers,
Gaspar
