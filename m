From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [PATCH 1/2] raid5-cache: update superblock at shutdown/reboot
Date: Thu, 17 Nov 2016 19:11:11 +0000
Message-ID: <582E00CF.4080903@youngman.org.uk>
References: <5d6f023fb1d1398317d07f02634f90b055e26f4b.1479345454.git.shli@fb.com>
 <87wpg2heg8.fsf@notabene.neil.brown.name> <582D7C07.8060507@youngman.org.uk>
 <20161117182359.tyyqmrbngtqufcvf@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161117182359.tyyqmrbngtqufcvf@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.com>, Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, songliubraving@fb.com, Zhengyuan Liu <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids

On 17/11/16 18:23, Shaohua Li wrote:
>> And yes, I *AM* volunteering to do the work - as I said elsewhere, I
>> > want to put a load of kerneldoc into the raid source, and get to
>> > understand it all, but the downside is you'll get a lot of newbie-ish
>> > questions from me trying to get to grips with what's going on. I'm an
>> > experienced C programmer but kernel style is alien to me - you know the
>> > disconnect when you're reading something, you can read the words easily,
>> > but you can't decipher the meaning. That's how I feel reading the kernel
>> > source at the moment.
>> > 
>> > Are we up for it?

> Yep, that makes sense. the journal (current write-through mode and upcoming
> write-back mode) does deserve a description. I'll add something into
> Documentation dir in kernel source.

From what I can make out ... :-)

The new kernel documentation system actually builds a load of stuff into
the Documentation/output directory from the kernel source. In other
words, it'll be far better edited into the source files. And/or put a
.rst file in the md directory.

I need to dig into this, and work out how it all fits together (I'm
having trouble running it on my main system at the moment, gentoo takes
forever to upgrade and the bits I need won't install ...)

https://www.kernel.org/doc/

When you've written it up, post it to the list, and we'll see about
getting it into the new documentation system rather than just dropping
it into the Documentation directory (I think the new system will put it
in Documentation/output/drivers/md, which is lot more sensible than just
jumbled in Documentation along with everything else.

Cheers,
Wol
