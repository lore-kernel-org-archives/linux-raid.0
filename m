From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Adding Reed-Solomon Personality to MD, need help/advice
Date: Thu, 29 Dec 2005 10:40:33 -0800 (PST)
Message-ID: <dp1aj1$su0$1@terminus.zytor.com>
References: <6.0.1.1.2.20040130235924.03f39710@mail.athenet.net> <dlsh2c$2h0$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <dlsh2c$2h0$1@sea.gmane.org>
By author:    "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
In newsgroup: linux.dev.raid
>
> Hello,
> 
> Nathan Lewis <nathapl@cs.okstate.edu> wrote:
> > As part of my Master's thesis, I am working on adding a Reed-Solomon 
> > personality to the existing linux RAID structure and I would like some 
> 
> Is there any progress in implementing a generic Reed-Solomon personality
> in MD since this mail from 31 Jan 2004?
> Regarding the intention-question... for me, personally, it would be the
> logical step inbetween raid5 resp. raid6 with survival of 1 resp. 2
> simultaneous disk failures and raid10 with survival of n/2 simultaneous
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

