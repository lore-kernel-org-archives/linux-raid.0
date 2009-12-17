From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Idea for new RAID type - background extended recovery information
Date: Wed, 16 Dec 2009 17:11:17 -0800
Message-ID: <4877c76c0912161711m52af0b3cudc90e59073508758@mail.gmail.com>
References: <4877c76c0912090106i684924edn7915c6609ab574f5@mail.gmail.com>
	 <alpine.DEB.1.10.0912091143350.23464@uplift.swm.pp.se>
	 <1260602531.7209.10.camel@localhost>
	 <4877c76c0912121947m42a62a61y2b2a4a0a74b4d5e1@mail.gmail.com>
	 <87iqc76p01.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87iqc76p01.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Kasper Sandberg <postmaster@metanurb.dk>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Dec 16, 2009 at 5:13 AM, Goswin von Brederlow <goswin-v-b@web.d=
e> wrote:
> Michael Evans <mjevans1983@gmail.com> writes:
>
>> On Fri, Dec 11, 2009 at 11:22 PM, Kasper Sandberg
>> <postmaster@metanurb.dk> wrote:
>>> On Wed, 2009-12-09 at 11:53 +0100, Mikael Abrahamsson wrote:
>>>> On Wed, 9 Dec 2009, Michael Evans wrote:
>>>
>>> while this could work, i would personally far rather see raid6 gain=
 all
>>> the recovery/sanity options possible. raid6 has multiple copies of =
the
>>> same data, and as long as you have >2 copies, you can begin to look=
 at
>>> all the data sets, and with a pretty good probability weed out the =
bad
>>> set.
>>>
>>
>> While I would like to have a layer that any storage use, including
>> other raid levels, could reside within. =A0Imagine how much smarter
>> raid6 could be if it already knew in advance which stripes had gone
>> bad? =A0Or if files older than a few seconds could also gain an
>> additional 'bad sector' survival; allowing the loss of whatever norm=
al
>> raid tolerances plus a bad sector or two. =A0It would not be require=
d,
>> but I believe it would be a good way of adding assurance to long-ter=
m
>> storage segments.
>>
>> I implore you to comment on the original suggestion, or my reply to
>> his reply as well.
>
> I think that really belongs in the filesystem. You don't want to wast=
e
> parity on data that isn't in use and you want to be able to connect
> bad data with the relevant files easily. So go use zfs or the like. :=
)
>
> MfG
> =A0 =A0 =A0 =A0Goswin
>

The same argument can be made for all current levels of RAID as well.
The primary reason we are still using RAID layers is that the majority
of, virtually all, filesystems currently in use lack the capacity.
Additionally it is likely that even with new maturing filesystems that
do support RAID style storage we will still need to rely on the
protection of RAID for backwards compatibility.

I do however agree that the goals of the current RAID system and even
potentially the algorithms for creating and recovering parity blocks
can, and should be, shared with any portion of the kernel; also
possibly even userspace via library abstraction (in the case of
hardware acceleration).  It only adds additional failure points to
have multiple copies of very similar procedures.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
