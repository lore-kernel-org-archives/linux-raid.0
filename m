From: "David Rees" <drees76@gmail.com>
Subject: Re: RAID 5 performance issue.
Date: Wed, 3 Oct 2007 13:36:39 -0700
Message-ID: <72dbd3150710031336s331782c3yd0ac7ceda4e81774@mail.gmail.com>
References: <20071003105321.06943824@zeus.pccl.info>
	 <Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
	 <20071003211910.439ded54@alpha.digital-domain.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071003211910.439ded54@alpha.digital-domain.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Clayton <andrew@digital-domain.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Andrew Clayton <andrew@pccl.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/3/07, Andrew Clayton <andrew@digital-domain.net> wrote:
> On Wed, 3 Oct 2007 12:43:24 -0400 (EDT), Justin Piszcz wrote:
> > Have you checked fragmentation?
>
> You know, that never even occurred to me. I've gotten into the mind set
> that it's generally not a problem under Linux.

It's probably not the root cause, but certainly doesn't help things.
At least with XFS you have an easy way to defrag the filesystem
without even taking it offline.

> # xfs_db -c frag -f /dev/md0
> actual 1828276, ideal 1708782, fragmentation factor 6.54%
>
> Good or bad?

Not bad, but not that good, either. Try running xfs_fsr into a nightly
cronjob. By default, it will defrag mounted xfs filesystems for up to
2 hours. Typically this is enough to keep fragmentation well below 1%.

-Dave
