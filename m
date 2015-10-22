From: Nate Dailey <nate.dailey@stratus.com>
Subject: Re: [PATCH 0/2] raid1/10: Handle write errors correctly in
 narrow_write_error()
Date: Thu, 22 Oct 2015 18:37:04 -0400
Message-ID: <56296510.4030702@stratus.com>
References: <1445357353-19906-1-git-send-email-Jes.Sorensen@redhat.com>
 <87pp092sid.fsf@notabene.neil.brown.name> <wrfjpp06lws6.fsf@redhat.com>
 <87r3kmziux.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r3kmziux.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org, William.Kuzeja@stratus.com, xni@redhat.com
List-Id: linux-raid.ids

The problem is that we aren't getting true write (medium) errors.

In this case we're testing device removals. The write errors happen because the 
disk goes away. Narrow_write_error returns 1, the bitmap bit is cleared, and 
then when the device is re-added the resync might not include the sectors in 
that chunk (there's some luck involved; if other writes to that chunk happen 
while the disk is removed, we're okay--bug is easier to hit with smaller bitmap 
chunks because of this).




On 10/22/2015 05:36 PM, Neil Brown wrote:
> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>
>> Neil Brown <neilb@suse.de> writes:
>>> Jes.Sorensen@redhat.com writes:
>>>
>>>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>>
>>>> Hi,
>>>>
>>>> Bill Kuzeja reported a problem to me about data corruption when
>>>> repeatedly removing and re-adding devices in raid1 arrays. It showed
>>>> up to be caused by the return value of submit_bio_wait() being handled
>>>> incorrectly. Tracking this down is credit of Bill!
>>>>
>>>> Looks like commit 9e882242c6193ae6f416f2d8d8db0d9126bd996b changed the
>>>> return of submit_bio_wait() to return != 0 on error, whereas before it
>>>> returned 0 on error.
>>>>
>>>> This fix should be suitable for -stable as far back as 3.9
>>> 3.10?
>>>
>>> Thanks to both of you!
>>>
>>> I took the liberty of changing the patches a little so they are now:
>>>
>>> -               if (submit_bio_wait(WRITE, wbio) == 0)
>>> +               if (submit_bio_wait(WRITE, wbio) < 0)
>>>
>>> because when there is no explicit test I tend to expect a Bool but these
>>> values are not Bool.
>>>
>>> Patches are in my for-linus branch and will be forwarded sometime this
>>> week.
>>>
>>> This bug only causes a problem when bad-block logs are active, so
>>> hopefully it won't have caused too much corruption yet -- you would need
>>> to be using a newish mdadm.
>> Neil,
>>
>> An additional twist on this one - Nate ran more tests on this, but was
>> still able to hit data corruption. He suggests the it is a mistake to
>> set 'ok = rdev_set_badblocks()' and it should instead be set to 0 if
>> submit_bio_wait() fails. Like this:
>>
>> --- raid1.c
>> +++ raid1.c
>> @@ -2234,11 +2234,12 @@
>>   		bio_trim(wbio, sector - r1_bio->sector, sectors);
>>   		wbio->bi_sector += rdev->data_offset;
>>   		wbio->bi_bdev = rdev->bdev;
>>   		if (submit_bio_wait(WRITE, wbio) < 0) {
>>   			/* failure! */
>> -			ok = rdev_set_badblocks(rdev, sector,
>> -						sectors, 0)
>> -				&& ok;
>> +			ok = 0;
>> +			rdev_set_badblocks(rdev, sector,
>> +					   sectors, 0);
>> +		}
>>
>> Question is whether this change has any negative impact in case of a
>> real write failure?
>>
>> I have actual patches, I'll send as a reply to this one.
>>
> If we unconditionally set ok to 0 on a write error, then
> narrow_write_error() will return 0 and handle_write finished() will call
> md_error() to kick the device out of the array.
>
> And given that we only call narrow_write_error()  when we got a write
> error, we strongly expect at least one sector to give an error.
>
> So it seems to me that the net result of this patch is to make
> bad-block-lists completely ineffective.
>
> What sort of tests are you running, and what sort of corruption do you
> see?
>
> NeilBrown

