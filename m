From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 10:50:56 +0100
Message-ID: <0h5qa2-0qa.ln1@news.it.uc3m.es>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <200501031846.42950.maarten@ultratux.net> <200501032052.21459.maarten@ultratux.net> <a9noa2-o12.ln1@news.it.uc3m.es> <fh0pa2-kvp.ln1@news.it.uc3m.es> <16857.55609.534526.297577@cse.unsw.edu.au> <jh4pa2-pi.ln1@news.it.uc3m.es> <16857.64086.362458.177296@cse.unsw.edu.au> <6d5bedd80501031816eb8f296@mail.gmail.com> <16857.65024.745883.752981@cse.unsw.edu.au> <20050104024108.GK99565@caffreys.strugglers.net> <16858.4291.816499.371678@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> wrote:
> On Tuesday January 4, andy@strugglers.net wrote:
> > Except that Peter says that the ext3 journals should be on separate
> > non-mirrored devices and the reason this is not mentioned in any
> > documentation (md / ext3) is that everyone sees it as obvious.
> > Whether it is true or not it's clear to me that it's not obvious to
> > everyone.
> 
> If Peter says that, then Peter is WRONG.

But Peter does NOT say that.

> ext3 journals are much safer on mirrored devices than on non-mirrored

That's irrelevant - you don't care what's in the journal, because if
your system crashes before committal you WANT the data in the journal
to be lost, rolled back, whatever, and you don't want your machine to
have acked the write until it actually has gone to disk.

Or at least that's what *I* want. But then everyone has different
wants and needs. What is obvious, however, are the issues involved.

Peter

