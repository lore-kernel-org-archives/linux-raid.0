From: Derek Yeung <dky@utcc.utoronto.ca>
Subject: RAID 1 cannot boot (using grub)
Date: Fri, 13 Jun 2003 15:52:55 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0306122342440.4181-100000@gpu.utcc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello everyone,

I would very much appreciate insight onto this problem:

System: IBM xSeries 335 / IDE Mirroring / RedHat 8 / Grub

I'm working on setting up mirroring on 2 IDE disks in RedHat 8.  I 
followed  Neil Brown's email to Stephen Lee (dated 20 Apr 2002).  

I created a degraded RAID 1 using /dev/hdc1, created a filesystem on 
it, copied everything from the existing boot to the new md device, 
modified the fstab accordingly.  Without the primary device added to 
the md set (meaning still working in degraded mode), the machine boots 
(with a few hitches -- something about a bad superblock and ext3 
mounting, which i will post more detail later)  -- but, it boots.  
The problem is after I add the /boot partition to the md set (i.e.: add 
hda1 to md1, which md1 already has hdc1), and then reboot, the machine 
fails to boot.  It stops after printing "GRUB".  Does anyone have any idea 
why?  

I'd very much appreciate any ideas/solutions.  

Thank you very, very much

/dky


