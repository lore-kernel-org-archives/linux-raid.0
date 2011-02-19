From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: External bitmap, questions
Date: Sat, 19 Feb 2011 12:20:41 +0000
Message-ID: <AANLkTinyG9idKMethaqzAqvpTe30-UwhkJ=_BMzc39Tr@mail.gmail.com>
References: <AANLkTinb3TvJr_-GPjMhXsyA-zwkf45GRAfpb7+Xio6H@mail.gmail.com>
	<20110219154924.2218c87c@notabene.brown>
	<AANLkTimpQ2=EM97ELX3z4c=Yf6gDp=Ekdn6m+ws6O8rm@mail.gmail.com>
	<20110219171437.3a6200e6@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110219171437.3a6200e6@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: NeilBrown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19 February 2011 12:14, Roman Mamedov <rm@romanrm.ru> wrote:
> On Sat, 19 Feb 2011 04:55:32 +0000
> Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:
>
>> > External bitmaps use 'BMAP' to find where the file lives on the de=
vice and
>> > then writes directly to the device - not through the filesystem.
>> >
>> > So as long as there is no tail-packing to block migration happenin=
g it
>> > should work fine.
>> >
>> > I haven't looked inside ext4 but I am fairly confident that extern=
al
>> > bitmaps will work properly.
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
> I have successfully stored an external bitmap on XFS for a brief time=
=2E
> However it proved difficult to ensure that the device storing the bit=
map is
> mounted, accessible and writable prior to boot scripts attempting to =
run the md
> arrays, so since then I just switched to an internal bitmap. The nega=
tive
> performance it had can be minimized to almost zero by using a larger =
bitmap
> chunk size.
>
> --
> With respect,
> Roman
>

I ended up storing the bitmap on my root filesystem (ext4) for now.
It's currently at the default size but I think I'll recreate it with
64MB size.

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
