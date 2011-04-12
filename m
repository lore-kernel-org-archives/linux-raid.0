From: Linux Raid Study <linuxraid.study@gmail.com>
Subject: Re: iostat with raid device...
Date: Mon, 11 Apr 2011 18:57:34 -0700
Message-ID: <BANLkTinFxHPuCgxERGc88W2KmZkzU_GF9Q@mail.gmail.com>
References: <BANLkTi=6uvCsQTpCi4xLUWzx5X7o99_=5g@mail.gmail.com>
	<20110409094629.2eae2d5b@notabene.brown>
	<BANLkTin2KP-_vy8jbmV3JB-LHHJNOEVCKw@mail.gmail.com>
	<20110409085044.GB417@cthulhu.home.robinhill.me.uk>
	<BANLkTim4fenro-GQchqJ0JzrcDAcJXG0UQ@mail.gmail.com>
	<20110411092559.GA20532@cthulhu.home.robinhill.me.uk>
	<BANLkTikYTECzE-2dCnC+jDT0wHNtgkNQ8Q@mail.gmail.com>
	<20110411095355.GB20532@cthulhu.home.robinhill.me.uk>
	<20110411201808.47cd19d5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110411201808.47cd19d5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Robin Hill <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If I use --assume-clean in mdadm, I see performance is 10-15% lower as
compared to the case wherein this option is not specified. When I run
without --assume_clean, I wait until mdadm prints "recovery_done" and
then run IO benchmarks...

Is perf drop expected?

Thanks.

On Mon, Apr 11, 2011 at 3:18 AM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 11 Apr 2011 10:53:55 +0100 Robin Hill <robin@robinhill.me.uk>=
 wrote:
>
>> On Mon Apr 11, 2011 at 02:36:50AM -0700, Linux Raid Study wrote:
>> > On Mon, Apr 11, 2011 at 2:25 AM, Robin Hill <robin@robinhill.me.uk=
> wrote:
>> > > On Mon Apr 11, 2011 at 01:32:34 -0700, Linux Raid Study wrote:
>> > >> On Sat, Apr 9, 2011 at 1:50 AM, Robin Hill <robin@robinhill.me.=
uk> wrote:
>> > >> > On Fri Apr 08, 2011 at 05:40:46PM -0700, Linux Raid Study wro=
te:
>> > >> >
>> > >> >> What I'm not sure of is if the device is newly formatted, wo=
uld raid
>> > >> >> recovery happen? What else could explain difference in the f=
irst run
>> > >> >> of IO benchmark?
>> > >> >>
>> > >> > When an array is first created, it's created in a degraded st=
ate - this
>> > >> > is the simplest way to make it available to the user instantl=
y. The
>> > >> > final drive(s) are then automatically rebuilt, calculating th=
e
>> > >> > parity/data information as normal for recovering a drive.
>> > >> >
>> > >> Thanks. So, the uneven (unequal) distribution of Wrtie/Sec numb=
ers in
>> > >> the iostat output are ok...is that correct?
>> > >>
>> > > If it hadn't completed the initial recovery, yes. =C2=A0If it _h=
ad_ completed
>> > > the initial recovery then I'd expect writes to be balanced (barr=
ing
>> > > any differences in hardware).
>> > >
>> > The initial recovery should normally be done during first few minu=
tes
>> > .... this is a newly formatted disk so there isn't any user data
>> > there. So, if I run the IO benchmark after say 3-4 min of doing, I
>> > should be ok?
>> >
>> > mdam --create /dev/md0 --raid5....
>> > mount /dev/md0 /mnt/raid
>> > mkfs.ext4 /mnt/raid
>> >
>> > ...wait 3-4 min
>> >
>> > run IO benchmark...
>> >
>> > Am I correct?
>> >
>> No, depending on the size of the drives, the initial recovery can ta=
ke
>> hours or even days. For RAID5 with N drives, it needs to read the
>> entirity of (N-1) drives, and write the entirity of the remaining dr=
ive
>> (whether there's any data or not, the initial state of the drives is
>> unknown so parity data has to be calculated for the entire array).
>>
>> Check /proc/mdstat and wait until the array has completed resync bef=
ore
>> running any benchmarks.
>
> or run
> =C2=A0mdadm --wait /dev/md0
>
> or create the array with --assume-clean. =C2=A0But if the array is ra=
id5, don't
> trust the data if a device fails: =C2=A0use this only for testing.
>
> NeilBrown
>
>
>>
>> Cheers,
>> =C2=A0 =C2=A0 Robin
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
