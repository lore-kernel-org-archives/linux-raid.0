From: Neil Brown <neilb@suse.de>
Subject: Re: New RAID causing system lockups
Date: Tue, 21 Sep 2010 12:26:44 +1000
Message-ID: <20100921122644.517fcab0@notabene>
References: <AANLkTimTvPupaPuFbfpcCGC=0Ys9fQWihAgaADsrowqq@mail.gmail.com>
	<20100912064308.46d96742@notabene>
	<AANLkTikWY1QE_2HBADkVV1u1OSCktVT=ShQrCdNWBF8n@mail.gmail.com>
	<AANLkTimzmoyq_KHA1Q3JgEJSj2iuwYwiHRNR=_ZuLQCZ@mail.gmail.com>
	<AANLkTiknrUVCToYg8NM0dUX9kXVE_kTAwtuAqo09X-qj@mail.gmail.com>
	<20100914095111.6e3045c7@notabene>
	<AANLkTin=jy=xJTtN5mQ6U=rYw3p+_4-nmkhO7zqR0KLP@mail.gmail.com>
	<AANLkTimyEr9LnS2BOR+rXhwfU0rCE-MmYcjttaTyqAWT@mail.gmail.com>
	<20100914113516.63c883c4@notabene>
	<AANLkTimeeecqZX1Bn23=_41sBYO+P8h_b5Z6Gf_ACuA1@mail.gmail.com>
	<AANLkTi=uO6a1e_eGKcg6T2rD_ZpqNg_-X1u6qq=zA5J6@mail.gmail.com>
	<20100914134837.2e740a3e@notabene>
	<AANLkTimXabL-TyjqJ81syrx-Oxn50qexbA8q9p22sxJt@mail.gmail.com>
	<AANLkTinYaE07MzZ7LSPY18jtrsSdvj5sf7rnDqGEQP=z@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinYaE07MzZ7LSPY18jtrsSdvj5sf7rnDqGEQP=z@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hartman <mike@hartmanipulation.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 15 Sep 2010 17:49:44 -0400
Mike Hartman <mike@hartmanipulation.com> wrote:

> >> Hmmm..
> >> =C2=A0Can you try mounting with
> >> =C2=A0 =C2=A0-o barrier=3D0
> >>
> >> just to see if my theory is at all correct?
> >>
> >> Thanks,
> >> NeilBrown
> >>
> >
>=20
> Progress report:
>=20
> I made the barrier change shortly after sending my last message (abou=
t
> 40 hours ago). With that in place, I was able to finish emptying one
> of the non-assimilated drives onto the array, after which I added tha=
t
> drive as a hot spare and started the process to grow the array onto i=
t
> - the same procedure I've been applying since I created the RAID the
> other week. No problems so far, and the reshape is at 46%.
>=20
> It's hard to be positive that the barrier deactivation is responsible
> yet though - while the last few lockups have only been 1-16 hours
> apart, I believe the first two had at least 2 or 3 days between them.
> I'll keep the array busy to enhance the chances of a lockup though -
> each one so far has been during a reshape or a large batch of writing
> to the array's partition. If I make it another couple days (meaning
> time for this reshape to complete, another drive to be emptied onto
> the array, and another reshape at least started) I'll be pretty
> confident the problem has been identified.

Thanks for the update.

>=20
> Assuming the barrier is the culprit (and I'm pretty sure you're right=
)
> what are the consequences of just leaving it off? I gather the idea o=
f
> the barrier is to prevent journal corruption in the event of a power
> failure or other sudden shutdown, which seems pretty important, but i=
t
> also doesn't seem like it was enabled by default in ext3/4 until 2008=
,
> which makes it seem less critical.

Correct.  Without the barriers the chance of corruption during powerfai=
l is
higher.  I don't really know how much higher, it depends a lot on the
filesystem design and the particular implementation.  I think ext4 tend=
s to
be fairly safe - after all some devices don't support barriers and it h=
as to
do best-effort on those too.

>=20
> Even if the ultimate solution for me is to just leave it disabled I'm
> happy to keep trying patches if you want to get it properly fixed in
> md. We may have to come up with an alternate way to work the array
> hard enough to trigger the lockups though - my last 1.5TB drive is
> what's being merged in now. After that completes I only have one more
> pair of 750GBs (that will have to be shoehorned in using RAID0 again)=
=2E
> I do have a single 750GB left over, so I'll probably find a mate for
> it and get it added to. After that we're maxed out on hardware for a
> while.
>=20
> Mike

I'll stare at the code a bit more and see if anything jumps out at me.

Thanks,
NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
