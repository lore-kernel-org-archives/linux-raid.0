From: Chris Webb <chris@arachsys.com>
Subject: Re: Assume-clean for md grow
Date: Thu, 26 Feb 2009 14:54:42 +0000
Message-ID: <20090226145442.GH17577@arachsys.com>
References: <20090225142229.GI32722@arachsys.com> <c5fe66de938d528320cf21d8ca3c7a83.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c5fe66de938d528320cf21d8ca3c7a83.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> Or if you want to be slightly more subtle, remove the
> 	if (mddev->pers)
> 		return -EBUSY;
> from resync_start_store.  Then before a grow that you want to be
> --assume-clean, write into /sys/block/mdXX/md/resync_start the
> number of sectors in the final raid1 array.

Hi Neil. Thanks for this suggestion: it looks fine for what we're looking to
achieve. Interestingly, this will mean writing a smaller value that shown by
a read from this file for an in-sync array, but will still work?

I'll build a patched kernel and give it a go a little later on.

Best wishes,

Chris.
