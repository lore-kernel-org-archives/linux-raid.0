From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: async writes in raid1
Date: Tue, 15 Apr 2003 14:14:07 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E9C4BEF.84E49DE5@SteelEye.com>
References: <200304141924.h3EJO4x07957@oboe.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: ptb@it.uc3m.es
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Peter T. Breuer" wrote:
> 
> "A month of sundays ago Paul Clements wrote:"

> > * allowing the bitmap to be rescaled -- i.e., changing the amount of
> > data that each bit represents
> 
> I really don't agree with that :-).  But maybe it can be done!  It's
> just I personally see no way anyone can count in anything except 1K
> blocks with the current raid code the way it is.
> 
> Originally I wrote the patch with more generality, but realized that the
> generality could never be made use of - there are too many assumptions
> in the extant raid code that one block = 1KB.

The translation from 1K blocks to whatever-sized bitmap blocks (or
"chunks") will be done only when marking or unmarking the bitmap (and
incrementing/decrementing the block counters). The block counters allow
us to know when multiple 1K block writes are actually on the same
"chunk" so that everything is handled correctly.

--
Paul
