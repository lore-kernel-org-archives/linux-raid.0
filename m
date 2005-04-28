From: "J. Ryan Earl" <ryan@dynaconnections.com>
Subject: RE: Can you help me on Linux SW RAID? [OT]
Date: Thu, 28 Apr 2005 17:32:08 -0500
Message-ID: <OMEKLMBKKEOEENCKLEIDOEPHCIAA.ryan@dynaconnections.com>
References: <20050428195610.GO21645@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050428195610.GO21645@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>, miele@inwind.it
Cc: jakob <jakob@unthought.net>, linux-raid <linux-raid@vger.kernel.org>, mingo <mingo@chiara.csoma.elte.hu>, bueso <bueso@vives.org>
List-Id: linux-raid.ids

I've had 2.6 based systems deployed in datacenters for over a year now,=
 and
it's pretty good for commodity hardware, but people still have to use 2=
=2E4
for most of the BigIron type stuff.  For instance, EMC only supports
PowerPath (their multi-pathing driver) for 2.4 last I checked, and thou=
gh
the newest 2.6 line has EMC CX/AX multipathing support built into DM, i=
t's
still experimental and I just can't tell a customer that's spent possib=
ly
millions of dollars on hardware and software licenses that we're using =
new
unproven technology.  Tons of Oracle things only come for 2.4 (ASMlib f=
or
example).

That, and, once things are setup, stable, and work, you generally just =
don't
want to change them *ahem* break them.  We -just- retired a Oracle data=
base
that's been running a 2.4.9 derived kernel for the last two years.
Additionally 2.6 performance has varied widely between releases this ye=
ar,
I've found that 2.6.3 was more stable than most of the versions that
followed it.  All my application servers run a 2.6 derived kernel, but =
the
database nodes will have to be on 2.4 for at least another year if not
two--how many people have tested 2.6's memory management performance on
systems with 32GB of RAM for instance?

Interesting on the OCFS2 support in SLES, our Oracle DBA prefered RHEL
because he had read about lots of problems between Oracle and SLES.  I
forwarded him your email =3D)  And now that I'm sufficiently off-topic,=
 I will
be quiet.

J. Ryan Earl
Systems/Network Engineer
dynaConnections Corporation
512.306.9898

-----Original Message-----
=46rom: Lars Marowsky-Bree [mailto:lmb@suse.de]
Sent: Thursday, April 28, 2005 2:56 PM
To: J. Ryan Earl; miele@inwind.it
Cc: jakob; linux-raid; mingo; bueso
Subject: Re: Can you help me on Linux SW RAID?


On 2005-04-28T14:18:28, "J. Ryan Earl" <ryan@dynaconnections.com> wrote=
:

> OCFS2 isn't stable yet, I wouldn't suggest its use for production sys=
tems.
> Furthermore, where did the requirement for 2.6 (kernel I assume) come
from?
> Sounds like he was using RHEL3 anyway...

That wasn't mentioned in the mail I replied to; anyone deploying a new
2.4 based system right now is a bit behind the times in my opinion, I
hope 2.4 goes away soon ;-)

OCFS2 is already included in SLES9 SP2 beta; we'll ship it for
production use with SLES9 SP2 general availability.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
