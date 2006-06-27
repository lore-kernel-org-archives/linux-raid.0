From: Nix <nix@esperi.org.uk>
Subject: Re: [PATCH*2] mdadm works with uClibc from SVN
Date: Tue, 27 Jun 2006 11:58:50 +0100
Message-ID: <87wtb2g905.fsf@hades.wkstn.nix>
References: <87wtbbjxd4.fsf@hades.wkstn.nix>
	<17567.25412.387397.430549@cse.unsw.edu.au>
	<8764ingcmb.fsf@hades.wkstn.nix>
	<17569.162.835803.817439@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17569.162.835803.817439@cse.unsw.edu.au> (Neil Brown's message of "Tue, 27 Jun 2006 19:55:46 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 27 Jun 2006, Neil Brown prattled cheerily:
> On Tuesday June 27, nix@esperi.org.uk wrote:
>> ,----[ config.c:load_partitions() ]
>> | name = map_dev(major, minor, 1);
>> | 
>> | d = malloc(sizeof(*d));
>> | d->devname = strdup(name);
>> `----
>> 
> 
> Ahh.. uhmmm... Oh yes.  I've fixed that since, but completely forgot
> about it and the change log didn't make it obvious.

Yahoo. That's what I like about free software: the pre-emptive bugfixes!
It seems that as soon as I find a bug, someone else will have already
fixed it :)

> So: that's fixed for 2.5.2.  Thanks for following it up.

No, thank *you* for fixing my boot process :)

-- 
`NB: Anyone suggesting that we should say "Tibibytes" instead of
 Terabytes there will be hunted down and brutally slain.
 That is all.' --- Matthew Wilcox
