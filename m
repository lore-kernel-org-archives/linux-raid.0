From: keld@keldix.com
Subject: Re: PATCH: RAID10-layout-descriptions
Date: Thu, 3 Jul 2014 11:40:38 +0200
Message-ID: <20140703094038.GA25459@www5.open-std.org>
References: <1402852943.4708.8.camel@heisenberg.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1402852943.4708.8.camel@heisenberg.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

The updated text is actually techninaclly misleading or plainly wrong, for the description
of the far and offset layouts. Offset cannot compete with far, as also witnessed by many benchmarks,
as described on the wiki. https://raid.wiki.kernel.org/index.php/Performance

The old text is much more precise than the new. So I advise
that we do not apply the patch, or do another one with the small improvements there
is still in the new patches.

Best regards
Keld

On Sun, Jun 15, 2014 at 07:22:23PM +0200, Christoph Anton Mitterer wrote:
> Hi Neil.
> 
> As mentioned on GitHub before I'm trying to clean up some old patches or
> get them merged.
> 
> 
> I lost a bit track on what we've discussed about them before,...
> 
> One thing I remember is that you didn't like unicode and tbl(1) being
> used.
> 
> Well of course we can talk about that again,... but I think this is
> 2014, so literally everyone has unicode and I think the explanations
> benefit from it (actually I see more and more manpages using unicode).
> 
> With respect to tbl(1) and the box drawings... I think you were
> complaining that this doesn't work with groff when rendering e.g. to
> PDF.... well I guess you're right, but the question is probably: is
> anyone in the world doing this?
> I mean for manpages it seems to work quite well and IMHO improves
> readability and understandability of the explanations quite a lot... and
> we can't just cover any side way on how the nroff files might be used,
> and for which rendering doesn't work.
> 
> 
> After all,... I think the patches below contain lots of valuable
> information which is currently missing in the manpages... so having that
> information merged somehow is surely better than not.
> Actually the same is IMHO fully missing for the different RAID 5/6
> layouts.
> 
> I'd be happy if someone could look into spelling issues and that like.
> 
> Cheers,
> Chris.








