From: "Sarcar, Shourya C (MED)" <Shourya.Sarcar@med.ge.com>
Subject: RE: Raid1 and mdadm
Date: Mon, 31 Mar 2003 07:33:43 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <EE1ED172E985D411A27B00508BE30A5E064ADD13@uswaumsx11medge.med.ge.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux RAID Mailing Liste <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Max,

Even if RAID is not compiled into the kernel, you can build an initrd
image (man mkinitrd) and change /etc/lilo.conf to point to the new
initrd image.
This way you will override the pains of a 'proper' kernel compile. 

Thanks
Shourya Sarcar 
_____________________________________________________
Global Recon Engine, Computed Tomography
Edison Engineering Development Program, GE Medical Systems
3000 N Grandview Blvd., MS W 1200, Waukesha, WI 53188, USA
Tel: 262 312 7405 (O) | *320 7405 (DialComm)
 


> -----Original Message-----
> From: Friedrich Lobenstock [mailto:fl@fl.priv.at]
> Sent: Monday, March 31, 2003 5:35 AM
> To: Linux RAID Mailing Liste
> Subject: Re: Raid1 and mdadm
> 
> 
> Max Booker wrote:
> > 
> > GRUB boot loader
> > 
> >     hda1    /boot
> >     hda2    /
> >     hda3    swap
> > 
> >     hdd1    (intended) mirror partition of  /
> > 
> > I can create the (degraded) array on hdd1, mkfs on 
> /dev/md0, mount /dev/md0
> > as /mnt, copy / to /mnt, and edit /mnt/etc/fstab.
> > 
> > Everything works well up to the point where I reboot, with 
> kernel parameters
> > (md=0,/dev/hdd1 root=/dev/md0). This is where the kernel panics.
> > 
> > I think that I have not edited fstab properly, or GRUB is 
> getting in the
> > way, or maybe it is not possible to add hda2 to the array 
> because it already
> > has a filesystem on it.... How do I get hda2 to be part of 
> the Raid array?
> > Nothing attempted so far has made any impression on the 
> fact that mdadm
> > insists that /dev/hda2 is not an md component.
> > 
> 
> As far as I know you have to use LILO instead of GRUB to boot
> from a root raid. Take care that raid1 is compiled into the kernel.
> 
> -- 
> MfG / Regards
> Friedrich Lobenstock
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
