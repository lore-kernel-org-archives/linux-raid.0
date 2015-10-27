From: Doug Herr <gmane@wombatz.com>
Subject: Re: Replacing a RAID1 drive that has not failed.
Date: Tue, 27 Oct 2015 16:45:23 +0000 (UTC)
Message-ID: <n0o9n3$gmk$2@ger.gmane.org>
References: <n0mbam$gmk$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks to both Wol and Eddie for pointing me to the --replace option and 
for not simply telling me to RTFM.  Part of my confusion was based on my 
last attempt (years back) to find out if three drive RAID 1 was even an 
option.  Just as before I found stuff that laughed at the mere idea of a 
three drive mirror.  Seems people were getting too tied up on the word 
"mirror", which is not really a proper name for it in my view.  The 
mirror copy of myself when looking into a mirror is *not* the same in me 
in so many ways.  Oh, and now I think I understand that hardware RAID 
rarely or never allows it but Linux md RAID has it now and maybe had it 
the whole time.

That said, I really should have slogged thru the man page better.  It 
does seem that --replace includes the key feature that I want:

"the  device remains  in  service  during the recovery process to 
increase resilience against multiple failures."


So, just in case somebody wants to see if they can find anything I 
missed, here is my current plan...


 1. Partition new drive (plugged in via external SATA dock)
#fdisk /dev/sdc
(make it an exact match of sda/sdb unless it turns out to be smaller,
 in which case I can shrink /boot to make room.)

 2. Replace sda partition with sdc partition for each RAID.
(Could do all at once but feels safer to do one at a time.)
#mdadm /dev/md123 --replace /dev/sda7 --with /dev/sdc7
#watch /proc/mdstat
#mdadm /dev/md125 --replace /dev/sda6 --with /dev/sdc6
#watch /proc/mdstat
#mdadm /dev/md126 --replace /dev/sda3 --with /dev/sdc3
#watch /proc/mdstat
#mdadm /dev/md1 --replace /dev/sda5 --with /dev/sdc5
#watch /proc/mdstat
#mdadm /dev/md4 --replace /dev/sda2 --with /dev/sdc2
#watch /proc/mdstat

 3. All RAIDs should be "active" and in "[UU]" status, with no sda partitions.
#cat /proc/mdstat

(Consider if this should only be done later/never so that sda can 
 be a form of backup in case of issues during the post replace reboot.)
 4. Prevent the old partitions from ever being pulled into the RAIDs.
#mdadm --zero-superblock /dev/sda7
#mdadm --zero-superblock /dev/sda6
#mdadm --zero-superblock /dev/sda3
#mdadm --zero-superblock /dev/sda5
#mdadm --zero-superblock /dev/sda2

 5. Make a new /boot on sdc.
(using rsync since the language is taken from my daily cron and this is a 
 tad quicker if I end up running it more than once.)
(fstab line needing update: UUID=52b14d98-b284-41a0-a36f-459ae3ae12a7 /boot ext4 defaults 1 2)
#mkfs.ext4 /dev/sdc1
#mkdir /bootnew
#mount /dev/sdc1 /bootnew
#rsync -a --delete /boot/ /bootnew
#grub-install /dev/sdc
#blkid /dev/sdc1
#vim /etc/fstab
#umount /bootnew ; rmdir /bootnew

 6. Power down and swap sdc into sda "slot".

 7. Make sure that all RAIDs are "active" and in "[UU]" status:
#cat /proc/mdstat




-- 
Doug Herr 

