From: Sandro Dentella <sandro.dentella@tin.it>
Subject: Re: Autodetect problem w/ SCSI
Date: Wed, 2 Jun 2004 12:40:17 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040602104017.GA2189@bluff>
References: <20040601183951.GA22078@bluff> <20040601204516.24507.qmail@web61004.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040601204516.24507.qmail@web61004.mail.yahoo.com>
To: M K <maheshext3@yahoo.com>
Cc: Sandro Dentella <sandro.dentella@tin.it>, Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



I moved the array w/ on a different machine w/ a different controller (same
model:adaptec 2940 pro ultra scsi) but the behaviour is the same: the array
is not autodetected. The same kernel autodetects ide disks.

Please tell me: is there some setting, peculiar to SCSI autodetect, I'm
ignoring? 

sandro

> 
> 
> On Tue, Jun 01, 2004 at 01:45:16PM -0700, M K wrote:
> > Can you send the exact command used to create the
> > array, the raidtabs or mdadm.conf file and the fdisk
> > -l listing of each drive thats part of the raid?
> 
> I used mdadm w/ (approxymantely, it's a script "mdadm --create $Md  -l1 -n2 $part $part2")
> 
>  mdadm --create /dev/md/0  -l1 -n2 /dev/scsi/host0/bus0/target0/lun0/part6 /dev/scsi/host0/bus0/target1/lun0/part6
> 
> >From a live CD after modprobe aic7xxx and "mdadm -A /dev/md4 /dev/sda1
> /dev/sdb1" and "mdadm -A /dev/md0 /dev/sda6 /dev/sdb6"
> 
> ####################################################
> fdisk -l /dev/sda
> root@argo-cd root # fdisk -l /dev/sda
> 
> Disk /dev/sda: 255 heads, 63 sectors, 2231 cylinders
> Units = cylinders of 16065 * 512 bytes
> 
>    Device Boot    Start       End    Blocks   Id  System
> /dev/sda1             1         3     24066   fd  Linux raid autodetect
> /dev/sda2             4      2231  17896410    f  Win95 Ext'd (LBA)
> /dev/sda5             4        68    522081   fd  Linux raid autodetect
> /dev/sda6            69       323   2048256   fd  Linux raid autodetect
> /dev/sda7           324      2231  15325978+  fd  Linux raid autodetect
