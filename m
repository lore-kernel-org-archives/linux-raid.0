From: "Matthew (RAID)" <RAID@lists.elvey.com>
Subject: (Can I mark a RAID 1 drive as old? Move it? SCA hangs)  Troubles
   creating a reliable backup system. (1/n)
Date: Thu, 08 Jul 2004 12:32:53 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1089315173.20973.199985973@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm wondering how handle a situation.  There are several issues, would
appreciate help w/ ANY ONE of 'em.
I'm most of the way there - I've been able to use RAID to create a
backup system, but it's far from quite right.

I think I want to make the raid code consider a disk in a raid 1 array
older than another disk, and/or move arrays around, and/or resolve a
hang when I insert SCA drives into the system.

This has come up as follows: I have two hardware-identical systems, with
SCA hot-swap SCSI.
Each has 6 drives. 
sdb and sdc make up md0 (RAID1)
sdd and sde make up md1 (RAID1)
md0 and md1 make up md2 (RAID0), where all the (postgres) database files
are.
sda and sdf are RAID1 (well, they're going to be, anyway; for now I've
used dd to make a nightly copy, which is not good, for reasons I'm aware
of.)  
(Yes, to be accurate, it's partitions on the drives that make up the md
devices).

One system is an already live system serving users, the other is a warm
backup.  I call 'em LIVE and BK. 
I've been using raid to make BK a backup of LIVE.

I've been using raidtools, as that's what all the HOWTOs use; I'm not
comfortable with mdadm yet.

So, I (safely) hot pull sdb, sdd and sdf from LIVE, put them in BK, make
them redundant, and put them back in LIVE.
I'm debating not using the hot-swap feature, and trying to resolve the
problems I ran into when doing the above.

Reasons to NOT use the hot-swap feature : 
1)LIVE failed twice when I put back a drive, but never on the first
insert, and never on a removal.  The system became non-responsive, and
periodically printed output relating to a scsi bus rescan.  I'm
wondering why.  Is there a requirement to 
echo "scsi add-single-device 0 0 n 0" > /proc/scsi/scsi
after each drive is added, instead of inserting the drives and then
running this command for each drive?  I imagine not.  Anyone interested
in error logs or hardware details or have ideas on how to troubleshoot
this?
2)I won't get a consistent backup.  (This isn't actually important,
because the db will prevent corruption and any lost/partial transactions
aren't a problem because of the nature of our application, and db and
log activity are the only disk access.)

Reasons to use the hot-swap feature : 
If I add and remove drives with the sytem off, I hit a different set of
problems:
1)If the system comes up with half the drives removed, the drives get
relabled : they are always sda, sdb, and sdc.
  I could rearrange things so that it's sdd,sde,and sdf that get pulled,
  but I don't know how to do that. Hence the second question in this
  email's subject.
2)If I put back the pulled drives, when the system restarts, sometimes
these drives are chosen by the RAID code as being newer than the drives
that haven't been pulled. Hence the first question in this email's
subject.

I have to get this process down to a completely documented step-by-step
instruction list, so that someone who's clueless can follow it too.

(Points I'm aware of: Of course, sda should have been set up as RAID at
install time. And perhaps this isn't how you'd suggest backing up a
system, but it's what we're doing. And I don't connect BK to the
network; it would impersonate LIVE.)

My Linux RAID experience: I've built a 1TB NFS server using 3ware and
ATA, set up several Red Hat Enterprise Linux 3 servers with software
raid (was that a breeze!), and set up a RHEL 3 server with hardware
RAID.  I also set up several Windows systems with hardware and software
RAID.



Here's my (buggy) recipe for the swap.
(Below it is my (buggy, non-working) recipe for making sda raid1 with
sdf):

raidsetfaulty /dev/md0 /dev/sdb1
raidsetfaulty /dev/md1 /dev/sdd1
raidhotremove /dev/md0 /dev/sdb1
raidhotremove /dev/md1 /dev/sdd1
#oops - that's b,d -they're not 2,4, but 1,3!!!
echo "scsi remove-single-device 0 0 1 0" > /proc/scsi/scsi
echo "scsi remove-single-device 0 0 3 0" > /proc/scsi/scsi
#Maybe umount /dev/sdf2
echo "scsi remove-single-device 0 0 5 0" > /proc/scsi/scsi

#on BK
#Install drives: 5=>0, 2=>1, 4=>3.
#Make that Install drives: 5=>0, 1=>1, 3=>3.
#Power up.
#See what md is doing before raidhotadd.
#sfdisk sdc,sde if needed.
#mkfs not needed.
raidhotadd /dev/md0 /dev/sdc1
raidhotadd /dev/md1 /dev/sde1
dd bs=128k if=/dev/sda of=/dev/sdf
#wait for RAID arrays to recover, and copy to complete.
#first: - because we want them not to be primary on return to live!
raidsetfaulty /dev/md0 /dev/sdb1
raidsetfaulty /dev/md1 /dev/sdd1
raidhotremove /dev/md0 /dev/sdb1
raidhotremove /dev/md1 /dev/sdd1
#Power off BK and remove drives and return to live.
##echo "scsi remove-single-device 0 0 x 0" > /proc/scsi/scsi

#on live:
#Boot w/just three drives in it, or w/Disk 5 in slot 4 (to ensure that
an md1 drive is sdd (or sde).)
echo "scsi add-single-device 0 0 1 0" > /proc/scsi/scsi
raidhotadd /dev/md0 /dev/sde1 #! yes, cuz it's in slot1, but is sde for
now.

echo "scsi add-single-device 0 0 5 0" > /proc/scsi/scsi
raidhotadd /dev/md1 /dev/sdf1

#no need to mount anything.

#Final touch:
#On BK, ensure drives dupe:
#Power up, w/just 3 HDs.
#See what md is doing before raidhotadd.
#sfdisk sdc,sde if needed.
raidhotadd /dev/md0 /dev/sdc1
raidhotadd /dev/md1 /dev/sde1
dd bs=128k if=/dev/sda of=/dev/sdf
#wait for RAID arrays to recover, and copy to complete.
#Power off BK.




############################################
Here's my (buggy, non-working) recipe for making sda raid1 with sdf:
#First make a backup:
cd / ; tar czf /u1/backup2.tar.gz bin etc proc/interrupts boot home misc
usr chroot initrd  root var dev lib opt sbin tmp
raidsetfaulty, raidhotremove /dev/mdx /dev/sdxy !!!!
cat /proc/scsi/scsi ; echo measure twice and cut once.
echo "scsi remove-single-device 0 0 n 0" > /proc/scsi/scsi
swapoff /dev/sdf3
umount /dev/md3 ; umount /dev/md4 ; umount /dev/md6
raidstop /dev/md3 ; raidstop /dev/md4 ; raidstop /dev/md6
TODO (again:) **************
sfdisk /dev/sdf < /sfdisk-d--sdf
fdisk /dev/sdf
<print> ; checked - following files are just right.
#These are needed the first time. (edits to the tabfiles)
#cp /etc/raidtabToBe /etc/raidtab
#cp /etc/fstabToBe /etc/fstab
#mkdirs in /mnt are done.
mkraid /dev/md3
mkraid /dev/md3 --really-force
mkraid /dev/md4 --really-force
mkraid /dev/md6 --really-force
cat /proc/mdstat > ~/mymdstat2
cat /proc/mdstat
 mkfs -V -t ext3 -v /dev/md3
 mkfs -V -t ext3 -v /dev/md4
 mkfs -V -t ext3 -v /dev/md6
mkswap -c /dev/sdf3
swapon -a
top
<top shows the swap size changed from 2GB to 4GB>
mount /dev/md3
mount /dev/md4
mount /dev/md6
# do tmp, dev and usr separate (and boot and home MUST be separate) -
runs smoothly.
 tar cf - bin etc proc/interrupts misc ps-important sfdisk-d--sdf    
 chroot initrd mnt/floppy mnt/cdrom root boot var     lib opt sbin     |
 ( cd /mnt/raidroot ; tar\
 xf -)
 tar cf -                     usr       dev             tmp | ( cd
 /mnt/raidroot ; tar xf -)
#try this *works great* (There are no hidden files (dotfiles) in /home
or /boot; else .??* .) Don't combine lines!  * may expand in wrong
place!
cd /boot
tar cf - *  | ( cd /mnt/raidboot ; tar xf -)
cd /home
tar cf - *  | ( cd /mnt/raidhome ; tar xf -)
emacs /etc/lilo.conf
lilo -v
cp /etc/raidtabToBe /mnt/raidroot/etc/raidtab
cp /etc/fstabToBe /mnt/raidroot/etc/fstab
Undo the original edits to /etc/fstab and /etc/raidtab!
