From: Scott Laird <scott@sigkill.org>
Subject: Irritating RAID problem (kept spare, kicked data disks due to timestamp)
Date: Mon, 10 Jan 2005 08:53:20 -0800
Message-ID: <21F89945-6328-11D9-B5C2-000393667D82@sigkill.org>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I found an interesting problem with software RAID 5 in 2.6.10:

I have a RAID 5 array, recently created with mdadm.  It consists of 4 
160 GB drives plus a spare.  All 4 drives were active and fully synced 
when the box locked up due to some sort of hardware problem.  When I 
rebooted, the kernel refused to start the array because all 4 drives 
had an older timestamp then the spare.  So the RAID code kicked them 
out, one after another, until it was left with just a single spare 
disk.  Since it can't start an array with 0/4 disks, it failed.  I was 
able to repeat this with 2.6.10 and 2.6.2 (the only other kernel I had 
handy).  Pulling the spare disk and rebooting fixed everything.

I don't have an record of the logs during this period--the box was in 
single-user mode with disk problems, and I didn't want to write 
anything to the disk.

Logically, it seems like the kernel's RAID recovery code shouldn't look 
for the newest disk, it should really look for a quorum, even if that 
means kicking out newer timestamps.  *Especially* when the newer 
timestamp is the spare disk.


Scott

