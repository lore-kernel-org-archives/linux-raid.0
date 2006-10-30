From: Al Boldi <a1426z@gawab.com>
Subject: Re: Propose of enhancement of raid1 driver
Date: Mon, 30 Oct 2006 20:55:01 +0300
Message-ID: <200610302055.01558.a1426z@gawab.com>
References: <45347D6E.3000600@mieszczak.com.pl> <200610301844.56901.a1426z@gawab.com> <ei5b7o$nb3$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ei5b7o$nb3$1@sea.gmane.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario 'BitKoenig' Holbe wrote:
> Al Boldi <a1426z@gawab.com> wrote:
> > Don't underestimate the effects mere layout can have on multi-disk array
> > performance, despite it being highly hw dependent.
>
> I can't see the difference between equal mirrors and somehow interleaved
> layout on RAID1. Since you have to seek anyways, there should be no
> difference between both approaches once you read big enough chunks. The
> problem with reading big chunks is: you probably read far too much when
> you don't really need the data you did read.

Think adaptive.

> And vice versa: when you
> don't read big chunks, it doesn't matter how your data is laid out.

Think tracks and heads, physical that is.


Thanks!

--
Al

