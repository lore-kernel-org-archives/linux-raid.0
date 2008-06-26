From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raid10,f2 degraded read speed
Date: Thu, 26 Jun 2008 15:37:08 +0200
Message-ID: <20080626133708.GA5462@rap.rap.dk>
References: <20080617143745.GA9148@rap.rap.dk> <20080625172516.GA21707@rap.rap.dk> <cccedfc60806251031q536dd88bg3cbeae703558318b@mail.gmail.com> <20080626081701.GE23500@rap.rap.dk> <cccedfc60806260535w7bf1a03by74ea476b1727f837@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cccedfc60806260535w7bf1a03by74ea476b1727f837@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 26, 2008 at 07:35:20AM -0500, Jon Nelson wrote:
> On Thu, Jun 26, 2008 at 3:17 AM, Keld J=F8rn Simonsen <keld@dkuug.dk>=
 wrote:
> > I think we should actually have more figures from systems in produc=
tion.
> ..
> > Nice to have more benchmarks. Maybe you can write up something for =
the
> > wiki?
> ..
>=20
> Funny you should mention that - I was speaking with a colleague
> recently and I told him that I'm going to try for a fairly
> comprehensive test of raid5, raid10[n2,o2,f2] in both regular and
> degraded mode, utilizing fstest to test ext3, jfs, xfs, and maybe
> spadfs. I've got most of it scripted too so some refinements to those
> scripts might be useful to somebody else. I plan on putting this on m=
y
> blog when I get the time.
>=20
> However, I'm rather pressed for time right now so it will likely be a=
 while.

Such is life. So then, when this is out, could I then use your findings
for the wiki?

I think the wiki is a good place to put up such tests, as more people
would have a chance finding the results there.

best regards
Keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
