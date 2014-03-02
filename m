From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: how to handle bad sectors in md control areas?
Date: Mon, 03 Mar 2014 09:21:44 +1100
Message-ID: <5313AEF8.3000505@eyal.emu.id.au>
References: <530DA2DE.9030705@eyal.emu.id.au> <20140303083838.6f6ba7c6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140303083838.6f6ba7c6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/03/14 08:38, NeilBrown wrote:
> On Wed, 26 Feb 2014 19:16:30 +1100 Eyal Lebedinsky <eyal@eyal.emu.id.au>
> wrote:
>
>> In another thread I investigated an issue with a pending sector, which now seems to be
>> a bad sector inside the md header (the first 256k sectors).
>>
>> The question now remaining: what is the correct approach to fixing this problem?
>
> You could "fix" it by simply redefining it not to be a problem.
> If you never get an error then is there a problem?

I did not know if this block is never accessed or just rarely so. I prefer to handle the
issue when I am in control rather than md encountering it, maybe at a bad time when
resyncing another disk, or growing or reshaping the array, or when the array fills up
and the write intent gets fully used.

I moved from raid5 to raid6 because the risk of another error while resyncing a
replaced raid5 disk (almost 10 hours of heavy activity) is becoming too high.

I also hoped that raid6 will be able to correctly repair an error (even when there
is no low level io error, just a mismatch) when assuming it is a "single" error
(using ECC terminology). I understand that this is not yet done?

>> The more general issue is what to do when any md control area develops an error. does
>> all data have redundant copies?
>
> We don't currently have any redundancy with a device.  Of course most
> metadata is replicated across all devices so there is redundancy in that
> sense.
> I have occasionally thought of creating a v1.3 metadata which duplicates the
> superblock at both end of the device.  Never quite seemed worth the effort
> though.
> The write-intent-bitmap would be a lot more expensive to duplicate but as it
> is identical on all devices, the  gain would be small (though there are cases
> where it would be useful).
>
> The bad-block log probably should be duplicated.  That wouldn't be too
> expensive and  might have  some real benefits....
>
>>
>> The simple way that I see is to fail the member, remove it, clear it (at least
>> --zero-superblock and write to the bad sector) and then add it. However this
>> will incur a full resync (about 10 hours).
>>
>> Is there a faster, yet safe way? I was thinking that a clean umount and raid stop
>> should allow a create with --assume-clean (which will write to the bad sector and
>> "fix" it), but the doco discourages this.
>
> Why do you think this will write the bad sector?

I assumed the full header (128MB) is initialised when it is created. Maybe not...

> When you --create and array it doesn't write too all the space on the array.
> It only writes what it needs to.  So the superblock, the write-intent-bitmap
> and maybe the bad-block-log.  But nothing else.

This (the last three words) is the information I was after.

> And most of that gets written during normal array activity.
>
> So if a block remains unwritten after stop/start/check, you can be fairy sure
> it isn't used at all, so you can ignore it.  Or write zeros to it.

This was my understanding too. The "ignore" was not optimal as apart from the emotional
stress from knowing there is an unreadable sector, there is the constant complaining
of smartd in the log. I zeroed it.

>> Also, it is not impossible to think that the specific bad sector (toward the end
>> of the header) is not actually used today, meaning I can live with it as is, or
>> write anything to the bad sector as it does not get used. Too involved though.
>>
>> A bad sector in the data area should be fixed with a standard raid 'check' action.
>>
>> TIA
>>
>
> NeilBrown

cheers
	Eyal

--
Eyal Lebedinsky (eyal@eyal.emu.id.au)
