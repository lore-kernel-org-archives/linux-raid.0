From: maarten <maarten@ultratux.net>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 22:48:50 +0100
Message-ID: <200501042248.50614.maarten@ultratux.net>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <200501042022.30072.maarten@ultratux.net> <2h9ra2-mfj.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2h9ra2-mfj.ln1@news.it.uc3m.es>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 04 January 2005 21:05, Peter T. Breuer wrote:
> maarten <maarten@ultratux.net> wrote:
> > On Tuesday 04 January 2005 15:13, Peter T. Breuer wrote:
> > > Maarten <maarten@ultratux.net> wrote:


> > Are you not boasting about it, simply by providing all the little details
> > no one cares about, except that it makes your story more believable ?
>
> What "little details"? Really, this is most aggravating!

These little details, as you scribbled, very helpfully I might add, below. ;)
  |
  |
  V

> over to backup pairs.  Last xmas I distinctly remember holding up the
> department on a single surviving server because a faulty cable had
> intermittently taken out one pair, and a faulty router had taken out
> another.  I forget what had happened to the remaining server.  Probably
> the cleaners switched it off!  Anyway, one survived and everything
> failed over to it, in a planned degradation.
>
> It would have been amusing, if I hadn't had  to deal with a horrible
> mail loop caused by mail being bounced by he server with intermittent
> contact through the faulty cable. There was no way of stopping it,
> since I couldn't open the building till Jan 6!

And another fine example of the various hurdles you encounter ;-)
Couldn't you just get the key from someone ?  If not, what if you saw 
something far worse happening, like all servers in one room dying shortly 
after another, or a full encompassing system compromise going on ??

> > Hah. Show me one school where there isn't.
>
> It doesn't matter. There is nothing they can do (provided that is, the
> comp department manages to learn how to configure ldap so that people
> don't send their passwords in the clear to their server for
> confirmation ... however, only you and I know that, eh?).

Yes.  This is not a public mailing list.  Ceci n'est pas une pipe.

There is nothing they can do... except of course, running p2p nets, spreading 
viruses, changing their grades, finding out other students' personal info and 
trying out new ways to collect credit card numbers.  Is that what you meant ?

> Do you mean edonkey and emule by that? "p2p" signifies nothing to me
> except "peer to peer", which is pretty well everything. For example,
> samba. There's nothing wrong with using such protocols. If you mean
> using it to download fillums, that's a personal question - we don't
> check data contents, and indeed it's not clear that we legally could,
> since the digital information acts here recognise digital "property
> rights" and "rights to privacy" that we cannot intrude into. Legally,
> of course.

P2p might encompass samba in theory, but the term as used by everybody 
specifically targets more or less rogue networks that share movies et al.  
I know of the legal uncertainties associated with it (I'm in the EU too) and I 
do not condemn the use of them even. It's just that this type of activity can 
wreak havoc on a network, just from a purely technical standpoint alone.

> Absolutely. Besides - it would be trivial to do. I do it all the time.
>
> That's really not the point - we would see it at once if they decided to
> do anything with root - all the alarm systems would trigger if _anyone_
> does anything with root.  All the machines are alarmed like mines,
> checked daily, byte by byte, and rootkits are easy to see, whenever they
> turn up.  I have a nice collection.

Yes, well, someday someone may come up with a way to defeat your alarms and 
tripwire / AIDE or whatever you have in place...  For instance, how do you 
check for a rogue LKM ?  If coded correctly, there is little you can do to 
find out it is loaded (all the while feeding you the md5 checksums you expect 
to find, without any of you being the wiser) apart from booting off a set of 
known good read-only media...  AFAIK.

> Really, I am surprised at you! Any experienced sysadmin would know that
> such things are trivialities to spot and remove. It is merely an
> intelligence test, and the attacker does not have more intelligence
> or experience than the defenders! Quite the opposite.

Uh-huh.  Defeating a random worm, yes. Finding a rogue 4777 /tmp/.../bash 
shell or an extra  "..... root /bin/sh" line in inetd.conf is, too.  Those 
things are scriptkiddies at work. But from math students I expect much more, 
and so should you, I think. You are dealing with highly intelligent people, 
some of whom already know more about computers than you'll ever know.
(the same holds true for me though, as I'm no young student anymore either...)

Maarten

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

