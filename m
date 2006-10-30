From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Propose of enhancement of raid1 driver
Date: Mon, 30 Oct 2006 18:02:48 +0100
Message-ID: <ei5b7o$nb3$1@sea.gmane.org>
References: <45347D6E.3000600@mieszczak.com.pl> <200610282031.07893.a1426z@gawab.com> <ei0elo$23m$1@sea.gmane.org> <200610301844.56901.a1426z@gawab.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Al Boldi <a1426z@gawab.com> wrote:
> Don't underestimate the effects mere layout can have on multi-disk array 
> performance, despite it being highly hw dependent.

I can't see the difference between equal mirrors and somehow interleaved
layout on RAID1. Since you have to seek anyways, there should be no
difference between both approaches once you read big enough chunks. The
problem with reading big chunks is: you probably read far too much when
you don't really need the data you did read. And vice versa: when you
don't read big chunks, it doesn't matter how your data is laid out.


regards
   Mario
-- 
Whenever you design a better fool-proof software,
the genetic pool will always design a better fool.

