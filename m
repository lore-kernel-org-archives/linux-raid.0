From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: Questions about VERY large software raid config
Date: Fri, 21 Feb 2003 10:50:24 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0302211048570.18440-100000@router.windsormachine.com>
References: <8075D5C3061B9441944E137377645118012E65@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8075D5C3061B9441944E137377645118012E65@cinshrexc03.shermfin.com>
To: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 21 Feb 2003, Rechenberg, Andrew wrote:

> Basically I'm going to do a bunch of RAID1 mirrors (56 drives), RAID)
> those in sets of 14 and then stripe those 4 into one big array.  We want
> to get the most spindles possible servicing disk requests and I wanted
> to know if anyone has tried such a setup.

How big are your drives?  There's apparently a 2 TiB limit on raid sizes,
there's even someone who has been asking if 12 x 160 or 13 x 160 is
ok(sorry, I don't have an answer for said person)

Mike

