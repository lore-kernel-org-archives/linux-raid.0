From: Robert Osiel <bob@osiel.org>
Subject: A few mdadm questions
Date: Fri, 12 Nov 2004 21:34:48 -0600
Message-ID: <419580D8.1020900@osiel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.
I have a five-disk RAID 5 array  in which one disk's failure went 
unnoticed for an indeterminate time.  Once I finally noticed, I did a 
raidhotremove on the disk -- or what I thought was the disk.  
Unfortunately, I can't count.  Now my array has one 'failed' disk and 
one 'spare' disk.  Aaargh.

Since then, I've learned a lot, but I haven't been able to find 
reassurances and/or answers elsewhere on a few issues.

The two big questions are:
1) How can I mark the 'spare' disk as 'clean' and get it back in the 
array?  If I read the mdadm source correctly, it looks like 'removed' 
disks are skipped when trying to assemble.
2) If I --assemble --force the array and just specify (n-1) disks, does 
that ensure that (if the array starts) it starts in degraded mode and 
won't start re-writing the parity information? 

Thanks a bunch in advance for any help.

Bob

