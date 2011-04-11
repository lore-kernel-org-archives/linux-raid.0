From: Linux Raid Study <linuxraid.study@gmail.com>
Subject: Re: iostat with raid device...
Date: Mon, 11 Apr 2011 02:36:50 -0700
Message-ID: <BANLkTikYTECzE-2dCnC+jDT0wHNtgkNQ8Q@mail.gmail.com>
References: <BANLkTi=6uvCsQTpCi4xLUWzx5X7o99_=5g@mail.gmail.com>
	<20110409094629.2eae2d5b@notabene.brown>
	<BANLkTin2KP-_vy8jbmV3JB-LHHJNOEVCKw@mail.gmail.com>
	<20110409085044.GB417@cthulhu.home.robinhill.me.uk>
	<BANLkTim4fenro-GQchqJ0JzrcDAcJXG0UQ@mail.gmail.com>
	<20110411092559.GA20532@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110411092559.GA20532@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid Study <linuxraid.study@gmail.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
Cc: Robin Hill <robin@robinhill.me.uk>
List-Id: linux-raid.ids

The initial recovery should normally be done during first few minutes
=2E... this is a newly formatted disk so there isn't any user data
there. So, if I run the IO benchmark after say 3-4 min of doing, I
should be ok?

mdam --create /dev/md0 --raid5....
mount /dev/md0 /mnt/raid
mkfs.ext4 /mnt/raid

=2E..wait 3-4 min

run IO benchmark...

Am I correct?

Thanks.

On Mon, Apr 11, 2011 at 2:25 AM, Robin Hill <robin@robinhill.me.uk> wro=
te:
> On Mon Apr 11, 2011 at 01:32:34 -0700, Linux Raid Study wrote:
>> On Sat, Apr 9, 2011 at 1:50 AM, Robin Hill <robin@robinhill.me.uk> w=
rote:
>> > On Fri Apr 08, 2011 at 05:40:46PM -0700, Linux Raid Study wrote:
>> >
>> >> What I'm not sure of is if the device is newly formatted, would r=
aid
>> >> recovery happen? What else could explain difference in the first =
run
>> >> of IO benchmark?
>> >>
>> > When an array is first created, it's created in a degraded state -=
 this
>> > is the simplest way to make it available to the user instantly. Th=
e
>> > final drive(s) are then automatically rebuilt, calculating the
>> > parity/data information as normal for recovering a drive.
>> >
>> Thanks. So, the uneven (unequal) distribution of Wrtie/Sec numbers i=
n
>> the iostat output are ok...is that correct?
>>
> If it hadn't completed the initial recovery, yes. =C2=A0If it _had_ c=
ompleted
> the initial recovery then I'd expect writes to be balanced (barring
> any differences in hardware).
>
> Cheers,
> =C2=A0 =C2=A0Robin
> --
> =C2=A0 =C2=A0 ___
> =C2=A0 =C2=A0( ' } =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0 Robin Hill =C2=
=A0 =C2=A0 =C2=A0 =C2=A0<robin@robinhill.me.uk> |
> =C2=A0 / / ) =C2=A0 =C2=A0 =C2=A0| Little Jim says .... =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|
> =C2=A0// !! =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0"He fallen in =
de water !!" =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
