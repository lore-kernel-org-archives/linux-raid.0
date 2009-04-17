From: "NeilBrown" <neilb@suse.de>
Subject: Re: Strange md(_resync?) related paging errors on 2.6.29
Date: Fri, 17 Apr 2009 19:53:55 +1000 (EST)
Message-ID: <50b8e80aaee3832b921cda536666d717.squirrel@neil.brown.name>
References: <20090417074301.GA21290@darkside.22.kls.lan>
    <777409cc1e62236fdb44290fd539a19b.squirrel@neil.brown.name>
    <20090417084656.GA13682@darkside.22.kls.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090417084656.GA13682@darkside.22.kls.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, April 17, 2009 6:46 pm, Mario 'BitKoenig' Holbe wrote:
> On Fri, Apr 17, 2009 at 06:18:20PM +1000, NeilBrown wrote:
>> This is a known problem that is fixed by
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=303a0e11d0ee136ad8f53f747f3c377daece763b
>> That patch should be in 2.6.29.1 when that gets released.
>
> Hmmm, I guess you mean 2.6.29.2, do you?

Yes, I guess I do.  2.6.29.1 came out 4 days before that patch,
and I didn't even notice...

NeilBrown


> All the 3 errors appeared on Debians linux-image-2.6.29-1-686-bigmem
> 2.6.29-2 which includes 2.6.29.1. And I can't find a commit for
> 303a0e11d0ee136ad8f53f747f3c377daece763b in ChangeLog-2.6.29.1.
>
> --
> Tower: "Say fuelstate." Pilot: "Fuelstate."
> Tower: "Say again." Pilot: "Again."
> Tower: "Arghl, give me your fuel!" Pilot: "Sorry, need it by myself..."
>

