From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: 4.1-rc6 radi5 OOPS
Date: Wed, 10 Jun 2015 12:27:35 -0400
Message-ID: <wrfjk2vbv894.fsf@carbonite.lan.trained-monkey.org>
References: <wrfjlhg0mtmi.fsf@jes.lga.redhat.com>
	<20150604064048.0cb2d7c9@notabene.brown>
	<wrfjzj4glajs.fsf@jes.lga.redhat.com>
	<20150610101942.0bc26a25@home.neil.brown.name>
	<20150610115721.64c474fa@home.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150610115721.64c474fa@home.neil.brown.name> (Neil Brown's
	message of "Wed, 10 Jun 2015 11:57:21 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:
> On Wed, 10 Jun 2015 10:19:42 +1000 Neil Brown <neilb@suse.de> wrote:
>
>> So it looks like some sort of race.  I have other evidence of a race
>> with the resync/reshape thread starting/stopping.  If I track that
>> down it'll probably fix this issue too.
>
> I think I have found just such a race.  If you request a reshape just
> as a recovery completes, you can end up with two reshapes running.
> This causes confusion :-)
>
> Can you try this patch?  If I can remember how to reproduce my race
> I'll test it on that too.
>
> Thanks,
> NeilBrown

Hi Neil,

Thanks for the patch - I tried with this applied, but it still crashed
for me :( I had to mangle it manually, somehow it got modified in the
email.

Note this was a mangled RHEL kernel, but it's the same crash I see on
the upstream kernel.

[  754.303561] md: using 128k window, over a total of 19456k.
[  754.309706] mddev->dev_sectors: 0x9800, reshape_sectors: 0x0200 stripe_addr: fffffffffffffdff, sector_nr 0, readpos 511, writepos -513, safepos 512
[  754.324486] ------------[ cut here ]------------
[  754.329649] kernel BUG at drivers/md/raid5.c:5388!

Cheers,
Jes
