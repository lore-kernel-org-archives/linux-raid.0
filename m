From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: mdadm 2.1: command line option parsing bug?
Date: Thu, 15 Dec 2005 11:37:13 +0100
Message-ID: <62b0912f0512150237p7c88f997gd6beb7a0b3d11ea6@mail.gmail.com>
References: <437E2CB6.2030903@xss.co.at>
	 <17282.22120.327672.720044@cse.unsw.edu.au>
	 <62b0912f0511220741v4a926cc4w9bb18e72ad457ff5@mail.gmail.com>
	 <17285.20141.12518.264787@cse.unsw.edu.au>
	 <62b0912f0512141753k438a66edv42f23e2ed08dadbb@mail.gmail.com>
	 <17312.61164.529345.692828@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17312.61164.529345.692828@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I found myself typing "IMHO" after writing up just about each comment.
I've dropped that and you'll just have to know that all this is IMHO
and not an attack on your ways if they happen to be different ^_^.

Neil Brown wrote:
> I like the suggestion of adding one-line descriptions to this.
> How about:

I'll first comment each command/description (general feedback later):

> Usage:
>        mdadm --create device options...
>           Create a new array from unused devices.
>        mdadm --assemble device options...
>           reassemble a previously created array

I like 'em!

>        mdadm --build device options...
>           create or assemble an array without metadata

Oh, that's what it's for, operating without metadata.  Good to know.

It would help a lot (for me) if the above also had a brief note about
why I would ever want to use --build.  Otherwise I'll just be confused
about when I should use assemble and when I should use build and why
it even exists.

What's the logic behind having split create/assemble commands but a
joined command for creating/assembling when there's no metadata?  (I'm
sure there is one, I'm just confused as always.)

>        mdadm --manage device options...
>           Make changes to an active array

Nice.

>        mdadm --misc options... devices
>           report information or perform miscellaneous tasks.

Get rid of the misc section or rename it to something meaningful..

>        mdadm --monitor options...
>           monitor one or more arrays and report any changes in status

Nice.

>        mdadm device options...
>           same as --manage

Oh, so that's what it does.
A bit confusing for a newbie like me that we're not sticking to _1_ syntax.

Since the above is a side note about a convenient syntax hack, I think
that (in the event that you find that it is not confusing [which I do
:->] and decide to keep it), there should be at least a blank line
between the very important --<cmd> descriptions and this rarely
relevant note.

General stuff:

The note:
 * use --help in combination with --<cmd> for further help

is missing.  I think it would be good to retain it.


> > I find it very unhelpful to have a --misc section.  Every time I'm
> > looking for some command, besides from having to guess in which
> > section it's located, I have to check --misc also, since misc can
> > cover anything.
>
> Yes, I can see how that is confusing.
> The difference between 'manage' and 'misc' is that manage will only
> apply to a single array, while misc can apply to multiple arrays.
> This is really a distinction that is mostly relevant in the
> implementation.  I should try to hide it in the documentation.

That would be good :-).
Renaming --misc to something which relates to the fact that this is
about "multi md device" commands and giving it an appropriate
description line (I don't think your --misc description was any good,
sorry, hehe) would also be *a lot* better..


> > And btw, why mention "device" and "options" for each and every
> > section/command set/command when it's obvious that you need more
> > parameters to do something fruitful?  In my opinion it would be better
> > to rid the general --help screen of them and instead specify in brief
> > what functionality the sections are meant to cover.
>
> well.  it is "device options" for all but misc, which has
>  "options ... devices..."

Yes, okay, I think that would be explained better by a description
line for misc saying that it's about multiple devices (by the way, are
we talking multiple MD or multiple component devices?)

> but I agree that it is probably unnecessary repetition.

Also completely useless since there's no mention of what any of the
options /are/, no?
Just adds to confusion, so better to snip it.

> > I keep typing mdadm --help --assemble which unfortunately gets me
> > nowhere.  A lot of the times it's because the general help text has
> > scrolled out of view because I've just done an '--xxx --help' for some
> > other command.  Maybe it's just me, but a minor improvement could be
> > to allow '--help --xxx'.
>
> That's a fair comment.  I currently print the help message as soon as I
> see the --help option.  But that could change to: if I see '--help',
> set a flag, then for every option, print the appropriate help.

That would be really swell!

> Then
>   mdadm --help --size
> could even give something useful...

Yup :-).  Hmm.  Not bad at all.
Would be good for the extreme newbie and confused ppl like me ;).

> >     ... snip ...
> >     For general help on options use
> >             mdadm --help-options
> >     ... snip ...
> >
> > Like misc, I think this is an odd section.  Let's explore it's contents:
> >
> >    $ mdadm --help-options
> >    Any parameter that does not start with '-' is treated as a device name
> >     ... snip ...
> >
> > To me, the above is very interesting information about mdadm's syntax
> > and thus should be presented at the start of the general --help
> > screen.
> >
> >     ... snip ...
> >    The first such name is often the name of an md device.  Subsequent
> >    names are often names of component devices.
> >     ... snip ...

> > It is somewhat more helpful to me if parameters is an exact science.
> > Eg. the above could say, "for commands affecting whole arrays, the
> > first device name is the name of the MD device while subsequent device
> > names refer to component devices".  Or preferably something a little
> > more concise.

> > What's with the "often" btw?
>
> mdadm --examine /dev/md1 /dev/md2 /dev/md3
>
> subsequent names are names of other md devices, not component devices.

Ok.  In that case, I think if this note is to be exacted enough to
actually become useful, it will also become too broad to be of any use
to the help reader anyway.  Thus it should be dropped in favor of
similar (but obviously simpler) notes, one per individual command.


> >     ... snip ...
> >    Some common options are:
> >   --help        -h   : General help message or, after above option,
> >                        mode specific help message
> >   --help-options     : This help message
> >     ... snip ...
> >
> > Those are not interesting at all, we've already used those to get here.
> > And both are mentioned in the general --help screen.  Snip 'em if
> > you ask me.
>
> Fair comment.  They are there for completeness, but not really needed.

Yes, ok, it's a good principle to document everything.

But stuffing a lot of unrelated options in --help-options (or --misc
for that matter) tastes like "not enough thought has went into
designing the categories and commands."

Don't take it as a criticism of your work - making this stuff right
takes a lot of hard thought that could be used for something
immediately productive.  And even when a lot of thought has gone into
it, it still takes:

* a bunch of other clever people to look at it and bring up fresh
suggestions, and
* real tests with real users trying to do real things while someone
does a transcript

before it becomes real good.  So don't take it like I'm criticizing
your hard work, I'm not!

Dropping the entire --help-options and moving --help to the front page
would be right in my mind.  If you want suggestions where the rest of
the commands should go, I can try and suggest something helpful.


> > Next on the agenda, I find the messages that I get from mdadm when I
> > make syntactic blunders confusing.  I think it comes from the fact
> > that mdadm is run like this (example): 'mdadm -f' instead of 'mdadm
> > --manage -f'.  It means that the error message I get when I try to do
> > something is way off, because mdadm thinks I'm doing something
> > completely different than what I'm actually trying to do.  I would
> > much prefer having to specify an extra word (fx. --manage) for firing
> > an actual mdadm command if that would give me useful error messages.
> > Having to look through a bundle of documentation for commands I'm not
> > even interested in just to try and figure out what mdadm thinks I'm
> > trying to make it do is not funny.
>
> I'm not sure exactly what you are thinking here, but I will try giving
> mdadm some erroneous arguments and try to improve what it says.

Can't remember, it's been a while since I used it last.  I tend to use
it a lot but then only for brief periods of time at a time.  I think I
was having trouble making mdadm output useful error messages for
--run.  Not sure whether I gave it devices which didn't exist, wrong
options or what I did.  Sorry I can't be more helpful here.
