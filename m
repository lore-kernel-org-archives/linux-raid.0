From: jahammonds prost <gmitch64@yahoo.com>
Subject: Re: Failed Array Rebuild advice Please
Date: Wed, 11 Apr 2012 19:10:47 -0700 (PDT)
Message-ID: <1334196647.20850.YahooMailNeo@web125501.mail.ne1.yahoo.com>
References: <1334097164.41181.YahooMailNeo@web125506.mail.ne1.yahoo.com> <20120411090219.78392784@notabene.brown> <1334117647.68845.YahooMailNeo@web125505.mail.ne1.yahoo.com> <20120411144302.35f13f3d@notabene.brown>
Reply-To: jahammonds prost <gmitch64@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120411144302.35f13f3d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I think it is best to recover, and then reshape later.
=A0
Which is what I did. The destructive badblocks ran fine overnight, with=
 no errors on the drives that were failed out of the array. Interesting=
ly one of the additional drives that I want to add took an additional 6=
 hours to run badblocks, so I need to look into that a bit.
=A0
I am having a bit of an issue with the reshape tho... When I try and ad=
d one of the 2 additional devices I want to add (I'm going to add them =
one at a time), I get an error about the bitmap needing to be removed.
=A0
=A0=A0=A0=A0=A0=A0=A0=A0mdadm --grow /dev/md0 --raid-devices=3D16
=A0=A0=A0=A0=A0=A0=A0=A0mdadm: Need to backup 93184K of critical sectio=
n..
=A0=A0=A0=A0=A0=A0=A0=A0mdadm: Cannot set device shape for /dev/md0: De=
vice or resource busy
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0Bitmap must be removed bef=
ore shape can be changed

Now, the docs (and indeed several websites when I googled) suggest that=
 you can have a bitmap present on a grow, and the help suggests that yo=
u can even change it during a grow..


=A0=A0=A0=A0=A0=A0=A0=A0=A0If the word internal is given, then the bitm=
ap is stored with the metadata on the array, and so is replicated on al=
l devices.=A0 If the word none is given with --grow mode, then any bitm=
ap that is present is removed.


Is there an issue with the array, or just in my understanding and googl=
e foo?

I am running on Centos 6 (2.6.32-220.7.1.el6.x86_64) with madam (mdadm =
- v3.2.2 - 17th June 2011)


Thanks again.



=A0
----- Original Message -----
=46rom: NeilBrown <neilb@suse.de>
To: jahammonds prost <gmitch64@yahoo.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
Sent: Wednesday, 11 April 2012, 0:43
Subject: Re: Failed Array Rebuild advice Please

On Tue, 10 Apr 2012 21:14:07 -0700 (PDT) jahammonds prost
<gmitch64@yahoo.com> wrote:

> One other question as the badblocks progresses.
> =A0
> >=A0 It will then recovery both devices in parallel.
>=20
> How many additional devices can be done at the same time? I presume t=
hat I am going to have to=A0replace the 2 failed devices before I try a=
nd grow the array by adding 3 additional drives? I so, how many=A0addit=
ional drives can be rebuilt concurrently with a grow? Could I add 5 dev=
ices and not see too much of a performance hit? Or would it be more sen=
sible to add them one at a time?
>=20

I think it is best to recover, and then reshape later.=A0 I cannot prom=
ise that
doing them both at once will work .... it might but I have a feeling th=
at
there might be problems.

Adding three additional drives at once should work well enough in terms=
 of
performance.
However I would only do it if I were very very confident of the drives.
If you hit bad blocks you start losing drives, and if you have 3 drives=
 that
you haven't used before, the chance of losing them all during the resha=
pe -
while still small - becomes a little too high for comfort.

But if you have run heavy bad-blocks tests on them all and they appear =
to
work, then adding 3 drives at once should be fine.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
