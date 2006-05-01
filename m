From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH 004 of 11] md: Increase the delay before marking metadata
 clean, and make it configurable.
Date: Mon, 1 May 2006 08:17:35 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0605010814410.2557@g5.osdl.org>
References: <20060501152229.18367.patches@notabene> <1060501053019.22949@suse.de>
 <20060430224404.1060d29a.akpm@osdl.org> <17493.42109.153523.381980@cse.unsw.edu.au>
 <20060430231303.6b2bce82.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060430231303.6b2bce82.akpm@osdl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 30 Apr 2006, Andrew Morton wrote:
> 
> Generally I don't think we should be teaching the kernel to accept
> pretend-floating-point numbers like this, especially when a) "delay in
> milliseconds" is such a simple concept and b) it's so easy to go from float
> to milliseconds in userspace.
> 
> Do you really expect that humans (really dumb ones ;)) will be echoing
> numbers into this file?  Or will it mainly be a thing for mdadm to fiddle
> with?

I generally hate interfaces that have some "random base".

So "delay in seconds" is not a random base, because "seconds" is a good SI 
base unit, and there's not a lot of question about it. But once you start 
talking milliseconds on microseconds, I'd actually much rather have a 
"fake floating point number" over having different files have different 
(magic) base constants. How do you remember which are milliseconds, which 
are microseconds, and which are just seconds?

It should be easy to have a helper function or two that takes a "struct 
timeval" and reads/writes a "float".

		Linus
