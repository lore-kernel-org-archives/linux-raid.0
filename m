From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Stress testing system?
Date: Fri, 08 Oct 2004 22:32:58 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4167078A.3030609@robinbowes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've got six 250GB Maxtor drives connected to 2 Promise SATA controllers 
  configured as follows:

Each disk has two partitions: 1.5G and 248.5G.

/dev/sda1 & /dev/sdd1 are mirrored and form the root filesystem.

/dev/sd[abcdef]2 are configured as a RAID5 array with one hot spare.

I use lvm to create a 10G /usr partition, a 5G /var partition, and the 
rest of the array (994G) in /home.

The system in which I installed these drives was rock-solid before I 
added the RAID storage (it had a single 120G drive). However, since 
adding the 6 disks I have experienced the system simply powering down 
and requiring filesystem recovering when it restarted.

I suspected this was down to an inadequate power supply (it was 400W) so 
I've upgrade to an OCZ 520W PSU.

I'd like to stress test the system to see if the new PSU has sorted the 
problem, i.e. really work the disks.

What's the best way to do get all six drives working as hard as possible?

Thanks,

R.
-- 
http://robinbowes.com
