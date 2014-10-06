From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Cancelling not pausing array check
Date: Mon, 6 Oct 2014 19:41:06 +0200
Message-ID: <CAAOsTSkyON_8mPu8C21Z3UPTyWvfa_sVKa-J0rHz7kewvy5=oQ@mail.gmail.com>
References: <CAAOsTSnYjW-r7VoOL0SiNhsdv5kn9DunrfD3izuLDzaHaBb56Q@mail.gmail.com>
	<20141006133641.GA1928@cthulhu.home.robinhill.me.uk>
	<CAAOsTSny1MUvQktS=nSLLGdvdWd3Ud4M7pPxgWKvHCamem8V4Q@mail.gmail.com>
	<20141006135314.GB1928@cthulhu.home.robinhill.me.uk>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141006135314.GB1928@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2014-10-06 15:53 GMT+02:00 Robin Hill <robin@robinhill.me.uk>:
> On Mon Oct 06, 2014 at 03:39:12PM +0200, Patrik Horn=EDk wrote:
>
>> 2014-10-06 15:36 GMT+02:00 Robin Hill <robin@robinhill.me.uk>:
>> > On Mon Oct 06, 2014 at 03:29:13PM +0200, Patrik Horn=EDk wrote:
>> >
>> >> Hello,
>> >>
>> >> is it possible to cancel RAID 6 array check? echo check >
>> >> /sys/block/mdX/md/sync_action apparently only pauses it and next =
check
>> >> continuing from saved position. (I guess /sys/block/mdX/md/sync_m=
in)
>> >>
>> >> I want to achieve two things:
>> >>
>> >> - Start check from the start of the array.
>> >>
>> >> - Be sure I can shutdown array without any ill effect because che=
ck
>> >> was interrupted.
>> >>
>> >> I guess that position will be cleared when array is stopped and
>> >> started again, but I dont want to guess and experiment... :)
>> >>
>> >
>> > You'd echo idle to the sync_action to pause/stop the check. If you=
 want
>> > to restart from the beginning next time, just echo 0 to sync_min
>> > (similarly, if you just want to check/repair a specific range then=
 set
>> > sync_min and sync_max before the check/repair).
>> >
>> OK, thanks. So that should be fully working and correct way to do it
>> and I cant harm my array by this in any way?
>>
> A check is always safe (well, excepting physical disk issues or issue=
s
> with overloading the I/O subsystem, but those are issues not limited =
to
> check) as it's read-only.
>
> The sync_min and sync_max values need to be multiples of the chunk si=
ze
> (it throws an error otherwise), which ensures a whole stripe is being
> checked/repaired (otherwise you could have issues).
>
> The kernel documentation describes setting sync_min/sync_max, so it's=
 an
> expected operation. Whether there's another way of doing the same thi=
ng
> I don't know - I've not heard of one though.

If that is recommended way in kernel documentation, that is of course
all I wanted :)

BTW sync_min is reset to 0 also when you stop and start the array as I
found out...

>
> Cheers,
>     Robin
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
