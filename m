From: Arshavir Grigorian <ag@m-cam.com>
Subject: raid on sparc
Date: Thu, 04 Nov 2004 15:54:43 -0500
Message-ID: <418A9713.50408@m-cam.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

After 2 days of struggling with setting up RAID5 (mdadm) on Sparc, 
someone finally told me that the partition included in the array cannot 
start at sector 0 because raidtools overwrites the partition table. He 
also told me that mdadm should not have that problem, but from what I 
could see, that problem was very much there and only moving the 
partition to cyl 1 fixed it.
Could someone please comment on this?
What I am trying to figure out is whether it is the raid partition that 
can't be on cyl 0, or any partition. I have a machine with 4 disks of 
which 3 are in a RAID5 array (no spare) and the forth has my /boot 
partition and the original root filesystem which is now on the array. I 
would like to eventually add this disk as a spare to the array but am am 
afraid that doing so will screw up my partition table since my /boot 
partition start at cyl 0.

On a related note, it would be very helpful to include this info in the 
HOWTO. Maybe a little note under the Devices section.

Thanks in advance.


Arshavir



