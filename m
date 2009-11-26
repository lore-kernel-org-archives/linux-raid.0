From: Asdo <asdo@shiftmail.org>
Subject: Re: Help on first dangerous scrub / suggestions
Date: Thu, 26 Nov 2009 15:06:45 +0100
Message-ID: <4B0E8B75.2030006@shiftmail.org>
References: <4B0E7111.20202@shiftmail.org>
 <alpine.DEB.2.00.0911260720220.23317@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <alpine.DEB.2.00.0911260720220.23317@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Justin Piszcz wrote:
> On Thu, 26 Nov 2009, Asdo wrote:
>
>> Hi all
>> we have a server with a 12 disks raid-6.
>> It has been up for 1 year now but I have never scrubbed it because at 
>> the time I did not know about this good practice (a note on man mdadm 
>> would help).
>> The array is currently not degraded and has spares.
>>
>> Now I am scared about initiating the first scrub because if it turns 
>> out that 3 areas in different disks have bad sectors I think am gonna 
>> lose the whole array.
>>
>> Doing backups now it's also scary because if I hit a bad 
>> (uncorrectable) area in anyone of the disks while reading, a rebuild 
>> will start on the spare and that's like initiating the scrub with all 
>> associated risks.
>>
>> About this point, I would like to suggest a new "mode" of the array, 
>> let's call it "nodegrade" in which no degradation can occur, and I/O 
>> in unreadable areas simply fails with I/O error. By temporarily 
>> putting the array in that mode, at least one could backup without 
>> anxiety. I understand it would not be possible to add a spare / 
>> rebuild in this mode but that's ok.
>>
>> BTW I would like to ask an info on "readonly" mode mentioned here:
>> http://www.mjmwired.net/kernel/Documentation/md.txt
>> upon read error, will it initiate a rebuild / degrade the array or not?
>>
>> Anyway the "nodegrade" mode I suggest above would be still more 
>> useful because you do not need to put the array in readonly mode, 
>> which is important for doing backups during normal operation.
>>
>> Coming back to my problem, I have thought that the best approach 
>> would probably be to first collect information on how good are my 12 
>> drives, and I probably can do that by reading each device like
>> dd if=/dev/sda of=/dev/null
>> and see how many of them read with errors. I just hope my 3ware disk 
>> controllers won't disconnect the whole drive upon read error.
>> (anyone has a better strategy?)
>>
>> But then if it turns out that 3 of them indeed have unreadable areas 
>> I am screwed anyway. Even with dd_rescue there's no strategy that can 
>> save my data, even if the unreadable areas have different placement 
>> in the 3 disks (and that's a case where it should instead be possible 
>> to get data back).
>>
>> This brings to my second suggestion:
>> I would like to see 12 (in my case) devices like:
>> /dev/md0_fromparity/{sda1,sdb1,...}   (all readonly)
>> that behave like this: when reading from /dev/md0_fromparity/sda1 , 
>> what comes out is the bytes that should be in sda1, but computed from 
>> the other disks. Reading from these devices should never degrade an 
>> array, at most give read error.
>>
>> Why is this useful?
>> Because one could recover sda1 from a disastered array with multiple 
>> unreadable areas (unless too many are overlapping) in this way:
>> With the array in "nodegrade" mode and blockdevice marked as readonly:
>> 1- dd_rescue if=/dev/sda1 of=/dev/sdz1   [sdz is a good drive to 
>> eventually take sda place]
>>    take note of failed sectors
>> 2- dd_rescue from /dev/md0_fromparity/sda1 to /dev/sdz1 only for the 
>> sectors that were unreadable from above
>> 3- stop array, take out sda1, and reassemble the array with sdz1 in 
>> place of sda1
>> ... repeat for all the other drives to get a good array back.
>>
>> What do you think?
>>
>> I have another question on scrubbing: I am not sure about the exact 
>> behaviour of "check" and "repair":
>> - will "check" degrade an array if it finds an uncorrectable 
>> read-error? The manual only mentions what happens if the checksums of 
>> the parity disks don't match with data, but that's not what I'm 
>> interested in right now.
>> - will "repair" .... (same question as above)
>>
>> Thanks for your comments
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Have you gotten any filesystem errors thus far?
> How bad are the disks?
Only one disk gave correctable read errors in dmesg twice (no filesystem 
errors), 64 sectors in sequence each time.
Smartctl -a reports indeed those errors on that disk, and no errors on 
all the other disks.
(
on the partially-bad disk:
 SMART overall-health self-assessment test result: PASSED
 ...
 1 Raw_Read_Error_Rate     0x000f   200   200   051    Pre-fail  
Always       -       138
 ...
 5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  
Always       -       0
the other disks have values: PASSED, 0, 0
)
However I never ran smartctl tests, so the only errors smartctl is aware 
of are indeed those I also got from md.

> Can you show the smartctl -a output of each of the 12 drives?
> Can you rsync all of the data to another host?
> What filesystem is being used?
>
> If your disks are failing I'd recommend an rsync ASAP over trying to 
> read/write/test the disks with dd or other tests.
Filesystem is ext3
For the rsync I am worried, have you read my original post? If rsync 
hits an area with uncorrectable read errors the rebuild will start and 
then if turns out there are other 2 partially-unreadable disks I will 
lose the array. And I will lose it *right now* and without knowing for 
sure before.
What are the drawbacks you see against the dd test I proposed? It's just 
to probe to have an idea of how bad is the situation, without changing 
the situation yet...



