From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Auto Rebuild on hot-plug
Date: Mon, 29 Mar 2010 17:46:15 -0700
Message-ID: <e9c3a7c21003291746o49191295r876c7fef50fe63a5@mail.gmail.com>
References: <20100325113543.0e2124c5@notabene.brown>
	 <905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com>
	 <e9c3a7c21003261737k1e753b08xc6f8eb45d0320be9@mail.gmail.com>
	 <4BB0ED13.6020507@redhat.com>
	 <e9c3a7c21003291436lb898278i21f988fd5f76bd53@mail.gmail.com>
	 <4BB13830.8070709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB13830.8070709@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "Labun, Marcin" <Marcin.Labun@intel.com>, Neil Brown <neilb@suse.de>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

On Mon, Mar 29, 2010 at 4:30 PM, Doug Ledford <dledford@redhat.com> wro=
te:
> On 03/29/2010 05:36 PM, Dan Williams wrote:
>> I agree once you have a DOMAIN you implicitly have a spare-group. =A0=
So
>> DOMAIN would supersede the existing spare-group identifier in the
>> ARRAY line and cause mdadm --monitor to auto-migrate spares between
>> 0.90 and 1.x metadata arrays in the same DOMAIN. =A0For the imsm cas=
e
>> the expectation is that spares migrate between containers regardless
>> of the DOMAIN line as that is what the implementation expects.
>
> Give me some clearer explanation here because I think you and I are
> using terms differently and so I want to make sure I have things righ=
t.
> =A0My understanding of imsm raid containers is that all the drives th=
at
> belong to a single option rom, as long as they aren't listed as jbod =
in
> the option rom setup, belong to the same container.

I think the disconnect in the imsm case is that the container to
DOMAIN relationship is N:1, not 1:1.  The mdadm notion of an
imsm-container correlates directly with a 'family' in the imsm
metadata.  The rules of a family are:

1/ All family members must be a member of all defined volumes.  For
example with a 4-drive container you could not simultaneously have a
4-drive (sd[abcd]) raid10 and a 2-drive (sd[ab]) raid1 volume because
any volume would need to incorporate all 4 disks.  Also, per the rules
if you create two raid1 volumes sd[ab] and sd[cd] those would show up
as two containers.

2/ A spare drive does not belong to any particular family
('family_number' is undefined for a spare).  The Windows driver will
automatically use a spare to fix any degraded family in the system.
In the mdadm/mdmon case since we break families into containers we
need a mechanism to migrate spare devices between containers because
they are equally valid hot spare candidate for any imsm container in
the system.

> That container is
> then split up into various chunks and that's where you get logical
> volumes. =A0I know there are odd rules for logical volumes inside a
> container, but I think those are mostly irrelevant to this discussion=
=2E
> So, when I think of a domain for imsm, I think of all the sata ports =
or
> sas ports under a single option rom. =A0From that perspective, spares=
 can
> *not* move between domains as a spare on a sas port can't be added to=
 a
> sata option rom container array. =A0I was under the impression that i=
f you
> had, say, a 6 port sata controller option rom, you couldn't have the
> first three ports be one container and the next three ports be anothe=
r
> container. =A0Is that impression wrong?

Yes, we can have exactly this situation.

This begs the question, why not change the definition of an imsm
container to incorporate anything with imsm metadata?  This definitely
would make spare management easier.  This was an early design decision
and had the nice side effect that it lined up naturally with the
failure and rebuild boundaries of a family.  I could give it more
thought, but right now I believe there is a lot riding on this 1:1
container-to-family relationship, and I would rather not go there.

> However, that just means (to me anyway) that I would treat all of the
> sata ports as one domain with multiple container arrays in that domai=
n
> just like we can have multiple native md arrays in a domain. =A0If a =
disk
> dies and we hot plug a new one, then mdadm would look for the degrade=
d
> container present in the domain and add the spare to it. =A0It would =
then
> be up to mdmon to determine what logical volumes are currently degrad=
ed
> and slice up the new drive to work as spares for those degraded logic=
al
> volumes. =A0Does this sound correct to you, and can mdmon do that alr=
eady
> or will this need to be added?

This sounds correct, and no mdmon cannot do this today.  The current
discussions we (Marcin and I) had with Neil offlist was extending
mdadm --monitor to handle spare migration for containers since it
already handles spare migration for native md arrays.  It will need
some mdmon coordination since mdmon is the only agent that can
disambiguate a spare from a stale device at any given point in time.

>> However this is where we get into questions of DOMAIN conflicting wi=
th
>> 'platform' expectations, under what conditions, if any, should DOMAI=
N
>> be allowed to conflict/override the platform constraint? =A0Currentl=
y
>> there is an environment variable IMSM_NO_PLATFORM, do we also need a
>> configuration op
>
> I'm not sure I would ever allow breaking valid platform limitations. =
=A0I
> think if you want to break platform limitations, then you need to use
> native md raid arrays and not imsm/ddf. =A0It seems to me that if you
> allow the creation of an imsm/ddf array that the BIOS can't work with
> then you've potentially opened an entire can of worms we don't want t=
o
> open about expectations that the BIOS will be able to work with thing=
s
> but can't. =A0If you force native arrays as the only type that can br=
eak
> platform limitations, then you are at least perfectly clear with the
> user that the BIOS can't do what the user wants.

Agreed.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
