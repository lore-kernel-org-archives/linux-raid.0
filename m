From: "Wilson, Jonathan" <piercing_male@hotmail.com>
Subject: Re: RAID newbie, 1 vs 5, chunk sizes
Date: Thu, 19 Jun 2014 07:45:00 +0100
Message-ID: <BLU436-SMTP21129DA8D8E77FBD7B995C898130@phx.gbl>
References: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com>
	 <539E5504.1080809@turmel.org>
	 <CADqA9ub=-=V_RMF+G2ZniQG06oDJ6KDhdPhDuPeufHFpgs4Mdw@mail.gmail.com>
	 <2036850.atdiKx507N@eseries.newtech.fi>
	 <CADNH=7E+xTPoM4LL_DJrpWxJjsw0aV_w7fVEosu1uc=1dsh16A@mail.gmail.com>
	 <20140618233433.20b43198@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140618233433.20b43198@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Mathias =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, dag@newtech.fi, Nuno =?ISO-8859-1?Q?Magalh=E3es?= <nunomagalhaes@eu.ipp.pt>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2014-06-18 at 23:34 +0600, Roman Mamedov wrote:
> On Wed, 18 Jun 2014 12:58:59 +0100
> Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:
>=20
> > If we're comparing drives, my 8x WD20EARS / EARX have been spinning
> > for years. 2 drives just failed after ~3.4 years uptime (24/7) and
> > over 400,000 head parkings. They had weekly SMART self-test and
> > monthly RAID6 scrubs, and a few unexpected power losses. Good value=
=2E
>=20
> Why do you hate your drives so much, or haven't you heard of 'wdidle3=
'?
> Or maybe I misunderstand and this whole endeavor was actually an expe=
riment on
> how soon will they fail from all that ridiculous amount of head parki=
ngs.

I was going to say the same, but you beat me to it. The "huge" head
parking figure is down to a firmware bug. I would also note that "some"
WD REDS also have the same problem (seems to be limited batch(es) in my
personal experience, 2 out of 6, and idle3ctl for linux fixes the
problem).



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
