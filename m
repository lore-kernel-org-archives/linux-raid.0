From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 20:57:39 +0100 (CET)
Message-ID: <Pine.LNX.4.44.0501042052430.3584-100000@uplift.swm.pp.se>
References: <200501041631.16339.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501041631.16339.maarten@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 4 Jan 2005, Maarten wrote:

> failures within the first 10 years, let alone 20, to even remotely support 
> that outrageous MTBF claim.

One should note that environment seriously affects MTBF, even on 
non-movable parts, and probably even more on movable parts.

I've talked to people in the reliability business, and they use models 
that say that MTBF for a part at 20 C as opposed to 40 C can differ by a 
factor of 3 or 4, or even more. A lot of people skimp on cooling and then 
get upset when their drives fail.

I'd venture to guess that a drive that has an MTBF of 1.2M at 25C will 
have less than 1/10th of that at 55-60C.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

