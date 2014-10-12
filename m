From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Good drive got kicked out - does mdadm assemble across suspend/resume
 like it does across reboots?
Date: Sun, 12 Oct 2014 12:38:10 -0500
Message-ID: <543ABC82.5020901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I did a minor booboo with my mdadm raid6. I suspended (not shutdown, but 
suspend-to-ram) the machine to install a *new* disk in a hotswap bay for 
a thorough test before usage. This machine also housed a mdadm raid6 
array with 4 disks /dev/sd[cdeg]1 (not /dev/sdf1). When I inserted the 
new disk, I also rearranged the disks in the hotswap cage. I think that 
is a stupid mistake because /dev/sdg1 was also in the cage and now 
became /dev/sdf1 and the new disk got the name /dev/sdg1. I did not 
think much about it, since I thought mdadm would assemble after a resume 
and will find the right disks. I did not bother to check if anything 
happened to /dev/md0.

After checking the new disk (now /dev/sdg1) I added /dev/sdg1 to md0 (as 
spare) without checking /proc/mdstat. I noticed rebuild started to my 
surprise. I was trying to figure out what happened. It looks like resume 
after suspend does not assemble md0 as it does for reboot. So, it looked 
at the new /dev/sdg1 and found to be not part of md0 and degraded the 
array. So when I added it, it thought I am adding a new drive and 
proceeded to rebuild to fix the degraded state. A quick check of 
/dev/sdf1 (which was /dev/sdg1 before my swap) contains everything 
right, but got kicked out of array due to suspend-swap disk-resume issue.

While this is not a disaster, I wonder if my understanding is correct? 
Does this mean mdadm does not scan to assemble as part of resume? More 
importantly, how should I rectify the situation like this? Reboot or 
simply stop md0 and scan in a live system?
Further, how do I use /dev/sdf1 (that was /dev/sdg1 before this 
problem)? zero-superblock and add back to md0?

Sorry, if this was already discussed. If so, just let me know and I will 
search the archive manually as Google did not find it.

Thanks for your help
Ramesh

