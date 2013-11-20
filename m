From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Triple parity and beyond
Date: Wed, 20 Nov 2013 11:10:11 -0800
Message-ID: <528D0913.1070604@zytor.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com>	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>	<528BCA2D.5010500@redhat.com>	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu> <CAGKKSfUGLzeLfab0uJTGV=UELxEH+mB3K4VbDouHxzmc+xuZ2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGKKSfUGLzeLfab0uJTGV=UELxEH+mB3K4VbDouHxzmc+xuZ2A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrea Mazzoleni <amadvance@gmail.com>, James Plank <plank@cs.utk.edu>
Cc: Ric Wheeler <rwheeler@redhat.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Brown <david.brown@hesbynett.no>, David Smith <creamyfish@gmail.com>
List-Id: linux-raid.ids

On 11/20/2013 11:05 AM, Andrea Mazzoleni wrote:
> 
> For the first row with j=0, I use xi = 2^-i and y0 = 0, that results in:
> 

How can xi = 2^-i if x is supposed to be constant?

That doesn't mean that your approach isn't valid, of course, but it
might not be a Cauchy matrix and thus needs additional analysis.

> row j=0 -> 1/(xi+y0) = 1/(2^-i + 0) = 2^i (RAID-6 coefficients)
> 
> For the next rows with j>0, I use yj = 2^j, resulting in:
> 
> rows j>0 -> 1/(xi+yj) = 1/(2^-i + 2^j)

Even more so here... 2^-i and 2^j don't seem to be of the form xi and yj
respectively.

	-hpa

