From: George Rapp <george.rapp@gmail.com>
Subject: RAID 6 "Failed to restore critical section for reshape, sorry." -
 recovery advice?
Date: Wed, 9 Dec 2015 18:12:58 -0500
Message-ID: <CAF-Kpgb57-LoNy=-jy76ZcE=YPABmARzfsHNitJNZyw3v2AShw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello RAID folks -

Reference my old thread at
http://marc.info/?l=linux-raid&m=143880359028232&w=2 which I'm just
now getting back around to working on, the delay having been caused by
my need to clone a failing disk.

Recall that I was attempting to grow a 5-disk RAID 6 array to 6 disks,
but writing to the backup-file was inhibited by SELinux.

# mdadm --add /dev/md4 /dev/sdi1
# mdadm --grow --raid-devices=6
--backup-file=/home/gwr/2015/2015-08/grow_md4.bak /dev/md4

The second command threw a bunch of SELinux errors about access to
/home/gwr/c/grow_md4.bak. The reshape operation sat for many minutes
at 0% progress, according to /proc/mdstat. However, the file
/home/gwr/c/grow_md4.bak *was* created with a size of 6295552 bytes/

I appeared to experience a segmentation fault or other runtime error
when attempting to stop the RAID 6 array with "#mdadm --stop
/dev/md4". System log from that situation has been uploaded to
https://app.box.com/s/3pksam3c7n79anpnzvsrwekzqwtsvlf6 Notably, the
backup file was created, but contains all zero/null characters.

My most recent raid.status file (generated using command "# mdadm
--examine /dev/sd[cdg]4 /dev/sd[hij]1" - and, yes, I know my partition
layout is a mess) has been uploaded to
https://app.box.com/s/pbienbpdanr0rq224b9ag2qu36vk76iv What I find
interesting about this status file is that the reshape of the array
appears to have made no progress (note the presence of " Reshape pos'n
: 0 " on all six devices).

I have been using the recovery advice found at
https://raid.wiki.kernel.org/index.php/RAID_Recovery and
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID,
especially the part about creating overlay files so as not to damage
my actual disks. The overlay devices are in the variable $OVERLAYS.

When I attempt to assemble the RAID 6 array using the backup file, I get this:

# mdadm --assemble --verbose --force
--backup-file=/home/gwr/2015/2015-08/grow_md6.bak /dev/md4 $OVERLAYS
mdadm: looking for devices for /dev/md4
mdadm: /dev/mapper/sdg4 is identified as a member of /dev/md4, slot 2.
mdadm: /dev/mapper/sdi1 is identified as a member of /dev/md4, slot 5.
mdadm: /dev/mapper/sdc4 is identified as a member of /dev/md4, slot 1.
mdadm: /dev/mapper/sdh1 is identified as a member of /dev/md4, slot 3.
mdadm: /dev/mapper/sdj1 is identified as a member of /dev/md4, slot 4.
mdadm: /dev/mapper/sdd4 is identified as a member of /dev/md4, slot 0.
mdadm: /dev/md4 has an active reshape - checking if critical section
needs to be restored
mdadm: No backup metadata on /home/gwr/2015/2015-08/grow_md6.bak
mdadm: Failed to find backup of critical section
mdadm: Failed to restore critical section for reshape, sorry.

and when I omit the backup file, I get this:

# mdadm --assemble --verbose --force --invalid-backup /dev/md4 $OVERLAYS
mdadm: looking for devices for /dev/md4
mdadm: /dev/mapper/sdg4 is identified as a member of /dev/md4, slot 2.
mdadm: /dev/mapper/sdi1 is identified as a member of /dev/md4, slot 5.
mdadm: /dev/mapper/sdc4 is identified as a member of /dev/md4, slot 1.
mdadm: /dev/mapper/sdh1 is identified as a member of /dev/md4, slot 3.
mdadm: /dev/mapper/sdj1 is identified as a member of /dev/md4, slot 4.
mdadm: /dev/mapper/sdd4 is identified as a member of /dev/md4, slot 0.
mdadm: /dev/md4 has an active reshape - checking if critical section
needs to be restored
mdadm: Failed to find backup of critical section
mdadm: continuing without restoring backup
mdadm: added /dev/mapper/sdc4 to /dev/md4 as 1
mdadm: added /dev/mapper/sdg4 to /dev/md4 as 2
mdadm: added /dev/mapper/sdh1 to /dev/md4 as 3
mdadm: added /dev/mapper/sdj1 to /dev/md4 as 4
mdadm: added /dev/mapper/sdi1 to /dev/md4 as 5
mdadm: added /dev/mapper/sdd4 to /dev/md4 as 0
mdadm: /dev/md4: Need a backup file to complete reshape of this array.
mdadm: Please provided one with "--backup-file=..."

I even tried --update=revert-reshape; no luck:

# mdadm --assemble --verbose --invalid-backup --force
--update=revert-reshape /dev/md4 $OVERLAYS
mdadm: looking for devices for /dev/md4
mdadm: /dev/mapper/sdg4 is identified as a member of /dev/md4, slot 2.
mdadm: /dev/mapper/sdi1 is identified as a member of /dev/md4, slot 5.
mdadm: /dev/mapper/sdc4 is identified as a member of /dev/md4, slot 1.
mdadm: /dev/mapper/sdh1 is identified as a member of /dev/md4, slot 3.
mdadm: /dev/mapper/sdj1 is identified as a member of /dev/md4, slot 4.
mdadm: /dev/mapper/sdd4 is identified as a member of /dev/md4, slot 0.
mdadm: /dev/md4 has an active reshape - checking if critical section
needs to be restored
mdadm: Failed to find backup of critical section
mdadm: continuing without restoring backup
mdadm: added /dev/mapper/sdc4 to /dev/md4 as 1
mdadm: added /dev/mapper/sdg4 to /dev/md4 as 2
mdadm: added /dev/mapper/sdh1 to /dev/md4 as 3
mdadm: added /dev/mapper/sdj1 to /dev/md4 as 4
mdadm: added /dev/mapper/sdi1 to /dev/md4 as 5
mdadm: added /dev/mapper/sdd4 to /dev/md4 as 0
mdadm: /dev/md4: Need a backup file to complete reshape of this array.
mdadm: Please provided one with "--backup-file=..."
mdadm: (Don't specify --update=revert-reshape again, that part succeeded.)


How can the array have an active reshape if the reshape pos'n is 0 on
all devices? Doesn't that mean that the reshape never actually
started? If so, can I just revert -- somehow -- to a 5-device RAID 6
array to recover my data?

Thanks.

-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
LinkedIn profile: https://www.linkedin.com/in/georgerapp
Phone: +1 740 936 RAPP (740 936 7277)
