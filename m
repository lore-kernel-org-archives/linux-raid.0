From: Timo.Bolse@SerNet.DE
Subject: Zero Superblock... any ways to recover?
Date: Mon, 1 Mar 2004 15:23:43 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1AxoKd-0004GZ-00@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi List,

The following Problem:

I dd'ed a whole harddisk with the RAID Partitions to another harddisk. The new
harddisk was a little bit bigger than the original one. Now if i'am doing an
mdadm -E /dev/hdc on the new harddisk i get this:

pentium-test:/proc/ide # mdadm -E /dev/hdc
mdadm: No super block found on /dev/hdc (Expected magic a92b4efc, got 00000000)

There must be a way to find the superblock on the new device... is there anyone
who has a solution for this problem?

I thougt about searching for a92b4efc on the device...

Regards,
Timo
