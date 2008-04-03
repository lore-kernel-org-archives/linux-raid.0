From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: performance problems with raid10,f2
Date: Thu, 3 Apr 2008 21:20:37 +0100
Message-ID: <18421.15381.649822.295786@tree.ty.sabi.co.uk>
References: <20080314231151.GA14568@rap.rap.dk>
	<20080320172817.GA27070@rap.rap.dk>
	<18408.35320.92714.891870@notabene.brown>
	<20080325103656.GA4911@rap.rap.dk>
	<18408.64635.201923.65782@tree.ty.sabi.co.uk>
	<20080402211315.GA7899@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080402211315.GA7899@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Wed, 2 Apr 2008 23:13:15 +0200, Keld J=F8rn Simonsen
>>> <keld@dkuug.dk> said:

[ ... slow RAID reading ... ]

>> That could be the usual issue with apparent pauses in the
>> stream of IO requests to the array component devices, with
>> the usual workaround of trying 'blockdev --setra 65536
>> /dev/mdN' and see if sequential reads improve.

keld> Yes, that did it!=20

But that's as usual very wrong. Such a large readhead has
negative consequences, and most likely is the result of both
some terrible misdesign in the Linux block IO subsystem (from
some further experiments it is most likely related to "plugging")
and integration of MD into it.

However I have found that on relatively fast machines (I think)
much lower values of read-ahead still give reasonable speed,
with some values being much better than others. For example with
another RAID10 I get pretty decent speed with a read-ahead of
128 on '/dev/md0' (but much worse with say 64 or 256). On others
1000 sectors read-ahead is good.

The read-ahead needed also depends a bit on the file system
type, don't trust tests done on the block device itself.

So please experiment a bit to try and reduce it, at least until
I find the time to figure out the (surely embarrasing) reason
why it is needed and how to avoid it, or the Linux block IO and
MD maintainers confess (they almost surely already know why)
and/or fix it already.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
