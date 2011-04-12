From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Growing 6 HDD RAID5 to 7 HDD RAID5
Date: Tue, 12 Apr 2011 22:53:44 +0100
Message-ID: <BANLkTimsU88r2yGpRL+4xB1hMU9-SGHvvA@mail.gmail.com>
References: <BANLkTi=yZkM464MbvEgAjEWPGrR+eieXCg@mail.gmail.com>
	<20110412231401.5bb9065c@natsu>
	<BANLkTim-iiYbza8ZZZv60ArRfXjnOuU7sg@mail.gmail.com>
	<20110413002238.3f31bdeb@natsu>
	<20110413071554.6537c52c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110413071554.6537c52c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Roman Mamedov <rm@romanrm.ru>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12 April 2011 22:15, NeilBrown <neilb@suse.de> wrote:
> On Wed, 13 Apr 2011 00:22:38 +0600 Roman Mamedov <rm@romanrm.ru> wrot=
e:
>
>> On Tue, 12 Apr 2011 18:21:13 +0100
>> Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:
>>
>> > If I use --layout=3Dpreserve , what impact will that have?
>> > If I preserve the layout, what is the final result of the array
>> > compared to not preserving it?
>>
>> Neil wrote about this on his blog:
>> "It is a very similar process that can now be used to convert a RAID=
5 to a
>> RAID6. We first change the RAID5 to RAID6 with a non-standard layout=
 that has
>> the parity blocks distributed as normal, but the Q blocks all on the=
 last
>> device (a new device). So this is RAID6 using the RAID6 driver, but =
with a
>> non-RAID6 layout. So we "simply" change the layout and the job is do=
ne."
>> http://neil.brown.name/blog/20090817000931
>>
>> Admittedly it is not completely clear to me what are the long-term d=
ownsides of
>> this layout. As I understand it does fully provide the RAID6-level r=
edundancy.
>> Perhaps just the performance will suffer a bit? Maybe someone can ex=
plain this
>> more.
>
> If you specify --layout=3Dpreserve, then all the 'Q' blocks will be o=
n one disk.
> As every write needs to update a Q block, every write will write to t=
hat disk.
>
> With our current RAID6 implementation that probably isn't a big cost =
- for
> any write, we need to either read from or write to each disk anyway.
>
> Anyway: =C2=A0the only possible problem would be a performance proble=
m, and I
> really don't know what performance impact there is - if any.
>
>>
>> If anything, I think it is safe to use this layout for a while, e.g.=
 in case
>> you don't want to rebuild 'right now'. You can always change the lay=
out to the
>> traditional one later, by issuing "--grow --layout=3Dnormalise". Or =
perhaps if
>> you plan to add another disk soon, you can normalise it on that occa=
sion, and
>> still gain the benefit of only one full reshape.
>
> Note that doing a normalise by itself later will be much slower than =
not
> doing a preserve now.
> Doing the normalise later when growing the the device again would be =
just as
> fast as no doing the preserve now.
>
> NeilBrown
>
>
>>
>> > =C2=A0Will the array have redundancy during the rebuild of the new=
 drive?
>>
>> If you choose --layout=3Dpreserve, your array immediately becomes a =
RAID6 with
>> one rebuilding drive. So this is the kind of redundancy you will hav=
e during
>> that rebuild - tolerance of up to one more (among the "old" drives) =
failure,
>> in other words, identical to what you currently have with RAID5.
>>
>
>

Right, so using --preserve seems like a sane and good option. Thanks
for the info, I'll let you know what happens, HDD should arrive the
next few days.

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
