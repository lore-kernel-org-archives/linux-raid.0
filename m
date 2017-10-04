From: Joe Landman <joe.landman@gmail.com>
Subject: Re: hung grow
Date: Wed, 4 Oct 2017 14:44:45 -0400
Message-ID: <cdf0fd70-ec6d-8e9d-6abd-6d9937b6a709@gmail.com>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
 <a528459f-8bf5-3e47-9c9a-7c040ad7ab81@youngman.org.uk>
 <CADg2FGYPENaUb7oDhOUu08VMhzygE365mqw=Lw332jBGbe1dGQ@mail.gmail.com>
 <0001704a-fe2f-e164-7694-f294a427ed83@gmail.com>
 <CADg2FGYRGYww6fTCYJCYRQvnrW70nZx-tTYpBP1+cyvzvTSpgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADg2FGYRGYww6fTCYJCYRQvnrW70nZx-tTYpBP1+cyvzvTSpgA@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Curt <lightspd@gmail.com>
Cc: Anthony Youngman <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 10/04/2017 02:37 PM, Curt wrote:
> Hi Joe,
>
> To clarify, the drives aren't completely dead.  I can see/examine all
> the drives currently in the array, the older ones I could see/examine,
> but like I said they had been marked faulty for a while and event
> count was way low.  The grow never went anywhere, just stayed at 0%
> with 100% CPU usage on md127_raid process.  I have rebooted and am not
> currently touching the drives.
>
> Assuming I can do a dd on one of my failed drives, will I be able to
> recover the data that's on the 4 that were good, before I took bad
> advice?  Also, will I need to dd on the failed drives or can I do 2 of
> the 3?

Not sure.   You will need to try to get back as much as you can off the 
other original "bad" drives.  If those drives are not "bad", you can 
pull out the "new" drives, and put them in.  See if you can force an 
assembly of the RAID.  If that works, you may have data (if the grow 
didn't corrupt anything).

If this is the case, the very first thing you should do is find and copy 
the data that you cannot lose from those drives, to another location, 
quickly.

Before you take any more advice, I'd recommend seeing if you can 
actually recover what you have now.

Generally speaking 3 failed drives on a RAID6 is a dead RAID6.  You may 
get lucky, in that this may have been simply a timeout error (I've seen 
these on consumer grade drives), or an internal operation on the drive 
taking longer than normal, and been booted.  In which case, you'll get 
scary warning messages, but might get your data back.

Under no circumstances do anything to change RAID metadata right now 
(grow, shrink, etc.).  Start with basic assembly.  If you can do that, 
you are in good shape.  If you can't, recovery is unlikely, even with 
heroic intervention.

>
> On Wed, Oct 4, 2017 at 2:29 PM, Joe Landman <joe.landman@gmail.com> wrote:
>>
>> On 10/04/2017 02:16 PM, Curt wrote:
>>> Hi,
>>>
>>> I was reading this one
>>> https://raid.wiki.kernel.org/index.php/RAID_Recovery
>>>
>>> I don't have any spare bays on that server...I'd have to make a trip
>>> to my datacenter and bring the drives back to my house.  The bad thing
>>> is the 2 drives I replaced, failed a while ago, so they were behind.
>>> I was hoping I could still use the 4 drives I had before I did a grow
>>> on them.  Do they need to be up-to-date or do I just need the config
>>> from them to recover the 3 drives that were still good?
>>>
>>> Oh, I originally started with 7, 2 failed a few moths back and the 3rd
>>> one just recently. FML
>>
>> Er ... honestly, I hope you have a backup.
>>
>> If the drives are really dead, and can't be seen with lsscsi or cat
>> /proc/scsi/scsi , then your raid is probably gone.
>>
>> If they can be seen, the ddrescue is your best option right now.
>>
>> Do not grow the system.  Stop that.  Do nothing that changes metadata.
>>
>> You may (remotely possibly) recover if you can copy the "dead" drives to two
>> new live ones.
>>
>>> Cheers,
>>> Curt
>>>
>>> On Wed, Oct 4, 2017 at 1:51 PM, Anthony Youngman
>>> <antlists@youngman.org.uk> wrote:
>>>> On 04/10/17 18:18, Curt wrote:
>>>>> Is my raid completely fucked or can I still recover some data with
>>>>> doing the create assume clean?
>>>>
>>>> PLEASE PLEASE PLEASE DON'T !!!!!!
>>>>
>>>> I take it you haven't read the raid wiki?
>>>>
>>>> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
>>>>
>>>> The bad news is your array is well borked. The good news is I don't think
>>>> you have - YET - managed to bork it irretrievably. A create will almost
>>>> certainly trash it beyond recovery!!!
>>>>
>>>> I think we can stop/revert the grow, and get the array back to a usable
>>>> state, where we can force an assemble. If a bit of data gets lost, sorry.
>>>>
>>>> Do you have spare SATA ports? So you have the bad drives you replaced
>>>> (can
>>>> you ddrescue them on to new drives?). What was the original configuration
>>>> of
>>>> the raid - you say you lost three drives, but how many did you have to
>>>> start
>>>> with?
>>>>
>>>> I'll let the experts talk you through the actual recovery, but the steps
>>>> need to be to revert the grow, ddrescue the best of your failed drives,
>>>> force an assembly, and then replace the other two failed drives. No
>>>> guarantees as to how much data will be left at the end, although
>>>> hopefully
>>>> we'll save most of it.
>>>>
>>>> Cheers,
>>>> Wol
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> Joe Landman
>> e: joe.landman@gmail.com
>> t: @hpcjoe
>> w: https://scalability.org
>> g: https://github.com/joelandman
>>

-- 
Joe Landman
e: joe.landman@gmail.com
t: @hpcjoe
w: https://scalability.org
g: https://github.com/joelandman
l: https://www.linkedin.com/in/joelandman

