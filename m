From: "Zeno R.R. Davatz" <zdavatz@ywesee.com>
Subject: duplicate hdc partition table
Date: Fri, 27 Jun 2003 11:03:08 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030627110308.7e50e586.zdavatz@ywesee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi List

I managed to boot into my Raid, now I would like to add the 'failed-disk':

 raidhotadd /dev/md/1 /dev/hda3

gives me:
/dev/md/1: can not hot-add disk: too small disk!


sfdisk --force /dev/hdc | sfdisk /dev/hda

gives me:

Checking that no-one is using this disk right now ...
Checking that no-one is using this disk right now ...
BLKRRPART: Device or resource busy
 
This disk is currently in use - repartitioning is probably a bad idea.
Umount all file systems, and swapoff all swap partitions on this disk.
Use the --no-reread flag to suppress this check.
Use the --force flag to overrule all checks.
BLKRRPART: Device or resource busy

Any idea how I could raidhotadd /dev/hda or to duplicate my hdc partition table to hda?

Thanks for your time and help.

Zeno
