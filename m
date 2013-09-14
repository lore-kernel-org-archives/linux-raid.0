From: Ian Pilcher <arequipeno@gmail.com>
Subject: Inoperative array shown as "active"
Date: Sat, 14 Sep 2013 00:39:20 -0500
Message-ID: <l10sq0$e24$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm in the process of writing a program to monitor various aspects of
my NAS.  As part of this effort, I've been simulating RAID disk failures
in a VM, and I noticed something that seems very odd.

Namely, when a sufficient number of disks has been removed from a RAID-5
or RAID-6 array to make it inoperable, the array is still shown as
"active" in /proc/mdstat and "clean" in the sysfs array_state file.  For
example:

md0 : active raid5 sde[3](F) sdd[2] sdc[1](F) sdb[0]
      6286848 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/2] [U_U_]

(mdadm does show the state as "clean, FAILED".)

Is this the expected behavior?

AFAICT, this means that there is no single item in either /proc/mdstat
or sysfs that indicates that an array such as the example above has
failed.  My program will have to parse the RAID level, calculated the
number of failed members (if any), and determine whether that RAID level
can survive that number of failures.  Is this correct?

Anything I'm missing?

Thanks!

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
Sometimes there's nothing left to do but crash and burn...or die trying.
========================================================================

