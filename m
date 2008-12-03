From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raid1 with possible lock inversion
Date: Wed, 3 Dec 2008 22:44:42 +0100
Message-ID: <20081203214442.GA15798@rap.rap.dk>
References: <web-78543249@dragon.rutgers.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <web-78543249@dragon.rutgers.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Ana Paula <anapaula@cs.rutgers.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 03, 2008 at 03:33:03PM -0500, Ana Paula wrote:
> Hello,
> I've got a fresh copy of the kernel 2.6.27.7 compiled with LOCKDEP (I
> am including the .config at the end of this message) on a SMP machine.
> 
> After the raid1module is loaded the arrays are assembled and mounted I
> get messages of a possible lock inversion.
> The machine freezes but as soon as the messages stop I get the machine
> back. 
> I can stop the arrays and unload the module.
> 
> Is this a known issue?

I don't know.

But you could also use raid10, which is another driver, and thus it may
not have the problem.

raid10,n2 is equivalent in almost all aspects to raid1

raid10,f2 can be used as a replacement for raid1 (and raid10,n2) and has
about double the speed for sequential read, while the other common
operations are about the same.

best regards
keld
