From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: mdadm - comments on command layout
Date: Sat, 14 Aug 2004 12:26:03 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408141626.i7EGQ3320304@watkins-home.com>
References: <200408141646.43625.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408141646.43625.maarten@ultratux.net>
To: 'maarten van den Berg' <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have never had any problems using mdadm's command syntax, but...

From the man page:
SYNOPSIS
       mdadm [mode] <raiddevice> [options] <component-devices>

Mode is optional.  Since some options are the same or similar (-b -B, -f -F,
-c -C, -r -R, -m --mail -m --super-minor) maybe the mode should not be
optional.  Over time even more options will be added, this will increase the
risk of mdadm not doing what I intended when I make a typo, or maybe
miss-understand the options.  It is common for me to forget the case of an
option, when this has happened I got errors, but there is a chance it was a
valid option but not what I intended.  It would suck to lose my BIG :) 200G
array due to a typo.  But, this is Unix, many commands could trash the
system with a simple 1 byte typo.  I use mode when I use mdadm, maybe I
never noticed it was optional, not sure.

In short...
	1. To make mdadm safer to use, make mode not optional.
	2. I am fine with it, as it is.
	3. Neil, spend your spare time adding new feature!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of maarten van den Berg
Sent: Saturday, August 14, 2004 10:47 AM
To: linux-raid@vger.kernel.org
Subject: Re: mdadm - comments on command layout

On Saturday 14 August 2004 14:33, Neil Brown wrote:
> On Friday August 13, stoffel@lucent.com wrote:
> > Hi Neil,
> >
> > I've been using mdadm recently to work with some arrays and I really
> > have to say I dislike how the commands are laid out and used.  First
> > off, they're not consistent from one usage to another.  Of course, I'm
> > going to be jerk and not give good examples since my personal box at
> > home is down and I'm at work.  But the idea is that when you assemble
> > a RAID device, it should look similiar to how you manage that raid
> > device.
>
> Examples would really help.  In my mind it is very regular.  There is
> some room for flexibility, but generally, the usage is
>
>    mdadm --mode --option...  /dev/md-device  [ component devices  ... ]

Hi Neil,

In my mind, either the manpage is somewhat confusing, or the program is.
From the exact syntax above I would assume that to (hot)add a device I need
to 
type 'mdadm --manage -a ...'.  But just 'mdadm -a ...' is enough.  So is the

case for some other modes.  The syntax given isn't mdadm [--mode] --option ,

so one would assume just omitting --manage would lead to an error.

This was, I mean still is, indeed confusing to me. 

There is another bit.  Quoting from the manpage you first have MODES, then
the 
6 modi are explained, and directly thereafter comes OPTIONS, but some of
them 
seem to list modes, not options:

 -A, --assemble
 -B, --build
 -C, --create
etc.

So that leaves a big question; is it a mode, an option...?
The whole mode thing is either not clear to _me_, or it is somewhat
confusing 
in general.  I wouldn't really suggest that typing 'mdadm -a' instead of 
'mdadm --manage -a'  should lead to an error, but the concept of the modi
now 
makes little sense (to me personally). But maybe I just misunderstood
things.
.
So moving the -A, -B etc. "options" to the section "modes" above, adding a
-M 
--manage mode there as well might make everything clearer. (That's just
MHO.)

But anyhow, the program does what it's supposed to do, so...  :-)

Respectfully,
Maarten

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

