From: yejj8xgg@rothert.de
Subject: raidreconf aborted after being almost done
Date: Thu, 10 Mar 2005 09:24:59 +0100 (CET)
Message-ID: <1110443099.4230045b50735@www.rothert.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I tried to add a 6th disk to a RAID-5 with raidreconf 0.1.2

Almost being done raidreconf aborted with the error message:

raid5_map_global_to_local: disk 0 block out of range: 2442004 (2442004)
gblock = 7326012
aborted

After searching the web I believe this is due to different disk sizes. Because I
use different disks (vendor and type) having different geometries it is not
possible to have partitions of exact the same size. They match as good as
possible but some always have different amounts of blocks.
It would be great if raidreconf would complain about the different disk sizes
and abort prior to messing up the disks.

Is there any way I can recover my RAID device? I tried raidstart on it but it
started using only the old setup with 5 disks without including the new one. How
do I start the array including the 6th disk?

Regards
Klaus
