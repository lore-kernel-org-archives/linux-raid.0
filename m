From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 18:23:22 +0100
Message-ID: <adkta2-06f.ln1@news.it.uc3m.es>
References: <Pine.LNX.3.96.1050105072829.9415A-100000@Maggie.Linux-Consulting.com> <41DC142C.5000704@tls.msk.ru>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:
> Again: pretty PLEASE, stop talking about thouse mysterious "silent
> corruption/errors".  Errors gets detected.

You confuse them here with failures (which probably get detected, but
then who can say!).  An error occurs when you do a sum on paper and you
forget to carry one in the third column.  In colloquial terms, it's a
"mistake".  Life carries on.  A failure occurs when your brain explodes
and CNN comes round and interviews your next door neignbour about the
hole in their wall.

> It is *very* unlikely
> case when an error on disk (either unability to read, or reading
> the "wrong" (aka not the same as has been written) data) will not
> be detected during read.

It's practically certain that it won't be "detected", because it is
on disk as far as anyone and anything can tell - there would have been a
failure if that were not the case.  It's an ordinary datum.

> , and if you do care about that cases, you
> have to use some very different hardware with every component
> (CPU, memory, buses, controllers etc etc) at least tripled, with
> hardware-level online monitoring/comparing stuff to detect errors

No, that detects errors internally (and corrects them, or else it
produces "failures" that are externally visible in place of them, or
else it doesn't detect them and the errors are also externally
visible).

> at any level and to switch to another component if one is "lying".

It still leaves the errors.  I don't know why everyone has such semantic
problems with this!  Think of an error as a "bug".  You catch those bugs
you can see, and don't catch the bugs you can't see.  There are always
bugs you can't see (hey!, if you saw them you would correct them, right?
Or at least die die die). It is simply a classification.

Peter

