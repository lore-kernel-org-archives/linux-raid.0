From: Alexander Stockinger <stockina@fmi.uni-passau.de>
Subject: RAID 5 disks not spinning down
Date: Sat, 12 Mar 2005 09:54:40 +0100
Message-ID: <d0uamj$s15$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I have a linux software RAID 5 running on a Debian Sarge with 2.6.7-smp. 
Since I installed the system (several kernel updates ago) the disks of 
the RAID 5 won't stay spinned down. Having them sent to standy manually 
using hdparm ends up in having the disks spin up within the next minute 
or so.
To further investigate the problem I watched the /proc/diskstats file 
for /dev/md0 and realized that prior to the spinup a single read access 
to the RAID is issued - consequently the disks attached to the read spin 
up again...
In order to find the reason for that read I did a dnotify on the mount 
point of the RAID - however this didn't show ANY file read at all when 
this single read access occurs.
I also tried noflushd - it simply keeps segfaulting after a few seconds. 
Plus I'd be happy to resolve the issue in the first place instead of 
fixing the symptoms anyway...

Any ideas what to do?

Thanks,
Alex

