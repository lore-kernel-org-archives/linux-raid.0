From: David Greaves <david@dgreaves.com>
Subject: Re:
Date: Wed, 14 May 2008 22:13:36 +0100
Message-ID: <482B5600.6040204@dgreaves.com>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B12C53D0880@SE-EX008.groupinfra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3ECBDC05781B3D48ABD520A01ABF2F9B12C53D0880@SE-EX008.groupinfra.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Henry, Andrew" <andrew.henry@logica.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Henry, Andrew wrote:
> I'm new to software RAID and this list.  I read a few months of archives to see if I found answers but only partly...
OK - good idea to start with a simple setup then... oh, wait...

> 1. badblocks -c 10240 -s -w -t random -v /dev/sd[ab]
fine
> 2. parted /dev/sdX mklabel msdos ##on both drives
> 3a. parted /dev/sdX mkpart primary 0 500.1GB ##on both drives
> 3b. parted /dev/sdX set 1 raid on ##on both drives
no point setting raid type since autodetect is not needed
> 4. mdadm --create --verbose /dev/md0 --metadata=1.0 --raid-devices=2 --level=raid1 --name=backupArray /dev/sd[ab]1
a mirror - so the same data/partitions should go to /dev/sda1 /dev/sdb1
> 5. mdadm --examine --scan | tee /etc/mdadm.conf and set 'DEVICES partitions' so that I don't hard code any devide names that may change on reboot.
hmm - on my Debian box I'd get /dev/md/backupArray as the device name I think -
I override this though

> 6. mdadm --assemble --name=mdBackup /dev/md0 ##assemble is run during --create it seems and this was not needed.
> 7. cryptsetup --verbose --verify-passphrase luksFormat /dev/md0
> 8. cryptsetup luksOpen /dev/md0 raid500
good luck with that
> 9. pvcreate /dev/mapper/raid500
> 10. vgcreate vgbackup /dev/mapper/raid500
> 11. lvcreate --name lvbackup --size 450G vgbackup ## check PEs first with vgdisplay
and that...


Seriously, they should work fine - but not a lot of people do this kind of thing
and there may be issues layering this many device layers (eg ISTR a suggestion
that 4K stacks may not be good). Be prepared to submit bug reports and have good
backups.

> 12. mkfs.ext3 -j -m 1 -O dir_index,filetype,sparse_super /dev/vgbackup/lvbackup
Well, I suppose you could have partitioned the lvm volume and used XFS and a
separate journal for maximum complexity <grin>

> 13. mkdir /mnt/raid500; mount /dev/vgbackup/lvbackup /mnt/raid500"
> This worked perfectly.  Did not test but everything lokked fine and I could use the mount.  Thought: lets see if everything comes up at boot (yes, I had edited fstab to mount /dev/vgbackup/lvbackup and set crypttab to start luks on raid500.
> Reboot failed.
I suspect you mean that the filesystem wasn't mounted.
Do you really mean that the machine wouldn't boot - that's bad - you may have
blatted some bootsector somewhere.
Raid admin does not need you to use dd or hack at disk partitions any more than
mkfs does.

> Fsck could not check raid device and would not boot.  Kernel had not
autodetected md0.  I now know this is because superblock format 1.0 puts
metadata at end of device and therefore kernel cannot autodetect.
Technically it's not the sb location that prevents the kernel autodetecting -
it's a design decision that only supports autodetect for v0.9
You don't need autodetect - if you wanted an encrypted lvm root fs then you'd
need an initrd anyhow.
Just make sure you're using a distro that 'does the right thing' and assembles
arrays according to your mdadm.conf at rc?.d time
(nb what distro/kernel are you using)

> I started a LiveCD, mounted my root lvm, removed entries from fstab/crypttab and rebooted.  Reboot was now OK.
> Now I tried to wipe the array so I can re-create with 0.9 metadata superblock.
mdadm --zero-superblock
> I ran dd on sd[ab] for a few hundred megs, which wiped partitions.  I removed /etc/mdadm.conf.  I then repartitioned and rebooted.  I then tried to recreate the array with:
which failed since the sb is at the end of the device
http://linux-raid.osdl.org/index.php/Superblock

> mdadm --create --verbose /dev/md0 --raid-devices=2 --level=raid1 /dev/sd[ab]1
> 
> but it reports that the devices are already part of an array and do I want to continue??  I say yes and it then immedialtely  says "out of sync, resyncing existing array" (not exact words but I suppose you get the idea)
> I reboot to kill sync and then dd again, repartition, etc ect then reboot.
> Now when server comes up, fdisk reports (it's the two 500GB discs that are in the array):
This is all probably down to randomly dd'ing the disks/partitions...
> 
> [root@k2 ~]# fdisk -l
> 
> Disk /dev/hda: 80.0 GB, 80026361856 bytes
> 255 heads, 63 sectors/track, 9729 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/hda1   *           1          19      152586   83  Linux
> /dev/hda2              20        9729    77995575   8e  Linux LVM
> 
> Disk /dev/sda: 500.1 GB, 500107862016 bytes
> 255 heads, 63 sectors/track, 60801 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1               1       60801   488384001   fd  Linux raid autodetect
> 
> Disk /dev/sdb: 320.0 GB, 320072933376 bytes
> 255 heads, 63 sectors/track, 38913 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1               1       38913   312568641   83  Linux


Err, this ^^^ is a 320GB drive. You said 2 500Gb drives...
Mirroring them will work but it will (silently-ish) only use the first 320Gb


> 
> Disk /dev/md0: 500.1 GB, 500105150464 bytes
> 2 heads, 4 sectors/track, 122095984 cylinders
> Units = cylinders of 8 * 512 = 4096 bytes
and somehow md0 is sized at 500Gb

what does /proc/mdstat say?

> Disk /dev/md0 doesn't contain a valid partition table
> 
> Where previously, I had /dev/sdc that was the same as /dev/sda above (ignore the 320GB, that is separate and on boot, they sometimes come up in different order).
So what kernel/distro did you use for the liveCD/main OS?

> Now, I cannot write to sda above (500GB disc) with commands: dd, mdadm -zero-superblock etc etc.  I can write to md0 with dd but what the heck happened to sdc??  Why did it become /dev/md0??
> Now I read the forum thread and ran dd on beginning and end of sda and md0 with /dev/zero using seek to skip first 490GB and deleted /dev/md0 then rebooted and now I see sda but there is no sdc or md0.
What's /dev/sdc?

> I cannot see any copy of mdadm.conf in /boot and initramfs-update does not work on CentOS, but I am more used to Debian and do not know the CentOS equivalent.  I do know that I have now completely dd'ed the first 10MB and last 2MB of sda and md0 and have deleted (with rm -f) /dev/md0, and now *only* /dev/sda (plus internal had and extra 320GB sdb) shows up in fdisk -l:  There is no md0 or sdc.
> 
> So after all that rambling, my question is:
> 
> Why did /dev/md0 appear in fdisk -l when it had previously been sda/sdb even after successfully creating my array before reboot?
fdisk -l looks at all the devices for partitions.
sdc isn't there (hardware failure?)

> How do I remove the array?  Have I now done everything to remove it?
mdadm --stop
> I suppose (hope) that if I go to the server and power cycle it and the esata discs, my sdc probably will appear again ( I have not done this yet-no chance today) but why does it not appear after a soft reboot after having dd'd /dev/md0?


Got to admit - I'm confused....


Go and try to make a simple ext3 on a mirror of your 2 500Gb drives. No 'dd'
required.
Once you have that working try playing with mdadm.
Then encrypt it and layer ext3 on that.
I have no idea what you're trying to achieve with lvm - do you need it?

Have a good luck here too : http://linux-raid.osdl.org/

David

