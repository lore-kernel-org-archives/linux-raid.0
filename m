From: Alfred Isele <Alfred.Isele@fujitsu-siemens.com>
Subject: Re: RAID 1 cannot boot (using grub)
Date: Mon, 16 Jun 2003 10:19:50 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3.0.6.32.20030616101950.00ac9cd0@athen>
References: <Pine.LNX.4.44.0306122342440.4181-100000@gpu.utcc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0306122342440.4181-100000@gpu.utcc>
To: Derek Yeung <dky@utcc.utoronto.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello!
Maybe you forgot to setup grub anew on hda: 
After adding /dev/hda1 to /dev/md1 (/boot)
you have to setup grub for hda1 again, because
the boot files to be anchored within the MBR are now
located at positions different from /dev/sda1.
To save your system try this:
Boot from CDROM, 
wait for /dev/md1 to be mirrored
and stup grub for /dev/hda (i.e. the first disk):  

mount /dev/md1 /boot
grub
root (hd0,0)
setup (hd0)
quit

and reboot from disk 1.
Regards
Alfred


At 15:52 13.06.03 -0400, Derek Yeung wrote:
>
>Hello everyone,
>
>I would very much appreciate insight onto this problem:
>
>System: IBM xSeries 335 / IDE Mirroring / RedHat 8 / Grub
>
>I'm working on setting up mirroring on 2 IDE disks in RedHat 8.  I 
>followed  Neil Brown's email to Stephen Lee (dated 20 Apr 2002).  
>
>I created a degraded RAID 1 using /dev/hdc1, created a filesystem on 
>it, copied everything from the existing boot to the new md device, 
>modified the fstab accordingly.  Without the primary device added to 
>the md set (meaning still working in degraded mode), the machine boots 
>(with a few hitches -- something about a bad superblock and ext3 
>mounting, which i will post more detail later)  -- but, it boots.  
>The problem is after I add the /boot partition to the md set (i.e.: add 
>hda1 to md1, which md1 already has hdc1), and then reboot, the machine 
>fails to boot.  It stops after printing "GRUB".  Does anyone have any idea 
>why?  
>
>I'd very much appreciate any ideas/solutions.  
>
>Thank you very, very much
>
>/dky
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

