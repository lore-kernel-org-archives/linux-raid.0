From: Paul <ocran@gmx.net>
Subject: promise reconstruction problem raid1
Date: Fri, 05 Sep 2003 11:09:58 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F58A746.8010004@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I have a raid 1 array, that has a fialed disk. I have repleaced the 
disk, and duplicated it with the promise fasttrack program. But when i 
boot my system, kernel 2.4.19 complains:
During boot, when the kernel is listing the arrays, it states that only 
one disk is in the array, when in fact there are two. Then it says code: 
Bad EIP value, and the warning fsck.ext3 for device /dev/ataraid/d1p1 
exited with signal 11. It then tells me to repair manually. Cuuld this 
possibly be a bad superblock? I am quite confused, and have tried 
several things. I have compiled different versions of the kernel, from 
2.4.18 to 2.4.21 but i have the same problem with all of them. I have 
even tried to compile them on another machine, still no luck. Has anyone 
succesfully done this?

Thanks,

Paul

