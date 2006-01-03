From: "Bailey, Scott" <scott.bailey@eds.com>
Subject: RE: Adding Reed-Solomon Personality to MD, need help/advice
Date: Tue, 3 Jan 2006 17:08:18 -0500
Message-ID: <E26C409DCE780347BD93D08771FF08E90129DB3D@usahm236.amer.corp.eds.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Interestingly, I was just browsing this paper
http://www.cs.utk.edu/%7Eplank/plank/papers/CS-05-569.html which appears
to be quite on-topic for this discussion. I admit my eyes glaze over
during intensive math discussions but it appears tuned RS might not be
as horrible as you'd think since apparently state-of-the-art now
provides tricks to avoid the Galois Field operations that used to be
required.

The thought that came to my mind was "how does md's RAID-6 personality
compare to EVENODD coding?"

Wondering if my home server will ever have enough storage for these
discussions to become non-academic for me, :-) 

	Scott


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of H. Peter Anvin
Sent: Thursday, December 29, 2005 1:41 PM
To: linux-raid@vger.kernel.org
Subject: Re: Adding Reed-Solomon Personality to MD, need help/advice

Followup to:  <dlsh2c$2h0$1@sea.gmane.org>
By author:    "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
In newsgroup: linux.dev.raid
>
> Hello,
> 
> Nathan Lewis <nathapl@cs.okstate.edu> wrote:
> > As part of my Master's thesis, I am working on adding a Reed-Solomon

> > personality to the existing linux RAID structure and I would like
some 
> 
> Is there any progress in implementing a generic Reed-Solomon
personality
> in MD since this mail from 31 Jan 2004?
> Regarding the intention-question... for me, personally, it would be
the
> logical step inbetween raid5 resp. raid6 with survival of 1 resp. 2
> simultaneous disk failures and raid10 with survival of n/2
simultaneous
> disk failures. RaidRS would give users the chance to configure
> redundancy and thus survivability exactly on their demands.
> This would especially make sense when I see the raid5 configurations
> with 14 and more devices which some users refer to on this list.
> To be honest, I was thinking about such a personality myself, too, and
> then was crawling the list's archive.
> 

It's not really in-between; generic RS RAID would be many times slower
than either; however, unlike raid10 it could survive *any* m failures
where m is the number of redundancy drives.

The fundamental problem is that generic RS requires table lookups even
in the common case, whereas RAID-6 uses shortcuts to substantially
speed up the computation in the common case.  RAID-6 is an important
corner of the problem space, since it deals with the unfortunately
fairly common problem of "disk failure discovered during recovery"
with RAID-5.

That doesn't mean there couldn't be a problem space where it would
make sense (in fact, on the contrary), but it's still a substantial
engineering effort that would have to be justified.

Heck, I might even be persuaded to look for generic RS shortcuts if
someone tempted me enough...

	-hpa

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
