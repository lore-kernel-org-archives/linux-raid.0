From: Lars Ellenberg <Lars.Ellenberg@linbit.com>
Subject: Re: [patch] latency problem in md driver
Date: Fri, 22 Dec 2006 18:33:35 +0100
Message-ID: <20061222173335.GB8199@soda.linbit>
References: <20061222143215.GD7477@soda.linbit> <458BF799.6010703@garzik.org> <20061222154017.GA8199@soda.linbit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20061222154017.GA8199@soda.linbit>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Ingo Molnar <mingo@redhat.com>, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org, Andrew Morton <akpm@osdl.org>
List-Id: linux-raid.ids

/ 2006-12-22 16:40:17 +0100
\ Lars Ellenberg:
> the issue at hand is:
> because md does special case the barrier bit, it strips off everything
> else by re-assigning only the io direction and the barrier bit.
> 
>  ==> I'd like it to also pass at least the sync bit.

some additional info maybe regarding the motivation for this patch.
in drbd 0.7, we have some bitmap on some block device.
this can grow pretty large (128MB), and the code reading/writing it
does synchronous sector size io (which is stupid, and has been changed
already in current drbd svn). --- ok, too much detail ---

anyways, initializing 128MB using 512 Byte bios at a time
with BIO_RW_SYNC using current md raid1 code takes about 5 _minutes_.

with the patch posted earlier, it takes about 5 _seconds_.

this same performance loss will affect every users that are bound
by many small synchronous updates, unless they explicitly unplug
somewhere else.

-- 
: Lars Ellenberg                            Tel +43-1-8178292-55 :
: LINBIT Information Technologies GmbH      Fax +43-1-8178292-82 :
: Vivenotgasse 48, A-1120 Vienna/Europe    http://www.linbit.com :
