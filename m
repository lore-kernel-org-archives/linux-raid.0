From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Can't expand linear RAID on top of 2 x RAID1
Date: Sun, 24 Jun 2012 09:17:48 -0500
Message-ID: <4FE7218C.6090706@hardwarefreak.com>
References: <4FE44BDD.302@websitemanagers.com.au> <4FE4FA32.8010506@hardwarefreak.com> <32a64312-93cd-47d7-9154-2e28eda58003@email.android.com> <4FE5B413.4000300@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FE5B413.4000300@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hay Neil,

Could you please take a look at this one?  I'm at the limits of my
knowledge in this case, not exactly sure what the OP's next step should be.

Thanks.

-- 
Stan


On 6/23/2012 7:18 AM, Stan Hoeppner wrote:
> On 6/22/2012 9:53 PM, Adam Goryachev wrote:
>> Stan Hoeppner <stan@hardwarefreak.com> wrote:
>>
>>> On 6/22/2012 5:41 AM, Adam Goryachev wrote:
>>>> I have expanded my system over time, I started with 2 x 2TB drives in
>>>> RAID1 (md2)
>>>>
>>>> I then added 2 x 750GB drives, configured as RAID1 (md1)
>>>> Then created a third raid (md3) as linear with the md2 + md1
>>>>
>>>> Finally, I've upgraded the 2 x 750G to 2 x 1TB drives (one at a
>>> time).
>>>>
>>>> I then did a mdadm --grow to expand the RAID1 from 750G to 1TB
>>>>
>>>> The problem I am having is that I can't expand the linear (md3) array
>>> to
>>>> grow the extra 250G of space.
>>>>
>>>> Could anyone suggest how I might be able to get the extra 250G of
>>> space
>>>> to become available?
>>>
>>> If you think about this for a few minutes more, and re-read how md
>>> --linear works, and thus how growing a linear array works, you'll
>>> surely
>>> understand why you can't do what you're attempting to do.
>>
>> Actually, no I don't understand the problem... From my (probably limited) understanding, linear simply appends each drive to the array. I understand that you would not be able to increase the size of any constituent device which is not the last component of the array, but I don't see any reason why it is not possible to increase the size of the last component. (Which is what I am attempting to do)
>>
>>> As for seeing that extra 250GB, I don't have an answer.  Typically
>>> linear arrays are used in lieu of growing constituent member arrays.
>>> That's kinda the whole point of linear (concatenation).
>>
>> Well, the only other alternative I can think of is to reduce the size of the array back to 750G, reduce the size of the partitions for that array to 750G. Then create a new 250G partition on the two 1TB drives, create a fourth RAID1 array, and then add that 4th RAID1 array to the end of the existing linear array. This just didn't seem like a very good solution (ie, not clean).
> 
> This is the only sure fire way I see ATM to do this.  But I agree, it's
> not very clean.  I'm a big proponent of only one array per physical
> disk, as I stated recently, and the reasons for it.  Given what I'm
> guessing your workload profile is, it wouldn't make a difference.
> 
>>> You could try deleting the linear array and simply creating a new one.
>>> But surely the changed offsets would wreak havoc on the filesystem
>>> currently spanning this mess.
>>
>> Perhaps this would work. If I delete the linear array and re-create, with assume-clean (or whatever the right flag is, I'll read the man page later when I'm doing it), then like I said, the first component device will be the same, the second component device is the same, but just happens to be bigger. Any comments on whether this should work?
>>
>> What should I do to ensure that the component devices are ordered the way I think they are? Apparently the numbers in /proc/mdstat just tell me what order the devices were added, not what order they are in the array?
>>
>> Thank you for your advice.
> 
> The best advice I can give you is to wait for Neil Brown to weigh in
> before you make any such changes.
> 


