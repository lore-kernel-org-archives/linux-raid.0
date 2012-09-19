From: Daniel Frey <djqfrey@gmail.com>
Subject: Re: Stop IMSM verify?
Date: Tue, 18 Sep 2012 18:21:55 -0700
Message-ID: <50591E33.8040309@gmail.com>
References: <CA+ZgY1E2T6C+Db1eb8_GFnXm7nzo4ecgGbMiPPf18C9-p5X5WQ@mail.gmail.com> <20120913112246.77b3041e@notabene.brown> <CA+ZgY1FMZm-g3-ODPLaRnN14+da+8QBcWhSX-p08kx70pGz97g@mail.gmail.com> <20120918164641.224b9c19@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120918164641.224b9c19@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/17/2012 11:46 PM, NeilBrown wrote:
> 
> I guess it would be nice if we could somehow arrange that the array were
> marked 'clean' just before suspend.... it looks like that should be possible.
> 'suspend notifiers' are called after the 'sync' and before user-space is
> frozen.  I could maybe get md to register a 'suspend notifier' which poked
> mdmon somehow so that it would mark the array as clean.  It might not even be
> that hard.
> If I were to create a patch against mainline (or maybe some earlier kernel if
> you really wanted), would you be able/willing to test it out?
> 
> NeilBrown
> 

I did discover my power supply was toast, the +5V line dropped well out
of tolerance. I've resolved that issue now.

Normally sleeping and waking doesn't cause the array to rebuild.

Gentoo's shutdown scripts weren't shutting the array down properly
initially, but I did fix that issue as well. All is finally good on my
computer.

The kernel I'm currently running is 3.4.9, but I can build the stable
3.5.4 to test if needed. I can test the patch (all I have to do to
replicate it is suspend + yank the power cord.) If you do write the
patch let me know what version to patch against.

Thanks Neil,

Dan
