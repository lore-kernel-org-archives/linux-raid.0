From: Neil Brown <neilb@suse.de>
Subject: RE: mdadm Device Busy Error
Date: Tue, 7 Mar 2006 16:17:29 +1100
Message-ID: <17421.5993.343080.896707@cse.unsw.edu.au>
References: <17382.32368.830307.369741@cse.unsw.edu.au>
	<000001c6419f$32f09170$644e0a0a@freeway.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Kunyiha on Monday March 6
Sender: linux-raid-owner@vger.kernel.org
To: Bill Kunyiha <bill@freeway.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday March 6, bill@freeway.com wrote:
> Please help me here. I want to create an array containing an active
> partition. 

You cannot do that.  It would corrupt the active partition.

>            I'd like to convert a machine from having a non-raid root to
> having a raid1 root.

It goes like this:
  1/ create a degraded array using only the new device
          mdadm -C /dev/md0 -l1 -n2 missing /dev/hdc1
  2/ make a filesystem there
          mkfs /dev/md0
  3/ mount and copy over
          mount /dev/md0 /mnt
          cp -ax / /mnt
  4/ update lilo.conf (or grub or whatever) on new filesystem
     Also update /etc/fstab
          vi /mnt/etc/lilo.conf
          chroot /mnt /sbin/lilo
          vi /mnt/etc/fstab
  5/ reboot
  6/ make sure the root filesystem is /dev/md0 and everything look
    cool.  If not, boot off /dev/hdb1 and try again.
  7/ add the original drive to the array
          mdadm /dev/md0 -a /dev/hdb1

Done/

  
          
> I want to create software raid on two ide drives(hdb and hdc).
> Currently everything is on hdb.
> I want to convert hdb and hdc to raid auto detect.
> I want if one drive fails, the other takes over, therefore all the disks
> should have a boot loader, bios (I mean identical). So that if I take any of
> the disks out, the system still boots. Can I do this and how do I go about
> doing this?
> 
> 
> On Friday February 3, bill@freeway.com wrote:
> > I had problems with mdadm and what i did was reinstall Fedora Core 4 on my
> > system. I would like to create raid 1 on /dev/hdb1 and /dev/hd1
> > However when i try and create raid on these drives, i get an error from
> > /dev/hdb1 saying that the device is busy. Here's the output i get from the
> > screen.
> > What could be the problem?
> > 
> > [root@lab-asterisk ~]# mdadm --create --verbose
> > /dev/md0 --level=1 --raid-devices=2 /dev/hdb1 /dev/hdc1
> > mdadm: Cannot open /dev/hdb1: Device or resource busy
> > mdadm: create aborted
> > 
> > [root@lab-asterisk ~]# fdisk -l
> > 
> > Disk /dev/hdb: 20.0 GB, 20020396032 bytes
> > 255 heads, 63 sectors/track, 2434 cylinders
> > Units = cylinders of 16065 * 512 = 8225280 bytes
> > 
> >    Device Boot      Start         End      Blocks   Id  System
> > /dev/hdb1   *           1        2401    19286001   fd  Linux raid
> > autodetect
> > /dev/hdb2            2402        2434      265072+  fd  Linux raid
> > autodetect
> > 
> > Disk /dev/hdc: 10.2 GB, 10242892800 bytes
> > 16 heads, 63 sectors/track, 19846 cylinders
> > Units = cylinders of 1008 * 512 = 516096 bytes
> > 
> >    Device Boot      Start         End      Blocks   Id  System
> > /dev/hdc1               1       19846    10002352+  fd  Linux raid
> > autodetect
> > [root@lab-asterisk ~]#
> > [root@lab-asterisk ~]#
> 
>  
