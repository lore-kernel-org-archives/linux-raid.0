From: "Nathanial A. Byrnes" <nate@qabal.org>
Subject: RAID 5 on four IDE channels doesn't work
Date: Sun, 10 Oct 2004 14:14:53 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1097432092.1294.8.camel@qabal.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
	I am having trouble getting my RAID 5 array to work on four channels.
It works fine on two channels, but when I configure the system to use
the second controller it will not find the disks on the second
controller.

	My working configuration is:

		/dev/hde
		/dev/hdf
		/dev/hdg
		/dev/hdh

	My non-working config is:
		/dev/hde
		/dev/hdg
		/dev/hdi
		/dev/hdk

	Where hde-hdh are on my PCI promise controller, and hdi-hdl are on my
onboard HighPoint 366 controller. (The same array worked on just the
Highpoint 366 controller as well)

	System info Linux-2.6.8.1 non-SMP. 

	The following is my /etc/raidtab (which is set up for the non-working
config, but works with the working config...)

raiddev /dev/md0
        raid-level              5
        nr-raid-disks           4
        persistent-superblock   1
        parity-algorithm        left-symmetric
        chunk-size              128

        device          /dev/hde
        raid-disk       0
        device          /dev/hdg
        raid-disk       1
        device          /dev/hdi
        raid-disk       2
        device          /dev/hdk
        raid-disk       3

	Any ideas?
	Thanks,
	Nate
