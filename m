From: o1bigtenor <o1bigtenor@gmail.com>
Subject: Re: Request for assistance
Date: Wed, 6 Jul 2016 07:14:26 -0500
Message-ID: <CAPpdf59gF6BMpmCY5SNzNH2O_WFn17hMVnrjHAyA0pU_i+--uA@mail.gmail.com>
References: <CAPpdf58z4JagWmP=xiUj9qOU-bdyN7W=EvcM9evjCT4ZWp+VxQ@mail.gmail.com>
 <577C64FA.6050504@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <577C64FA.6050504@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jul 5, 2016 at 8:55 PM, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
> On 06/07/16 10:13, o1bigtenor wrote:
>>
>> Greetings
>>
>> Running a Raid 10 array with 4 - 3 TB drives. Have a UPS but this area
>> gets significant lightning and also brownout (rural power) events.
>>
snip
>>
>> Do I just re-create the array?
>>
> No, not if you value your data. Only re-create the array if you are told to
> by someone (knowledgeable) on the list.
>
> In your case, I think you should stop the array.
> mdadm --stop /dev/md0
> Make sure there is nothing listed in /proc/mdstat
> Then try to assemble the array, but force the events to match:
> mdadm --assemble /dev/md0 --force /dev/sd[bcef]1
>
> If that doesn't work, then include the output from dmesg as well as
> /proc/mdstat and any commandline output generated.
>
> You might also want to examine why two drives dropped, referring to logs or
> similar might assist.
>
mdadm --stop /dev/md0
cat /proc/mdstat
    indicated no md (can't remember the exact response but it said
nothing there)
mdadm --assemble /dev/md0 --force /dev/sd[bcef]1 to

mdadm :forcing event count in /dev/sde1(2) from 64841 to 64844
mdadm :forcing event count in /dev/sdf1(3) from 64841 to 64844
mdadm: clearing FAULTY flag for device 3 in /dev/md0 for /dev/sdf1
mdadm: Marking array /dev/md0 as 'clean'
mdadm: /dev/md0 has been started with 4 drives

So my array is back up - - - thank you very much for your assistance!!!

What does the 'clearing FAULTY flag . . ' mean?

Regards

Dee
