From: "NeilBrown" <neilb@suse.de>
Subject: Re: [PATCH 00/18] Assorted md patches headed for 2.6.30
Date: Thu, 12 Feb 2009 21:45:38 +1100 (EST)
Message-ID: <780b8d5e33de8ec127222529e84f6026.squirrel@neil.brown.name>
References: <20090212031009.23983.14496.stgit@notabene.brown>
    <20090212081148.GD9439@rap.rap.dk>
    <12039e3b9172d1a1347b8396cab59f11.squirrel@neil.brown.name>
    <20090212095305.GB11981@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212095305.GB11981@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, February 12, 2009 8:53 pm, Keld J=F8rn Simonsen wrote:
> On Thu, Feb 12, 2009 at 08:21:12PM +1100, NeilBrown wrote:
>> On Thu, February 12, 2009 7:11 pm, Keld J=F8rn Simonsen wrote:
>> > On Thu, Feb 12, 2009 at 02:10:10PM +1100, NeilBrown wrote:
>> >> Comments and testing very welcome.
>> >
>> > I would rather have functionality to convert raid10 to raid5.
>> > raid1 should be depreciated, as raid10,n2 for all purposes is the =
same
>> > but better implementation and performance, and raid10,f2 and raid1=
0,o2
>> > are even better.  Nobody should use raid1 anymore.
>>
>> That is a fairly simplistic view.
>
> It was also formulated to provoke some thoughts.
>
>> raid1 supports --write-mostly and --write-behind which raid10 is
>> unlikely
>> ever to support.
>
> why?
>
> Anyway would it not be possible that this functionality be implemente=
d
> for raid10,n2?

It would be possible, but it might not be sensible.

write-mostly and write-behind only really make sense when you have the
clear distinction between drives that raid1 gives you.
These options don't make sense for raid10 in general.  Only in very spe=
cific
layouts.
If you like, raid1 is an implementation of a specific raid10 layout,
where it makes sense to add some extra functionality.

>
> Some code to grow raid10 would also be desirable. Maybe it is some of
> the same operations that need to be applied: getting the old data in,
> have it restructured for the new format, in a safe way, and possibly
> with the help of an extra disk, or possibly not. It sounds non-trivia=
l
> to me too.

What particular growth scenarios are you interested it?
Just adding a drive and restriping onto that?  i.e keep that
same nominal layout but increase 'raid-disks'?

That would be quite similar to the raid5 grow operation so it shouldn't
be too hard to achieve.
A 'grow' which changed the layout (e.g. near to far) would be a lot
harder.

NeilBrown


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
