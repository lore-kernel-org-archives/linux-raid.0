From: Stefan *St0fF* Huebner <st0ff@gmx.net>
Subject: Re: Pending sectors in valid array - how to proceed?
Date: Wed, 28 Jul 2010 22:27:48 +0200
Message-ID: <4C5092C4.6050708@gmx.net>
References: <4C506CF5.2080307@xunil.at> <4C5079C4.2050308@seoss.co.uk>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C5079C4.2050308@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@seoss.co.uk>
Cc: lists@xunil.at, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 Am 28.07.2010 20:41, schrieb Tim Small:
> Stefan G. Weichinger wrote:
>> md3 : active raid5 sdd3[3](S) sdc3[2] sdb3[1] sda3[0]
>>       15647104 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>>   
> ...
>
>> smartctl shows for /dev/sdb:
>>
>>   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always
>>       -       0
>> 195 Hardware_ECC_Recovered  0x001a   058   039   000    Old_age   Always
>>       -       146754005
>> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always
>>       -       13
>> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
>> Offline      -       13
>>
>> (relevant lines as far as I understand ...)
>>   
> Do you have any high-fly writes?  Are there lots of
> Hardware_ECC_Recovered on all the drives?  Is vibration likely to be an
> issue?  What's the drive/chassis?
Hardware ECC recovered means how many times the internal error
correction of the drive succeeded.  Indeed this may indicate vibration
or other external sources of errors.
>> I also read of a way of removing and re-adding a drive to get rid of
>> these sectors?
>>
>> Is this a recommended thing to do?
>> What would you recommend me to do?
>>   
> I think you should trigger a check, this should attempt to read these
> pending sectors (assuming they are within the boundaries of the array),
> along with every other sector in the array, and scrub them when the read
> fails (i.e. reconstruct the data from the other array members, and write
> them to the pending sectors on sdb - thus triggering reallocation of
> those sectors).
>
> echo check > /sys/block/md1/md/sync_action
Well, I also think this would be the way to go, but it depends on the
drives used!!!  Are the drives Customer Class or Enterprise Class
drives?  If they are Enterprise Class (i.e. Raid Edition), go ahead.  If
they're Customer Class, please enable ERC (if supported by the drives)
before scrubbing, as this needs to be there.  If ERC is not supported
(or not enabled), most likely when hitting a pending sector, the
respective drive will not respond while doing it's error correction.  It
will still be in the error recovery procedure, when mdraid tries to
rewrite the sector.  The rewrite will fail, as the drive won't respond. 
Then the drive gets kicked out of the array.
> etc.
>
> Personally, I'd then wait to see if/how the reallocated count goes up -
> if the sectors are the result of a one-off event, then no-problem, but
> if they steadily climb, then the drive is probably on its way out -
> those ECC_Recovered counts look a bit naff to me.  If you're nervous of
> losing a drive during resync, the the check is a good thing to do first,
> but you could also consider migrating the array to RAID6, to give you
> double redundancy...
I have had the situation, that pending sectors just went away ;)  No
reallocation occurred.  I just wanted to mention that this might be
another way it can go so you're not surprised if that happens.
> Cheers,
>
> Tim.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
dito,
Stefan
