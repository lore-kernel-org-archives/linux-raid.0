From: Neil Brown <neilb@suse.de>
Subject: Re: Help on first dangerous scrub / suggestions
Date: Sat, 28 Nov 2009 08:21:33 +1100
Message-ID: <20091128082133.62dcb122@notabene.brown>
References: <4B0E7111.20202@shiftmail.org>
	<alpine.DEB.2.00.0911260720220.23317@p34.internal.lan>
	<4B0E8B75.2030006@shiftmail.org>
	<alpine.DEB.2.00.0911260915520.17452@p34.internal.lan>
	<4B0ED0DF.10502@shiftmail.org>
	<alpine.DEB.2.00.0911261554170.14297@p34.internal.lan>
	<4B0FD689.9030904@shiftmail.org>
	<4B101653.8040904@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B101653.8040904@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 27 Nov 2009 19:11:31 +0100
Asdo <asdo@shiftmail.org> wrote:

> Asdo wrote:
> > ....
> > Without knowing this I will probably opt for your way: rsync data out, 
> > starting from the smallest and most important stuff...
> > ...
> 
> I had another thought:
> 
> If I take the computer offline, boot with a livecd (one of the worst 
> messes here is that the root filesystem is also in that array), run the 
> raid6 array in READONLY MODE and maybe without spares, then I start a 
> check (scrub) ...

If the array is marked read-only, it wont do a scrub.

However if you simply don't have any filesystem mounted, then the array
will remain 'clean' and any failures are less likely cause further
failures.

So doing it off line is a good idea, but setting the array to read-only
won't work.

NeilBrown
