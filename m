From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Fri, 25 Mar 2005 19:51:30 +0100
Message-ID: <i63eh2-eat.ln1@news.it.uc3m.es>
References: <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <423B2F7C.3030907@steeleye.com> <qehtg2-6c1.ln1@news.it.uc3m.es> <423EF12A.4030207@steeleye.com> <20050321185606.GA27541@percy.comedia.it> <423F2780.5000601@steeleye.com> <20050322093525.GL7040@percy.comedia.it> <8275h2-sn4.ln1@news.it.uc3m.es> <20050323203125.GD26683@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra <bluca@comedia.it> wrote:
> we can have a series of failures which must be accounted for and dealt
> with according to a policy that might be site specific.
> 
> A) Failure of the standby node
>   A.1) the active is allowed to continue in the absence of a data replica
>   A.2) disk writes from the active should return an error.
>   we can configure this setting in advance.

OK. One normally wants RAID to provide continuity of service in real
time however. Your choice A2 is not aimed at that, but at guaranteeing
te existence of an exact copy of whatever is written. This seems to me
only to have applications in accountancy :-).

> B) Failure of the active node
>   B.1) the standby node takes immediately ownership of data and resumes
>   processing
>   B.2) the standby node remains idle

Well, that's the same set of choices as for A, morally. You might as well
pair them with A1 and A2.

> C) communication failure between the two nodes (and we don't have an
> external mechanism to arbitrate the split brain condition)
>   C.1) both system panic and halt
>   C.2) A1 + B2

I don't see the point of anything except A1+B1, A2+B2, as policies. But
A1+B1 will normally cause divergence, unless the failure is due to
actual isolation of, say, system A from the whole external net. Prvided
the route between the two systems passes through the router that
chooses whether to use A or B for external contacts, I don't see how a
loss of contact can be anything but a breakdown of that router (but you
could argue for a very whacky router). In which case it doesn't matter
what you choose, because nothing will write to either.

>   C.3) A2 + B2
>   C.4) A1 + B1
>   C.5) A2 + B1 (which hopefully will go to A2 itself)


> D) communication failure between the two nodes (admitting we have an
> external mechanism to arbitrate the split brain condition)
>   D.1) A1 + B2
>   D.2) A2 + B2
>   D.2) B1 then A1
>   D.3) B1 then A2

I would hope that we could at least guarantee that if comms fails
between them, then it is because ONE (or more) of them is out of contact
with the world.  We can achieve that condition via routing. In that
case either A1+B1 or A2+B2 would do, depending on your aims (continuity
of service or data replication).

> E) rolling failure (C, then B)
> 
> F) rolling failure (D, then B)

Not sure what these mean.

> G) a failed nodes is restored
> 
> H) a node (re)starts while the other is failed
> 
> I) a node (re)starts during C
> 
> J) a node (re)starts during D
> 
> K) a node (re)starts during E
> 
> L) a node (re)starts during F

Ecch. Well, you are very thorough. This is well thought-through.

> scenarios without a sub-scenarios are left as an exercise to the reader,
> or i might find myself losing a job :)
> 
> now evaluate all scenarios under the following drivers:
> 1) data availability above all others
> 2) replica of data above all others

Exactly. I see only those as sensible aims.

> 3) data availability above replica, but data consistency above
> availability

Heck! Well, that is very very thorough.


> (*) if you got this far, add asynchronous replicas to the picture.

I don't know what to say. In many of those situations we do not know
what to do, but your analysis is excellent, and allos us to at least
think about it.


Peter

