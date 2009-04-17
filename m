From: "NeilBrown" <neilb@suse.de>
Subject: Re: Strange md(_resync?) related paging errors on 2.6.29
Date: Fri, 17 Apr 2009 18:18:20 +1000 (EST)
Message-ID: <777409cc1e62236fdb44290fd539a19b.squirrel@neil.brown.name>
References: <20090417074301.GA21290@darkside.22.kls.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090417074301.GA21290@darkside.22.kls.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, April 17, 2009 5:43 pm, Mario 'BitKoenig' Holbe wrote:
> Hello,
>
> starting with 2.6.29 (I'm using the Debian 2.6.29-1-686-bigmem kernel
> image) I get strange paging-related errors that seem to be somehow
> connected to md, maybe especially to md_resync. I got no other errors
> where md was not involved, that's why I'm mailing to linux-raid@ only
> at first.
> All the actions described below succeeded when falling back to 2.6.28,
> so it's most likely not hardware-related on the one hand and probably
> caused by some change from .28 to .29 - even though I have no idea
> which one that could be.

Thanks for the report.
This is a known problem that is fixed by

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=303a0e11d0ee136ad8f53f747f3c377daece763b

That patch should be in 2.6.29.1 when that gets released.

NeilBrown


