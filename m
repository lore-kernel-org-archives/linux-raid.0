From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Migrating a RAID 5 from 4x2TB to 3x6TB ?
Date: Mon, 15 Jun 2015 22:45:54 +0100
Message-ID: <557F4792.4040805@youngman.org.uk>
References: <167089395.613.1433791723592.JavaMail.zimbra@wieser.fr>	 <1056149272.1412.1433965061737.JavaMail.zimbra@wieser.fr> <BLU436-SMTP134979C5D563F30AFDBD89898B80@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU436-SMTP134979C5D563F30AFDBD89898B80@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: "Wilson, Jonathan" <piercing_male@hotmail.com>, Pierre Wieser <pierre.wieser@gadz.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/06/15 11:46, Wilson, Jonathan wrote:
> On the 4 disks, create 17G partitions then create a 4 disk raid10 far2
> array with 64K chunk. This will give you a swap file of 34G in size
> (well over provisioned, but doesn't hurt or impact performance). As its
> likely swap access will be in small random amounts this means the disk
> write size is not overly large, no point in writing/reading 512K chunks
> (the current default) for a 4K page swap/memory access; raid10 is fast;
> far2 from what I've read also improves the speed of read/writes in some
> tests (I don't know why or if the tests I've seen mentioned on the web
> are accurate for the type of access swap will cause but on my setup I
> can get a dd speed of 582M read and 215M write from drives with a single
> device speed of about 80-100M as a rough and ready speed test).

Bear in mind that linux will all by itself do a raid-0 on your swap
partitions if you ask it to.

I *always* size my swap partitions at twice mobo max ram. If you read
the release notes for linux 2.4.early, you'll notice Linus says "if you
have swap, it MUST be twice ram or more" - that was a kernel panic if
you ignored it ! Given that people have been saying that rule was
obsolete since before linux was born, and that while a lot of water has
passed under the bridge since then I've seen and heard nothing to tell
me that the fundamentals have changed ... so because my mobo maxes out
at 16MB ram, all my disks have a 32GB swap partition each.

If you want to raid10 that lot, fine, I just set equal priority on all
my swap partitions, and linux will raid-0 it for me.

The other thing to bear in mind, it's all very well doing speed tests on
your drive, but if you're hammering swap and backing store at the same
time, your speeds are going to plummet as your drive starts seeking all
over the shop ... mind you, with a decent amount of ram you probably
won't need swap at all.

Cheers,
Wol

Cheers,
Wol
