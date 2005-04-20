From: =?iso-8859-1?Q?Herv=E9?= Eychenne <rv@eychenne.org>
Subject: Re: Questions about software RAID
Date: Wed, 20 Apr 2005 11:32:22 +0200
Message-ID: <20050420093222.GL3103@eychenne.org>
References: <200504200415.j3K4FWm29946@www.watkins-home.com> <42660BED.7000804@dgreaves.com> <62b0912f05042002266bfef91d@mail.gmail.com>
Reply-To: rv@eychenne.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <62b0912f05042002266bfef91d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 20, 2005 at 11:26:28AM +0200, Molle Bestefich wrote:

> David Greaves wrote:
> > Guy wrote:
> > > Well, I agree with KISS, but from the operator's point of view!
> > >
> > > I want...
> > [snip]
> >=20
> > Fair enough.
> [snip]
> > should the LED control code be built into mdadm?

> Obviously not.
> But currently, a LED control app would have to pull information from
> /proc/mdstat, right?
> mdstat is a crappy place to derive any state from.
> It currently seems to have a dual purpose:
>  - being a simple textual representation of RAID state for the user.
>  - providing MD state information for userspace apps.

> That's not good.

I could not agree more.

> There seems to be an obvious lack of a properly thought out interface
> to notify userspace applications of MD events (disk failed --> go
> light a LED, etc).

> Please correct me if I'm on the wrong track, in which case the rest o=
f
> this posting will be bogus.  Maybe there are IOCTLs or such that I'm
> not aware of.

> I'm not sure how a proper interface could be done (so I'm basically
> just blabbering).  ACPI has some sort of event system, but the MD one
> would need to be more flexible.  For instance userspace apps has to
> pick up on MD events such as disk failures, even if the userspace app
> happens to not be running in the exact moment that the event occurs
> (due to system restart, daemon restart or what not).  So the system
> that ACPI uses is probably unsuited.

> Perhaps a simple logfile would do.

No, as it requires active polling.
I think something like a netlink device would be more accurate, but I'm
not a kernel guru.

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
