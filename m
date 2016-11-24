From: Andy Smith <andy@strugglers.net>
Subject: Re: Bug#784070: Newly-created arrays don't auto-assemble - related
 to hostname change?
Date: Thu, 24 Nov 2016 01:24:51 +0000
Message-ID: <20161124012451.GR21587@bitfolk.com>
References: <87poltfq2d.fsf@notabene.neil.brown.name>
 <20161118034716.GI21587@bitfolk.com>
 <87k2c1fn0o.fsf@notabene.neil.brown.name>
 <20161118041759.GE1804@bitfolk.com>
 <877f7xe9lh.fsf@notabene.neil.brown.name>
 <20161121060256.GL1804@bitfolk.com>
 <87shqkcuhv.fsf@notabene.neil.brown.name>
 <20161122060105.GS1804@bitfolk.com>
 <87wpfuc4ab.fsf@notabene.neil.brown.name>
 <c7f7e076-0fed-eb51-3291-f93cf66a49a3@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c7f7e076-0fed-eb51-3291-f93cf66a49a3@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: NeilBrown <neilb@suse.com>, 784070@bugs.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On Wed, Nov 23, 2016 at 12:03:49PM +0300, Michael Tokarev wrote:
> It was long ago when we disabled incremental assembly when
> you turned it on by default, and kept old static way to
> assemble arrays, because neither our initrd nor regular
> userpsace weren't ready for that.

Okay, so, on Debian jessie then, it is expected that md arrays on
devices that are only present after the initramfs is done working
will not be automatically (incrementally) started?

I saw Yann mentioned that in stretch the GOTO="md_inc_end" has been
removed again. Does that mean that incremental assembly on device
change is expected to work again in stretch (I have not tested it,
and most likely will not have time to do so with this hardware).

Thanks,
Andy
