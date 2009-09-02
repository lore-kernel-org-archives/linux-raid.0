From: "me at tmr.com" <tmrbill@tmr.com>
Subject: (unknown)
Date: Wed, 2 Sep 2009 14:46:11 -0400
Message-ID: <200909021846.n82IkB3I020713@firewall2.tmr.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements wrote:
> Bill Davidsen wrote:
>> NeilBrown wrote:
>>> On Tue, August 25, 2009 12:39 am, Simon Jackson wrote:
>>>  
>>>> I am trying to use write intent bitmaps on some RAID 1 volumes to 
>>>> reduce
>>>> the rebuild times in the event of hard resets that cause the md 
>>>> driver to
>>>> kick members out of my arrays.
>>>>
>>>> I used the mdadm --grow /dev/md0 --bitmap=internal  and this 
>>>> appeared to
>>>> succeed, but when I tried to examine the bitmap I get an error.
>>>>
>>>>
>>>> :~$ sudo mdadm --grow /dev/md0 --bitmap=internal
>>>> :~$ sudo mdadm -X /dev/md0
>>>>         Filename : /dev/md0
>>>>            Magic : 00000000
>>>> mdadm: invalid bitmap magic 0x0, the bitmap file appears to be 
>>>> corrupted
>>>>          Version : 0
>>>> mdadm: unknown bitmap version 0, either the bitmap file is 
>>>> corrupted or
>>>> you need to upgrade your tools
>>>>     
>>>
>>> Quoting from the man page:
>>>
>>>        -X, --examine-bitmap
>>>               Report  information about a bitmap file.  The argument is
>>> either
>>>               an external bitmap file or an array  component  in  
>>> case  of
>>>  an
>>>               internal  bitmap.   Note  that  running  this on an array
>>> device
>>>               (e.g.  /dev/md0) does not report the bitmap for that 
>>> array.
>>>
>>>
>>> Particularly read the last sentence.
>>> Then try
>>>    mdadm -X /dev/sda5
>>>   
>>
>> Well that's nice and clear, but raises the question "why not?" This 
>> would seem to be one of the most common things someone would do, to 
>> look at the bitmap for an array.
>
> Two reasons why not:
>
> The examine code simply takes the device or file you give it and looks 
> for a bitmap in that file or device. You'd have to do some hand-waving 
> to "read the bitmap for /dev/md0". There actually is no bitmap on 
> /dev/md0; there is a bitmap stored either in a file or on each of the 
> component devices. So which version of the bitmap do you read? From 
> the first, second, third ... component disk?
>
I know what the code does now, the question is why it doesn't handle the 
most intuitive usage.  The software can select which component to check 
if (a) a bitmap exists at all on this array, and (b) this isn't a 
component. And software could select a component with a current event 
count, just in case. It's useful if the tool does something useful 
instead of requiring multiple manual steps.
> Also, mdadm's behavior would be ambiguous if you implemented the 
> above. What if /dev/md0 is itself a component of another md device? 
> Then how is mdadm to know which bitmap you want? The one that actually 
> physically exists on md0, or the ones that the components of md0 contain?

The two steps above are deterministic, so it will always do the same 
thing, in most cases the desired thing, and in all cases where the 
target is a component the same thing it does now.
>
> Perhaps better would be to simply throw an error in this case?

It does, and the error has three major faults:
- it misdiagnoses the problem in the majority of cases
- it suggests that the bitmap is broken or the tools don't match the kernel
- it needlessly alarms users, who equate "corrupted" with "lost data"

    mdadm: unknown bitmap version 0, either the bitmap file is corrupted
    or you need to upgrade your tools
      

---

bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"Now we have another quarterback besides Kurt Warner telling us during postgame
interviews that he owes every great thing that happens to him on a football
field to his faith in Jesus. I knew there had to be a reason why the Almighty
included a mute button on my remote."
			-- Arthur Troyer on Tim Tebow (Sports Illustrated)

