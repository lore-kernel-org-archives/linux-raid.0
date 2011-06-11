From: Durval Menezes <durval.menezes@gmail.com>
Subject: Re: Maximizing failed disk replacement on a RAID5 array
Date: Sat, 11 Jun 2011 19:35:17 -0300
Message-ID: <BANLkTimOqdb2VH26Zv=-VSJ4VYccAuv02w@mail.gmail.com>
References: <BANLkTimBYFhjQ-sC9DhTMO+PG-Ox+A9S2Q@mail.gmail.com>
	<BANLkTimOxCF7diZfeFgtqCBWKZVF2pxyLg@mail.gmail.com>
	<BANLkTi=px08AWxfJJq+zNepCZM8aAsKECA@mail.gmail.com>
	<4DECF025.9040006@fnarfbargle.com>
	<BANLkTi=jPiXLySacVZqDkeThdG80K_HTxQ@mail.gmail.com>
	<4DECF841.1060906@fnarfbargle.com>
	<BANLkTikPxQvyDD3d_A6d3+GLKOLgqFJbFw@mail.gmail.com>
	<4DEDE6E7.40301@anonymous.org.uk>
	<4DF1F117.5010604@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DF1F117.5010604@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello John,

On Fri, Jun 10, 2011 at 7:25 AM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 07/06/2011 09:52, John Robinson wrote:
>>
>> On 06/06/2011 19:06, Durval Menezes wrote:
>> [...]
>>>
>>> It would be great to have a
>>> "duplicate-this-bad-old-disk-into-this-shiny-new-disk" functionalit=
y,
>>> as it would enable an almost-no-downtime disk replacement with
>>> minimum risk, but it seems we can't have everything... :-0 Maybe it=
's
>>> something for the wishlist?
>>
>> It's already on the wishlist, described as a hot replace.
>
> Actually I've been thinking about this. I think I'd rather the hot re=
place
> functionality did a normal rebuild from the still-good drives, and on=
ly if
> it came across a read error from those would it attempt to refer to t=
he
> contents of the known-to-be-failing drive (and then also attempt to r=
epair
> the read error on the supposedly-still-good drive that gave a read er=
ror, as
> already happens).

This looks like a very good idea. The old (failing) drive would be
kept "on reserve", ready to be accessed for eventual failed sectors on
the other old (good) drives...

> My rationale for this is as follows: if we want to hot-replace a driv=
e
> that's known to be failing, we should trust it less than the remainin=
g
> still-good drives, and treat it with kid gloves. It may be suffering =
from
> bit-rot. We'd rather not hit all the bad sectors on the failing drive=
,
> because each time we do that we send the drive into 7 seconds (or mor=
e, for
> cheap drives without TLER) of re-reading, plus any Linux-level re-rea=
ding
> there might be. Further, making the known-to-be-failing drive work ex=
tra
> hard (doing the equivalent of dd'ing from it while also still using i=
t to
> serve its contents as an array member) might make it die completely b=
efore
> we've finished.

I agree completely.

> What will this do for rebuild time? Well, I don't think it'll be any =
slower.

I think it will actually be faster.

> On the one hand, you'd think that copying from one drive to another w=
ould be
> faster than a rebuild, because you're only reading 1 drive instead of=
 N-1,
> but on the other, your array is going to run slowly (pretty much degr=
aded
> speed) anyway because you're keeping one drive in constant use readin=
g from
> it, and you risk it becoming much, much slower if you do run in to hu=
ndreds
> or thousands of read errors on the failing drive.
>
> So overall I think hot-replace should be a normal replace with a poss=
ible
> second source of data/parity.

Your reasoning sounds good to me.

> Thoughts?

Only sadness that it's not implemented yet... :-)

> Yes, I know, -ENOPATCH

Exactly :-)

Cheers,
--=20
   Durval Menezes.


>
> Cheers,
>
> John.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
