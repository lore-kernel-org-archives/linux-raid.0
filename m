From: Daniel Browning <db@endpoint.com>
Subject: Raid level 5 not permitted with --build
Date: Tue, 8 Jan 2008 00:02:46 -0800
Message-ID: <200801080002.46242.db@endpoint.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Why do I get the following error when I attempt to 'mdadm --build' a 
software RAID 5 array that was created in Windows 2003 using Dynamic Disks 
(LDM)?

Raid level 5 not permitted with --build

RAID-0 arrays work great, and some of the kernel documentation implies that 
RAID-5 should work too:

Documentation/ldm.txt:
> Once the LDM driver has divided up the disk, you can use the MD driver to
> assemble any multi-partition volumes, e.g.  Stripes, RAID5.

Documentation/filesystems/ntfs.txt:
> Using NTFS volume and stripe sets
> =================================
> 
> For support of volume and stripe sets, you can either use the kernel's
> Device-Mapper driver or the kernel's Software RAID / MD driver.  The 
> former is the recommended one to use for linear raid.  But the latter is
> required for raid level 5.  For striping and mirroring, either driver
> should work fine.  

I'm using 2.6.23.12 vanilla, CONFIG_LDM_PARTITION=y, mdadm v2.6.2, 
ntfs-3g-1.1120, Fedora Core 8.

My goal is to access the same 6-disk 5TB RAID-5 array when booting Windows 
or Linux. I need Windows for professional video editing software like Avid 
and PPro that will not appear on Linux any time soon.

Hardware raid is not needed for the performance or lower CPU utilization; 
I'm already getting 400 MB/s at 25% of one core. 8-port cards are $$$$.

Fakeraid does not seem to be a good solution either; I could not find any 
high-quality implementations supported equally well by dmraid and Windows.

A virtual machine in Windows with Linux, mdadm, and Samba would work, but 
would be too slow.

Sincerely,
--
Daniel Browning
End Point Corporation
http://www.endpoint.com/
