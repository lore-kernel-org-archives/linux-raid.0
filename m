From: Derek Vadala <derek@cynicism.com>
Subject: Re: raid 5 question
Date: Tue, 30 Apr 2002 14:08:25 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.21.0204301346440.27156-100000@gecko.roadtoad.net>
References: <20020430221936.E15847@unthought.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020430221936.E15847@unthought.net>
To: =?iso-8859-1?Q?Jakob_=D8stergaard?= <jakob@unthought.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 30 Apr 2002, [iso-8859-1] Jakob =D8stergaard wrote:

> >I noticed that the raidreconf bundled with the raidtools-1.0 in
> > skipjack is 0.1.2 and the one at unthought.net is 0.1.1-- but maybe=
 that's
> > because someone else worked on it and didn't put their name in.
>=20
> That is interesting - too bad RedHat didn't care to ask me about the =
known
> problems with the tool... Some of the known problems are easily fixab=
le.

There are indeed differences, but they all appear to be trivial. Looks
like some stuff was moved from rrc_common.c and into raidreconf.c,
specifcally the progress indicator, command line error-checking and use=
r
confirmation. Everything else appears to be simple compatibility change=
s
for parts of the raidtools that raidreconf relies on. For example,
md-int.h is now md_p.h and md_u.h.

I'm about half way through the tests I want to run, so I should have so=
me
data on how longs are expected to take tomorrow. So far it hasn't been =
as
slow as I expected.

---
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
