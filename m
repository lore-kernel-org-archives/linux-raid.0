From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Questions about software RAID
Date: Wed, 20 Apr 2005 00:15:27 -0400
Message-ID: <200504200415.j3K4FWm29946@www.watkins-home.com>
References: <42656030.6000506@weisshuhn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42656030.6000506@weisshuhn.de>
Sender: linux-raid-owner@vger.kernel.org
To: 'Frank Wittig' <fw@weisshuhn.de>, rv@eychenne.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Frank Wittig
> Sent: Tuesday, April 19, 2005 3:47 PM
> To: rv@eychenne.org
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Questions about software RAID
>=20
> Herv=E9 Eychenne wrote:
>=20
> >Maybe you are an experienced guy so it seems so simple to you... but
> >I'm always amused when an experienced guy refuses to make things
> >simpler for those who aren't as much as he is. And sends them to
> >Microsoft. Great.
> >
> >
> i don't send you to microsoft. i want you to understand the philosoph=
y
> behind linux.
> the sort of functionality you want doesn't belong to the mdadm tool.
> mdadm is the command line interface to dm.
> more complex functionality like the one you desire is covered by
> frontends like EVMS.
> i don't know EVMS but what i heard about it sounds exactly like what =
you
> want. simple administration without having to know how things work in
> the background.
>=20
> >I personnaly do not consider that this is yet another case.  For me,
> >RAID is about have disk availability, right?  So the most common
> >production case is definitely when one of your disks crashed, and yo=
u
> >want to replace it.
> >There must be some kind of way to deal with that without typing too
> >much contextual command lines.
> >
> >
> after the first time you lose data because of a failure of an automat=
ed
> process you will think different about that.
> i think automation is fine for normal operation.
> failure of a component is far from normal and in this case full contr=
ol
> is what you want/need.
>=20
> >Whether this simple way should belong to mdadm is another question, =
but
> >I personnaly think it should, as it would introduce no overhead
> >(would it, really ?) and would be very helpful.
> >
> >
> KISS: keep it stupid simple
> this is the philosophy. keep low-level tools stupid simple. more
> complexity brings a higher risk of failure.
> we're talking about raid. not about doing backups or syncing the syst=
em
> clock.
>=20
> >>did you ever thought about switching to a hardware where you can re=
move
> >>and add disks without having to do anything else than pull the old =
one
> >>out and push teh new one in?
> >>
> >>
> >Ok, here we are...
> >[First, the RAID controller I'm forced to deal with has no Linux
> >driver, but that's not important for our discussion.]
> >
> >
> there are some nice boxes arround. ther take a bunch of disks and app=
ear
> to the host as a simple SCSI disk. had such a thing in the past.
> replacing disks was so simple a secretary could have done that. ;-)
>=20
> >I don't agree with that. Using grep on vague patterns is not
> >
> >
> i think grep is far more powerfull as you think.
>=20
> >>the more you get used to it, the less "kludgy" they will be.
> >>
> >>
> >Of course, but the very idea is that one shouldn't have to get used =
to
> >it too much to perform simple and common actions.
> >
> >
> if replacing disks is a common case to you, you should buy your disks
> from a different manufacturer. ;-)
> and if you have so many arrays that a disk failure is common because =
of
> the number of disks, you would want to know the basics.
>=20
> >But I guess we'll never agree anyway... :-(
> >
> >
> we're just on different levels of usage. and there's a tool for every=
one
> on us.
> my tool is mdadm.
> and yours is EVMS or some other high level frontend which abstracts t=
he
> use of the low-level tools behind a nice looking UI.
>=20
> greetings,
> Frank

Well, I agree with KISS, but from the operator's point of view!

I want the failed disk to light a red LED.
I want the tray the disk is in to light a red LED.
I want the cabinet the tray is in to light a red LED.
I want the re-build to the spare to start.
I want the operator du jour to notice the red LEDs.
I want the operator to remove the failed disk.
I want the operator to install the new disk.
I want the re-build to the new disk to start.
I want the re-build to not fail the current spare so data says redundan=
t.
I want the old spare to become the spare again. (optional)

The operator would log the event:
"Disk xyz's LED went red, I replaced the disk, the red LED went out."

In my opinion, most operators would not be able to replace a disk on a =
md
RAID system.  It is much too complex!  Most operators need written
procedures.  They can't use independent thought to resolve problems.

Also, most operators can't use vi!  So, if you can use vi, you are bett=
er
than most operators!!!  IMO.

Of course I can't have the red LED, but the disks could be labeled and =
an
email sent saying disk xyz has failed.  The operator could then replace=
 disk
xyz, if they could find it!  Then another email(s) with a status update=
=2E

With most (maybe all) hardware RAID systems I have used, the above is h=
ow it
works.  Even the red LED!!!  But these are dedicated RAID systems, not =
off
the shelf components.

I don't expect a software solution to ever be as easy as hardware, but =
I do
agree it needs to be much more operator friendly than it is today.

Guy

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
