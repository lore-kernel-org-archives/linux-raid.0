From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: raid10,f2 degraded read speed
Date: Thu, 26 Jun 2008 07:35:20 -0500
Message-ID: <cccedfc60806260535w7bf1a03by74ea476b1727f837@mail.gmail.com>
References: <20080617143745.GA9148@rap.rap.dk>
	 <20080625172516.GA21707@rap.rap.dk>
	 <cccedfc60806251031q536dd88bg3cbeae703558318b@mail.gmail.com>
	 <20080626081701.GE23500@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080626081701.GE23500@rap.rap.dk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 26, 2008 at 3:17 AM, Keld J=F8rn Simonsen <keld@dkuug.dk> w=
rote:
> I think we should actually have more figures from systems in producti=
on.
=2E.
> Nice to have more benchmarks. Maybe you can write up something for th=
e
> wiki?
=2E.

=46unny you should mention that - I was speaking with a colleague
recently and I told him that I'm going to try for a fairly
comprehensive test of raid5, raid10[n2,o2,f2] in both regular and
degraded mode, utilizing fstest to test ext3, jfs, xfs, and maybe
spadfs. I've got most of it scripted too so some refinements to those
scripts might be useful to somebody else. I plan on putting this on my
blog when I get the time.

However, I'm rather pressed for time right now so it will likely be a w=
hile.

> And to stand the teeth of time, I would like to have performance
> expressed in terms of relative performance of raw read speed for one
> disk, this figure is most likely very stable even over a 10 years'
> timespan.

I agree.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
