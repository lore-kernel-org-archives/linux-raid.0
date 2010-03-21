From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: Problem converting from raid5 to raid6
Date: Sun, 21 Mar 2010 12:21:02 +0000
Message-ID: <73e903671003210521o5fe2e11cyf1fb6ef0f2f0b8f0@mail.gmail.com>
References: <20100321030107.GA18586@csy.ca> <4877c76c1003210328s313155c5u7c6e829d33f38abe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003210328s313155c5u7c6e829d33f38abe@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shane W <shane-kernel@csy.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Mar 21, 2010 at 10:28 AM, Michael Evans <mjevans1983@gmail.com> wrote:
> On Sat, Mar 20, 2010 at 8:01 PM, Shane W <shane-kernel@csy.ca> wrote:
>> Hello all,
>>
>> I am trying to convert a 5 disk raid5 array to a 6 disk
>> raid6 but am having no luck. I first added the 6th disk as
>> a spare then
>> mdadm --grow /dev/md3 --level 6
>> mdadm level of /dev/md3 changed to raid6
>> mdadm: /dev/md3: Something wrong - reshape aborted
>> mdadm: aborting level change
>>
>> dmesg doesn't show an error and neither does mdadm beyond
>> "something wrong". Is this supported?
>>
>> mdadm 3.1.1 Linux 2.6.32.8 x86_64.
>>
>> Thanks,
>> Shane

+1 on the critical section backup

And some bonus info: If you have a write-intent bitmap on the RAID5
array, you may have to get the bitmap out of the way of the reshape.
This one got me for a while. (I'm not sure about all cases, but I
believe you have to turn the bitmap off. I had an _internal_ bitmap,
turned it off, and only then my reshape kicked into gear. Remember to
turn it back on :) )

Good luck!

-- Kristleifur
