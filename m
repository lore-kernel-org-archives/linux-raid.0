From: Jure =?ISO-8859-2?Q?Pe=5Far?= <pegasus@nerv.eu.org>
Subject: Re: raid5, media scans and stripe-wise resync
Date: Mon, 25 Oct 2004 22:48:38 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041025224838.04c51a0b.pegasus@nerv.eu.org>
References: <200410252029.i9PKTEN26833@www.watkins-home.com>
	<1098736532.5399.52.camel@duxeon.cobite.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1098736532.5399.52.camel@duxeon.cobite.com>
To: David Mansfield <md@dm.cobite.com>
Cc: bugzilla@watkins-home.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 25 Oct 2004 16:35:32 -0400
David Mansfield <md@dm.cobite.com> wrote:

> The point is that NEITHER DRIVE 'FAILS'.  They just have unrecoverabl=
e
> read errors, or bad sectors.  As long as the two bad sectors are not =
in
> the same stripe, you have not lost any data (theoretically, for s/w a=
nd
> realistically for h/w).

As I see the problem, the definition of what is a "failed drive" is
different from sysadmin's point of view and from md's point of view.

Md freaks out on every single unrecoverable read error, but these usual=
y do
not indicate a completely failed and dead drive.=20

What needs to be done is to give md some more knowledge about disk erro=
rs,
disk behaviour at dying and possibly integrate it in some way with smar=
td.
This has been requested every now and then at least for the last three
years, however nobody started to work on something like this, at least =
I'm
not aware of any such activity.

How exactly this could / should be acomplished is an interesting topic =
too.


--=20

Jure Pe=E8ar
http://jure.pecar.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
