From: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Subject: Re: Resize Raid5 devices
Date: Sat, 20 Jun 2009 16:21:22 +0200
Message-ID: <F1460A31-578A-4F80-8209-C56B47FBA367@bj-ig.de>
References: <62E07ACC-0F47-4B5F-94C7-29199ECE46FE@bj-ig.de> <87tz2e7xqt.fsf@frosties.localdomain> <4CB2808F-EB88-458A-9D2B-22E31A97EB4F@bj-ig.de> <19002.61619.121746.923481@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19002.61619.121746.923481@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids


Am 19.06.2009 um 03:58 schrieb Neil Brown:
>>> When you added it back the event counter would differ and the
>>> disk needs to be resynced completly. A bitmap would help limiting  
>>> this
>>> to the parts that have changed. Add an internal bitmap before you
>>> remove the next disk.
>>
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

Just for your information: I updated to OpenSuSE 11.1
(kernel 2.6.27.23-0.1) and tried to remove, grow, re-add the other
devices. For the first disk it worked - re-add took nearly no time
because of the bitmap. For the second disk - it did not work: complete
resync triggered. No idea why. It has been the same sequence of
commands on the same kind of device. There were no filesystem write
operations on the raid while updating.

I will wait for the resync to complete, offline the array, grow the
last device and reassemble with "--update=devicesize". Would there
have been a way to update the recorded device-size of the member
devices online? If the fail/grow/re-add cycle would have worked, I
still would have superblocks with the old size - right?

Regards
Ralf

-- 
Van Roy's Law: -------------------------------------------------------
        An unbreakable toy is useful for breaking other toys.



