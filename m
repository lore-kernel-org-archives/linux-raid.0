From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 21:05:22 +0100
Message-ID: <2h9ra2-mfj.ln1@news.it.uc3m.es>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <200501041436.17447.maarten@ultratux.net> <ctkqa2-4m2.ln1@news.it.uc3m.es> <200501042022.30072.maarten@ultratux.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maarten <maarten@ultratux.net> wrote:
> On Tuesday 04 January 2005 15:13, Peter T. Breuer wrote:
> > Maarten <maarten@ultratux.net> wrote:
> > > On Tuesday 04 January 2005 11:18, Peter T. Breuer wrote:
> > > > Maarten <maarten@ultratux.net> wrote:
> > > > > On Tuesday 04 January 2005 03:41, Andy Smith wrote:
> > > > > > On Tue, Jan 04, 2005 at 01:22:56PM +1100, Neil Brown wrote:
> > > > > > > On Monday January 3, ewan.grantham@gmail.com wrote:
> > > >
> > > > It's not "my" data center.  It is what it is.  I can only control
> > > > certain things in it, such as the software on the machines, and which
> > > > machines are bought.  Nor is it a "data center", but a working
> > > > environment for about 200 scientists and engineers, plus thousands of
> > > > incompetent monkeys.  I.e., a university department.
> 
> > I'm not "boasting"  about them. They simply ARE.
> 
> Are you not boasting about it, simply by providing all the little details no 
> one cares about, except that it makes your story more believable ?

What "little details"? Really, this is most aggravating!

> If I state my IQ was tested as above 140, am I then boasting, or simply 
> stating a fact ?

You're being an improbability.

> Stating a fact and boasting are not mutually exclusive. 

But about WHAT? I have no idea what you may consider boasting!

> > > on your whole secure data center turns out to be a school department,
> >
> > Eh?
> 
> What, "Eh?" ?  

What "secure data center"? I have never mentioned such a thing! We have
a big floor of a big building, plus a few labs in the basement, and a
few labs in another couple of buldings.  We used to locate the servers
in secure places in the various buildings, but nowadays we tend to dump
most of them in a single highly a/c'ed rack room up here.  Mind you, I
still have six in my office, and I don't use a/c.  I guess others are
scattered arund the place too.

However, all the servers are paired, and fail over to each other, and
do each others mirroring. If I recall correctly, even the pairs fail
over to backup pairs.  Last xmas I distinctly remember holding up the
department on a single surviving server because a faulty cable had
intermittently taken out one pair, and a faulty router had taken out
another.  I forget what had happened to the remaining server.  Probably
the cleaners switched it off!  Anyway, one survived and everything
failed over to it, in a planned degradation.

It would have been amusing, if I hadn't had  to deal with a horrible
mail loop caused by mail being bounced by he server with intermittent
contact through the faulty cable. There was no way of stopping it,
since I couldn't open the building till Jan 6!

> Are you taking offense to me calling a "university department" a school ? 

No - it is a school. "La escuela superior de ...". What the french call
an "ecole superior".

> Is 
> it not what you are, you are an educational institution, ie. a school.

Schools are not generally universityies, except perhaps in the united
states!  Elsewhere one goes to learn, not to be taught.

> > > undoubtedly with viruses rampant, students hacking at the schools'
> > > systems,
> >
> > Sure - that's precisely what there is.
> 
> Hah. Show me one school where there isn't.

It doesn't matter. There is nothing they can do (provided that is, the
comp department manages to learn how to configure ldap so that people
don't send their passwords in the clear to their server for
confirmation ... however, only you and I know that, eh?).


> > Uh, no. We don't run windos. Well, it is on the clients, but I simply
> > sabaotage them whenever I can :). That saves time. Then they can boot
> > into the right o/s.
> 
> Ehm. p2p exists for linux too.  Look into it.  Are you so dead certain no 

Do you mean edonkey and emule by that? "p2p" signifies nothing to me
except "peer to peer", which is pretty well everything. For example,
samba. There's nothing wrong with using such protocols. If you mean
using it to download fillums, that's a personal question - we don't
check data contents, and indeed it's not clear that we legally could,
since the digital information acts here recognise digital "property
rights" and "rights to privacy" that we cannot intrude into. Legally,
of course.

> student of yours ever found a local root hole ?  

Absolutely. Besides - it would be trivial to do. I do it all the time.

That's really not the point - we would see it at once if they decided to
do anything with root - all the alarm systems would trigger if _anyone_
does anything with root.  All the machines are alarmed like mines,
checked daily, byte by byte, and rootkits are easy to see, whenever they
turn up.  I have a nice collection.

Really, I am surprised at you! Any experienced sysadmin would know that
such things are trivialities to spot and remove. It is merely an
intelligence test, and the attacker does not have more intelligence
or experience than the defenders! Quite the opposite.

> Then you have more balls than you can carry.

???

> > Eh? It's as secure stable and organised as it can be, given that nobody
> > is in charge of anything.
> 
> Normal people usually refer to such a state as "an anarchy".

Good - that's the way I like it.  Coping with and managing chaos amounts
to giving the maximum freedom to all, and preserving their freedoms.
Including the freedom to mess up.  To help them, I maintain copies of
their work for them, and guard them against each other and outside
threats.

> Not a perfect example of stability, security or organization by any stretch of 
> the imagination...

Sounds great to me!

Peter

