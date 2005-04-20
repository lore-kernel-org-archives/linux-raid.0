From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Questions about software RAID
Date: Wed, 20 Apr 2005 19:36:40 +0200
Message-ID: <62b0912f050420103618110e66@mail.gmail.com>
References: <200504200415.j3K4FWm29946@www.watkins-home.com>
	 <42660BED.7000804@dgreaves.com>
	 <62b0912f05042002266bfef91d@mail.gmail.com>
	 <20050420093222.GL3103@eychenne.org>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050420093222.GL3103@eychenne.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: rv@eychenne.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Herv=E9 Eychenne wrote:
> Molle Bestefich wrote:
> > There seems to be an obvious lack of a properly thought out interfa=
ce
> > to notify userspace applications of MD events (disk failed --> go
> > light a LED, etc).
> >=20
> > I'm not sure how a proper interface could be done (so I'm basically
> > just blabbering).  ACPI has some sort of event system, but the MD o=
ne
> > would need to be more flexible.  For instance userspace apps has to
> > pick up on MD events such as disk failures, even if the userspace a=
pp
> > happens to not be running in the exact moment that the event occurs
> > (due to system restart, daemon restart or what not).  So the system
> > that ACPI uses is probably unsuited.
> >=20
> > Perhaps a simple logfile would do.  It's focus should be
> > machine-readability (vs. human readability for mdstat).  A userspac=
e
> > app could follow MD's state from the beginning (bootup, no devices
> > discovered, logfile cleared), through device discovery and RAID
> > assembly and to failing devices.  By adding up the information in a=
ll
> > the log lines, a userspace app could derive the current state of MD
> > (which disks are dead..).
>
> No, as it requires active polling.

No it doesn't.
Just tail -f the logfile (or /proc/xxxx or /sys/xxxx "file"), and your
app will receive due notice exactly when something happens.  Or use
inotify.

> I think something like a netlink device would be more accurate,
> but I'm not a kernel guru.

No idea how that works :-).
If by "accurate" you mean you'll get a faster reaction, that's wrong
as per above explanation.  And I'll try to explain why a logfile in
other respects are actually _more_ accurate.

I can see why a logfile _seems_ wrong at first sight.
But the idea that it allows you to (*also*!) see historic MD events
instead of just the current status this instant seems compelling.

 - You can be sure that you haven't missed or lost any MD events.  If
your monitoring app crashes or restarts, just look in the log.  (If
you're unsure whether you've notified the admin on some event or not;
I'm sure MD could log the disk's event counters.  The monitoring app
could keep it's own "how far have I gotten" event counter [on disk],
so the app knows "it's own status".)

 - If the log resides in eg. /proc/whatever, you can pipe it to an
actual file.  It could be pretty useful for debugging MD (attach your
MD log, send a mail asking "what happened", and it'll be clear to the
super-md-dude at first sight).

 - Seems more convincing to enterprise customers that you can actually
see MD's every move in the log.  Makes it seem much more robust and
reliable.

 - Really useful for debugging the monitoring app....

 - Probably other advantages.....  Haven't really thought it trough
that well :-).

The problem, as I see it, is if it's worth the implementation trouble
(is it any harder than to implement a netlink / what not interface?=20
No idea!)
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
