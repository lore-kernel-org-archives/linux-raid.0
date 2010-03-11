From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: How to fix Current_Pending_Sector?
Date: Thu, 11 Mar 2010 17:54:44 +0100
Message-ID: <4B992054.9020903@stud.tu-ilmenau.de>
References: <C7BE91A7.10FF2%postmaster@email.iain.rauch.co.uk>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C7BE91A7.10FF2%postmaster@email.iain.rauch.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 11.03.2010 13:25, schrieb Iain Rauch:
>> On Thu, Mar 11, 2010 at 3:51 AM, Iain Rauch
>> <groups@email.iain.rauch.co.uk> wrote:
>>> Smartd emailed me to say I have "1 Currently unreadable (pending) sectors".
>>> This actually happened for two disks now.
>>>
>>> I ran a check and then a repair on my array and they both gave mismatch_cnt
>>> of 8.
>>>
>>> I ran a long self-test on both and they completed without error with no
>>> errors logged. Yet the 'Current_Pending_Sector' is still 1 on both, and one
>>> disk also has a 'UDMA_CRC_Error_Count' of 1.
>>>
>>> I ran 'hdrecover' on both and they are both telling me "Couldn't recover
>>> sector 2930277168". It's asking if I want to overwrite it with zeros to fix
>>> it, but I would assume this will damage my array?
>>>
>>> The disk sizes are 1500301910016 bytes and I use 1500250M partition sizes
>>> for the array components. Does that sector fall outside my partition, and
>>> hence would it be safe to overwrite it with zeros?
>>>
>>> Also, why did I have a mismatch_cnt? I haven't run another check since I did
>>> the repair, as I wanted to fix the pending sector.
>>>
>>> BTW, I have a 15 drive RAID6.
>>>
>>
>> If you are running RAID6 and it can read from all but two drives then
>> it should still be able to calculate whatever would match the
>> remaining (presumed good) reads to fill the later two drives.  RECENT
>> kernels will try to write over failed sectors automatically; and only
>> kick the drive if the write fails.
>>
>> Please provide more information.
>>
>> Kernel version
>> mdadm version
>>
>> Information about how the source block devices are split up before
>> mdadm sees them, and any related messages from the system-log.  The
>> relevant section should be near the end of a dmesg output when you've
>> just completed a check or repair.  Your syslog probably already
>> captured the same data and stored it elsewhere.
> 
> I thought doing the repair was supposed to fix the issue, but it didn't seem
> to touch it. I wonder if it is outside what md sees, but then how would it
> have been noticed as unreadable? And is it coincidence that both drives have
> the same unreadable sector?
> 
> root@Edna:/home/iain# uname -a
> Linux Edna 2.6.28-16-server #57-Ubuntu SMP Wed Nov 11 10:34:04 UTC 2009
> x86_64 GNU/Linux
> root@Edna:/home/iain# mdadm -V
> mdadm - v2.6.9 - 10th March 2009
> 
> I paste the end of messages below. There's loads of that all the way through
> doing the repair so I'm not sure how to filter out the useful bits.
> 
> 
> Iain
> [...]

Hi Iain,

the "Current_pending_sectors" is a smart attribute which gets
incremented during online (reading and writing sectors) AND offline
drive scanning (also called SMART Data Collection), when the drive finds
out a sector cannot be correctly read at the first try (offline data
collection) or after applying various error-correction techniques.
The easiest way to get rid of this problem: dd a sector of zeros onto
the broken sector, then fail the drive, re-add it.  Now wait until the
resync is done.
The fact I'm not sure about is: should one fail and re-add both drives
at once?  As by that the redundancy would get lost...

Speaking about redundancy: our rule of thumb (at xtivate.de) is "each 4
drives need one redundancy" - so a redundancy of 2 with 15 drives is
kind of playing with your luck...

Good luck,
Stefan
