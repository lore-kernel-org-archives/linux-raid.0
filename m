From: Leandro =?ISO-8859-1?Q?Guimar=E3es?= Faria Corcete Dutra
	<leandro@dutra.fastmail.fm>
Subject: Re: 2.6.0: ext3 journal aborted with ext3/lvm/raid5
Date: Thu, 19 Feb 2004 19:01:44 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1077228103.11696.548.camel@moacir.wlt.com.br>
References: <20040107205326.GA14511@hamachi.dyndns.org>
	 <pan.2004.02.18.14.55.50.11785@dutra.fastmail.fm>
	 <20040219210805.GA576@hamachi.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040219210805.GA576@hamachi.dyndns.org>
To: Steven Ihde <sihde@cs.stanford.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Em Qui, 2004-02-19 =C3=A0s 18:08, Steven Ihde escreveu:
> On Wed, Feb 18, 2004 at 11:55:50AM -0300, Leandro Guimar=C3=A3es Fari=
a Corsetti Dutra wrote:
> > On Wed, 07 Jan 2004 12:53:26 -0800, Steven Ihde wrote:
> > > I get "Aborting journal on device dm-x" and associated errors abo=
ut every
> > > week or two.  This is on a 2.6.0 kernel, ext3 filesystem running =
on lvm
> > > over md raid5.
> >=20
> > 	I've found a similar situation, have any fix came forth?
>=20
> Can anyone suggest what the next step is? =20

	I'd suggest a bug report... I was thinking about upgrading to 2.6.3 an=
d
following the procedures to generate a PROBLEM-format bug report.  Only
I'm lazy and usually wait for the Debian packages to upgrade...

	But I guess we already have enough information and thus this would be
unnecessary, and all we need now is a sufficient knowledgeable hacker t=
o
take an interest in our plight.


> Here are the latest entries from my syslog (this is 2.6.2).  As it
> usually does, this occurred early in the morning while the locatedb
> was being updated.

	I've Google'd around and at another lists (like the ext3-users and
linux-kernel ones) people usually have this at the same hour, usually
linked to some scheduled (implying I/O heavy) event.

	Mine occurred around 18h, same as one of the reporters I found.
=20

--=20
Leandro Guimar=C3=A3es Faria Corcete Dutra
Maring=C3=A1, PR, BRASIL                 +55 (11) 5685 2219
http://br.geocities.com./lgcdutra/  +55 (44) 3028 7467
Soli Deo Gloria!                    +55 (44) 3028 8335

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
