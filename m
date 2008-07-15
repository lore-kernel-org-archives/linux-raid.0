From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Tue, 15 Jul 2008 21:41:43 +0200
Message-ID: <20080715194143.GA25566@rap.rap.dk>
References: <1216130769.5633.318.camel@sam.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1216130769.5633.318.camel@sam.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Martin <monkeyiq@users.sourceforge.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 16, 2008 at 12:06:09AM +1000, Ben Martin wrote:
> Hi,
>   Apologies if posting this here is inappropriate but a recent article
> of mine compares the Linux Kernel RAID code to an $800 hardware RAID
> card and might be of interest to list members:
> 
> http://www.linux.com/feature/140734

Thanks for this! I have written about it on the wiki.

I see that the Adaptec has a mode 1E which looks a lot like Linux
raid10,o2.  It could be fun to compare these, and also raid10,f2.

Also, if you wish, it would be nice to see what can actually be achieved
without the expensive Adaptec card, that is what can be done with the
controller on the mobo, with arrays with 4 disks.

And also if the mobo controller has raid types, what could be achieved
with this.... 

best regards
keld
