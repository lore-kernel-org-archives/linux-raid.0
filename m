From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 2.1: command line option parsing bug?
Date: Thu, 15 Dec 2005 15:19:56 +1100
Message-ID: <17312.61164.529345.692828@cse.unsw.edu.au>
References: <437E2CB6.2030903@xss.co.at>
	<17282.22120.327672.720044@cse.unsw.edu.au>
	<62b0912f0511220741v4a926cc4w9bb18e72ad457ff5@mail.gmail.com>
	<17285.20141.12518.264787@cse.unsw.edu.au>
	<62b0912f0512141753k438a66edv42f23e2ed08dadbb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Molle Bestefich on Thursday December 15
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday December 15, molle.bestefich@gmail.com wrote:
> 
> I can, but I suck at putting these things down in writing, which is
> why my initial description was intentionally vague and shallow :-). 
> Now, I'll try anyway.  It'll be imprecise and I'll miss some things
> and show up late with major points etc., but at least I will have
> tried =).

Thanks for trying.

> 
> Ok.. Starting with the usage output:
> 
>    $ mdadm
>    Usage: mdadm --help
>      for help
> 
> Nothing wrong with that.  Good, concise stuff.  Great.
> 
> The --help output, however...:
> 
>    $ mdadm --help
>    Usage: mdadm --create device options...
>           mdadm --assemble device options...
>           mdadm --build device options...
>    ... snip ...
> 
> ... I find confusing.

I like the suggestion of adding one-line descriptions to this.
How about:

Usage: mdadm --create device options...
          Create a new array from unused devices.
       mdadm --assemble device options...
          reassemble a previously created array
       mdadm --build device options...
          create or assemble an array without metadata
       mdadm --manage device options...
          Make changes to an active array
       mdadm --misc options... devices
          report information or perform miscellaneous tasks.
       mdadm --monitor options...
          monitor one or more arrays and report any changes in status
       mdadm device options...
          same as --manage

> 
> Moving right along:
> 
>     ... snip ...
>           mdadm --manage device options...
>           mdadm --misc options... devices
>           mdadm --monitor options...
>     ... snip ...
> 
> I find it very unhelpful to have a --misc section.  Every time I'm
> looking for some command, besides from having to guess in which
> section it's located, I have to check --misc also, since misc can
> cover anything.

Yes, I can see how that is confusing.  
The difference between 'manage' and 'misc' is that manage will only
apply to a single array, while misc can apply to multiple arrays.
This is really a distinction that is mostly relevant in the
implementation.  I should try to hide it in the documentation.

> 
>     ... snip ...
>           mdadm device options...
>     ... snip ...
> 
> Where does that syntax suddenly come from?
> Is it a special no-command mode?  What does it do?  Hmm.  Confusing.
> 
> And btw, why mention "device" and "options" for each and every
> section/command set/command when it's obvious that you need more
> parameters to do something fruitful?  In my opinion it would be better
> to rid the general --help screen of them and instead specify in brief
> what functionality the sections are meant to cover.

well.  it is "device options" for all but misc, which has 
 "options ... devices..."

but I agree that it is probably unnecessary repetition. 

> I keep typing mdadm --help --assemble which unfortunately gets me
> nowhere.  A lot of the times it's because the general help text has
> scrolled out of view because I've just done an '--xxx --help' for some
> other command.  Maybe it's just me, but a minor improvement could be
> to allow '--help --xxx'.

That's a fair comment.  I currently print the help message as soon as I
see the --help option.  But that could change to: if I see '--help',
set a flag, then for every option, print the appropriate help.
Then 
  mdadm --help --size
could even give something useful...

> 
>     ... snip ...
>     For general help on options use
>             mdadm --help-options
>     ... snip ...
> 
> Like misc, I think this is an odd section.  Let's explore it's contents:
> 
>    $ mdadm --help-options
>    Any parameter that does not start with '-' is treated as a device name
>     ... snip ...
> 
> To me, the above is very interesting information about mdadm's syntax
> and thus should be presented at the start of the general --help
> screen.
> 
>     ... snip ...
>    The first such name is often the name of an md device.  Subsequent
>    names are often names of component devices.
>     ... snip ...
> 
> This too.
> 
> What's with the "often" btw?

mdadm --examine /dev/md1 /dev/md2 /dev/md3

subsequent names are names of other md devices, not component devices.


> It is somewhat more helpful to me if parameters is an exact science.
> Eg. the above could say, "for commands affecting whole arrays, the
> first device name is the name of the MD device while subsequent device
> names refer to component devices".  Or preferably something a little
> more concise.
> 
>     ... snip ...
>    Some common options are:
>   --help        -h   : General help message or, after above option,
>                        mode specific help message
>   --help-options     : This help message
>     ... snip ...
> 
> Those are not interesting at all, we've already used those to get here.
> And both are mentioned in the general --help screen.  Snip 'em if
> you ask me.

Fair comment.  They are there for completeness, but not really needed.

> 
> Next on the agenda, I find the messages that I get from mdadm when I
> make syntactic blunders confusing.  I think it comes from the fact
> that mdadm is run like this (example): 'mdadm -f' instead of 'mdadm
> --manage -f'.  It means that the error message I get when I try to do
> something is way off, because mdadm thinks I'm doing something
> completely different than what I'm actually trying to do.  I would
> much prefer having to specify an extra word (fx. --manage) for firing
> an actual mdadm command if that would give me useful error messages. 
> Having to look through a bundle of documentation for commands I'm not
> even interested in just to try and figure out what mdadm thinks I'm
> trying to make it do is not funny.

I'm not sure exactly what you are thinking here, but I will try giving
mdadm some erroneous arguments and try to improve what it says.


> 
> 
> There you go.. initial thoughts.
> 
> Sorry for all the negativism, hope at least it's useful for something
> constructive!

Yes, very useful, thanks.
> 
> The CLI is probably overkill, better help screens can probably do the
> trick for me.

Well, lets see if we can improve the help screens first...

(Note: there are other comments in the email that I haven't directly
responded to.  That doesn't mean I disagree or anything, just that I
didn't respond to them).

Thanks,

NeilBrown

