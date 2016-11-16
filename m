From: Alexander Shenkin <al@shenkin.org>
Subject: Re: recovering failed raid5
Date: Wed, 16 Nov 2016 09:04:29 +0000
Message-ID: <194ae464-2d19-cefd-055f-6f4a33676ab2@shenkin.org>
References: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
 <20161027160400.GA21042@metamorpher.de>
 <715b259f-1e56-9606-edc4-3e5c4d57744b@shenkin.org>
 <20161028133626.GA27462@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161028133626.GA27462@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Andreas Klauer <Andreas.Klauer@metamorpher.de>, rm@romanrm.net, robin@robinhill.me.uk
List-Id: linux-raid.ids

Hello all,

As a quick reminder, my sdb failed in a 4-disk RAID5, and then sdc 
failed when trying to replace sdb.  I'm now trying to recover sdc with 
ddrescue.

After much back and forth, I've finally got ddrescue running to 
replicate my apparently-faulty sdc.  I'm ddrescue'ing from a seagate 3TB 
to a toshiba 3TB drive, and I'm getting a 'No space left on device 
error'.  Any thoughts?

One further question: should I also try to ddrescue my original failed 
sdb in the hopes that anything lost on sdc would be covered by the 
recovered sdb?

Logs below... (below, /dev/sdb is the original failed seagate sdc, and 
/dev/sdc below is the new bare toshiba drive).

Thanks,
Allie


username@Ubuntu-VirtualBox:~$ sudo ddrescue -d -f -r3 /dev/sdb /dev/sdc 
~/rescue.logfile
[sudo] password for username:
GNU ddrescue 1.19
Press Ctrl-C to interrupt
rescued:     3000 GB,  errsize:   65536 B,  current rate:   55640 kB/s
    ipos:     3000 GB,   errors:       1,    average rate:   83070 kB/s
    opos:     3000 GB, run time:   10.03 h,  successful read:       0 s ago
Copying non-tried blocks... Pass 1 (forwards)
ddrescue: Write error: No space left on device



username@Ubuntu-VirtualBox:~$ lsblk -o name,label,size,fstype,model
NAME   LABEL           SIZE FSTYPE            MODEL
sda                      8G                   VBOX HARDDISK
├─sda1                   6G ext4
├─sda2                   1K
└─sda5                   2G swap
sdb                    2.7T                   2105
├─sdb1 arrayname:0  1.9G linux_raid_member
├─sdb2                   1M
├─sdb3 arrayname:2  2.7T linux_raid_member
└─sdb4 arrayname:3  7.6G linux_raid_member
sdc                    2.7T                   Expan



username@Ubuntu-VirtualBox:~$ fdisk -l

[...]

Disk /dev/sdb: 2.7 TiB, 3000592982016 bytes, 5860533168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 4B356AFA-8F48-4227-86F0-329565146D7A

Device          Start        End    Sectors  Size Type
/dev/sdb1        2048    3905535    3903488  1.9G Linux RAID
/dev/sdb2     3905536    3907583       2048    1M BIOS boot
/dev/sdb3     3907584 5844547583 5840640000  2.7T Linux RAID
/dev/sdb4  5844547584 5860532223   15984640  7.6G Linux RAID


Disk /dev/sdc: 2.7 TiB, 3000592977920 bytes, 732566645 sectors
Units: sectors of 1 * 4096 = 4096 bytes
Sector size (logical/physical): 4096 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x00000000

Device     Boot Start        End    Sectors Size Id Type
/dev/sdc1           1 4294967295 4294967295  16T ee GPT



username@Ubuntu-VirtualBox:~$ cat rescue.logfile
# Rescue Logfile. Created by GNU ddrescue version 1.19
# Command line: ddrescue -d -f -r3 /dev/sdb /dev/sdc 
/home/username/rescue.logfile
# Start time:   2016-11-15 13:54:24
# Current time: 2016-11-15 23:56:25
# Copying non-tried blocks... Pass 1 (forwards)
# current_pos  current_status
0x2BAA1470000     ?
#      pos        size  status
0x00000000  0x7F5A0000  +
0x7F5A0000  0x00010000  *
0x7F5B0000  0x00010000  ?
0x7F5C0000  0x2BA21EB0000  +


On 10/28/2016 2:36 PM, Robin Hill wrote:
> On Fri Oct 28, 2016 at 01:22:31PM +0100, Alexander Shenkin wrote:
>
>> Thanks Andreas, much appreciated.  Your points about selftests and smart
>> are well taken, and i'll implement them once i get this back up.  I'll
>> buy yet another new, non drive-from-hell (yes Roman, I did buy the same
>> damn drive again.  Will try to return it, thanks for the heads up...)
>> and follow your instructions below.
>>
>> One remaining question: is sdc definitely toast?  Or, is it possible
>> that the Timeout Mismatch (as mentioned by Robin Hill; thanks Robin) is
>> flagging the drive as failed, when something else is at play and perhaps
>> the drive is actually fine?
>>
> It's not definitely toast, no (but this is unrelated to the Timeout
> mismatches). It has some pending reallocations, which means the drive
> was unable to read from some blocks - if a write to the blocks fails
> then one of the spare blocks will be reallocated instead, but a write
> will often succeed and the pending reallocation will just be cleared.
>
> Unfortunately, reconstruction of the array depends on this data being
> readable, so the fact the drive isn't toast doesn't necessarily help.
> I'd suggest replicating (using ddrescue) that drive to the new one (when
> it arrives) as a first step. It's possible ddrescue will manage to read
> the data (it'll make several attempts, so can sometimes read data that
> fails initially), otherwise you'll end up with some missing data
> (possibly corrupt files, possibly corrupt filesystem metadata, possibly
> just a bit of extra noise in an audio/video file). Once that's done, you
> can do a proper check on sdc (e.g. a badblocks read/write test), which
> will either lead to sector actually being reallocated, or to clearing
> the pending reallocations. Unless you get a lot more reallocated sectors
> than are currently pending, you can put the drive back into use if you
> like (bearing in mind the reputation of these drives and weighing the
> replacement cost against the value of your data).
>
> If you run a regular selftest on the array, these sort of issues would
> be picked up and repaired automatically (the read errors will trigger
> rewrites and either reallocate blocks, clear the pending reallocations,
> or fail the drive). Otherwise they're liable to come back to bite you
> when you're trying to recover from a different failure.
>
> Timeout Mismatches will lead to drives being failed from an otherwise
> healthy array - a read failure on the drive can't be corrected as the
> drive is still busy trying when the write request goes through, so the
> drive gets kicked out of the array. You didn't say what the issue was
> with your original sdb, but if it wasn't a definite fault then it may
> have been affected by a timeout mismatch.
>
> Cheers,
>     Robin
>
>> To everyone: sorry for the multiple posts.  Was having majordomo issues...
>>
>> On 10/27/2016 5:04 PM, Andreas Klauer wrote:
>>> On Thu, Oct 27, 2016 at 04:06:14PM +0100, Alexander Shenkin wrote:
>>>> md2: raid5 mounted on /, via sd[abcd]3
>>>
>>> Two failed disks...
>>>
>>>> md0: raid1 mounted on /boot, via sd[abcd]1
>>>
>>> Actually only two disks active in that one, the other two are spares.
>>> It hardly matters for /boot, but you could grow it to a 4 disk raid1.
>>> Spares are not useful.
>>>
>>>> My sdb was recently reporting problems.  Instead of second guessing
>>>> those problems, I just got a new disk, replaced it, and added it to
>>>> the arrays.
>>>
>>> Replacing right away is the right thing to do.
>>> Unfortunately it seems you have another disk that is broke too.
>>>
>>>> 2) smartctl (disabled on drives - can enable once back up.  should I?)
>>>> note: SMART only enabled after problems started cropping up.
>>>
>>> But... why? Why disable smart? And if you do, is it a surprise that you
>>> only notice disk failures when it's already too late?
>>
>> yeah, i asked myself that same question.  there was probably some reason
>> I did, but i don't remember what it was.  i'll keep smart enabled from
>> now on...
>>
>>> You should enable smart, and not only that, also run regular selftests,
>>> and have smartd running, and have it send you mail when something happens.
>>> Same with raid checks, raid checks are at least something but it won't
>>> tell you about how many reallocated sectors your drive has.
>>
>> will do
>>
>>>> root@machinename:/home/username# smartctl --xall /dev/sda
>>>
>>> Looks fine but never ran a selftest.
>>>
>>>> root@machinename:/home/username# smartctl --xall /dev/sdb
>>>
>>> Looks new. (New drives need selftests too.)
>>>
>>>> root@machinename:/home/username# smartctl --xall /dev/sdc
>>>> smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.19.0-39-generic] (local build)
>>>> Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org
>>>>
>>>> === START OF INFORMATION SECTION ===
>>>> Model Family:     Seagate Barracuda 7200.14 (AF)
>>>> Device Model:     ST3000DM001-1CH166
>>>> Serial Number:    W1F1N909
>>>>
>>>> 197 Current_Pending_Sector  -O--C-   100   100   000    -    8
>>>> 198 Offline_Uncorrectable   ----C-   100   100   000    -    8
>>>
>>> This one is faulty and probably the reason why your resync failed.
>>> You have no redundancy left, so an option here would be to get a
>>> new drive and ddrescue it over.
>>>
>>> That's exactly the kind of thing you should be notified instantly
>>> about via mail. And it should be discovered when running selftests.
>>> Without full surface scan of the media, the disk itself won't know.
>>>
>>>> ==> WARNING: A firmware update for this drive may be available,
>>>> see the following Seagate web pages:
>>>> http://knowledge.seagate.com/articles/en_US/FAQ/207931en
>>>> http://knowledge.seagate.com/articles/en_US/FAQ/223651en
>>>
>>> About this, *shrug*
>>> I don't have these drives, you might want to check that out.
>>> But it probably won't fix bad sectors.
>>>
>>>> root@machinename:/home/username# smartctl --xall /dev/sdd
>>>
>>> Some strange things in the error log here, but old.
>>> Still, same as for all others - selftest.
>>>
>>>> ################### mdadm --examine ###########################
>>>>
>>>> /dev/sda1:
>>>>      Raid Level : raid1
>>>>    Raid Devices : 2
>>>
>>> A RAID 1 with two drives, could be four.
>>>
>>>> /dev/sdb1:
>>>> /dev/sdc1:
>>>
>>> So these would also have data instead of being spare.
>>>
>>>> /dev/sda3:
>>>>      Raid Level : raid5
>>>>    Raid Devices : 4
>>>>
>>>>     Update Time : Mon Oct 24 09:02:52 2016
>>>>          Events : 53547
>>>>
>>>>    Device Role : Active device 0
>>>>    Array State : A..A ('A' == active, '.' == missing)
>>>
>>> RAID-5 with two failed disks.
>>>
>>>> /dev/sdc3:
>>>>      Raid Level : raid5
>>>>    Raid Devices : 4
>>>>
>>>>     Update Time : Mon Oct 24 08:53:57 2016
>>>>          Events : 53539
>>>>
>>>>    Device Role : Active device 2
>>>>    Array State : AAAA ('A' == active, '.' == missing)
>>>
>>> This one failed, 8:53.
>>>
>>>> ############ /proc/mdstat ############################################
>>>>
>>>> md2 : active raid5 sda3[0] sdc3[2](F) sdd3[3]
>>>>       8760565248 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/2]
>>>> [U__U]
>>>
>>> [U__U] refers to device roles as in [0123],
>>> so device role 0 and 3 is okay, 1 and 2 missing.
>>>
>>>> md0 : active raid1 sdb1[4](S) sdc1[2](S) sda1[0] sdd1[3]
>>>>       1950656 blocks super 1.2 [2/2] [UU]
>>>
>>> Those two spares again, could be [UUUU] instead.
>>>
>>> tl;dr
>>> stop it all,
>>> ddrescue /dev/sdc to your new disk,
>>> try your luck with --assemble --force (not using /dev/sdc!),
>>> get yet another new disk, add, sync, cross fingers.
>>>
>>> There's also mdadm --replace instead of --remove, --add,
>>> that sometimes helps if there's only a few bad sectors
>>> on each disk. If the disk you already removed wasn't
>>> already kicked from the array by the time you replaced,
>>> maybe it would have avoided this problem.
>>>
>>> But good disk monitoring and testing is even more important.
>>
>> thanks a bunch, Andreas.  I'll monitor and test from now on...
>>
>>> Regards
>>> Andreas Klauer
>>
>
