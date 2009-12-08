From: Neil Brown <neilb@suse.de>
Subject: Re: [patch 0/1][mdadm] Fix needed to enable RAID volumes on SAS
 devices (version 2).
Date: Tue, 8 Dec 2009 16:37:44 +1100
Message-ID: <20091208163744.7ea0eef9@notabene.brown>
References: <58C655507FA1494D95397652C4416F35CCF61201@irsmsx503.ger.corp.intel.com>
	<20091113193545.GW21495@skl-net.de>
	<1259593933.3178.122.camel@awojcik-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1259593933.3178.122.camel@awojcik-linux>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Wojcik <artur.wojcik@intel.com>
Cc: Andre Noll <maan@systemlinux.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Mon, 30 Nov 2009 16:12:13 +0100
Artur Wojcik <artur.wojcik@intel.com> wrote:

> Neil/Andre,
> I incorporated the suggestions Andre gave me and this resulted in the
> second version of patch. However I decided to not use pathconf()
> function but to define PATH_MAX instead. It is just the size of a buffer
> and I would like this to be resolved during compilation time rather then
> dynamically during execution time. Please review it and let me know if
> something needs to be changed.
> 
> As for the being paranoid... so I really am, if we talk about software
> security and vulnerability. I decided to introduce a new __str_fmt()
> function and str_fmt() helper macro. Both are documented in source code
> (let me know if you need separate patch for this).
> 

I'm afraid that I really don't like this.
Creating little functions that do almost-but-not-quite-exactly what some
standard library function does always bothers me.  It makes the code harder
to read.
If you just used it in 2 or 3 places where you actually needed it then it
might be OK, but you have used it everywhere, including several places where
it isn't needed at all as the buffer is known to be big enough.

And I don't like the introduction of a new header file just to store one or 2
definitions.  Just put new definitions in mdadm.h  Keep It Simple.

I am perfectly happy with making 'buf' larger as appropriate, even making it
PATH_MAX in some cases.
I would be happy with more use of asprinf.
I would be happy adding checks before certain critical sprintf calls that
the result will not exceed the buffer.

But I'm afraid that I don't like str_fmt at all.

Can we just fix the bits that are actually broken please?

NeilBrown

