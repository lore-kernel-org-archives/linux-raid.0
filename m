From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: raid1 bitmap code [Was: Re: Questions answered by Neil Brown]
Date: Thu, 27 Feb 2003 11:50:24 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302271050.h1RAoOX26874@oboe.it.uc3m.es>
References: <200302271035.h1RAZ9A26165@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200302271035.h1RAZ9A26165@oboe.it.uc3m.es> from "Peter T. Breuer"
 at "Feb 27, 2003 11:35:09 am"
To: ptb@it.uc3m.es
Cc: Paul Clements <Paul.Clements@SteelEye.com>, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Peter T. Breuer wrote:"
> "Paul Clements wrote:"
> > fails, and doing on-demand allocation the rest of the time? Another
> > idea, expanding on what Peter has already done with marking the pointer
> > with an "address" of 1 if the kmalloc fails (this means that the bitmap
> > degrades from 1bit/1k to 1bit/4MB, which is not a terrible thing, all in
> > all). What if we were clever and used more than just one bit when the

I forgot to say that when the bitmap page fails to be allocated in
order that we may mark it, then an attempted mark also fails, and the
async-write code notices that and refuses to even try an async write,
but stays sync instead.

So this fails safe.

I also forgot to say something else but I forgot what it was ... ah
yes, it's that I did take care never to call kmalloc (or kfree) with
the bitmap spinlock held. So that if the kernel blocks and sleeps
we don't cause death. Instead we release the lock and regain it after
the kmalloc, and retest the conditions that made us want to do the
kmalloc then, aborting if they have been satisfied by anyone else.

Indeed the kmalloc calls are only in the init function and in the
function that is supposed to check the bitmap page and install a page
if one is required, prior to further access. It all /looks/ under
control.

Peter
