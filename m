From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PULL-REQUEST] md: remove a potential deadlock.
Date: Mon, 9 Mar 2009 08:10:00 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0903090808480.19207@localhost.localdomain>
References: <18868.20721.541359.900702@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18868.20721.541359.900702@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: stable@kernel.org, linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids



On Mon, 9 Mar 2009, Neil Brown wrote:
> 
> are available in the git repository at:
> 
>   git://neil.brown.name/md for-linus

Hmm:

	neil.brown.name[0: 220.233.11.133]: errno=Connection timed out
	fatal: unable to connect a socket (Connection timed out)

I can ping it, but can't reach it with git. Firewall? Crashed machine?

			Linus
