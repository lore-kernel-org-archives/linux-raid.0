From: spam@altium.nl (Dick Streefland)
Subject: Re: RAID becomes un-bootable after failure
Date: Wed, 02 Jun 2004 15:30:22 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <72f2.40bdf28e.e6217@altium.nl>
References: <40BDEA63.5040001@plasticboy.com>
Reply-To: dick.streefland@altium.nl (Dick Streefland)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ben Williams <benw@plasticboy.com> wrote:
| I have a 2-disk RAID-1 that I set up using the Red Hat 9 installer. My 
| problem is that pretty much any simulated drive failure makes the system 
| unbootable. If I power down the machine and remove drive 1, the system 
| can't find any bootable device. If I set a drive faulty using the 
| RAIDtools, re-add it, and let the recovery process run the boot loader 
| seems to get overwritten and I end up with a system hung at "GRUB 
| loading stage2". Can anyone shed some light on what's going on here? My 
| guess is that GRUB isn't installed on drive 2, so that removing drive 1 
| or recovering drive 1 from drive 2 leads to no boot loader, but 
| shouldn't GRUB have been copied to drive 2 in the mirroring process? How 
| can I configure my system so that it will still be bootable after a 
| drive failure?

Boot from CD-ROM (using stage2_eltorito). Make sure GRUB reads the
kernel and initrd (if you use one) from the CD-ROM. Another option is
a USB stick.

-- 
Dick Streefland                      ////                      Altium BV
dick.streefland@altium.nl           (@ @)          http://www.altium.com
--------------------------------oOO--(_)--OOo---------------------------

