From: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mru@inprovide.com>
Subject: Re: Good news / bad news - The joys of RAID
Date: Tue, 23 Nov 2004 01:09:57 +0100
Message-ID: <yw1xbrdpwhm2.fsf@ford.inprovide.com>
References: <Pine.LNX.4.56.0411221754520.4195@lion.drogon.net> <200411222348.iAMNmJN01404@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Guy" <bugzilla@watkins-home.com> writes:

> Amanda...
> I looked into this about 2 years ago.  From what I found, each daily =
backup
> used a different tape.  This is crazy!  I can put 10-20 days on 1 tap=
e.
> Maybe more, not really sure.  Of course it is based on how much data =
changes
> each day.  So, my full backups are only needed about once every 2-3 w=
eeks. =20

Using several tapes, switching every day (or however often you make
backups), is a good idea.  If the tapes can hold more than one backup,
just keep adding to the oldest tape when all have been used once.
That way, if the system explodes during a backup, it won't take the
most recent backup with it.

--=20
M=E5ns Rullg=E5rd
mru@inprovide.com

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
