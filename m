From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 10:54:37 +0100
Message-ID: <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
 <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
 <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Allison <jeff.allison@allygray.2y.net>, Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 21.03.2017 um 03:33 schrieb Jeff Allison:
> I don't have a spare SATA slot I do however have a spare USB carrier,
> is that fast enough to be used temporarily?

USB3 yes, USB2 don't make fun because the speed of the array depends on 
the slowest disk in the spindle

and about RAID5/RAID6 versus RAID10: both RAID5 and RAID6 suffer from 
the same problems - due rebuild you have a lot of random-IO load on all 
remaining disks which leads in bad performance and make it more likely 
that before the rebuild is finished another disk fails, RAID6 produces 
even more random IO because of the double parity and if you have a 
Unrecoverable-Read-Error on RAID5 you are dead, RAID6 is not much better 
here and the probability of a URE becomes more likely with larger disks

RAID10: less to zero performance impact due rebuild and no random-IO 
caused by the rebuild, it's just "read a disk from start to end and 
write the data on another disk linear" while the only head moves on your 
disks is the normal workload on the array

with disks 2 TB or larger you can make the conclusion "do not use 
RAID5/6 anymore and when you do be prepared that you won't survive a 
rebuild caused by a failed disk"

> On 21 March 2017 at 01:59, Adam Goryachev
> <mailinglists@websitemanagers.com.au> wrote:
>>
>>
>> On 20/3/17 23:47, Jeff Allison wrote:
>>>
>>> Hi all I’ve had a poke around but am yet to find something definitive.
>>>
>>> I have a raid 5 array of 4 disks amounting to approx 5.5tb. Now this disks
>>> are getting a bit long in the tooth so before I get into problems I’ve
>>> bought 4 new disks to replace them.
>>>
>>> I have a backup so if it all goes west I’m covered. So I’m looking for
>>> suggestions.
>>>
>>> My current plan is just to replace the 2tb drives with the new 3tb drives
>>> and move on, I’d like to do it on line with out having to trash the array
>>> and start again, so does anyone have a game plan for doing that.
>>
>> Yes, do not fail a disk and then replace it, use the newer replace method
>> (it keeps redundancy in the array).
>> Even better would be to add a disk, and convert to RAID6, then add a second
>> disk (using replace), and so on, then remove the last disk, grow the array
>> to fill the 3TB, and then reduce the number of disks in the raid.
>> This way, you end up with RAID6...
>>>
>>> Or is a 9tb raid 5 array the wrong thing to be doing and should I be doing
>>> something else 6tb raid 10 or something I’m open to suggestions.
>>
>> I'd feel safer with RAID6, but it depends on your requirements. RAID10 is
>> also a nice option, but, it depends...
