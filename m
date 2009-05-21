From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Subject: [001/002 ] raid0 reshape
Date: Thu, 21 May 2009 15:20:42 -0400
Message-ID: <87f94c370905211220n4e686a30ke452a56a2690d22b@mail.gmail.com>
References: <1241300764.5607.36.camel@raz>
	 <e9c3a7c20905191109s92db696ue31a20b0816a4aed@mail.gmail.com>
	 <18965.16276.485692.812516@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18965.16276.485692.812516@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, raz ben yehuda <raziebe@013.net>, linux-raid@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids

On Thu, May 21, 2009 at 7:48 AM, Neil Brown <neilb@suse.de> wrote:
> On Tuesday May 19, dan.j.williams@intel.com wrote:
>> On Sat, May 2, 2009 at 2:46 PM, raz ben yehuda <raziebe@013.net> wro=
te:
>> > Neil Hello
>> > The bellow is the raid0 grow code.I have decided to fix raid0 and =
not
>> > perform the transformation raid0-raid4-raid0 due to two reasons:
>> > 1. raid0 zones. this patch support any zone transformations.
>> > 2. Undesired dependency of raid0 over raid4 re-striping code.
>>
>> Hi Raz,
>>
>> Can you explain a bit more about why the raid4 approach is
>> undesirable? =A0I think making reshape only available to raid0 array=
s
>> where all the members are the same size is a reasonable constraint.
>> We then get the nice benefit of reusing the raid5 reshape
>> infrastructure. =A0In other words I am not convinced that the benefi=
ts
>> of reimplementing reshape in raid0 outweigh the costs.
>
> I've been thinking about this too... Is it something we really want t=
o
> do?
>
> My thoughts include:
>
> =A0- I don't like special cases - it would be nice to support reshape=
 on
> =A0 all arrays, even RAID0 with different sizes devices.
> =A0- Anyone who does this with a raid0 made of simple drives is askin=
g
> =A0 for trouble. =A0But a RAID0 over a bunch of RAID5 or RAID1 might =
make
> =A0 sense.
> =A0- Maybe we should support different sized drives in RAID4. =A0As l=
ong
> =A0 as the parity drive is as big as the largest data drive it could =
be
> =A0 made to work. =A0Similarly hot spares would need to be big, but y=
ou
> =A0 could have 2 hot spares and take the smallest one that is big
> =A0 enough.
> =A0 If a drive in the RAID4+ (or is it is the thing called NORAID?)
> =A0 failed and was replaced with a bigger drive, it would be cool to =
be
> =A0 able to incorporate that extra space into the array.
>
> =A0 If we did all that, then the 0->4->0 conversion could make use of
> =A0 the same code.
> =A0- Surely RAID0 is (like LVM) just a legacy idea until we get sensi=
ble
> =A0 file systems that actually understand multiple devices and do all
> =A0 this stuff for you are a more sensible level - so why are we
> =A0 busting a gut(*) to make RAID0 work well?? =A0Answer is of course
> =A0 that no-one has made a sensible file system yet. (well... maybe z=
fs
> =A0 or btrfs, not sure)
> =A0- If you read the DDF spec carefully, you find there is a secondar=
y
> =A0 raid level which stripes over heterogeneous arrays a different wa=
y.
> =A0 You divide every primary array up into N chunks, so the chunk siz=
es are
> =A0 different on different arrays. =A0Then you make a secondary array=
 by
> =A0 striping over those chunks.
> =A0 So e.g. you might have a 4Gig RAID5 and a 1GIG RAID1. =A0So the
> =A0 stripes array on top of these could take 4Meg from the RAID5, the=
n
> =A0 1Meg from the RAID1, then another 4 from the RAID5 etc.
> =A0 So we want to support that? =A0And would we want to reshape such =
a
> =A0 thing??
>
> So: lots of thoughts, some pointing in different directions.
> But I'm not against reshape code appearing in RAID0 providing it is
> well designed, maintainable, reliable, and doesn't slow down normal
> RAID0 processing. =A0I suspect we can get there.
>
> NeilBrown

This may be in a FAQ / wiki somewhere, but is the long range plan of
mdraid to stick to the formal "raid levels" or to implement "raid
equivalent levels".

I am a big fan of the raid equivalent concept and would love to see
mdraid moving in that direction.

=3D=3D> What I mean by raid equivalent levels

More and more arrays allow the user to simply say "give me a 100 GB
logical volume with Raid 5 equivalent protection.  The array then
looks at the drives it has available and puts together the necessary
pieces.  As drives are added, removed it moves the data around under
its own control, but maintains the raid equivalent protection.

Especially when working with dozens of drives and lots of logical
volumes it makes life much easier.  Admittedly it may come at a cost
of not being able to specify raid levels with the specificity that
mdraid currently allows.

=3D=3D>

The reason I ask if this is the goal is that doing so may factor into
decisions about how reshaping is implemented.

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
=46irst 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.p=
df

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
