From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: External bitmap, questions
Date: Sat, 19 Feb 2011 05:42:53 +0000
Message-ID: <AANLkTinYr3UjU5X3Hfz0rNh0uciDEo34r4W624qSJzWG@mail.gmail.com>
References: <AANLkTinb3TvJr_-GPjMhXsyA-zwkf45GRAfpb7+Xio6H@mail.gmail.com>
	<20110219154924.2218c87c@notabene.brown>
	<AANLkTimpQ2=EM97ELX3z4c=Yf6gDp=Ekdn6m+ws6O8rm@mail.gmail.com>
	<20110219163018.26058ce3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110219163018.26058ce3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19 February 2011 05:30, NeilBrown <neilb@suse.de> wrote:
> On Sat, 19 Feb 2011 04:55:32 +0000 Mathias Bur=C3=A9n <mathias.buren@=
gmail.com>
> wrote:
>
>> On 19 February 2011 04:49, NeilBrown <neilb@suse.de> wrote:
>> > On Sat, 19 Feb 2011 00:47:10 +0000 Mathias Bur=C3=A9n <mathias.bur=
en@gmail.com>
>> > wrote:
>> >
>> >> Hi,
>> >>
>> >> >From the mdadm manual:
>> >>
>> >> "-b, --bitmap=3D
>> >> [...]
>> >> Note: external bitmaps are only known to work on ext2 and ext3.
>> >> Storing bitmap files on other filesystems may result in serious
>> >> problems."
>> >>
>> >> I was planning to store the external bitmap on an ext4 partition.=
 Will
>> >> this be a problem, or is the warning there because it hasn't been
>> >> tested enough but no problems found?
>> >
>> > External bitmaps use 'BMAP' to find where the file lives on the de=
vice and
>> > then writes directly to the device - not through the filesystem.
>> >
>> > So as long as there is no tail-packing to block migration happenin=
g it should
>> > work fine.
>> >
>> > I haven't looked inside ext4 but I am fairly confident that extern=
al bitmaps
>> > will work properly.
>> >
>> > NeilBrown
>> >
>> >
>>
>> Thanks, Neil. Are there any differences between using an internal or
>> external bitmap? Also, does one need a bitmap at all when not planni=
ng
>> to "mess" with the array? (does it provide any other purpose?)
>
> The difference between internal and external is simply that one is st=
ored in
> the array - a copy on each device - and the other is stored externall=
y to the
> array =C2=A0- a single copy in a file.
> External are slightly harder to work with as you need somewhere separ=
ate to
> store the bitmap (it cannot be in the array) and you need to tell mda=
dm where
> to find it (so it needs to be listed in mdadm.conf).
>
> I don't know what you mean by "mess" with the array. =C2=A0The main p=
urpose of the
> bitmap is the accelerate resync after an unclean shutdown. =C2=A0The =
secondary
> purpose is to accelerate recovery if you remove and then re-add a dev=
ice.
> Maybe that is what you mean by "mess with".
>
> So if you don't want to "mess" with the array and you are certain tha=
t your
> machine will never crash, then you don't really need a bitmap.
>
> NeilBrown
>
>

Hi,

Yes, you understood me correctly! Sorry, I should've been more clear.
That answers my questions, thanks a bunch :-)

// Mahtias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
