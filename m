From: CoolCold <coolthecold@gmail.com>
Subject: Re: Kernel oops adding bitmap
Date: Thu, 22 Mar 2012 23:54:51 +0400
Message-ID: <CAGqmV7p_a3nwA2kxyhBYDvjCdiKHnS_6EGP==8NV0b1EmJxqhw@mail.gmail.com>
References: <4F67627D.8050205@nuclearwinter.com>
	<20120320083210.4a272426@notabene.brown>
	<4F67A7C7.1050803@nuclearwinter.com>
	<CAGqmV7qgQUxndmFzAU=cx3stQryOYRSRGPb_1HX9Nw9Ludot-A@mail.gmail.com>
	<20120322070308.2233d1dd@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120322070308.2233d1dd@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Larkin Lowrey <llowrey@nuclearwinter.com>, linux-raid <linux-raid@vger.kernel.org>, John Robinson <john.robinson@anonymous.org.uk>
List-Id: linux-raid.ids

On Thu, Mar 22, 2012 at 12:03 AM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 21 Mar 2012 17:21:55 +0400 CoolCold <coolthecold@gmail.com> w=
rote:
>
>> Btw, was interested in, where bitmap will be placed when adding it o=
n
>> live array? I.e. as it requires some diskspace, we should provide so=
me
>> free space, but where it can be taken from if array is already creat=
ed
>> and used by, say filesystem?
>
> For 0.90 metadata there is 60K of unused space after the superblock. =
=A0The
> bitmap is stored there.
>
> For 1.x, the metadata stores a data_offset and data_size. =A0All arra=
y data is
> in that range. =A0Anything out side there is available for mdadm to u=
se.
> When mdadm creates an array it reserves enough space for bitmap and p=
ossible
> other uses.
>
> NeilBrown
>
John, Neil, thanks for sharing this info! May be add it this to wiki?
>>
>> On Tue, Mar 20, 2012 at 1:40 AM, Larkin Lowrey
>> <llowrey@nuclearwinter.com> wrote:
>> > On 3/19/2012 4:32 PM, NeilBrown wrote:
>> >> On Mon, 19 Mar 2012 11:44:45 -0500 Larkin Lowrey
>> > <llowrey@nuclearwinter.com>
>> >> wrote:
>> >>
>> >>> The following command oopsed.
>> >>>
>> >>> mdadm -G --bitmap=3Dinternal /dev/md0
>> >>>
>> >>> The array is a two disk raid1 and hosts the root filesystem.
>> >>>
>> >>> Is it not possible/allowed to add a bitmap to an active/mounted =
array?
>> >>
>> >> It is. But it is busted.
>> >>
>> >> Either use an older mdadm (3.2.2 or earlier), or apply this patch
>> >>
>> >> http://neil.brown.name/git?p=3Dmd;a=3Dcommitdiff;h=3D4474ca42e257=
7563a919fd3ed782e2ec55bf11a2
>> >>
>> >> which has been sent to Linus already and should appear in -stable
>> > kernels in
>> >> a couple of weeks.
>> >>
>> >> NeilBrown
>> >
>> > Thank you for the explanation.
>> >
>> > --Larkin
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>
>>
>>
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
