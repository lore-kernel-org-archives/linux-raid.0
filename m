From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: > 2TB ?
Date: Thu, 10 Feb 2005 22:10:13 +0100
Message-ID: <l6vsd2-blf.ln1@news.it.uc3m.es>
References: <09d601c50fb1$b9c9df10$020a0a0a@musicroom>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

No email <null@hotmail.com> wrote:
> 
> Forgive me as this is probably a silly question and one that has been
> answered many times, I have tried to search for the answers but have
> ended up more confused than when I started.  So thought maybe I could
> ask the community to put me out of my misery
> 
> Is there a version of MD that can create larger than 2TB raid sets?  

Hmm ...  with 1KB blocks, and at 32 bits, 2^32 * 1KB = 4TB would be the
notional limit of any block device counted in blocks and using a 32bit
counter.

But in the 2.6 kernel the counter is 64bit.

> Obviously with 400GB drives being commonplace a typical 12 bay solution
> is capable of significant capacity,

3.6TB under raid0 or linear?

> but if we need to split this down
> into multiple raid sets, then we start to lose.  

I don't see that you have to on general principle even on a 2.4 kernel,
but maybe there are extra limits in the case of md devices over block
devices that I do not know about.

> So, if anyone can advise me as to MD / Linux size limitations I would be
> grateful :)

Well, I don't have anything to add to the observation above and I'm too
lazy to look! But where do you get the "2TB" number from? I can believe
that as a number for 1KB block devices in general in early 2.4 kernel
times, before signage had been dealt with.

Peter

