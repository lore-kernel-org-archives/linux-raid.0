From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: high throughput storage server?
Date: Thu, 24 Feb 2011 14:28:14 -0600
Message-ID: <AANLkTi=DFXqt5VAJHdVkzigM1UfdNKwrTX589aCcBm4Q@mail.gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
	<AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com>
	<20110215044434.GA9186@septictank.raw-sewage.fake>
	<ijdhtg$on7$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ijdhtg$on7$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wow, I can't believe the number of responses I've received to this
question.  I've been trying to digest it all.  I'm going to throw some
follow-up comments as time allows, starting here...

On Tue, Feb 15, 2011 at 3:43 AM, David Brown <david@westcontrol.com> wr=
ote:
> If you are not too bothered about write performance, I'd put a fair a=
mount
> of the budget into ram rather than just disk performance. =A0When you=
've got
> the ram space to make sure small reads are mostly cached, the main
> bottleneck will be sequential reads - and big hard disks handle seque=
ntial
> reads as fast as expensive SSDs.

I could be wrong, but I'm not so sure RAM would be beneficial for our
case.  Are workload is virtually all reads, however, these are huge
reads.  The analysis programs basically do a full read of data files
that are generally pretty big: roughly 100 MB to 5 GB in the worst
case.  Average file size is maybe 500 MB (rough estimate).  And there
are hundreds of these falls, all of which need "immediate" access.  So
to cache these in RAM, seems like it would take an awful lot of RAM.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
