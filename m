From: maarten <maarten@ultratux.net>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 02:53:35 +0100
Message-ID: <200501050253.35912.maarten@ultratux.net>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <200501042248.50614.maarten@ultratux.net> <ckkra2-s1j.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ckkra2-s1j.ln1@news.it.uc3m.es>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 05 January 2005 00:14, Peter T. Breuer wrote:
> maarten <maarten@ultratux.net> wrote:
> > On Tuesday 04 January 2005 21:05, Peter T. Breuer wrote:
> > > maarten <maarten@ultratux.net> wrote:

> > If not, what if you saw
> > something far worse happening, like all servers in one room dying shortly
> > after another, or a full encompassing system compromise going on ??
>
> Nothing - I could not get in.

Now that is a sensible solution !  The fans in the server died off, you have 
30 minutes before everything overheats and subsequently incinerates the whole 
building, and you have no way to prevent that.  Great !  Well played.



> No - they can't do any of those things.  P2p nets are not illegal, and
> we would see the traffic if there were any.  They cannot "change their
> grades" because they do not have access to them - nobody does.  They are
> sent to goodness knows where in a govt bulding somewhere via ssl (an
> improvement from the times when we had to fill in a computer card marked
> in ink, for goodness sake, but I haven't done the sending in myself
> lately, so I don't know the details - I give the list to the secretary
> rather than suffer).  As to reading MY disk, anyone can do that.  I
> don't have secrets, be it marks on anything else.  Indeed, my disk will
> nfs mount on the student machines if they so much as cd to my home
> directory (but don't tell them that!).  Of course they'd then have to
> figure out how to become root in order to change uid so they could read
> my data, and they can't do that - all the alarms in the building would
> go off!  su isn't even executable, let alone suid, and root login is
> disabled so many places I forget (heh, .profile in /root ays something
> awful to you, and then exits), and then there are the reapers, the
> monitors, oh, everything, waiting for just such an opportunity to ring
> the alarm bells.  As to holes in other protocols, I can't even remenber
> a daemon that runs as root nowadays without looking!  What?  And so
> what?  If they got a root shell, everything would start howling.  And
> then if they got a root shell and did something, all the alrms would go
> off again as the checks swung in on the hour.  Why would they risk it?
> Na ..  we only get breakin attempts from script-kiddies outside, not
> inside.

Uh-oh. Where to start.  Shall I start by saying that when you exploit a local 
root hole you _are_ root and there is no need for any su ?  Or shall I start 
by saying that if they can get access to their tests well in advance they 
need not access to their grades ? Or perhaps... That your alarm bells 
probably are just as predictable and reliable as your UPS systems ?
Let's leave it at that shall we.

> > P2p might encompass samba in theory, but the term as used by everybody
> > specifically targets more or less rogue networks that share movies et al.
>
> Not by me - you must be in a particular clique.  This is a networking
> department!  It would be strange if anyone were NOT running a peer to
> peer system!

Read a newspaper someday, why don't you...?

> There is a time of year when the network bounces like a yo yo because
> the students are implementing proxy arp  and getting it completely
> wrong!

Yeah. So maybe they are proxy-arping that PC you mentioned above that sends 
the grades over SSL.  But nooo, no man in the middle attack there, is there ?

> > Yes, well, someday someone may come up with a way to defeat your alarms
> > and tripwire / AIDE or whatever you have in place...  For instance, how
> > do you
>
> No they won't. And if they do, so what? They will fall over the next
> one along the line!  There is no way they can do it.  I couldn't do it
> if I were trying to avoid me seeing - I'm too experienced as a defender.
> I can edit a running kernel to reset syscalls that have been altered by
> adore, and see them.  I regularly have I-get-root duels, and I have no
> problem with getting and keeping root, while letting someone else also
> stay root. I can get out of a chroot jail, since I have root. I run
> uml honeypots.

W0w you'r3 5o l33t, P3ter !

But thanks, this solves our mystery here !  If you routinely change syscalls 
on a running kernel that has already been compromised by a rootkit, then it 
is no wonder you also flip a bit here and there in random files.  
So you were the culprit all along !!! 

> and one can see from the outside open ports that are not visibly
> occupied by anything on the inside.

Oh suuuuure.  Never thought about them NOT opening an extra port to the 
outside ?  By means of trojaning sshd, or login, or whatever.  W00t !
Or else by portknocking, which google will yield results for I'm sure.

> > If coded correctly, there is little you can do to
> > find out it is loaded (all the while feeding you the md5 checksums you
> > expect
>
> They can't predict what attack I can use against them to see it!  And
> there is no defense against an unknown attack.

Nope, rather the reverse is true.  YOU don't know how to defend yourself, 
since you don't know what they'll hit you with, when (I'll bet during the two 
weeks mandatory absense of christmas!) and where they're coming from. 

> They don't know what I expect to find, and they would have to keep the
> original data around, something which would show up in the free space
> count. And anyway I don't have to see the md5sums to know when a
> computer is acting strangely - it's entire signature would have changed
> in terms of reactions to stimuli, the apparant load versus the actual,
> and so on. You are not being very imaginative!

They have all the time in the world to research all your procedures, if they 
even have to. For one, this post is googleable. Next, they can snoop around 
all year on your system just behaving like the good students they seem, and 
last but not least you seem pretty vulnerable to a social engineering attack; 
you tell me -a complete stranger- all about it without the least of effort 
from my side.  A minute longer and you'd have told me how your scripts make 
the md5 snapshots, what bells you have in place and what time you usually 
read your logfiles (giving a precise window to work in undetected).

Please.  Enough with the endless arrogance.  You are not invincible.
The fact alone that you have a "nice stack of rootkits" already is a clear 
sign on how well your past endeavours fared stopping intruders...

> I don't, but then neither are these math students - they're
> telecommunications engineers.

Oh, telecom engineers ?  Oh, indeed, those guys know nothing about computers 
whatsoever.   Nothing.  There isn't a single computer to be found in the 
telecom industry.

> If someone were to actually be capable of writing something that looked
> capable, I would be pleased. I've only seen decent code from overseas
> students - logical concepts don't seem to penetrate the environment
> here.  The first year of the technical school (as distinct to the
> "superior" school) is spent trying bring some small percentage of the
> technical students up to the concept of loops in code - which they
> mostly cannot grasp.

The true blackhat will make an effort NOT to be noticed, so he'll be the last 
that will try to impress you with an impressive piece of code!  It's very 
strange not to realize even that.
I might be paranoid, but you are naive like I've never seen before...

> And if they were to be good enough to get root even for a moment, I
> would be plee3ed.

Of course you would, but then again chances are they will not tell you they 
got root as that is precisely the point of the whole game. :-)

> But of course they aren't - they have enough problems passing the exams
> and finding somebody else to copy practicals off (which they can do
> simply by paying).

Or just copying it off the server directory.

> If anyone were good enough to notice, I would notice. And what would
> make me notice would not be good.

Sure thing, Peter Mitnick...

Maarten

