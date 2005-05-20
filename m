From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Bug report: mdadm -E oddity
Date: Fri, 20 May 2005 19:16:36 +0200
Message-ID: <kki1m2-r1n.ln1@news.it.uc3m.es>
References: <1115999051.3974.14.camel@compaq-rhel4.xsintricity.com> <1116004267.3974.35.camel@compaq-rhel4.xsintricity.com> <17029.12773.197506.463977@cse.unsw.edu.au> <1116077316.13780.52.camel@compaq-rhel4.xsintricity.com> <17037.35615.456231.737766@cse.unsw.edu.au> <1116592212.23785.75.camel@compaq-rhel4.xsintricity.com> <428E0A92.3060108@steeleye.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements <paul.clements@steeleye.com> wrote:
> disk1   disk2   {disk3}

>   D1       P      {D2}

> So, say we're in the middle of updating this stripe, and we're writing 
> D1 and P to disk when the system crashes. We may have just corrupted D2, 
> which isn't even active right now. This is because we'll use D1 and P to 
> reconstruct D2 when disk3 (or its replacement) comes back. If we wrote 
> D1 and not P, then when we use D1 and P to reconstruct D2, we'll get the 
> wrong data. Same goes if we wrote P and not D1, or some partial piece of 
> either or both.

> There's no way for a filesystem journal to protect us from D2 getting 
> corrupted, as far as I know.

Surely the raid won't have acked the write, so the journal won't
consider the write done and will replay it next chance it gets. Mind
you ... owwww! If we restart the array AGAIN without D3, and the
journal is now replayed(to redo the write), then since we have already
written D1, the parity in P is all wrong relative to it, and hence we
will have virtual data in D3 which is all wrong, and hence when we come
to write the parity info P we will get it wrong. No? (I haven't done
the calculation and so there might be some idempotency here that the
casual reasoning above fails to take account of).

On the other hand, if the journal itself is what we are talking about,
being located on the raid device, all bets are off (I've said that
before, and remain to be convinced that it is not so, but it may be so
- I simply see a danger that I have not been made to feel good about ..). 

Peter

