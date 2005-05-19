From: Gil <gil@fooplanet.com>
Subject: Re: Problems setting up RAID1
Date: Thu, 19 May 2005 00:12:51 -0700
Message-ID: <428C3C73.7010208@fooplanet.com>
References: <d6danj$nmr$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d6danj$nmr$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: George Huber <huber_geo@hotmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

George Huber wrote:
> all,
>
> 
> I am having problems setting up RAID 1 using Fedora core 3.  Here are
> the steps that I have taken to date.
> 
> 1) On the first SCSI drive, I installed a clean version of Linux, the
>    hard drive is partitioned as follows:
>    /dev/sda1              /boot              512 Mbytes
>    /dev/sda2              /cvsroot           20 GBytes
>    /dev/sda3              /archives          20 GBytes
>    /dev/sda4     (extended partition)
>    /dev/sda5              /home              10 GBytes
>    /dev/sda6              swap                2 GBytes
>    /dev/sda7              /                  14 GBytes

If I understand you correctly, I think you went wrong by installing
first and *then* trying to go to RAID.  In the general case you need to
create raid devices and then filesystems on top of those devices, not
the other way around.

Changing a filesystem in-place to be hosted on an MD device is possible
but I couldn't tell you how to do it (it involves shrinking the FS just so).

If you're willing to start again, the FC3 installer's parititioning app
is pretty good and should be able create all your RAID devices and
filesystems.  You shouldn't have to do anything manually unless you want
to stack RAID devices or something like that.

If you don't like Disk Druid, at the point where it prompts you to start
partitioning, you can always drop out to the root prompt with
Ctrl+Alt+F3 (or F2, I don't remember) and issue the fdisk commands
yourself.  The sequence you might use is:

1. fdisk /dev/sda, all partitions except sda4 get type 0xfd.

2. copy partitions from sda to sdb, e.g.
sfdisk -d /dev/sda | sfdisk /dev/sdb

3. create raid partitions, e.g.
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sd[ab]1
mdadm --create /dev/md3 --level=1 --raid-devices=2 /dev/sd[ab]6
...

4. create filesystems and swap
mke2fs -j /dev/md0 # other options or filesystems probably apply
mkswap /dev/md3
...

5. return to installation via Ctrl-Alt-F7, and select manual
partitioning.  This should reflect your partitioning choices -- all you
should need to do is nominate where the partitions get mounted.

6. proceed with installation as normal.


If you had wanted to make /boot a RAID1 as well, you might need to take
an extra step because the FC3 installer may not get that right,
regardless of your choice to use Disk Druid to lay out the partitions or
some other manual process.  That step, in your case, would be:

7. At the point where the installer prompts you to reboot for the first
time after copying, drop out to the shell again and run grub by hand.
Fedora's grub doesn't understand MD devices so you may need to install
boot sectors by hand.  See
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=114690 for discussion.

Supposedly the installer is smarter than just calling grub-install, but
I don't trust it and install the bootsectors myself.

# /mnt/sysimage/sbin/grub # can't remember if chroot is required
device (hd0) /dev/sda
root (hd0,0)
setup (hd0)
device (hd0) /dev/sdb
root (hd0,0)
setup (hd0)

This is a bit of a cargo-cult invocation because I don't understand grub
well enough to really know what's really going on.  I had read elsewhere
(and since forgotten the link), that the device lines make sure that
grub treats both disks as a boot disk even though sdb is not sda.

The explanation is probably rubbish, but that sequence does leave me
with two bootable disks (I can boot from either in the BIOS).


> 2) Downloaded the souce code for 2.6.11-8 recompiled the kernel with
>    RAID support included in the kernel, not as modules.

Fedora's mkinitrd process takes care of loading the necessary modules so
don't do this unless you need to.  (I had to because I bought SATA disks
and want to monitor them with SMART).

> 3) Build the partions on the second SCSI drive to match the first.
> 
> 4) Set the partition types of sd[ab]2, sd[ab]3, sd[ab]5, sd[ab]6 and
>    sd[ab]7 to 0xFD (Linux Software Raid Autodetect)

I think the rest of this may be follow on damage from the fact that you
created md devices over existing filesystems.

> 
> 5) rebooted the host, on reboot I had three mirroed partitions:
>    /dev/md0 : /dev/sda2 and /dev/sdb2
>    /dev/md1 : /dev/sda3 and /dev/sdb3
>    /dev/md2 : /dev/sda5 and /dev/sdb5
> 
>    Question 1 - why did swap and root fail to become part of the array?
>
> [snip]

--Gil
