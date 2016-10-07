From: Dark Penguin <darkpenguin@yandex.ru>
Subject: Re: Why not just return an error?
Date: Fri, 7 Oct 2016 23:39:52 +0300
Message-ID: <57F80818.1050108@yandex.ru>
References: <57F6DF18.40703@yandex.ru> <20161007112151.GA4405@metamorpher.de>
 <e887908f-ba51-0f88-f891-f60e8bac50bd@turmel.org>
 <57F7CC10.3050607@yandex.ru>
 <94b1a4f4-adec-90b7-e804-2d8d2c94a7af@turmel.org>
 <57F7DF05.8090605@yandex.ru>
 <a39cdc87-394e-008c-2e50-6df1bd7394da@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a39cdc87-394e-008c-2e50-6df1bd7394da@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, keld@keldix.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> On 07/10/16 19:52, Phil Turmel wrote:
>
>>> MD raid has no idea what is at any given sector.  And with a
>>> near-infinite variety of layering choices, there's no way it's going to.
>>>    That's why *you* have to do this.  You trimmed my description of the
>>> only "easy option" actually trustable.
>>
>> I actually wanted to ask about that. Can you really ddrescue a drive
>> with a "hole" in it, re-add it and expect it to work?.. What happens if
>> you try to read from that "hole" again? And while I'm talking about
>> re-adding, when does it become impossible to "re-add" a drive?..
>
> Yes, ddrescue replaces unreadable areas with zeroes.  If those blocks
> were part of a file, then the file will have zeroes in it.  But they
> might have been where an inode or dirent were stored, in which case you
> get orphaned data elsewhere.  You need fsck to minimize that.

Ah, yes - in this case it's the only drive with this piece of 
information, and md doesn't keep any checksums or anything, so it will 
simply return those zeroes. Thanks for explaining this!


> ddrescue can provide a listing of the sectors it replaced so you can use
> filesystem forensic tools to pinpoint the problems (which file, etc).
>
> Note that all of the above are manual operations -- mdadm has no
> knowledge of the upper layers.
>
> None of the above uses --re-add.  Just assembly or forced assembly.
> Re-add is only to return a kicked drive to a *functional* array when the
> failure reason isn't really the drive.  (Controller, cable, power
> supply, etc.)  And re-add is only helpful if the array members have
> write-intent bitmaps so MD can figure out which parts of the re-added
> disk are out of date.  Re-add can be used if a drive is kicked for
> timeout mismatch, but is only helpful if the mismatch is addressed first.

"Forced assembly"... That's one thing I've missed. So forced-assembling 
a faulty drive back into a collapsed array after each failure would 
basically do what I wanted to do - and with no inconsistencies, because 
the array stops the moment the drive was kicked; but I can see why this 
is not a good idea. %)

So, "re-adding" is only possible with a functional array, and only when 
a write-intent bitmap is used. But I remember clearly that not long ago, 
one of my drives failed (most likely due to a cable popping off) and 
refused to re-add into a mirror with a bitmap, so I'm still wondering 
why was it not possible. At least in theory, as long as there is a 
bitmap, it should be possible to re-add, no matter how much later, right?..


-- 
darkpenguin
