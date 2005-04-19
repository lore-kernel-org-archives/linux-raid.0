From: =?iso-8859-1?Q?Herv=E9?= Eychenne <rv@eychenne.org>
Subject: Re: Questions about software RAID
Date: Tue, 19 Apr 2005 19:54:07 +0200
Message-ID: <20050419175407.GK3103@eychenne.org>
References: <200504191100.NAA01462@node130.rhm.de> <20050419144011.GI3103@eychenne.org> <42652352.3050706@dgreaves.com> <20050419155447.GJ3103@eychenne.org> <426537A0.6020007@weisshuhn.de>
Reply-To: rv@eychenne.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <426537A0.6020007@weisshuhn.de>
Sender: linux-raid-owner@vger.kernel.org
To: Frank Wittig <fw@weisshuhn.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 19, 2005 at 06:53:52PM +0200, Frank Wittig wrote:

> >>And those who do can type:
> >>  fdisk -l /dev/sda | grep -i fd | cut -f1 -d' ' | xargs -n1 mdadm =
-r
> >=20
> >=20
> > I really don't like kludgy things like that...
> [...]
> > Isn't the insertion/removal of a disk common enough to justify the
> > addition of a simple and clean mdadm option?

> have you thought about the idea that there is a certain clue behind t=
he
> actual behaviour of the mdadm tool?
> is it so annoying to you to mark a disk/partition as faulty before
> removing it?

I'm sorry, but having to do a cat /proc/mdstat, figure out by myself
what to do (which partition is concerned), then type several commands
(for each concerned partition) actually is painful.
Maybe you are an experienced guy so it seems so simple to you... but
I'm always amused when an experienced guy refuses to make things
simpler for those who aren't as much as he is. And sends them to
Microsoft. Great.

This mailing-list is probably full of kernel guys, so maybe I should
have guessed.  But I come here as a user (who wants RAID to work as
smoothly as possible), having found no other mailing-list (a user one)
for RAID on Linux. (did I miss it?)
Maybe I'm not asking questions to the right people, but for me,
computer science is about automating things.  And the process or
replacing a crashed disk (described above) on a system managed with
mdadm is not particularly automated, right?
Maybe it's not a problem for _you_, because you know exactly what to
do by heart.  So you've forgotten the complexity.  But it's there, and
even if it's good that you can do complex and powerful things, it's
not normal to force people to get into that complexity to do simple
things. Think about it.

> do you think it makes sense to implement every single case in an extr=
a
> command line option?

I personnaly do not consider that this is yet another case.  For me,
RAID is about have disk availability, right?  So the most common
production case is definitely when one of your disks crashed, and you
want to replace it.
There must be some kind of way to deal with that without typing too
much contextual command lines.

Whether this simple way should belong to mdadm is another question, but
I personnaly think it should, as it would introduce no overhead
(would it, really ?) and would be very helpful.  Let me reassure you,
you could stay with several commands if you like. :-)

> did you ever thought about switching to a hardware where you can remo=
ve
> and add disks without having to do anything else than pull the old on=
e
> out and push teh new one in?

Ok, here we are...
[First, the RAID controller I'm forced to deal with has no Linux
driver, but that's not important for our discussion.]
Software RAID is about doing the same that hardware RAID, but in soft.
I think we agree on that. ;-)
So I see absolutely no reason why software RAID should not be as
simple as possible.  And RAID management with mdadm could be made
simpler for a common case like that.

> i run several raid arrays on many machines and i find the tools quite
> useful.

They are. They could be even more if things were as simple as
possible.

> if you mind such command lines like the one above you should
> think about switching to a microsoft product where you can push your
> mouse arround and tell everyone that you can do what you want without
> those kludgy command lines which no one really understands.

> so please ask and learn.

You tell me to ask and learn from kernel guys who like to type command
lines (I do, but I don't want to force everyone to do so). So maybe I
can tell you to please learn from users who like the command line, but
try to make simple things as simple as possible.

> there are many people on this list which are pleased to answer your
> questions.
> the idea behind *n?x systems is to combine simple functionality throu=
gh
> pipes and redirects to gain unlimited complexy and power. so if you w=
ant
> to use the full power of *n?x systems you have to get used to this
> "kludgy" command lines.

I don't agree with that. Using grep on vague patterns is not
what I call power. Having to type several commands when one would
be enough (I insist that I think we are talking about one of the most
common cases) is not powerful, according to me.
My motto is "be as complex as possible for people who want power
(you, and sometimes me), but be as simple as possible for people who
just want things to be done quickly, simply, and efficiently (sometimes
me, and all the others)".

> the more you get used to it, the less "kludgy" they will be.

Of course, but the very idea is that one shouldn't have to get used to
it too much to perform simple and common actions.

But I guess we'll never agree anyway... :-(

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)  Homepage:          http://www.eychenne.org/
v_/_ WallFire project:  http://www.wallfire.org/

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
