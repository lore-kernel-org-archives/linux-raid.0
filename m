From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: I've made a bit of a mess in my raid setup
Date: Sat, 08 Mar 2014 13:44:08 +0100
Message-ID: <531B1098.8080305@grumpydevil.homelinux.org>
References: <CAFRU1XuCKyfL7uMa0wJj0dUjHyhBDp933_O4+TsQk33KM6brUA@mail.gmail.com> <531AF967.60500@grumpydevil.homelinux.org> <CAFRU1XsTdqVZ8bHumH3m-xfTK1M6u29U4H3ZDKNa_TZ=gKR_tg@mail.gmail.com> <531B0229.7030800@grumpydevil.homelinux.org> <CAFRU1XueM=bR0XXxskgwSGAcM_eXsDrsTVdF9V6GBvP9eZNs2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFRU1XueM=bR0XXxskgwSGAcM_eXsDrsTVdF9V6GBvP9eZNs2w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Federico Foschini <undicizeri@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08-03-14 13:08, Federico Foschini wrote:
> I think ubuntu kernel has mdadm in itself, but I'm not sure. How can I
> check? Remember also my boot disc is sdc and it's not part of any raid
urm... mdadm will never be part of the kernel. It is a separate program. 
It makes use of kernel modules though.

Considering the manner you do not answer my question, i am assuming 
default ubuntu kernel, which means an initrd is used.

>
> Anyway in addition to my configuration I've posted in my first mail
> this is my fstab and mdadm.conf:
> # /etc/fstab: static file system information.
> #
> # Use 'blkid -o value -s UUID' to print the universally unique identifier
> # for a device; this may be used with UUID= as a more robust way to name
> # devices that works even if disks are added and removed. See fstab(5).
> #
> # <file system> <mount point>   <type>  <options>       <dump>  <pass>
> proc            /proc           proc    nodev,noexec,nosuid 0       0
> # / was on /dev/sdc5 during installation
> UUID=a53356cf-05a3-42d8-a2ec-8a7fd4702e30 /               ext4
> errors=remount-ro 0       1
> # swap was on /dev/sdc1 during installation
> UUID=df505cf8-aac8-42d6-805a-908d5909f8d5 none            swap    sw
>             0       0
> /dev/md1 /media/dischi  ext4 defaults 0 1
>
> # mdadm.conf
> #
> # Please refer to mdadm.conf(5) for information about this file.
> #
>
> # by default, scan all partitions (/proc/partitions) for MD superblocks.
> # alternatively, specify devices to scan, using wildcards if desired.
> DEVICE partitions
>
> # auto-create devices with Debian standard permissions
> CREATE owner=root group=disk mode=0660 auto=yes
>
> # automatically tag new arrays as belonging to the local system
> HOMEHOST <system>
>
> # instruct the monitoring daemon where to send mail alerts
> MAILADDR root
>
> ARRAY /dev/md0 metadata=1.2 name=petra:0
> UUID=952ad074:4039f24a:2ec1808e:d555a88c
> ARRAY /dev/md1 metadata=1.2 name=petra:md1
> UUID=03c85017:15cecfb6:13d059bc:a8ff8779
>
> Thank you for your help!

In the default condition, this file is not only on your bootdisk, it is 
also in the initrd. I would expect that you updated your HDD copy, but 
not the one contained in the initrd. This leads to the error during boot 
that you see.

As the raid is not needed for the boot, no harm is done and the raid 
simply starts a bit later.

To solve this, you need to update the initrd. Please google for this, i 
do not use ubuntu so am not the best to give instructions on it.
>
> 0) The system was /dev/sda1 /dev/sdb1 in raid1 (dev/md0) with a LVM
> partition on top of the raid
> 1) I created a new degradeted raid 1 /dev/md1 array with /dev/sdd
> (without defining any partition)
> 2) I've mounted /dev/md1 and formatted as ext4. Then I copied
> everything from /dev/md0
> 3) I destroyed the old /dev/md0 and than recreated a new /dev/md0 as a
> linear array
> 4) I've added /dev/md0 on /dev/md1 and the drivers start syncying
>
> Than I've update the kernel and grub complained about "raid array -1".
> When I restarted the system a Grub error 17 was showed.
> So I booted from an usb key and restored grub (I think I installed it
> wrongly on /dev/sda instead of the correct drive /dev/sdc) and the
> system booted correctly.
>
>

Most likely your original raid did use partitions. Then when you 
re-configured you did not delete those partitions, but simply used the 
full disk.

This is the most likely explanation for the state you are now finding. A 
bit confusing, but no harm in itself.

To solve the error during boot, update your initrd

Cheers


Rudy
