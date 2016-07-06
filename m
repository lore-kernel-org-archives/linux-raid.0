From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Request for assistance
Date: Wed, 6 Jul 2016 13:51:16 +0100
Message-ID: <577CFEC4.7040704@youngman.org.uk>
References: <CAPpdf58z4JagWmP=xiUj9qOU-bdyN7W=EvcM9evjCT4ZWp+VxQ@mail.gmail.com>
 <577C64FA.6050504@websitemanagers.com.au>
 <CAPpdf59gF6BMpmCY5SNzNH2O_WFn17hMVnrjHAyA0pU_i+--uA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf59gF6BMpmCY5SNzNH2O_WFn17hMVnrjHAyA0pU_i+--uA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>, Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/07/16 13:14, o1bigtenor wrote:
> On Tue, Jul 5, 2016 at 8:55 PM, Adam Goryachev
> <mailinglists@websitemanagers.com.au> wrote:
>> On 06/07/16 10:13, o1bigtenor wrote:
>>>
>>> Greetings
>>>
>>> Running a Raid 10 array with 4 - 3 TB drives. Have a UPS but this area
>>> gets significant lightning and also brownout (rural power) events.
>>>
> snip
>>>
>>> Do I just re-create the array?
>>>
>> No, not if you value your data. Only re-create the array if you are told to
>> by someone (knowledgeable) on the list.
>>
>> In your case, I think you should stop the array.
>> mdadm --stop /dev/md0
>> Make sure there is nothing listed in /proc/mdstat
>> Then try to assemble the array, but force the events to match:
>> mdadm --assemble /dev/md0 --force /dev/sd[bcef]1
>>
>> If that doesn't work, then include the output from dmesg as well as
>> /proc/mdstat and any commandline output generated.
>>
>> You might also want to examine why two drives dropped, referring to logs or
>> similar might assist.
>>
> mdadm --stop /dev/md0
> cat /proc/mdstat
>     indicated no md (can't remember the exact response but it said
> nothing there)
> mdadm --assemble /dev/md0 --force /dev/sd[bcef]1 to
> 
> mdadm :forcing event count in /dev/sde1(2) from 64841 to 64844
> mdadm :forcing event count in /dev/sdf1(3) from 64841 to 64844
> mdadm: clearing FAULTY flag for device 3 in /dev/md0 for /dev/sdf1
> mdadm: Marking array /dev/md0 as 'clean'
> mdadm: /dev/md0 has been started with 4 drives
> 
> So my array is back up - - - thank you very much for your assistance!!!
> 
But why did they drop ... are you using desktop drives? I use Seagate
Barracudas - NOT a particularly good idea. You should be using WD Red,
Seagate NAS, or similar.

"smartctl -x /dev/sdx" will give you an idea of what's going on. Search
the list for "timeout error" for an idea of the grief you'll get if
you're using desktop drives ...

If smartctl says smart is disabled, enable it. When I do, my drive comes
back (using the -x option again) saying "SCT Error Recovery not
supported". This is a no-no for a decent raid drive. I think the other
acronyms are ETL or TLS - either way you can control how the drive
reports an error back to the OS. Which is why you need proper raid
drives (the manufacturers have downgraded the firmware on desktop drives :-(

You need to fix the WHY or it could easily happen again. And this could
well be why ... (if you've had a problem on a desktop drive, it WILL
happen again, and data loss is quite likely ... even if you recover the
bulk of the drive).

Cheers,
Wol

