From: maarten van den Berg <maarten@ultratux.net>
Subject: Re: mdadm - comments on command layout
Date: Sat, 14 Aug 2004 16:46:43 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408141646.43625.maarten@ultratux.net>
References: <16669.9163.392465.637229@gargle.gargle.HOWL> <16670.1701.954970.773800@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16670.1701.954970.773800@cse.unsw.edu.au>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
From the exact syntax above I would assume that to (hot)add a device I need to 
type 'mdadm --manage -a ...'.  But just 'mdadm -a ...' is enough.  So is the 
case for some other modes.  The syntax given isn't mdadm [--mode] --option , 
so one would assume just omitting --manage would lead to an error.

This was, I mean still is, indeed confusing to me. 

There is another bit.  Quoting from the manpage you first have MODES, then the 
6 modi are explained, and directly thereafter comes OPTIONS, but some of them 
seem to list modes, not options:

 -A, --assemble
 -B, --build
 -C, --create
etc.

So that leaves a big question; is it a mode, an option...?
The whole mode thing is either not clear to _me_, or it is somewhat confusing 
in general.  I wouldn't really suggest that typing 'mdadm -a' instead of 
'mdadm --manage -a'  should lead to an error, but the concept of the modi now 
makes little sense (to me personally). But maybe I just misunderstood things.
.
So moving the -A, -B etc. "options" to the section "modes" above, adding a -M 
--manage mode there as well might make everything clearer. (That's just MHO.)

But anyhow, the program does what it's supposed to do, so...  :-)

Respectfully,
Maarten

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

