From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 00:14:52 +0100
Message-ID: <ckkra2-s1j.ln1@news.it.uc3m.es>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <200501042022.30072.maarten@ultratux.net> <2h9ra2-mfj.ln1@news.it.uc3m.es> <200501042248.50614.maarten@ultratux.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maarten <maarten@ultratux.net> wrote:
> On Tuesday 04 January 2005 21:05, Peter T. Breuer wrote:
> > maarten <maarten@ultratux.net> wrote:
> > > On Tuesday 04 January 2005 15:13, Peter T. Breuer wrote:
> > > > Maarten <maarten@ultratux.net> wrote:
> 
> 
> > > Are you not boasting about it, simply by providing all the little details
> > > no one cares about, except that it makes your story more believable ?
> >
> > What "little details"? Really, this is most aggravating!

> These little details, as you scribbled, very helpfully I might add, below. ;)
>   |
>   |
>   V
> 
> > over to backup pairs.  Last xmas I distinctly remember holding up the
> > department on a single surviving server because a faulty cable had
> > intermittently taken out one pair, and a faulty router had taken out
> > another.  I forget what had happened to the remaining server.  Probably
> > the cleaners switched it off!  Anyway, one survived and everything
> > failed over to it, in a planned degradation.

This is in response to your strange statement that I had a "data center".
I hope it gives you a better idea.

> > It would have been amusing, if I hadn't had  to deal with a horrible
> > mail loop caused by mail being bounced by he server with intermittent
> > contact through the faulty cable. There was no way of stopping it,
> > since I couldn't open the building till Jan 6!
> 
> And another fine example of the various hurdles you encounter ;-)
> Couldn't you just get the key from someone ?

Xmas holidays are total here, from 24 december to 6 jan.  There is
nobody in the building.  Maybe a security guard doing a round, but they
certainly do not have authority to let anyone in.  Just the opposite!

> If not, what if you saw 
> something far worse happening, like all servers in one room dying shortly 
> after another, or a full encompassing system compromise going on ??

Nothing - I could not get in. 


> > It doesn't matter. There is nothing they can do (provided that is, the
> > comp department manages to learn how to configure ldap so that people
> > don't send their passwords in the clear to their server for
> > confirmation ... however, only you and I know that, eh?).
> 
> Yes.  This is not a public mailing list.  Ceci n'est pas une pipe.

Indeed. Let's keep it to ourselves, then.


> There is nothing they can do... except of course, running p2p nets, spreading 
> viruses, changing their grades, finding out other students' personal info and 
> trying out new ways to collect credit card numbers.  Is that what you meant ?

No - they can't do any of those things.  P2p nets are not illegal, and
we would see the traffic if there were any.  They cannot "change their
grades" because they do not have access to them - nobody does.  They are
sent to goodness knows where in a govt bulding somewhere via ssl (an
improvement from the times when we had to fill in a computer card marked
in ink, for goodness sake, but I haven't done the sending in myself
lately, so I don't know the details - I give the list to the secretary
rather than suffer).  As to reading MY disk, anyone can do that.  I
don't have secrets, be it marks on anything else.  Indeed, my disk will
nfs mount on the student machines if they so much as cd to my home
directory (but don't tell them that!).  Of course they'd then have to
figure out how to become root in order to change uid so they could read
my data, and they can't do that - all the alarms in the building would
go off!  su isn't even executable, let alone suid, and root login is
disabled so many places I forget (heh, .profile in /root ays something
awful to you, and then exits), and then there are the reapers, the
monitors, oh, everything, waiting for just such an opportunity to ring
the alarm bells.  As to holes in other protocols, I can't even remenber
a daemon that runs as root nowadays without looking!  What?  And so
what?  If they got a root shell, everything would start howling.  And
then if they got a root shell and did something, all the alrms would go
off again as the checks swung in on the hour.  Why would they risk it?
Na ..  we only get breakin attempts from script-kiddies outside, not
inside.

As to credit card numbers - nobody has one.  Students don't earn enough
to get credit cards.  Heck, even the profs don't!  As to personal info,
they can see whatever anyone can see.  There is no special "personal
info" anywhere in particular.  If somebody wants to keep their password
in a file labelled "my passwords" in a world readable directory of their
own creation, called "secret", that is their own lookout.  If somebody
else steals their "digital identity" (if only they knew what it was)
they can change their password - heck they have enough trouble
remembering the one they have!

I'm not paranoid - this is an ordinary place.  They either act All I do
is provide copies of their accounts, and failover services for them to
use, or to hld up other services.

And they have plenty of illegal things to do on their own without
involving me.


> P2p might encompass samba in theory, but the term as used by everybody 
> specifically targets more or less rogue networks that share movies et al.  

Not by me - you must be in a particular clique.  This is a networking
department!  It would be strange if anyone were NOT running a peer to
peer system!

> do not condemn the use of them even. It's just that this type of activity can 
> wreak havoc on a network, just from a purely technical standpoint alone.

Why should it wreak havoc? We have no problem with bandwidth. We have
far more prblems when the routing classes deliberately change the
network topologies, or some practical implements RIP and one student
gets it wrong!

There is a time of year when the network bounces like a yo yo because
the students are implementing proxy arp  and getting it completely
wrong!

> > That's really not the point - we would see it at once if they decided to
> > do anything with root - all the alarm systems would trigger if _anyone_
> > does anything with root.  All the machines are alarmed like mines,
> > checked daily, byte by byte, and rootkits are easy to see, whenever they
> > turn up.  I have a nice collection.
> 
> Yes, well, someday someone may come up with a way to defeat your alarms and 
> tripwire / AIDE or whatever you have in place...  For instance, how do you 

No they won't. And if they do, so what? They will fall over the next
one along the line!  There is no way they can do it.  I couldn't do it
if I were trying to avoid me seeing - I'm too experienced as a defender.
I can edit a running kernel to reset syscalls that have been altered by
adore, and see them.  I regularly have I-get-root duels, and I have no
problem with getting and keeping root, while letting someone else also
stay root. I can get out of a chroot jail, since I have root. I run
uml honeypots.

> check for a rogue LKM ?

Easily. Not worth mentioning. Apart from the classic error that hidden
processes have a different count in /proc than via other syscalls, one
can see other giveaways like directories with the wrong entry count,
and one can see from the outside open ports that are not visibly
occupied by anything on the inside.

> If coded correctly, there is little you can do to 
> find out it is loaded (all the while feeding you the md5 checksums you expect 

They can't predict what attack I can use against them to see it!  And
there is no defense against an unknown attack.

> to find,

They don't know what I expect to find, and they would have to keep the
original data around, something which would show up in the free space
count. And anyway I don't have to see the md5sums to know when a
computer is acting strangely - it's entire signature would have changed
in terms of reactions to stimuli, the apparant load versus the actual,
and so on. You are not being very imaginative!


> without any of you being the wiser) apart from booting off a set of 
> known good read-only media...  AFAIK.

I don't have to - they don't even know what IS the boot media. 

> > Really, I am surprised at you! Any experienced sysadmin would know that
> > such things are trivialities to spot and remove. It is merely an
> > intelligence test, and the attacker does not have more intelligence
> > or experience than the defenders! Quite the opposite.
> 
> Uh-huh.  Defeating a random worm, yes. Finding a rogue 4777 /tmp/.../bash 
> shell or an extra  "..... root /bin/sh" line in inetd.conf is, too.  Those 
> things are scriptkiddies at work.

Sure - and that's all they are.

> But from math students I expect much more, 

I don't, but then neither are these math students - they're
telecommunications engineers.

> and so should you, I think. You are dealing with highly intelligent people, 

No I'm not!  They are mostly idiots with computers.  Most of them
couldn't tell you how to copy a file from one place to another (I've
seen it), or think of that concept to replace "move to where the file
is".  If any one of them were to develop to the point of being good
enough to even know how to run a skript, I would be pleased.  I'd even
be pleased if the concept of "change your desktop environment to suit
yourself" entered their head, along with "indent your code", "keep
comments to less than 80 characters", and so on.

If someone were to actually be capable of writing something that looked
capable, I would be pleased. I've only seen decent code from overseas
students - logical concepts don't seem to penetrate the environment
here.  The first year of the technical school (as distinct to the
"superior" school) is spent trying bring some small percentage of the
technical students up to the concept of loops in code - which they
mostly cannot grasp.

(the technical school has three-year courses, the superior school has
six-year courses, though it is not unusual to take eight or nine
years, or more).

And if they were to be good enough to get root even for a moment, I
would be plee3ed.

But of course they aren't - they have enough problems passing the exams
and finding somebody else to copy practicals off (which they can do
simply by paying).

> some of whom already know more about computers than you'll ever know.
> (the same holds true for me though, as I'm no young student anymore either...)

If anyone were good enough to notice, I would notice. And what would
make me notice would not be good.


Peter

