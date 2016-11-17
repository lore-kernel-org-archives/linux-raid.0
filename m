From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/2] raid5-cache: update superblock at shutdown/reboot
Date: Thu, 17 Nov 2016 10:23:59 -0800
Message-ID: <20161117182359.tyyqmrbngtqufcvf@kernel.org>
References: <5d6f023fb1d1398317d07f02634f90b055e26f4b.1479345454.git.shli@fb.com>
 <87wpg2heg8.fsf@notabene.neil.brown.name>
 <582D7C07.8060507@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <582D7C07.8060507@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: NeilBrown <neilb@suse.com>, Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, songliubraving@fb.com, Zhengyuan Liu <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids

On Thu, Nov 17, 2016 at 09:44:39AM +0000, Wols Lists wrote:
> On 17/11/16 05:18, NeilBrown wrote:
> > On Thu, Nov 17 2016, Shaohua Li wrote:
> > 
> >> Currently raid5-cache update superblock in .quiesce. But since at
> >> shutdown/reboot, .quiesce is called with reconfig mutex locked,
> >> superblock isn't guaranteed to be called in reclaim thread (see
> >> 8e018c21da3). This will make assemble do unnecessary journal recovery.
> >> It doesn't corrupt data but is annoying.  This adds an extra hook to
> >> guarantee journal is flushed to raid disks.  And since this hook is
> >> called before superblock update, this will guarantee we have a uptodate
> >> superblock in shutdown/reboot
> > 
> > Hi.
> > I don't quite follow some of the reasoning here.
> > In particular, the ->stop_writes() that you have implemented
> > does almost exactly the same thing as r5l_quiesce(1).
> > So why not simply call ->quiesce(mddev, 1) in __md_stop_writes()??
> > You probably need to also call ->quiesce(mddev, 0) to keep things
> > balanced.
> > 
> > Also you have introduced a static mutex (which isn't my favourite sort
> > of thing) without giving any explanation why in the changelog comment.
> > So I cannot easily see if that addition is at all justified.
> > 
> > Thanks,
> > NeilBrown
> > 
> I need to be careful I don't ruffle any feathers here ...
> 
> But this is saying to me this is a nice feature that hasn't been
> properly spec'd and thought through. Don't get me wrong, I know that -
> in typical linux fashion - people have been adding things, and raid has
> "just growed" topsy fashion. So it's incredibly difficult to spec a new
> feature when you don't have a spec for the stuff you're building it on.
> 
> Anyways, what I'm saying is, it seems to me this caching stuff (it's a
> new feature, iirc) would be great for trying to write out a proper spec
> of what's meant to be going on. It'll roll over into spec'ing the stuff
> it relies on ...
> 
> And yes, I *AM* volunteering to do the work - as I said elsewhere, I
> want to put a load of kerneldoc into the raid source, and get to
> understand it all, but the downside is you'll get a lot of newbie-ish
> questions from me trying to get to grips with what's going on. I'm an
> experienced C programmer but kernel style is alien to me - you know the
> disconnect when you're reading something, you can read the words easily,
> but you can't decipher the meaning. That's how I feel reading the kernel
> source at the moment.
> 
> Are we up for it?

Yep, that makes sense. the journal (current write-through mode and upcoming
write-back mode) does deserve a description. I'll add something into
Documentation dir in kernel source.

Thanks,
Shaohua
