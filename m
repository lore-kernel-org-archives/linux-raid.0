From: freaky <freaky@bananateam.nl>
Subject: Re: Serious performance issues with mdadm RAID-5 partition exported
 through LIO (iSCSI)
Date: Wed, 19 Sep 2012 16:19:17 +0200
Message-ID: <5059D465.9020802@bananateam.nl>
References: <50588731.5050502@bananateam.nl> <1347997760.25356.16.camel@haakon2.linux-iscsi.org> <20568.58664.669085.313654@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20568.58664.669085.313654@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> For a RAID set of 6+1 2TB drives each capable of 60-120MB/s that
> is still pretty terrible speed (even if the performance seems
> not too bad).
>

Yes, but do note the 3.2 kernel has issues with the queue thingy. max
sectors and max hw sectors is set on 127. I've seen this on some
machines with late 2.6 kernels and 3.0 and 3.1 too iirc. It seems fixed
in 3.5. However, I had issues compiling the iscsitarget-dkms modules
against the 3.5 kernel (from package manager) and haven't taken the time
to build a newer version myself, so I haven't tested IET with 3.5.

Also, since it's reading and writing at the same time now it's no longer
(nearly due to fs overhead) purely sequential.

>>> Iostat with IETD whilst writing shows say 110-120% read per
>>> write, however, in this case we were also actually reading.
>>> [ ... ] IETD is running in fileio mode (write-back), so it
>>> buffers too. [ ... ]
> That probably helps the MD get a bit of help with aligned
> writes, or perhaps at that point the array had been resynced,
> who knows...

The results I've submitted now all have been taken whilst the array was
healthy.

>> Are you enabling emulate_write_cache=1 with your iblock
>> backends..? This can have a gigantic effect on initiator
>> performance for both MSFT + Linux SCSI clients.
> That sounds interesting, but also potentially rather dangerous,
> unless there is a very reliable implementation of IO barriers.
> Just like with enabling write caches on real disks...
>
>> [ ... ] check your [ ... ]/queue/max*sectors_kb for the MD
>> RAID to make sure the WRITEs are striped aligned to get best
>> performance with software MD raid.
> That does not quite ensure that the writes are stripe aligned,
> but perhaps a larger stripe cache would help.

Does this help?

root@datavault:~# parted /dev/md4
GNU Parted 2.3
Using /dev/md4
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) u b                                                             
(parted) pr                                                              
Model: Linux Software RAID Array (md)
Disk /dev/md4: 12002393063424B
Sector size (logical/physical): 512B/4096B
Partition Table: gpt

Number  Start            End              Size             File system 
Name           Flags
 1      1966080B         10115507159039B  10115505192960B              
ReplayStorage
 2      10115507159040B  12002393046527B  1886885887488B               
VDR-Storage

(parted) sel /dev/md4p1
Using /dev/md4p1
(parted) pr                                                              
Model: Unknown (unknown)
Disk /dev/md4p1: 10115505192960B
Sector size (logical/physical): 512B/4096B
Partition Table: gpt

Number  Start       End              Size             File system 
Name                          Flags
 1      17408B      134235135B       134217728B                   
Microsoft reserved partition  msftres
 2      135266304B  10115504668671B  10115369402368B  ntfs         Basic
data partition

(parted) quit                                                            

1966080/(1024*64*6)=5 (not rounded)
135266304/(1024*64*6)=344 (not rounded)

If my calculations are correct it shouldn't thus only be chunk but even
stripe aligned. I did pay a lot of attention to this during setup. It's
not my daily thing tho', so I do hope I did it correctly. 1024 to get
from B to kiB, 64 kiB's per chunk, 6 data chunks in a 7 disk RAID-5 set
(or well, originally a 8 disk RAID-6 but shouldn't differ).

NTFS is formatted with 64kiB block/cluster size. I've just verified this
again, in 3 ways :).

>
>> Please use FILEIO with this reporting emulate_write_cache=1
>> (WCE=1) to the SCSI clients. Note that by default in the last
>> kernel releases we've change FILEIO backends to only always
>> use O_SYNC to ensure data consistency during a hard power
>> failure, regardless of the emulate_write_cache=1 setting.
> Ahh interesting too. That's also the right choice unless there
> is IO barrier support at all levels.
This is too low level for me currently. I'll have to look it up. I also
take from this that *emulating* write cache != write cache :). I've only
conciously set the buffered mode, but as stated the targetcli utility,
at least the version that comes with ubuntu 12.04, doesn't show this is
set. Then again, not running in fileio mode either and the functionality
has been disabled in 3.5 if I understood correctly.

>> Also note that by default it's my understanding that IETD uses
>> buffered FILEIO for performance, so in your particular type of
>> setup you'd still see better performance with buffered FILEIO,
>> but would still have the potential risk of silent data
>> corruption with buffered FILEIO.
> Not silent data corruption, but data loss. Silent data
> corruption is usually meant for the case where an IO completes
> and reports success, but the data recorded is not the data
> submitted.

Ok, then we have the same concepts. The loss might cause corruption
obviously, but I've never seen it happen silently :).

>
>> [ ... ] understand the possible data integrity risks
>> associated with using buffered FILEIO during a hard power
>> failure, I'm fine with re-adding this back into
>> target_core_file for v3.7 code for people who really know what
>> they are doing.
> That "people who really know what they are doing" is generally a
> bit optimistic :-).

I like to be free to choose. Might not always choose the smart thing -
but at least it's been my choice, not some spoon fed thing :). Others
like to be nurtured tho'. If you're concerned about users (or well
admins - I've never seen a regular user set up a RAID + iSCSI target)
safety that much though I'd take the middle ground - just throw a big
fat red warning. Targetcli already uses fancy colors :). If people
choose to ignore that it's *most definitely* their responsibility (not
that it's anyone elses otherwise, the license clearly states no warranty
whatsoever). There's other ways to make things safe tho' and sometimes
speed is more important than integrity. There's probably still other
reasons people might want to enable it.



>
> Do the various modes support IO barriers? That usually is what
> is critical, at least for the better informed people.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

