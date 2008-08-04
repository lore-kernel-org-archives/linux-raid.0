From: "Conway S. Smith" <beolach@gmail.com>
Subject: Re: RAID5 to RAID6 migration
Date: Mon, 4 Aug 2008 07:57:58 -0600
Message-ID: <20080804075758.2d7cdd6b@hardcode42.net>
References: <6c4602af0808040544k2b1a3028vf0867a9b32958b25@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6c4602af0808040544k2b1a3028vf0867a9b32958b25@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-2?B?TWljaGGzIFByenmzdXNraQ==?= <mikylie@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 4 Aug 2008 14:44:41 +0200
"Micha=B3 Przy=B3uski" <mikylie@gmail.com> wrote:
> Good day,
>=20
> I've been a happy user of md RAID5 for over 8 months now. However,
> a few days ago, one (I wonder which one too) of my (3) WD RE2 750s
> decided to start clicking every few seconds during write. No disk
> shows any abnormalities from others on SMART tests, and raid5
> sync_action check, checks all right. Seems it's all safe for now,
> it's raid5 after all, but that brought to my attention a need, and
> possibility, to improve my redundancy, by migrating to RAID6. I was
> planning to grow the array anyways. Therefore, I sit back to google,
> and encountered a few issues I couldn't really resolve myself.
>=20
> First of all, what is the current state of RAID5->6 conversion?
> I've went through a lot of blogs, and it seem that this matter has
> been considered log ago to be added to mdadm, however I was unable
> to find any definitive information about that for now. I've read,
> well skimmed, latest mdadm source and I cannot really say I see it
> there. What's more, I recall reading about future possibility (or
> lack of it) to change the raid5/6 chunk size, in a way of reshape.
> I've not found any updates on that since then. It's mostly out of
> curiosity, as it seems I'll have to totally recreate my raid
> anyways.
>=20

My understanding from when I asked a while ago is that RAID5->6
is still a planned feature, but shouldn't be expected or counted on
for the foreseeable future.  I don't know anything about changing
chunk size on a live array.

Why are you thinking you'll have to totally recreate your raid anyway?
(I'm assuming you meant even if RAID5->6 reshape was possible, you'd
still be recreating it instead of reshaping).

> <snip>
>=20
> Now, back to the point. What should I do? :) I want to migrate my
> 1.1TiB of data, from 3 hdd RAID5 to, most likely, a 5 hdd RAID6.
> I guess it's the very last moment, size-of-data-wise, to accommodate
> all data during migration.
>=20
> I see the following ways, supposing there's no reshape from raid5
> to raid6.
>=20
> 1. Copy stuff to 2 new hdds (not raid'ed), create a slightly
> degraded raid6 out of old 3 hdds (making raid6 looks like it should
> have had 4), copy stuff over to raid6, and then add/reshape/etc.
>=20
> 2. Create a totally degraded raid6 with 2 new hdds, lacking 2
> drives. Copy from current, operational, raid5, and then
> add/reshape/etc.
>=20
> 3. (risky) Check current raid5, and if it's checks ok, degrade it!
> Create a 4 hdd raid6 (4 out of 4 operational), copy stuff from
> degraded raid5, add/reshape/etc.
>=20

I'd actually lean towards a fourth option: keeping the existing
RAID5, possibly reshaped to add more space on a new disk, and then=20
have another new disk as a hot spare.  Not as good redundancy as
moving to RAID6, but much simpler w/ the current md feature set.
Except above you said you thought you'd have to recreate the array
anyway, in which case you may as well go to RAID6 now.  Of the three
methods you show, I think #2 looks best, as it only involves one copy
step.  The totally degraded RAID6 will be slow, but I doubt as slow
as another copy step.


Good luck,
Conway S. Smith
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
