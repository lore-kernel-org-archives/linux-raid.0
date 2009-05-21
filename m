From: Neil Brown <neilb@suse.de>
Subject: Re: "raid array not clean" messages
Date: Thu, 21 May 2009 16:20:02 +1000
Message-ID: <18964.62098.885221.299555@notabene.brown>
References: <5817fbed0905202136i1e7e73dfk58dfe375baa06360@mail.gmail.com>
	<37d33d830905202149u7759fc36id79cc69757892f95@mail.gmail.com>
	<4A43563A-43D5-437D-A916-0DCCB1A61239@gmail.com>
	<5817fbed0905202211t6f2b73d3o187906f77383fe5b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from fibre raid on Thursday May 21
Sender: linux-raid-owner@vger.kernel.org
To: fibre raid <fibreraid@gmail.com>
Cc: Christopher Chen <muffaleta@gmail.com>, SandeepKsinha <sandeepksinha@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday May 21, fibreraid@gmail.com wrote:
> I have no problem with this message being written to
> /var/log/messages, but in our case, we don't want it on the console.
> We want the console to only be there for kernel crash dumps (if they
> occur), nothing else.

I feel you are a bit optimistic...

But I guess what you are really asking is for the message to be
printed with a lower priority than KERN_ERR - maybe KERN_INFO.
It is in drivers/md/md.c at the end of analyze_sbs.

You would need to compile a new kernel to achieve that.

NeilBrown
