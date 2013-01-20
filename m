From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Suboptimal raid6 linear read speed
Date: Sun, 20 Jan 2013 21:50:42 +0000
Message-ID: <20732.26290.571133.210024@tree.ty.sabi.co.uk>
References: <20130115123301.GA11948@rabbit.us>
	<50F55046.7050605@turmel.org>
	<20130115125507.GA12184@rabbit.us>
	<50F614F7.20104@hardwarefreak.com>
	<20130116025857.GA31112@rabbit.us>
	<50F70DB7.6020104@hardwarefreak.com>
	<alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se>
	<50F90857.3010305@hardwarefreak.com>
	<alpine.DEB.2.00.1301181015270.12098@uplift.swm.pp.se>
	<50F9D32F.7090606@hardwarefreak.com>
	<alpine.DEB.2.00.1301190838440.12098@uplift.swm.pp.se>
	<20732.17741.587765.199649@tree.ty.sabi.co.uk>
	<alpine.DEB.2.00.1301202155310.12098@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1301202155310.12098@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>> [ ... ] there are a few narrow cases where the rather skewed
>> performance envelopes of RAID5 and even of RAID6 match
>> workload and budget requirements. But it takes apparently
>> unusual insight to recognize these cases, so just use RAID10
>> even if you suspect it is one of those narrow cases.

> In your whole post you never touched on URE rates (well you
> did, but you didn't seem to this was a problem).

They are a big problem, especially because in a typical RAID set
they are not uncorrelated, either with each other or the
environment, and I wrote a lot about that.

The *absolute* level of URE rates matters less, but some people
on this thread have noticed that they are not that low, compared
with whole-disk reading, even the perhaps somewhat optimistic
ones quoted by manufacturers.

> I'm using RAID6 because I don't really care about performance,

That's a pretty unusual case, but perhaps that falls under the
"know better" qualification above, except that:

> but I do want to be able to fail one drive and have scattered
> URE handled while rebuilding.

RAID6 is not appropriate for this either.

Perhaps I have not been clear in my earlier comment, but the URE
rate is not a constant you can just (euphemism) uncritically
read from a spec sheet.

Let's try shouting:

  * THE URE RATE DEPENDS ON ENVIRONMENTAL FACTORS AND COMMON
    MODES OF FAILURE (INCLUDING THE AGE OF THE DRIVE).

  * In a typical incomplete or rebuilding RAID6 the aggregate
    URE rate is much higher than the single drive URE rate or
    even the RAID10 URE rate.

I also sometimes suspect that manufacturers quote ideal numbers;
for example I just had a look at some user manuals for a few
"enterprise" and "desktop" Seagate (they do very detailed
manuals) and their "annualized return rate" is usually around
0.4-0.7%, and many large sites report annual failure rates of
around 2-4%.

> I have had scattered URE hit me numerous times over the past
> 10 years.

That is indeed a big problem, and it is rare and good that you
don't underestimate it.

> With RAID6 they are handled nicely even with a failed drive.

Unfortunately RAID6 correlates failure modes across drives
because of the !"=A3$%^ parity, and increases them by stressing
all of them hard while the RAID6 set is incomplete or syncing.

Incomplete or syncing RAID6 not only has pretty bad speed, which
you don't care about, but drives up error rates, and you should
care about that.

Sure, most of the time one can replace the failed drive and sync
before something bad happens, but an incomplete or syncing RAID6
has at some point in the life of the RAID set a much higher
chance of 2 or more failures...

BTW important qualification as to all this: when people mention
BERs they really imply that this discussion is about *sector*
UREs, and *single*-sector ones in particular, which matters a
fair bit.

Because a typical RAID6 under the stress of being incomplete or
syncing can have something far worse than single-sector UREs, it
can trigger much more brutal mechanical or electronic failures.

While single-sector UREs are in most cases not such a big deal,
as usally losing a single sector's content allows for nearly
complete recovery; some/most drives IIRC can return the sector
content that has been reconstructed, which often is wrong in
only a few bits.

> If I cared about performance, I would either do what was
> discussed earlier in the thread (use smaller enterprise drives
> with better BER) in RAID10,

Whether "enterprise" drives effectively have a better URE is an
experimental question that is difficult to settle.

> or I would use threeway mirror RAID1 and use lvm to vg several
> RAID1:s together.

This particular case is not caring much about performance either
because linear (concat) is not as quick for most workloads as a
RAID0.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
