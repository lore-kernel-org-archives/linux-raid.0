From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Triple parity and beyond
Date: Wed, 20 Nov 2013 22:59:39 +0100
Message-ID: <20131120215939.GA2622@lazy.lzy>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
 <20131119181237.GA3666@lazy.lzy>
 <528C9297.9030801@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <528C9297.9030801@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Andrea Mazzoleni <amadvance@gmail.com>, linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org, hpa@zytor.com, creamyfish@gmail.com
List-Id: linux-raid.ids

On Wed, Nov 20, 2013 at 11:44:39AM +0100, David Brown wrote:
[...]
> > In RAID-6 (as per raid6check) there is an easy way
> > to verify where an HDD has incorrect data.
> >=20
>=20
> I think the way to do that is just to generate the parity blocks from
> the data blocks, and compare them to the existing parity blocks.

Uhm, the generic RS decoder should try all
the possible combination of erasure and so
detect the error.
This is unfeasible already with 3 parities,
so there are faster algorithms, I believe:

Peterson=E2=80=93Gorenstein=E2=80=93Zierler algorithm
Berlekamp=E2=80=93Massey algorithm

Nevertheless, I do not know too much about
those, so I cannot state if they apply to
the Cauchy matrix as explained here.

bye,

--=20

piergiorgio
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
