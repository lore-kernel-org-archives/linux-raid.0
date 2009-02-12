From: Wil Reichert <wil.reichert@gmail.com>
Subject: Re: [PATCH 00/18] Assorted md patches headed for 2.6.30
Date: Thu, 12 Feb 2009 07:28:59 -0800
Message-ID: <7a329d910902120728u146e7cddk6e7d990668c16345@mail.gmail.com>
References: <20090212031009.23983.14496.stgit@notabene.brown>
	 <20090212081148.GD9439@rap.rap.dk>
	 <12039e3b9172d1a1347b8396cab59f11.squirrel@neil.brown.name>
	 <20090212095305.GB11981@rap.rap.dk>
	 <780b8d5e33de8ec127222529e84f6026.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <780b8d5e33de8ec127222529e84f6026.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: =?UTF-8?Q?Keld_J=C3=B8rn_Simonsen?= <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 12, 2009 at 2:45 AM, NeilBrown <neilb@suse.de> wrote:
> On Thu, February 12, 2009 8:53 pm, Keld J=C3=B8rn Simonsen wrote:
>> On Thu, Feb 12, 2009 at 08:21:12PM +1100, NeilBrown wrote:
>>> On Thu, February 12, 2009 7:11 pm, Keld J=C3=B8rn Simonsen wrote:
>>> > On Thu, Feb 12, 2009 at 02:10:10PM +1100, NeilBrown wrote:
>>> >> Comments and testing very welcome.
>>> >
>>> > I would rather have functionality to convert raid10 to raid5.
>>> > raid1 should be depreciated, as raid10,n2 for all purposes is the=
 same
>>> > but better implementation and performance, and raid10,f2 and raid=
10,o2
>>> > are even better.  Nobody should use raid1 anymore.
>>>
>>> That is a fairly simplistic view.
>>
>> It was also formulated to provoke some thoughts.
>>
>>> raid1 supports --write-mostly and --write-behind which raid10 is
>>> unlikely
>>> ever to support.
>>
>> why?
>>
>> Anyway would it not be possible that this functionality be implement=
ed
>> for raid10,n2?
>
> It would be possible, but it might not be sensible.
>
> write-mostly and write-behind only really make sense when you have th=
e
> clear distinction between drives that raid1 gives you.
> These options don't make sense for raid10 in general.  Only in very s=
pecific
> layouts.
> If you like, raid1 is an implementation of a specific raid10 layout,
> where it makes sense to add some extra functionality.
>
>>
>> Some code to grow raid10 would also be desirable. Maybe it is some o=
f
>> the same operations that need to be applied: getting the old data in=
,
>> have it restructured for the new format, in a safe way, and possibly
>> with the help of an extra disk, or possibly not. It sounds non-trivi=
al
>> to me too.
>
> What particular growth scenarios are you interested it?
> Just adding a drive and restriping onto that?  i.e keep that
> same nominal layout but increase 'raid-disks'?
>
> That would be quite similar to the raid5 grow operation so it shouldn=
't
> be too hard to achieve.
> A 'grow' which changed the layout (e.g. near to far) would be a lot
> harder.

I'd previously seen the wikipedia article regarding Linux RAID10 and
its mention of the 3 disk case.  Out of academic curiousity, how does
the 2 disk RAID10 work?  Is it just a matter of have 2 identical
volumes and reading subsequent stripes from the alteranate drives?  Or
is the algorithm more complicated?

Wil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
