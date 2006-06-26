From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH*2] mdadm works with uClibc from SVN
Date: Mon, 26 Jun 2006 14:32:04 +1000
Message-ID: <17567.25412.387397.430549@cse.unsw.edu.au>
References: <87wtbbjxd4.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nix on Tuesday June 20
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 20, nix@esperi.org.uk wrote:
> For some time, mdadm's been dumping core on me in my uClibc-built
> initramfs. As you might imagine this is somewhat frustrating, not least
> since my root filesystem's in LVM on RAID. Half an hour ago I got around
> to debugging this.
> 
> Imagine my surprise when I found that it was effectively guaranteed to
> crash: map_dev() in util.c is stubbed out for uClibc builds, and
> returns -1 at all times. That means that code in, among other places,
> config.c:load_partitions() is guaranteed to segfault, which is a bit
> tough if you're using the (sane) default `DEVICE partitions' in your
> mdadm.conf.

I'm confused.  map_dev doesn't return -1, it returns NULL.
And the code in load_partitions() handles a NULL return.
So I cannot see why it would be core dumping.
If you have more details, I'd be really interested.

That said: utils doesn't handle the case for 'ftw not available' as
well as it could.  I will fix that.

NeilBrown
