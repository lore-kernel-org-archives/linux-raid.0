From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raid10 far layout outperforms offset at writing? (was: Help with chunksize on raid10 -p o3 array)
Date: Wed, 17 Dec 2008 15:34:43 +0100
Message-ID: <20081217143443.GA6467@rap.rap.dk>
References: <20081217124154.GA5406@rap.rap.dk> <4948F590.2050007@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4948F590.2050007@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 17, 2008 at 01:50:24PM +0100, Peter Rabbitson wrote:
> Keld J=F8rn Simonsen wrote:
> > I found this old message:
> >=20
> >> Peter Rabbitson
> >> Mon, 19 Mar 2007 06:14:38 -0800
> >>
> >=20
> > The links were not valid anymore. I wanted to see the results and=20
> > possibly include the results in the performance wiki page
> > I would appreciate some new links here.
>=20
> I apologize, I don't have the data available anymore.
'
OK.

> > Furthermore some comments to the post: My take on o3 vs f3 is that =
both
> > in theory and practice f3 should be much faster for sequential read=
ing,
> > as the layout is equivalent to raid0. For random reading and sequen=
tial
> > and random writing f3 and o3 (and the same goes for the more normal=
 f2
> > vs o2) should be about the same, especially when a filesystem and
> > its associated elevator algorithm is employed.
>=20
> Yes, this is what I also concluded since I wrote this email. I am in =
the
> process of upgrading my raid setup, and while I am at it I am leaving
> 5GB blank partitions at the start of all my workstations spindles, so=
 I
> can get some real testing at night. I will share my methodology with =
the
> list before I commence testing (which should take about 20 days the w=
ay
> I am planing it).

I have tried to persuade Neil to change the description for MD to
reflect the above, but until now with no luck.

I look forward to see your new tests!

> But first comes the vacation - happy holidays to you too guys.

Yes, happy holidays to all!

Best regards
Keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
