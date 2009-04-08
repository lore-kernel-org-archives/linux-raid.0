From: Steven Ellis <steven@openmedia.co.nz>
Subject: Can't resolve mismatch_count > 0 for a raid 1 array
Date: Wed, 8 Apr 2009 22:03:32 +1200
Message-ID: <F87E9034-BDD7-4D74-8117-3ED1884D4165@openmedia.co.nz>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've resolved most of my raid issues by re-housing the affected system  
and replacing the motherboard, but across the 3 boards I've tried I  
always have an issue with my /dev/md1 array producing mismatch_count  
of 128 or 256.

System is running Centos 5.2 with a Xen Dom0 kernel

This md1 volume is a pair of 40GB HDs raid1 on an IDE controller which  
I them have a bunch of LVM's that are my Xen guests.

Is there any chance that these mismatch_count values are due to swap  
partitions for the Xen guests?

Steve


Steven Ellis - Technical Director
OpenMedia Limited


