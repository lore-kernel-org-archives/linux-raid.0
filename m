From: Christian Gatzemeier <c.gatzemeier@tu-bs.de>
Subject: Re: safe segmenting of conflicting changes, and hot-plugging between alternative versions
Date: Sat, 24 Apr 2010 08:10:38 +0000 (UTC)
Message-ID: <loom.20100424T093259-782@post.gmane.org>
References: <loom.20100423T152429-20@post.gmane.org> <4BD1B7E8.9020602@cfl.rr.com> <loom.20100423T213339-797@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> (To simply support segments consisting of single raid member
> devices it may be enough if a superblock marking itself as failed would
> mean itis contains conflicting changes. Multi member segments would require
> segment IDs)

Don't know why I thought that extra IDs would be needed, as UUID+device-number
is enough and degrading into multi device segments is and has been working all
the time.

Aside not catching a conflict in the case of two segments with same event count
(both segments only booted with few changes), i.e. the main issue addressed in
my original post, plugging different versions also just works.



Concerning the scheme to mark segments as containing conflicting changes for
Enhancement 2) from my original post:

I think saying a superblock marking itself as failed (.) would indicates a known
conflicting segment (alternative version), may just as well work for multiple
member segments.
In the example below, first both dev1+dev2 can be considered to contain known
conflicting segments (alternative versions) because they mark themselves as
failed. But because they mark each other as up (U) they both constitute one
two-member-segment. The dev3 was the first segment on the incidence that both
segments came up together, because it does not mark itself as failed.

dev1 [.U.]
dev2 [U..]
dev3 [..U]


Kind regards,
Christian




