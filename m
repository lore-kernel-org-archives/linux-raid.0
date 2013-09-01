From: Nathan Shearer <mail@nathanshearer.ca>
Subject: Failed to find backup of critical section
Date: Sun, 01 Sep 2013 02:56:12 -0600
Message-ID: <5223012C.2090207@nathanshearer.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, I've run into a problem recovering my array from a server power 
failure. I'll try to keep it short so here is a sequence of events:

 1. Running a healthy 4-disk RAID5 array (on server-01).
 2. Added a 5th drive and grow the array to a 5-disk RAID6 array (backup
    file stored on a separate RAID1 array on other disks)
 3. Grow begins and passes the critical section, gets to ~15% complete
    and power to the server fails
 4. I then move all 5 drives to backup server. The RAID5/6 array
    assembles and grow continues (without backup file since it's on
    server-01)
 5. I begin copying data off of that array onto a separate array --
    filesystem and data is consistent :)
 6. Power restored to server-01
 7. Safely stop the growing array with mdadm --stop
 8. Move 5 drives back into server-01
 9. Attempt mdadm --assemble and I get:
    # mdadm --assemble /dev/md9
    mdadm: Failed to restore critical section for reshape, sorry.
           Possibly you needed to specify the --backup-file
10. Attempt with the original backup file:
    # mdadm --assemble /dev/md9 --backup-file
    /mnt/temp/raid-reshape-backup-file
    mdadm: Failed to restore critical section for reshape, sorry.

So when I enable --verbose I get:

    mdadm:/dev/md9 has an active reshape - checking if critical section
    needs to be restored
    mdadm: Failed to find backup of critical section
    mdadm: Failed to restore critical section for reshape, sorry.
           Possibly you needed to specify the --backup-file

When I provide the backup file I get:

    mdadm:/dev/md9 has an active reshape - checking if critical section
    needs to be restored
    mdadm: too-old timestamp on backup-metadata on
    /mnt/temp/raid-reshape-backup-file
    mdadm: Failed to find backup of critical section
    mdadm: Failed to restore critical section for reshape, sorry.

When I tell it to use the "old" backup file I get:

    # export MDADM_GROW_ALLOW_OLD=1
    # mdadm --assemble /dev/md9 -vv --backup-file
    /mnt/temp/raid-reshape-backup-file
    mdadm:/dev/md9 has an active reshape - checking if critical section
    needs to be restored
    mdadm: accepting backup with timestamp 1377794387 for array with
    timestamp 1377904444
    mdadm: backup-metadata found on /mnt/temp/raid-reshape-backup-file
    but is not needed
    mdadm: Failed to find backup of critical section
    mdadm: Failed to restore critical section for reshape, sorry.

OK, so the backup file is not needed. I assume this is because the 
critical section was passed long ago, but then why is it attempting to 
find and restore the backup file when it is provided and also not 
needed? I have not tried a --force because I don't want to trash my 
array if there is another better option that I can still try. Any ideas? 
Is this potentially a bug in mdadm where this kind of array state is not 
expected?

-- 
*Nathan Shearer*
www.nathanshearer.ca
403 393 6789

