From: Nathan Shearer <mail@nathanshearer.ca>
Subject: Re: Failed to find backup of critical section
Date: Sun, 01 Sep 2013 04:25:44 -0600
Message-ID: <52231628.1030200@nathanshearer.ca>
References: <5223012C.2090207@nathanshearer.ca> <20130901192149.6f119180@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130901192149.6f119180@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Sun, 01 Sep 2013 02:56:12 -0600 Nathan Shearer<mail@nathanshearer.ca>
> wrote:
>
>> Hi, I've run into a problem recovering my array from a server power
>> failure. I'll try to keep it short so here is a sequence of events:
>>
>>   1. Running a healthy 4-disk RAID5 array (on server-01).
>>   2. Added a 5th drive and grow the array to a 5-disk RAID6 array (backup
>>      file stored on a separate RAID1 array on other disks)
>>   3. Grow begins and passes the critical section, gets to ~15% complete
>>      and power to the server fails
> When growing a 4-disk RAID5 to a 5-disk RAID6 the entire process is in the
> "critical section".  This is because it is always writing to location where
> live data is.
> When increasing the number of data drives there is a short critical section
> at the start.
> When decreasing the number of data drives there is a short critical section
> at the end.
> But when you don't change the number of data drives as in this case, it is
> all critical and all needs a backup.
>
>>   4. I then move all 5 drives to backup server. The RAID5/6 array
>>      assembles and grow continues (without backup file since it's on
>>      server-01)
> That shouldn't work.  It shouldn't start without the backup file.
>
>>   5. I begin copying data off of that array onto a separate array --
>>      filesystem and data is consistent :)
>>   6. Power restored to server-01
>>   7. Safely stop the growing array with mdadm --stop
>>   8. Move 5 drives back into server-01
>>   9. Attempt mdadm --assemble and I get:
>>      # mdadm --assemble /dev/md9
>>      mdadm: Failed to restore critical section for reshape, sorry.
>>             Possibly you needed to specify the --backup-file
> That should have happened on server-02
>
>> 10. Attempt with the original backup file:
>>      # mdadm --assemble /dev/md9 --backup-file
>>      /mnt/temp/raid-reshape-backup-file
>>      mdadm: Failed to restore critical section for reshape, sorry.
>>
>> So when I enable --verbose I get:
>>
>>      mdadm:/dev/md9 has an active reshape - checking if critical section
>>      needs to be restored
>>      mdadm: Failed to find backup of critical section
>>      mdadm: Failed to restore critical section for reshape, sorry.
>>             Possibly you needed to specify the --backup-file
>>
>> When I provide the backup file I get:
>>
>>      mdadm:/dev/md9 has an active reshape - checking if critical section
>>      needs to be restored
>>      mdadm: too-old timestamp on backup-metadata on
>>      /mnt/temp/raid-reshape-backup-file
>>      mdadm: Failed to find backup of critical section
>>      mdadm: Failed to restore critical section for reshape, sorry.
>>
>> When I tell it to use the "old" backup file I get:
>>
>>      # export MDADM_GROW_ALLOW_OLD=1
>>      # mdadm --assemble /dev/md9 -vv --backup-file
>>      /mnt/temp/raid-reshape-backup-file
>>      mdadm:/dev/md9 has an active reshape - checking if critical section
>>      needs to be restored
>>      mdadm: accepting backup with timestamp 1377794387 for array with
>>      timestamp 1377904444
>>      mdadm: backup-metadata found on /mnt/temp/raid-reshape-backup-file
>>      but is not needed
>>      mdadm: Failed to find backup of critical section
>>      mdadm: Failed to restore critical section for reshape, sorry.
>>
>> OK, so the backup file is not needed. I assume this is because the
>> critical section was passed long ago, but then why is it attempting to
>> find and restore the backup file when it is provided and also not
>> needed? I have not tried a --force because I don't want to trash my
>> array if there is another better option that I can still try. Any ideas?
>> Is this potentially a bug in mdadm where this kind of array state is not
>> expected?
>>
> The content of the backup file is not needed as it is (presumably) before the
> place where the reshape has proceeded to.
>
> The backup is only needed after an unclean shutdown.  Presumably you had an
> unclean shutdown when server-01 lost power, so that could have resulted in
> corruption and shouldn't have restarted easily on server-02.
>
> However as the shutdown on server-02 was clean there would be no further
> corruption.
> You can start the array by giving a backup file (it can be empty) and
> specifying  --invalid-backup.  This  tells mdadm not to bother if it cannot
> restore the critical section but to just keep going.
>
> NeilBrown
>
>
I must be confused on the order of events then -- it's been a busy week. 
Just for the record (in case anybody else runs into a similar problem 
searching the e-mail archive), the --invalid-backup option did start the 
array for me. I used the original backup file that was created instead 
of creating a blank one like Neil suggested.

    # mdadm --assemble /dev/md3 --backup-file
    /root/raid-reshape-backup-file --invalid-backup --verbose
    mdadm: looking for devices for /dev/md3
    mdadm: /dev/sdf3 is identified as a member of /dev/md3, slot 0.
    mdadm: /dev/sde3 is identified as a member of /dev/md3, slot 1.
    mdadm: /dev/sdd3 is identified as a member of /dev/md3, slot 3.
    mdadm: /dev/sdc3 is identified as a member of /dev/md3, slot 2.
    mdadm: /dev/sdb3 is identified as a member of /dev/md3, slot 4.
    mdadm:/dev/md3 has an active reshape - checking if critical section
    needs to be restored
    mdadm: accepting backup with timestamp 1377794387 for array with
    timestamp 1377904444
    mdadm: backup-metadata found on /root/raid-reshape-backup-file but
    is not needed
    mdadm: Failed to find backup of critical section
    mdadm: continuing without restoring backup
    mdadm: added /dev/sde3 to /dev/md3 as 1
    mdadm: added /dev/sdc3 to /dev/md3 as 2
    mdadm: added /dev/sdd3 to /dev/md3 as 3
    mdadm: added /dev/sdb3 to /dev/md3 as 4
    mdadm: added /dev/sdf3 to /dev/md3 as 0
    mdadm: /dev/md3 has been started with 4 drives (out of 5) and 1
    rebuilding.
    # cat /proc/mdstat
    Personalities : [raid1] [raid6] [raid5] [raid4]
    md3 : active raid6 sdf3[5] sdb3[6] sdd3[4] sdc3[2] sde3[1]
           8587336140 blocks super 1.2 level 6, 4k chunk, algorithm 18
    [5/4] [UUUU_]
           [==========>..........]  reshape = 54.8%
    (1570055672/2862445380) finish=9347.2min speed=2304K/sec

    unused devices: <none>

