From: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Subject: Re: Resize Raid5 devices
Date: Fri, 19 Jun 2009 10:04:42 +0200
Message-ID: <EF59F281-B4DA-478C-8D21-DECABCBCDA7E@bj-ig.de>
References: <62E07ACC-0F47-4B5F-94C7-29199ECE46FE@bj-ig.de> <87tz2e7xqt.fsf@frosties.localdomain> <4CB2808F-EB88-458A-9D2B-22E31A97EB4F@bj-ig.de> <19002.61619.121746.923481@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19002.61619.121746.923481@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids


Am 19.06.2009 um 03:58 schrieb Neil Brown:
>> There is an internal write intent bitmap at the array:
>> DatenGrab:/media # cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4] [raid1]
>> md3 : active raid5 sdf1[3] sdi1[0] sdj1[4] sdh1[1]
>>      3457099008 blocks super 1.2 level 5, 256k chunk, algorithm 2
>> [4/4] [UUUU]
>>      bitmap: 0/275 pages [0KB], 2048KB chunk
>>
>> Do you have an idea why this bitmap has been ignored?
>
> Probably a kernel bug.  There have been a couple of fixes relating to
> this since 2.6.25.  Hopefully it is all working in 2.6.30...
>
> The bug that you hit was probably the one fixed by
>  commit a0da84f35b25875870270d16b6eccda4884d61a7
> which is in 2.6.27.

Mh ... ok. So it may be a good idea to update to OpenSuSE 11.1 before
growing the other devices. Will do that at the weekend.

>>> Alternatively stop the raid completly, resize all the partitions and
>>> start the raid again. No need to fail/readd each disk in turn.
>>
>> good idea ...
>
> And when you re-assemble the array, use --update=devicesize.  That
> will ensure that md sees all of the new space on the devices.

This hint may have saved me a lot of time.

Thanks a lot
Ralf

-- 
Van Roy's Law: -------------------------------------------------------
        An unbreakable toy is useful for breaking other toys.



