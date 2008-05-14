From: "Henry, Andrew" <andrew.henry@logica.com>
Subject: (unknown)
Date: Wed, 14 May 2008 14:53:35 +0200
Message-ID: <3ECBDC05781B3D48ABD520A01ABF2F9B12C53D0880@SE-EX008.groupinfra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Subject: 
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm new to software RAID and this list.  I read a few months of archives to see if I found answers but only partly...

I set up a raid1 set using 2xWD Mybook eSATA discs on a Sil CardBus controller.  I was not aware of automount rules and it didn't work, and I want to wipe it all and start again but cannot.  I read the thread listed in my subject and it helped me quite a lot but not fully.  Perhaps someone would be kind enough to help me the rest of the way.  This is what I have done:

1. badblocks -c 10240 -s -w -t random -v /dev/sd[ab]
2. parted /dev/sdX mklabel msdos ##on both drives
3a. parted /dev/sdX mkpart primary 0 500.1GB ##on both drives
3b. parted /dev/sdX set 1 raid on ##on both drives
4. mdadm --create --verbose /dev/md0 --metadata=1.0 --raid-devices=2 --level=raid1 --name=backupArray /dev/sd[ab]1
5. mdadm --examine --scan | tee /etc/mdadm.conf and set 'DEVICES partitions' so that I don't hard code any devide names that may change on reboot.
6. mdadm --assemble --name=mdBackup /dev/md0 ##assemble is run during --create it seems and this was not needed.
7. cryptsetup --verbose --verify-passphrase luksFormat /dev/md0
8. cryptsetup luksOpen /dev/md0 raid500
9. pvcreate /dev/mapper/raid500
10. vgcreate vgbackup /dev/mapper/raid500
11. lvcreate --name lvbackup --size 450G vgbackup ## check PEs first with vgdisplay
12. mkfs.ext3 -j -m 1 -O dir_index,filetype,sparse_super /dev/vgbackup/lvbackup
13. mkdir /mnt/raid500; mount /dev/vgbackup/lvbackup /mnt/raid500"

This worked perfectly.  Did not test but everything lokked fine and I could use the mount.  Thought: lets see if everything comes up at boot (yes, I had edited fstab to mount /dev/vgbackup/lvbackup and set crypttab to start luks on raid500.
Reboot failed.  Fsck could not check raid device and would not boot.  Kernel had not autodetected md0.  I now know this is because superblock format 1.0 puts metadata at end of device and therefore kernel cannot autodetect.
I started a LiveCD, mounted my root lvm, removed entries from fstab/crypttab and rebooted.  Reboot was now OK.
Now I tried to wipe the array so I can re-create with 0.9 metadata superblock.
I ran dd on sd[ab] for a few hundred megs, which wiped partitions.  I removed /etc/mdadm.conf.  I then repartitioned and rebooted.  I then tried to recreate the array with:

mdadm --create --verbose /dev/md0 --raid-devices=2 --level=raid1 /dev/sd[ab]1

but it reports that the devices are already part of an array and do I want to continue??  I say yes and it then immedialtely  says "out of sync, resyncing existing array" (not exact words but I suppose you get the idea)
I reboot to kill sync and then dd again, repartition, etc ect then reboot.
Now when server comes up, fdisk reports (it's the two 500GB discs that are in the array):

[root@k2 ~]# fdisk -l

Disk /dev/hda: 80.0 GB, 80026361856 bytes
255 heads, 63 sectors/track, 9729 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/hda1   *           1          19      152586   83  Linux
/dev/hda2              20        9729    77995575   8e  Linux LVM

Disk /dev/sda: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1       60801   488384001   fd  Linux raid autodetect

Disk /dev/sdb: 320.0 GB, 320072933376 bytes
255 heads, 63 sectors/track, 38913 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       38913   312568641   83  Linux

Disk /dev/md0: 500.1 GB, 500105150464 bytes
2 heads, 4 sectors/track, 122095984 cylinders
Units = cylinders of 8 * 512 = 4096 bytes

Disk /dev/md0 doesn't contain a valid partition table

Where previously, I had /dev/sdc that was the same as /dev/sda above (ignore the 320GB, that is separate and on boot, they sometimes come up in different order).
Now, I cannot write to sda above (500GB disc) with commands: dd, mdadm -zero-superblock etc etc.  I can write to md0 with dd but what the heck happened to sdc??  Why did it become /dev/md0??
Now I read the forum thread and ran dd on beginning and end of sda and md0 with /dev/zero using seek to skip first 490GB and deleted /dev/md0 then rebooted and now I see sda but there is no sdc or md0.
I cannot see any copy of mdadm.conf in /boot and initramfs-update does not work on CentOS, but I am more used to Debian and do not know the CentOS equivalent.  I do know that I have now completely dd'ed the first 10MB and last 2MB of sda and md0 and have deleted (with rm -f) /dev/md0, and now *only* /dev/sda (plus internal had and extra 320GB sdb) shows up in fdisk -l:  There is no md0 or sdc.

So after all that rambling, my question is:

Why did /dev/md0 appear in fdisk -l when it had previously been sda/sdb even after successfully creating my array before reboot?
How do I remove the array?  Have I now done everything to remove it?
I suppose (hope) that if I go to the server and power cycle it and the esata discs, my sdc probably will appear again ( I have not done this yet-no chance today) but why does it not appear after a soft reboot after having dd'd /dev/md0?


andrew henry
Oracle DBA

infra solutions|ao/bas|dba
Logica
