From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Persistent superblock error
Date: Mon, 25 Oct 2004 16:41:54 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410252041.i9PKfxN26881@www.watkins-home.com>
References: <417D4497.7090606@atmos.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <417D4497.7090606@atmos.colostate.edu>
To: 'Saurabh Barve' <sa@atmos.colostate.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry, man page really is confusing.  I correct this with little thought
when I run into it.  I do recall someone else having issues with the man
page, I disagreed with him.  Maybe he was correct!

"mdadm -C /dev/md0 -c 64 -l raid5 -p left-symmetric -n 4 /dev/hdc1 missing
/dev/hdg1 /dev/hdh1"

As you can see from the man page, mode is optional and -C is an option.
Options are listed after the raiddevice.  But in this case the option "-C"
must be listed before the raiddevice.  I also have an old mdadm.  It may be
more readable in newer versions.

From man page:
       mdadm [mode] <raiddevice> [options] <component-devices>

MODES
       mdadm has 6 major modes of operation:
       Assemble
<snip>

OPTIONS
       Available options are:

       -A, --assemble
              Assemble a pre-existing array.

       -B, --build
              Build a legacy array without superblocks.

       -C, --create
<snip>

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Saurabh Barve
Sent: Monday, October 25, 2004 2:23 PM
To: Guy
Cc: linux-raid@vger.kernel.org
Subject: Re: Persistent superblock error

Hi Guy.

I am still having problems. I'm sorry; I'm new to mdadm :(

I tried running the mdadm command you told me :

mdadm /dev/md0 -C -c 64 -l raid5 -p left-symmetric -n 4 /dev/hdc1 
missing /dev/hdg1 /dev/hdh1

However, it gave me the error:
mdadm: -C would set mode to create, but it is already manage.

mdadm --examine /dev/md0 gives the message "mdadm: /dev/md0 is too small 
for md".

mdadm --detail --test /dev/md0 gives the message "mdadm: md device 
/dev/md0 does not appear to be active".

fdisk is unable to read /dev/md0, and fsck exits with the following error:
---------
fsck.ext3: Invalid argument while trying to open /dev/md0

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
     e2fsck -b 8193 <device>
---------

How do I get out of the manage mode, and force mdadm into the create mode?

Saurabh.

Guy wrote:
> Ok, to preserve the data, when you create a new array you must use the
same
> parameters as before.  If you get the order of the disks, block size, or
> layout wrong then the creation of the parity will overwrite previous data.
> 
> It would have been best to assemble the array with 1 disk missing.  Then
the
> re-sync would not occur, and if the data was bad you could try again after
> correcting your mistake.  I think a create with 1 disk missing would also
be
> safe, but that would change the super block.  I have never needed to
create
> over a previous array where I wanted to retail the data.  Even with a
> create, if you did it wrong, you could just stop the array and create it
> again with the correct options, if you keep a disk missing each time.
> 
> Since you did a create, I assume the re-sync started.  As I said, this
would
> not damage your data if the parameters were the same as the previous
array.
> If you had anything different the re-sync trashed some of your data,
enough
> that I don't think you can recover.  Since the fsck could not recognize
the
> filesystem I believe you are out of luck.
> 
> I don't understand why "mdadm --detail" gives errors if you did a create.
> Even an assemble should look better than what you show.
> 
> Now let's pretend your data is still there.  :)
> If this is the case you must have done the create with the parameters
wrong.
> If this is the correct listing of your array when it was working:
> raiddev /dev/md0
> 
>>         raid-level              5
>>         nr-raid-disks           4
>>         nr-spare-disks          0
>>         persistent-superblock   1
>>         parity-algorithm        left-symmetric
>>         chunk-size              64
>>         device                  /dev/hdc1
>>         raid-disk               0
>>         device                  /dev/hdd1
>>         raid-disk               1
>>         device                  /dev/hdg1
>>         raid-disk               2
>>         device                  /dev/hdh1
>>         raid-disk               3
> 
> 
> then try this mdadm command:
> 
> mdadm /dev/md0 -C -c 64 -l raid5 -p left-symmetric -n 4 /dev/hdc1
/dev/hdd1
> /dev/hdg1 missing
> or
> mdadm /dev/md0 -C -l raid5 -n 4 /dev/hdc1 /dev/hdd1 /dev/hdg1 missing
> 
> -c 64 is the default
> -p left-symmetric is the default
> 
> We leave 1 disk missing so that a re-sync can't happen.  If for some
reason
> you think you know which disk is least likely to have the correct data,
then
> make that disk missing.  Example:  hdd1 maybe had the most bad spots when
> doing the ddrescue command.  This disk should be left "missing".
> 
> mdadm /dev/md0 -C -c 64 -l raid5 -p left-symmetric -n 4 /dev/hdc1 missing
> /dev/hdg1 /dev/hdh1
> 
> You must maintain the order and position of the disks.
> 
> If this does not yield good data, stop the array and try again with a
> different missing disk.  Since you had 2 disks go bad, I think it is a
safe
> bet that the 2 disks that did not fail have good data.  So no need to try
> them as missing.
> 
> I am making some of this up as I go along!  But I have had to do something
> similar.  This part is confusing and not really worth reading unless you
> like scary stories!  I did not have a backup!  ---  I had a disk fail.
Just
> a read error I think.  The re-sync to the spare worked.  Since this
happens
> when you get a read error, I did a remove and add of the failed disk, it
was
> now the spare.  I then failed the previous spare so the data would be put
> back to the failed disk which is now the spare.  (This is a normal event
for
> me.  I have a read error on 1 of my 14 disks 2 to 4 time per year.  The
disk
> is not really bad, it just need to re-locate the bad sector.)  Then while
> the spare was re-syncing other disks on the same SCSI bus failed.  The
disk
> had more than a bad sector, and I guess the bad disk affected the bus.  My
> array went down.  To verify that each disk was good or bad I used dd and
it
> did effect the other disks.  I unplugged the bad disk and now the other
> disks were fine.  I replaced the disk and partitioned the disk.  So I did
an
> assemble with the force option (since I had about 4 failed disks).  Then
> failed the old spare again.  The re-sync failed again.  The new disk
seemed
> bad.  I need SCSI adapters to use my SCA-80 disks, so I determined the
> SCSI-68/SCA-80 adapter was bad.  I replaced it.  I did another assemble
with
> the force option, the system decided the new disk was more current than
> another disk, so the other disk was being re-built based on the new disk.
I
> noticed this after the fsck did not work very well.  I stopped the array.
I
> did an assemble with the disk that was just trashed marked as missing and
> did not list the new disk, but I did list the old spare which is now good.
> Now the array worked just fine.  I did an add of the trashed disk, after
the
> re-sync the array was in good shape.  I added the new disk as a spare,
then
> failed the old spare.  The re-sync went fine.  I removed and added the old
> spare, it is now the spare again.  I did not need to keep the same disk as
> the spare, but by doing so I know the logical order of my 14 disks (plus
> spare).  I anyone understands the above mess, let me know!
> 
> I don't know of any hardware RAID that would allow you to correct a
problem
> like that.  The support group would just say your data is gone, sorry,
> restore from your backup.  Have a nice day!  And I have had an HP FC-60
that
> had a similar problem caused by a read error during a re-sync after
another
> disk failed.  ddrescue could have helped, but no such access to the disks.
> Have a nice day!
> 
> Anyway, I hope this helps!  Have a nice day!
> 
> Guy
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Saurabh Barve
> Sent: Thursday, October 21, 2004 10:07 PM
> To: Guy
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Persistent superblock error
> 
> OK. Maybe I wasn't clear enough. This is from my earlier post 
> (http://marc.theaimsgroup.com/?l=linux-raid&m=109753064507208&w=2):
> 
> I am running a server that has four 250 GB hard drives in a RAID 5 
> configuration. Recently, two of the hard drives failed. I copied the 
> data bitwise from one of the failed hard drives (/dev/hdc1) to another 
> (/dev/hdd1) using dd_rescue 
> (http://www.garloff.de/kurt/linux/ddrescue/). The failed hard drive had 
> about 300 bad blocks (I checked using the badblocks utility).
> 
> I tried to use the two new disks to recover the RAID data working on an 
> assumption in the post:
> http://www.spinics.net/lists/raid/msg03502.html
> 
> However, that didn't seem to work. I'd like to recover the data if 
> possible, but I'm pretty sure I had all of it backed up. So, I just 
> tried to force the creation of the array using mkraid /dev/md0 
> --really-force. That seemed to give me problems when running fsck, so I 
> rebooted the server and tried creating the array using mdadm.
> 
> That is when I was getting the errors. Hopefully, this made things a 
> bit clearer.
> 
> If you think I'm spamming on the list, you can mail me at 
> sa@atmos.colostate.edu.
> 
> Thanks,
> Saurabh.
> 
> On Oct 21, 2004, at 6:57 PM, Guy wrote:
> 
> 
>>You said: "Any advice on why my RAID array will not run?"
>>Yes, you have 2 failed disks!
>>
>>     Number   Major   Minor   RaidDevice State
>>        0      22        1        0      active sync   /dev/hdc1
>>        1      22       65        1      faulty   /dev/hdd1
>>        2       0        0        2      faulty removed
>>        3      34       65        3      active sync   /dev/hdh1
>>
>>        4      34        1        4      spare   /dev/hdg1
>>
>>
>>If you replaced 2 disks from a RAID5, then the data is lost!
>>Are you sure this is what you wanted to do?
>>
>>How did you assemble with 2 failed/replaced disks?
>>
>>I am confused.  Based on the output of "mdadm --detail", the array 
>>should be
>>down.
>>
>>Do you want to recover the data?
>>If yes then
>>	If you hope to save the data stop doing stuff!
>>	And don't lose the failed disks!  They may not be bad.
>>	And label them so you know which is which, if not too late!
>>	If both disks are really bad (unreadable), then the data is gone.
>>	Post another message with the status of the failed disks.
>>If no then
>>	Just recreate the array with the current disks and move on.
>>	Use mkfs to create a new filesystem.
>>
>>Guy
>>	
>>
>>-----Original Message-----
>>From: linux-raid-owner@vger.kernel.org
>>[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Saurabh Barve
>>Sent: Thursday, October 21, 2004 6:55 PM
>>To: linux-raid@vger.kernel.org
>>Subject: Persistent superblock error
>>
>>Hi,
>>
>>I recently lost 2 hard drives in my 4-drive RAID-5 array. I replaced 
>>the
>>two faulty hard drives and tried rebuilding the array. However, I
>>continue to get errors.
>>
>>I created the raid array using madam:
>>mdadm --assemble /dev/md0 --update=summaries /dev/hdc1 /dev/hdd1
>>/dev/hdg1 /dev/hdh1
>>
>>
>>I then tried to run fsck on /dev/md0 to make sure there were no file
>>system errors. However, fsck returned error messages that the number of
>>cylinders according to the superblock were 183833712, while the 
>>physical
>>size of the device was 183104736.
>>
>>Running fdisk on /dev/md0 returned the following:
>>
>>--------------
>>Device contains neither a valid DOS partition table, nor Sun, SGI or 
>>OSF
>>disklabel
>>Building a new DOS disklabel. Changes will remain in memory only,
>>until you decide to write them. After that, of course, the previous
>>content won't be recoverable.
>>
>>
>>The number of cylinders for this disk is set to 183104736.
>>There is nothing wrong with that, but this is larger than 1024,
>>and could in certain setups cause problems with:
>>1) software that runs at boot time (e.g., old versions of LILO)
>>2) booting and partitioning software from other OSs
>>    (e.g., DOS FDISK, OS/2 FDISK)
>>Warning: invalid flag 0x0000 of partition table 4 will be corrected by
>>w(rite)
>>
>>Command (m for help): p
>>
>>Disk /dev/md0: 749.9 GB, 749996998656 bytes
>>2 heads, 4 sectors/track, 183104736 cylinders
>>Units = cylinders of 8 * 512 = 4096 bytes
>>---------------
>>
>>
>>
>>I tried inspecting the raid array with mdamd - 'mdadm --detail --test
>>/dev/md0'. It gave me the following results:
>>------------------
>>/dev/md0:
>>         Version : 00.90.00
>>   Creation Time : Thu Oct 21 16:27:20 2004
>>      Raid Level : raid5
>>      Array Size : 732418944 (698.49 GiB 749.100 GB)
>>     Device Size : 244139648 (232.83 GiB 249.100 GB)
>>    Raid Devices : 4
>>   Total Devices : 4
>>Preferred Minor : 0
>>     Persistence : Superblock is persistent
>>
>>     Update Time : Thu Oct 21 16:38:59 2004
>>           State : dirty, degraded
>>  Active Devices : 2
>>Working Devices : 3
>>  Failed Devices : 1
>>   Spare Devices : 1
>>
>>          Layout : left-symmetric
>>      Chunk Size : 64K
>>
>>            UUID : c7a73d47:a072c630:7693d236:dff40ca6
>>          Events : 0.6
>>
>>     Number   Major   Minor   RaidDevice State
>>        0      22        1        0      active sync   /dev/hdc1
>>        1      22       65        1      faulty   /dev/hdd1
>>        2       0        0        2      faulty removed
>>        3      34       65        3      active sync   /dev/hdh1
>>
>>        4      34        1        4      spare   /dev/hdg1
>>--------------------
>>
>>
>>My /etc/raidtab files reads like this:
>>
>>---------
>>raiddev /dev/md0
>>         raid-level              5
>>         nr-raid-disks           4
>>         nr-spare-disks          0
>>         persistent-superblock   1
>>         parity-algorithm        left-symmetric
>>         chunk-size              64
>>         device                  /dev/hdc1
>>         raid-disk               0
>>         device                  /dev/hdd1
>>         raid-disk               1
>>         device                  /dev/hdg1
>>         raid-disk               2
>>         device                  /dev/hdh1
>>         raid-disk               3
>>----------
>>
>>
>>Any advice on why my RAID array will not run?
>>
>>Thanks,
>>Saurabh.
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-raid" 
>>in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

