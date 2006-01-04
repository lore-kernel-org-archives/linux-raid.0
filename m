From: Andargor The Wise <andargor@yahoo.com>
Subject: Re: SATA performace
Date: Tue, 3 Jan 2006 20:04:10 -0800 (PST)
Message-ID: <20060104040410.71687.qmail@web54607.mail.yahoo.com>
References: <1136314242.10745.4.camel@seki.nac.uci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1136314242.10745.4.camel@seki.nac.uci.edu>
Sender: linux-raid-owner@vger.kernel.org
Cc: Paul Aviles <paul.aviles@palei.com>, linux-raid@vger.kernel.org, strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids

Hmm. I just installed EVMS 2.5.4 two weeks ago. Unless
I did something wrong?

Andargor


--- Dan Stromberg <strombrg@dcs.nac.uci.edu> wrote:

>=20
> Supposedly current versions of EVMS and LVM sit
> overtop of the same
> "device mapper" kernel component...  Given this, I
> have to wonder if the
> situation hasn't changed since last evaluated.
>=20
> On Tue, 2006-01-03 at 00:36 -0800, Andargor The Wise
> wrote:
> > --- Paul Aviles <paul.aviles@palei.com> wrote:
> >=20
> > > Are SATA drives similar in performance than IDE
> > > drives? I have tested=20
> > > Barracudas 7200.0 (500Gb) and WD too on the same
> > > type of servers (more than=20
> > > 1 unit) and what I am getting is painfully slow
> in
> > > terms of read/writes.=20
> > > Anyone out there with similar experience or this
> is
> > > just my isolated=20
> > > results?
> > >=20
> > > Thanks
> > >=20
> > > Paul Aviles=20
> > >=20
> >=20
> > Don't know about IDE, but I did some SATA tests on
> > RAID-5, if it can give you an indication:
> >=20
> > http://www.andargor.com/raid5.html
> >=20
> > BTW, EVMS will cut your performance about 50% (the
> > tests were run with straight MD, no EVMS). I don't
> > know about LVM, but that might add some overhead
> as
> > well...
> >=20
> > Andargor
> >=20
> >=20
> >=20
> > =09
> > 	=09
> > __________________________________=20
> > Yahoo! for Good - Make a difference this year.=20
> > http://brand.yahoo.com/cybergivingweek2005/
> > -
> > To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at=20
> http://vger.kernel.org/majordomo-info.html
> >=20
>=20
>=20



	=09
__________________________________________=20
Yahoo! DSL =96 Something to write home about.=20
Just $16.99/mo. or less.=20
dsl.yahoo.com=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
