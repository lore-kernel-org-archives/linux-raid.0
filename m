From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Making spare device into active
Date: Sat, 9 Aug 2014 10:33:49 +0200
Message-ID: <CAAOsTSn=SCbBmEoViMvVvRmR9GbdVovLAJyFo_v2EFk2v+-TaQ@mail.gmail.com>
References: <CAAOsTSmkyCqLxrG-q2PQxnbXiAC1zz=qw6+ekMUmY=N+ZoHZ-w@mail.gmail.com>
	<20140809103159.338bef61@notabene.brown>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140809103159.338bef61@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2014-08-09 2:31 GMT+02:00 NeilBrown <neilb@suse.de>:
> On Fri, 8 Aug 2014 19:25:24 +0200 Patrik Horn=EDk <patrik@dsl.sk> wro=
te:
>
>> Hello Neil,
>>
>> I am experiencing the problem with one RAID6 array.
>>
>> - I was running degraded array with 3 of 5 drives. When adding fourt=
h
>> HDD one of the drives reported read errors, later disconnected and
>> then it was kicked out from array. (It was maybe doing of controller
>> and not drive, not important.)
>>
>> - The array has internal intent bitmap. After the drive reconnected
>> I've tried it to --re-add to array with 2 of 5 drives. I am not sure
>> if that should work? But it did not, recovery got interrupted just
>> after start and drive was marked as spare.
>
> No, that is not expected to work.  RAID6 survives 2 device failures, =
not 3.
> Once three have failed, the array has failed.  You have to stop it, a=
nd maybe
> put it back together.
>

I know what RAID6 is. There were no user writes at the time of kicking
out the drive so re-add with bitmap can theoretically work? I hoped
there were no writes at all so the drive can be re-added. But in any
case if you issue re-add and it cant be re-added mdadm should not
touch the drive and mark it spare. That is what complicated things,
after that it is not possible to reassemble the array without changing
device role back to active.

>>
>> - Right now I want to assemble array to get data out of it. Is it
>> possible to change "device role" field in device's superblock so it
>> can be assembled? I I have --examine and --detail output from before
>> the problem and so I know at which position the kicked drive belongs=
=2E
>
> Best option is to assemble with --force.
> If that works then you might have a bit of data corruption, but most =
of the
> array should be fine.
>

Should assemble with --force work also in this case, when one drive is
marked spare in his superblock? I am not 100% if I tried it, I choosed
different way for now.

=46or now I used dm snapshots over drives and recreated array on them.
It worked so I am rescuing data I need this way and will decide what
to do next.

Were write intent bitmaps destroyed when I tried to re-add drive? Now
on snapshots it is of course destroyed because I recreated array, but
on the drives I have bitmaps after failing array and trying re-add
kicked drive back.

There were no user space writes at the time, but some lower layers
maybe wrote something. If the bitmaps are preserved, is there any tool
to show their content and find out which chunks can be incorrect?

> If it fails, you probably need to carefully re-create the array with =
all the
> right bits in the right places.  Maybe sure to create it degraded so =
that it
> doesn't automatically resync, otherwise if you did something wrong yo=
u could
> suddenly lose all hope.
>
> But before you do any of that, you should make sure your drives and
> controller are actually working.  Completely.
> If any drive has any bad blocks, then get a replacement drive and cop=
y
> everything (maybe using ddrescue) from the failing drive to a good dr=
ive.
>
> There is no way to just change arbitrary fields in the superblock, so=
 you
> cannot simply "set the device role".
>
> Good luck.

Thanks. For now it seems that data is intact.

>
> NeilBrown
>
>
>>
>> - Changing device role field seems much safer way than recreating
>> array with --assume-clean, because with recreating too much things c=
an
>> go wrong...
>>
>> Thanks.
>>
>> Patrik
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
