From: Asdo <asdo@shiftmail.org>
Subject: Re: Help on first dangerous scrub / suggestions
Date: Thu, 26 Nov 2009 20:02:55 +0100
Message-ID: <4B0ED0DF.10502@shiftmail.org>
References: <4B0E7111.20202@shiftmail.org>
 <alpine.DEB.2.00.0911260720220.23317@p34.internal.lan>
 <4B0E8B75.2030006@shiftmail.org>
 <alpine.DEB.2.00.0911260915520.17452@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <alpine.DEB.2.00.0911260915520.17452@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Justin Piszcz wrote:
> On Thu, 26 Nov 2009, Asdo wrote:
>
>>>>
>>>> BTW I would like to ask an info on "readonly" mode mentioned here:
>>>> http://www.mjmwired.net/kernel/Documentation/md.txt
>>>> upon read error, will it initiate a rebuild / degrade the array or 
>>>> not?
> This is a good question but it is difficult to test as each use case is
> different. That would be a question for Neil.
>
>>>>
>>>> Anyway the "nodegrade" mode I suggest above would be still more 
>>>> useful because you do not need to put the array in readonly mode, 
>>>> which is important for doing backups during normal operation.
>>>>
>>>> Coming back to my problem, I have thought that the best approach 
>>>> would probably be to first collect information on how good are my 
>>>> 12 drives, and I probably can do that by reading each device like
>>>> dd if=/dev/sda of=/dev/null
>>>> and see how many of them read with errors. I just hope my 3ware 
>>>> disk controllers won't disconnect the whole drive upon read error.
>>>> (anyone has a better strategy?)
> I see where you're going here.  Read below but if you go this route I 
> assume
> you would first stop the array (?) mdadm -S /dev/mdX and then test each
> individual disk one at a time?

I don't plan to stop the array prior to reading the drives. Reads should 
not be harmful...
You think otherwise?
I think I did read the drives in the past on a mounted array and it was 
no problem.

>>>>
>>>> But then if it turns out that 3 of them indeed have unreadable 
>>>> areas I am screwed anyway. Even with dd_rescue there's no strategy 
>>>> that can save my data, even if the unreadable areas have different 
>>>> placement in the 3 disks (and that's a case where it should instead 
>>>> be possible to get data back).
> So wouldn't your priority to copy/rsync the *MOST* important data off the
> machine first before resorting to more invasive methods?

Yeah I will eventually do that if I find more than 2 drives with read 
errors.
(dd read to the individual drives is less invasive than rsync imho)
So You are saying that even if I find less than 2 disks with read errors 
(which might even be correctable) with dd reads, you would anyway 
proceed with a backup before the scrub?

(Actually I would need to also test the spares for write functionality, 
heck...
Oh well... I have many spares...)

I miss so much a "nodegrade" mode as described in my original post :-/
("undegradeable" would probably be more correct btw)

>>>>
>>>> This brings to my second suggestion:
>>>> I would like to see 12 (in my case) devices like:
>>>> /dev/md0_fromparity/{sda1,sdb1,...}   (all readonly)
>>>> that behave like this: when reading from /dev/md0_fromparity/sda1 , 
>>>> what comes out is the bytes that should be in sda1, but computed 
>>>> from the other disks. Reading from these devices should never 
>>>> degrade an array, at most give read error.
>>>>
>>>> Why is this useful?
>>>> Because one could recover sda1 from a disastered array with 
>>>> multiple unreadable areas (unless too many are overlapping) in this 
>>>> way:
>>>> With the array in "nodegrade" mode and blockdevice marked as readonly:
>>>> 1- dd_rescue if=/dev/sda1 of=/dev/sdz1   [sdz is a good drive to 
>>>> eventually take sda place]
>>>>    take note of failed sectors
>>>> 2- dd_rescue from /dev/md0_fromparity/sda1 to /dev/sdz1 only for 
>>>> the sectors that were unreadable from above
>>>> 3- stop array, take out sda1, and reassemble the array with sdz1 in 
>>>> place of sda1
>>>> ... repeat for all the other drives to get a good array back.
>>>>
>>>> What do you think?
> While this may be possibly, has anyone on this list done something 
> like this
> and had it work successfully?

Nobody could try this way because the 
/dev/md0_fromparity/{sda1,sdb1,...} do not exist. This is a feature 
request...

>>>>
>>>> I have another question on scrubbing: I am not sure about the exact 
>>>> behaviour of "check" and "repair":
>>>> - will "check" degrade an array if it finds an uncorrectable 
>>>> read-error? 
>> From README.checkarray:
>
> 'check' is a read-only operation, even though the kernel logs may suggest
> otherwise (e.g. /proc/mdstat and several kernel messages will mention
> "resync"). Please also see question 21 of the FAQ.
>
> If, however, while reading, a read error occurs, the check will 
> trigger the
> normal response to read errors which is to generate the 'correct' data 
> and try
> to write that out - so it is possible that a 'check' will trigger a 
> write.
> However in the absence of read errors it is read-only.
>
> Per md.txt:
>
>        resync        - redundancy is being recalculated after unclean
>                        shutdown or creation
>
>        repair        - A full check and repair is happening.  This is
>                        similar to 'resync', but was requested by the
>                        user, and the write-intent bitmap is NOT used to
>                        optimise the process.
>
>        check         - A full check of redundancy was requested and is
>                        happening.  This reads all block and checks
>                        them. A repair may also happen for some raid
>                        levels.

Unfortunately this does not specifically answer the question, even 
though the sentence
"If, however, while reading, a read error occurs, the check will trigger 
the normal response to read errors..."
seems to suggest that in case of uncorrectable read error the drive will 
be kicked.

