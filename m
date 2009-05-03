From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: md extension to support booting from raid whole disks.
Date: Sun, 3 May 2009 13:05:44 -0500
Message-ID: <20090503180549337.FGR22077@cdptpa-omta02.mail.rr.com>
References: <e13f0e541934a0966f213f6da13d83da.squirrel@neil.brown.name>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e13f0e541934a0966f213f6da13d83da.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> On Sun, May 3, 2009 11:33 am, Leslie Rhorer wrote:
> >> First thing is, DO NOT boot from raid5/6. It's pointless anyway.
> >
> > I agree.
> 
> I don't.
> I think it is very valuable for people to share their experiences
> of what works and what doesn't.  Of what problem situations arise
> and what solutions seem effective.  It is even good to give advice
> when advice is sought.
> But to assume that the thing which works best for you will always
> work for everyone else - or vice versa - is wrong.   And people seem
> to be appearing close to that assumption.

I admit the case was overstated, and I thought about that very fact after I
sent the message.  See below.
 
> >> Summing up, I don't get, why would anybody really want to boot from
> >> raid5
> >> or 6.
> >
> > Well, I can see the reasons, but to my mind they are outweighed by the
> > problems inherent in doing so and the fact the benefits are minimal.
> >
> 
> You are very welcome to share what you see as the inherent problems.
> But please be aware that others may see benefits that you do not.

That's entirely possible, but note I qualified my statement specifically
saying I did see advantages, and there are - cost being one.  I stand by my
statement, fully qualified as my personal opinion above, that to my mind the
benefits of booting from a RAID array are outweighed by the inherent issues.
Any other person is free to have a different viewpoint.

> > With hard drives being so inexpensive, I see no reason not to have
> > separate
> > boot drive or mirrored set and data devices.
> 
> Yes, hard drives are cheaper than they once were.  But they still
> aren't free.

Well, I have a dozen or so hard drives laying around which will never be
used - being too small for any other purpose - unless they get stuck into a
system as a boot drive.  Barring that potential use, they would just be
discarded.  That's about as close to free as it gets.  More to the point, it
would seem to me anyone who has enough cash to purchase 4 or more large hard
drives should not ordinarily have a problem getting a small one.

> And they do consume measurable volume and current.

True, but power supplies are also cheap.  Space can admittedly be a
bugger-bear of an issue, but a larger case or an external drive solution may
be viable.  Given we are talking about creating a system, here, proper
planning is advisable.  Obtaining a system which is too small to meet one's
needs is not.

> If I happen to have a box which has only got room for 4 drives, then
> I'm not going to use two of them just for boot, nor am I going to
> plug in external drives with all the risks associated with them.

Well, as I mentioned, I prefer backing up the boot system with a cold drive
sitting on the shelf, but I have also never purchased a case intended to
host a RAID array which only has four drive slots.  In any case, mirrored
systems are far too prone to user errors for my tastes.  I make easily a
thousand stupid mistakes in configuring systems for every drive failure I
have ever had, and no level of RAID support can make up for that.  A cold
spare drive can.

> My own "ideal" would be
>  - simple boot loader in first sector of every drive that loaded a
>    'second stage' linearly off the early sectors of the disk.
>  - the 'second stage' is a linux kernel plus initramfs which finds
>    the root filesystem loads the final kernel and initramfs, and
>    uses kexec to boot into it.
> 
> Thus the final stage of the boot loader can understand any filesystem,
> any raid level, any combination of controllers.

Yeah, but I don't think that will work with a Windows partition, will it?
'Much as I hate Windows and avoid it whenever possible, I do always include
a Windows boot in every x86 architecture machine, simply because many
manufacturers still refuse to supply the breadth of tools for their hardware
for Linux they do for Windows.  It also provides a comparison which can help
to determine if a problem is software or hardware related.  Recently I was
having a problem with a UPS, for example, and it was unclear if the problem
was the UPS or the Linux driver.  By booting Windows, I was able to
determine it was the Linux driver.  OTOH, the last thing I want to do is
waste relatively precious drive space on an array with a Windows partition.

> The area that stores the second stage would be written rarely, and
> always written as a whole - no incremental updates.  So much of the
> power of md/raid1 would not be necessary.  Having some tool that
> installed the boot loader and second stage on every bootable device would
> seem an adequate solution.
> Whether this space were kept free by traditional partitioning,
> or by the filesystem or raid or whatever "knowing" to leave the first
> few meg free is of relatively little interest to me.  I can see advantages
> both ways.

True.  With a completely separate drive, however, the admin can take an idle
machine, build his OS with drivers and utilities intact, test the machine to
work out bugs, and then upgrade the production machine by downing it and
replacing the boot hard drive.  If the system subsequently crashes or
exhibits unstable behavior, swap the drives back and go back to the drawing
board.

> While that would be my ideal, I'm quite happy to support other people in
> experimenting with other approaches.  It is by being open to making
> mistakes and learning from them that we grow.

Absolutely!  An important part of that process, however, is listening to the
opinions and experiences of other people, and learning from their successes
and failures.  That's why I decided to chime in.  As always, every observer
is perfectly welcome to take my opinions into whatever consideration  they
like, or ignore them completely.


> So I still plan to offer a "--reserve-space=2M" option for mdadm to
> allow the first 2M of each device to not used for raid data.  Whether
> any particular usage of this option is viable or not, is a different
> question altogether.

Having additional options available is never a bad thing, and I would never
discourage a developer from adding what he feels is useful features to a
system.  After all, one always has the option of simply not using the
feature.

