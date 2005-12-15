From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: mdadm 2.1: command line option parsing bug?
Date: Thu, 15 Dec 2005 01:53:05 +0000
Message-ID: <62b0912f0512141753k438a66edv42f23e2ed08dadbb@mail.gmail.com>
References: <437E2CB6.2030903@xss.co.at>
	 <17282.22120.327672.720044@cse.unsw.edu.au>
	 <62b0912f0511220741v4a926cc4w9bb18e72ad457ff5@mail.gmail.com>
	 <17285.20141.12518.264787@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17285.20141.12518.264787@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > mdadm's command line arguments seem arcane and cryptic and unintuitive.
> > It's difficult to grasp what combinations will actually do something
> > worthwhile and what combinations will just yield a 'you cannot do
> > that' output.
> >
> > I find myself spending 20 minutes with mdadm --help and experimenting
> > with different commands (which shouldn't be the case when doing RAID
> > stuff) just to do simple things like create an array or make MD
> > assemble the devices that compose an array.
>
> Thanks strange.  They seem very regular and intuitive to me (but I
> find it very hard to be objective).  Maybe you have a mental model of
> what the task involves that differs from how md actually does things.

> Can you say anything more about the sort of mistakes you find yourself
> making.  That might help either improve the help pages or the error
> messages (revamping all the diagnostic messages to make the more
> helpful is slowly climbing to the top of my todo list).

I can, but I suck at putting these things down in writing, which is
why my initial description was intentionally vague and shallow :-). 
Now, I'll try anyway.  It'll be imprecise and I'll miss some things
and show up late with major points etc., but at least I will have
tried =).

Ok.. Starting with the usage output:

   $ mdadm
   Usage: mdadm --help
     for help

Nothing wrong with that.  Good, concise stuff.  Great.

The --help output, however...:

   $ mdadm --help
   Usage: mdadm --create device options...
          mdadm --assemble device options...
          mdadm --build device options...
   ... snip ...

... I find confusing.
Try and read the words create, assemble and build as an outsider or a
child would read them, as regular english words, not with MD
development in mind.  All three words mean just about the same thing
in plain english (something like "taking smaller parts and
constructing something bigger with them" or some such).  That confuses
me.

To make things worse, I now have to type in 3 commands (--help
--<cmd>) and compare the output of each just to get a grasp on what
each of the 3 individual commands do.  The proces is "laborious". 
Well, I'll live, but it's annoying to have to scroll up and down
perhaps 5-6 screens of text whilst comparing options just to figure
out which command I would like to use.  I would much prefer if the
'areas of utility' that mdadm commands are divided in were self
explanatory.

I'm not saying that these 'areas of utility' (--create etc.) are not
grouped in a logical fashion.  Just that it's not always easy to
comprehend what they cover.  Perhaps it's enough just to add a small
description per line of 'mdadm --help' output.  After 'mdadm --create'
it would fx. say 'creates a new RAID array based on multiple devices.'
or so.  Just a one-liner.

Moving right along:

    ... snip ...
          mdadm --manage device options...
          mdadm --misc options... devices
          mdadm --monitor options...
    ... snip ...

I find it very unhelpful to have a --misc section.  Every time I'm
looking for some command, besides from having to guess in which
section it's located, I have to check --misc also, since misc can
cover anything.

    ... snip ...
          mdadm device options...
    ... snip ...

Where does that syntax suddenly come from?
Is it a special no-command mode?  What does it do?  Hmm.  Confusing.

And btw, why mention "device" and "options" for each and every
section/command set/command when it's obvious that you need more
parameters to do something fruitful?  In my opinion it would be better
to rid the general --help screen of them and instead specify in brief
what functionality the sections are meant to cover.

    ... snip ...
    mdadm is used for building, managing, and monitoring
    Linux md devices (aka RAID arrays)
    ... snip ...

Probably belongs in the top of the output, but that's a small nit...

    ... snip ...
    For detailed help on the above major modes use --help after the mode
    e.g.
            mdadm --assemble --help
    ... snip ...

I keep typing mdadm --help --assemble which unfortunately gets me
nowhere.  A lot of the times it's because the general help text has
scrolled out of view because I've just done an '--xxx --help' for some
other command.  Maybe it's just me, but a minor improvement could be
to allow '--help --xxx'.

    ... snip ...
    For general help on options use
            mdadm --help-options
    ... snip ...

Like misc, I think this is an odd section.  Let's explore it's contents:

   $ mdadm --help-options
   Any parameter that does not start with '-' is treated as a device name
    ... snip ...

To me, the above is very interesting information about mdadm's syntax
and thus should be presented at the start of the general --help
screen.

    ... snip ...
   The first such name is often the name of an md device.  Subsequent
   names are often names of component devices.
    ... snip ...

This too.

What's with the "often" btw?
It is somewhat more helpful to me if parameters is an exact science.
Eg. the above could say, "for commands affecting whole arrays, the
first device name is the name of the MD device while subsequent device
names refer to component devices".  Or preferably something a little
more concise.

    ... snip ...
   Some common options are:
  --help        -h   : General help message or, after above option,
                       mode specific help message
  --help-options     : This help message
    ... snip ...

Those are not interesting at all, we've already used those to get here.
And both are mentioned in the general --help screen.  Snip 'em if you ask me.

    ... snip ...
  --version     -V   : Print version information for mdadm
    ... snip ...

I don't know where I'd put this.
Maybe I would rename 'monitor' to 'monitor/information' and make the
section description something like 'array monitoring, array/device
queries and other information' and then stuff --version in that
section....

    ... snip ...
  --force       -f   : Override normal checks and be more forceful
    ... snip ...

Without a context, --force is terribly unusable to me, as is mentioning it here.

    ... snip ...
  --verbose     -v   : Be more verbose about what is happening
  --brief       -b   : Be less verbose, more brief
    ... snip ...

No comments.  Not sure what they'd do since they're mentioned out of
context.  I think most people shrug and think 'irrellevant' when they
read those two lines.

    ... snip ...
  --assemble    -A   : Assemble an array
  --build       -B   : Build a legacy array
  --create      -C   : Create a new array
  --detail      -D   : Display details of an array
    ... snip ...

Extremely useful information about basic commands is right there, but
is very well hidden away in a section named "--help-options".
IMHO, the above should go directly to the front --help screen.

If I understand "--build" above correctly (I spotted the word "legacy"
upon reading it the third time), it should IMHO be renamed from
"--build" to "--assemble-legacy" right away!

    ... snip ...
  --examine     -E   : Examine superblock on an array component
  --monitor     -F   : monitor (follow) some arrays
  --query       -Q   : Display general information about how a
                       device relates to the md driver
    ... snip ...

Again, seems very useful.  Wonder why these are hiding in odd places
like --misc and --help-options.

Ok, enough about sections and grouping.

Next on the agenda, I find the messages that I get from mdadm when I
make syntactic blunders confusing.  I think it comes from the fact
that mdadm is run like this (example): 'mdadm -f' instead of 'mdadm
--manage -f'.  It means that the error message I get when I try to do
something is way off, because mdadm thinks I'm doing something
completely different than what I'm actually trying to do.  I would
much prefer having to specify an extra word (fx. --manage) for firing
an actual mdadm command if that would give me useful error messages. 
Having to look through a bundle of documentation for commands I'm not
even interested in just to try and figure out what mdadm thinks I'm
trying to make it do is not funny.


There you go.. initial thoughts.

Sorry for all the negativism, hope at least it's useful for something
constructive!


> Is this and interactive interface where you have hit 'tab' at anytime
> and it either completes the current word, or lists options? (For me,
> that is the 'kermit' interface, as kermit was the first program I used
> which had it).

Yes.

I'm not saying this is good as a replacement for mdadm's command line
arguments.  Most programs that has a Kermit-like CLI can also be
executed with the exact same commands that the CLI accepts, raw on the
command line.  So the CLI would be an added feature to mdadm, but
would not replace or remove anything.  Although "--create" would have
to be renamed "create" and so forth.

Maybe the CLI is a bad idea.  It could be that the CLI is a solution
to a symptom, not the problem itself.  Maybe I'm just struggling with
having to type the 'mdadm --help' part of 'mdadm --help blah' far too
many times because the help screens are not helping me as much as I
would like (and because I reverse order --help and --<cmd>).  Maybe
I'm just tired of typing a lot of similar 'mdadm <insert various
commands and parameters here>' a lot because I don't understand the
syntactic error messages that mdadm is giving me, because it's giving
me wrong messages on account of thinking that I want to fire a
different command than I'm really trying to.  I dunno.

The CLI is probably overkill, better help screens can probably do the
trick for me.
And if not, BASH can be extended to show help screens and finish mdadm
commands/parameters :-).
