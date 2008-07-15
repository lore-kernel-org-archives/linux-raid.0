From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Tue, 15 Jul 2008 12:06:04 -0500
Message-ID: <cccedfc60807151006mbcf58e2udd725f3b7bd38637@mail.gmail.com>
References: <1216130769.5633.318.camel@sam.localdomain>
	 <20080715163932.GA23164@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080715163932.GA23164@rap.rap.dk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Ben Martin <monkeyiq@users.sourceforge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I would add to that request that you consider using a smaller chunk siz=
e.
My own benchmarks showed that for some raid levels and layouts, a
smaller chunk size gave the best overall performance.


On Tue, Jul 15, 2008 at 11:39 AM, Keld J=F8rn Simonsen <keld@dkuug.dk> =
wrote:
=2E..
> It would be interesting if you could enhance your article with benchm=
arks
> on raid10, f2 and o2 layouts. I think they would outperform HW raid, =
at
> least on input. And I would like to see how they perform on outout an=
d
> rewrite, with ext3 and xfs. We do have some tests, but many of them a=
re
> without a file system layer.



--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
