From: Ben Williams <benw@plasticboy.com>
Subject: RAID becomes un-bootable after failure
Date: Wed, 02 Jun 2004 10:55:31 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40BDEA63.5040001@plasticboy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 2-disk RAID-1 that I set up using the Red Hat 9 installer. My 
problem is that pretty much any simulated drive failure makes the system 
unbootable. If I power down the machine and remove drive 1, the system 
can't find any bootable device. If I set a drive faulty using the 
RAIDtools, re-add it, and let the recovery process run the boot loader 
seems to get overwritten and I end up with a system hung at "GRUB 
loading stage2". Can anyone shed some light on what's going on here? My 
guess is that GRUB isn't installed on drive 2, so that removing drive 1 
or recovering drive 1 from drive 2 leads to no boot loader, but 
shouldn't GRUB have been copied to drive 2 in the mirroring process? How 
can I configure my system so that it will still be bootable after a 
drive failure?

Thanks for your help.
