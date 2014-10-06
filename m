From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Cancelling not pausing array check
Date: Tue, 7 Oct 2014 00:57:40 +0200
Message-ID: <CAAOsTS=7LnqWkNMVvk6JHG3D=wZ0wx27BnRJNedOiLV+9ZZQuA@mail.gmail.com>
References: <CAAOsTSnYjW-r7VoOL0SiNhsdv5kn9DunrfD3izuLDzaHaBb56Q@mail.gmail.com>
	<20141007075944.30be70ae@notabene.brown>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141007075944.30be70ae@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2014-10-06 22:59 GMT+02:00 NeilBrown <neilb@suse.de>:
> On Mon, 6 Oct 2014 15:29:13 +0200 Patrik Horn=EDk <patrik@dsl.sk> wro=
te:
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
>
> Why ever not?  Guessing and experimenting is AWESOME.  We call it "Sc=
ience".
> I can understand that you might not want to experiment we real data, =
but
> creating a few loop-back devices with "losetup", forming them into an=
 array,
> and experimenting on that can be very worthwhile.

Yeah, I fully agree. I love guessing and experimenting. In this case I
will be guessing if you write it as it should be written and we will
then test it on your production data :) Do we have a deal?

Regarding loopback devices, I of course sometimes test it. If I am in
some potential trouble I usually go further and testing it on cow dm
snapshots over drives, because you never know if it will work on
devices in your state exactly same as on just created small loopback
devices. But maybe I cannot think about all the factors and the most
effective way to know is to ask.

Patrik

>
> NeilBrown
>
>
>>
>> Thanks.
>>
>> Best regards,
>>
>> Patrik
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
