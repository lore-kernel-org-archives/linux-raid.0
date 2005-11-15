From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 002 of 2] Make md threads interruptible again.
Date: Mon, 14 Nov 2005 18:08:05 -0800
Message-ID: <20051114180805.01dbf4b9.akpm@osdl.org>
References: <20051115125442.9317.patches@notabene>
	<1051115015641.9393@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1051115015641.9393@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
>
> 
> Despite the fact that md threads don't need to be signalled, and won't
> respond to signals anyway, we need to have an 'interruptible' wait,
> else they stay in 'D' state and add to the load average.
> 
> ...
> +		if (signal_pending(current))
> +			flush_signals(current);

Kernel threads don't accept signals by default, so the above is unneeded.

I'll leave it in there now, since that's how things used to be, but please
make a note to nuke that check, then test it to make sure I'm telling the
truth, then fix it up later on?
