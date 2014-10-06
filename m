From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Cancelling not pausing array check
Date: Mon, 6 Oct 2014 15:39:12 +0200
Message-ID: <CAAOsTSny1MUvQktS=nSLLGdvdWd3Ud4M7pPxgWKvHCamem8V4Q@mail.gmail.com>
References: <CAAOsTSnYjW-r7VoOL0SiNhsdv5kn9DunrfD3izuLDzaHaBb56Q@mail.gmail.com>
	<20141006133641.GA1928@cthulhu.home.robinhill.me.uk>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141006133641.GA1928@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

OK, thanks. So that should be fully working and correct way to do it
and I cant harm my array by this in any way?


2014-10-06 15:36 GMT+02:00 Robin Hill <robin@robinhill.me.uk>:
> On Mon Oct 06, 2014 at 03:29:13PM +0200, Patrik Horn=EDk wrote:
>
>> Hello,
>>
>> is it possible to cancel RAID 6 array check? echo check >
>> /sys/block/mdX/md/sync_action apparently only pauses it and next che=
ck
>> continuing from saved position. (I guess /sys/block/mdX/md/sync_min)
>>
>> I want to achieve two things:
>>
>> - Start check from the start of the array.
>>
>> - Be sure I can shutdown array without any ill effect because check
>> was interrupted.
>>
>> I guess that position will be cleared when array is stopped and
>> started again, but I dont want to guess and experiment... :)
>>
>> Thanks.
>>
>> Best regards,
>>
>> Patrik
>
> You'd echo idle to the sync_action to pause/stop the check. If you wa=
nt
> to restart from the beginning next time, just echo 0 to sync_min
> (similarly, if you just want to check/repair a specific range then se=
t
> sync_min and sync_max before the check/repair).
>
> Cheers,
>     Robin
> position.
>
> --
>      ___
>     ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
>    / / )      | Little Jim says ....                            |
>   // !!       |      "He fallen in de water !!"                 |
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
