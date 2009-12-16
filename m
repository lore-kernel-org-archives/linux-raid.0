From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Idea for new RAID type - background extended recovery information
Date: Wed, 16 Dec 2009 14:13:18 +0100
Message-ID: <87iqc76p01.fsf@frosties.localdomain>
References: <4877c76c0912090106i684924edn7915c6609ab574f5@mail.gmail.com>
	<alpine.DEB.1.10.0912091143350.23464@uplift.swm.pp.se>
	<1260602531.7209.10.camel@localhost>
	<4877c76c0912121947m42a62a61y2b2a4a0a74b4d5e1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0912121947m42a62a61y2b2a4a0a74b4d5e1@mail.gmail.com>
	(Michael Evans's message of "Sat, 12 Dec 2009 19:47:58 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Kasper Sandberg <postmaster@metanurb.dk>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Michael Evans <mjevans1983@gmail.com> writes:

> On Fri, Dec 11, 2009 at 11:22 PM, Kasper Sandberg
> <postmaster@metanurb.dk> wrote:
>> On Wed, 2009-12-09 at 11:53 +0100, Mikael Abrahamsson wrote:
>>> On Wed, 9 Dec 2009, Michael Evans wrote:
>>
>> while this could work, i would personally far rather see raid6 gain all
>> the recovery/sanity options possible. raid6 has multiple copies of the
>> same data, and as long as you have >2 copies, you can begin to look at
>> all the data sets, and with a pretty good probability weed out the bad
>> set.
>>
>
> While I would like to have a layer that any storage use, including
> other raid levels, could reside within.  Imagine how much smarter
> raid6 could be if it already knew in advance which stripes had gone
> bad?  Or if files older than a few seconds could also gain an
> additional 'bad sector' survival; allowing the loss of whatever normal
> raid tolerances plus a bad sector or two.  It would not be required,
> but I believe it would be a good way of adding assurance to long-term
> storage segments.
>
> I implore you to comment on the original suggestion, or my reply to
> his reply as well.

I think that really belongs in the filesystem. You don't want to waste
parity on data that isn't in use and you want to be able to connect
bad data with the relevant files easily. So go use zfs or the like. :)

MfG
        Goswin
