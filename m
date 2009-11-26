From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Help on first dangerous scrub / suggestions
Date: Thu, 26 Nov 2009 09:38:48 -0500 (EST)
Message-ID: <alpine.DEB.2.00.0911260915520.17452@p34.internal.lan>
References: <4B0E7111.20202@shiftmail.org> <alpine.DEB.2.00.0911260720220.23317@p34.internal.lan> <4B0E8B75.2030006@shiftmail.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B0E8B75.2030006@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Thu, 26 Nov 2009, Asdo wrote:

>>> 
>>> BTW I would like to ask an info on "readonly" mode mentioned here:
>>> http://www.mjmwired.net/kernel/Documentation/md.txt
>>> upon read error, will it initiate a rebuild / degrade the array or not?
This is a good question but it is difficult to test as each use case is
different. That would be a question for Neil.

>>> 
>>> Anyway the "nodegrade" mode I suggest above would be still more useful 
>>> because you do not need to put the array in readonly mode, which is 
>>> important for doing backups during normal operation.
>>> 
>>> Coming back to my problem, I have thought that the best approach would 
>>> probably be to first collect information on how good are my 12 drives, and 
>>> I probably can do that by reading each device like
>>> dd if=/dev/sda of=/dev/null
>>> and see how many of them read with errors. I just hope my 3ware disk 
>>> controllers won't disconnect the whole drive upon read error.
>>> (anyone has a better strategy?)
I see where you're going here.  Read below but if you go this route I assume
you would first stop the array (?) mdadm -S /dev/mdX and then test each
individual disk one at a time?

>>> 
>>> But then if it turns out that 3 of them indeed have unreadable areas I am 
>>> screwed anyway. Even with dd_rescue there's no strategy that can save my 
>>> data, even if the unreadable areas have different placement in the 3 disks 
>>> (and that's a case where it should instead be possible to get data back).
So wouldn't your priority to copy/rsync the *MOST* important data off the
machine first before resorting to more invasive methods?

>>> 
>>> This brings to my second suggestion:
>>> I would like to see 12 (in my case) devices like:
>>> /dev/md0_fromparity/{sda1,sdb1,...}   (all readonly)
>>> that behave like this: when reading from /dev/md0_fromparity/sda1 , what 
>>> comes out is the bytes that should be in sda1, but computed from the other 
>>> disks. Reading from these devices should never degrade an array, at most 
>>> give read error.
>>> 
>>> Why is this useful?
>>> Because one could recover sda1 from a disastered array with multiple 
>>> unreadable areas (unless too many are overlapping) in this way:
>>> With the array in "nodegrade" mode and blockdevice marked as readonly:
>>> 1- dd_rescue if=/dev/sda1 of=/dev/sdz1   [sdz is a good drive to 
>>> eventually take sda place]
>>>    take note of failed sectors
>>> 2- dd_rescue from /dev/md0_fromparity/sda1 to /dev/sdz1 only for the 
>>> sectors that were unreadable from above
>>> 3- stop array, take out sda1, and reassemble the array with sdz1 in place 
>>> of sda1
>>> ... repeat for all the other drives to get a good array back.
>>> 
>>> What do you think?
While this may be possibly, has anyone on this list done something like this
and had it work successfully?

>>> 
>>> I have another question on scrubbing: I am not sure about the exact 
>>> behaviour of "check" and "repair":
>>> - will "check" degrade an array if it finds an uncorrectable read-error? 
From README.checkarray:

'check' is a read-only operation, even though the kernel logs may suggest
otherwise (e.g. /proc/mdstat and several kernel messages will mention
"resync"). Please also see question 21 of the FAQ.

If, however, while reading, a read error occurs, the check will trigger the
normal response to read errors which is to generate the 'correct' data and try
to write that out - so it is possible that a 'check' will trigger a write.
However in the absence of read errors it is read-only.

Per md.txt:

        resync        - redundancy is being recalculated after unclean
                        shutdown or creation

        repair        - A full check and repair is happening.  This is
                        similar to 'resync', but was requested by the
                        user, and the write-intent bitmap is NOT used to
                        optimise the process.

        check         - A full check of redundancy was requested and is
                        happening.  This reads all block and checks
                        them. A repair may also happen for some raid
                        levels.

>>> The manual only mentions what happens if the checksums of the parity disks 
>>> don't match with data, but that's not what I'm interested in right now.
>>> - will "repair" .... (same question as above)
>>> 
>>> Thanks for your comments
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> 
>> 
>> Have you gotten any filesystem errors thus far?
>> How bad are the disks?
> Only one disk gave correctable read errors in dmesg twice (no filesystem 
> errors), 64 sectors in sequence each time.
> Smartctl -a reports indeed those errors on that disk, and no errors on all 
> the other disks.
> (
> on the partially-bad disk:
> SMART overall-health self-assessment test result: PASSED
> ...
> 1 Raw_Read_Error_Rate     0x000f   200   200   051    Pre-fail  Always 
> -       138
> ...
> 5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always 
> -       0
> the other disks have values: PASSED, 0, 0
> )
> However I never ran smartctl tests, so the only errors smartctl is aware of 
> are indeed those I also got from md.
Ouch, in addition if you do not run the 'offline' test mentioned in the
smartctl manpage, (all of the offline-test related statistics) will NOT
be updated, so there is no way to tell how bad the disk really is, the
smartctl statistics for those disks are unknown because they have not been
updated.  I had a REAL weird issue once with a mdadm raid-1 where one disk
kept dropping out of the array (two raptor 150s) and I had not run the offline
test and got fed up with it all and put them on a 3ware controller.  Shortly
thereafter, I built a new RAID-1 with the same disks and I saw many
re-allocated sectors, the drive was on its way out.  However, since I had not
run an offline test before, the disk looked completely FINE, all smart tests
had passed (short,long) && the output from smartctl -a looked good too!

>
>> Can you show the smartctl -a output of each of the 12 drives?
>> Can you rsync all of the data to another host?
>> What filesystem is being used?
>> 
>> If your disks are failing I'd recommend an rsync ASAP over trying to 
>> read/write/test the disks with dd or other tests.
> Filesystem is ext3
> For the rsync I am worried, have you read my original post? If rsync hits an 
> area with uncorrectable read errors the rebuild will start and then if turns 
> out there are other 2 partially-unreadable disks I will lose the array. And I 
> will lose it *right now* and without knowing for sure before.
Per your other reply, it is plausible that what you are saying may occur.  I
have to ask though if you have 12 disks on a 3ware controller, why are you
not using HW RAID-6?  Whenever there are read errors on a 3ware controller
it simply remaps the bad sector and marks it as bad, for each sector, and
it does not drop out of the array until there are > 100-300 reallocated
sectors (if these are enterprise drives) (and depending on how the drive
fails of course)..

Aside from that, if your array is say, 50% full and you rsync, you only need
to read what is on the disks and not the entire array (as you would need
to do with the dd).  In addition, this would also allow you to rsync your
most important data off at your choosing.  If you go ahead with the dd test
and through it you find 3 disks fail during the process, what have you gained?

There is a risk you take either way, your method may bear less risk as long
as no drives completely fail during your read tests.  Whereas if you copy or
rsync the data, you may be successful, or not; however in the second scenario
you (hopefully) end up with the data in a second location, to which you can
then run all of the tests you want thereafter.


> What are the drawbacks you see against the dd test I proposed? It's just to 
> probe to have an idea of how bad is the situation, without changing the 
> situation yet...
Maybe.. As long as the dd test does not brick the drives (unlikely) but it 
could happen.

