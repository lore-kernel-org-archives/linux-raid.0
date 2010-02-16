From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm vesions and linux kernel correspondance
Date: Tue, 16 Feb 2010 12:27:30 +1100
Message-ID: <20100216122730.6b01cd66@notabene.brown>
References: <20100210172841.GA23419@light.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100210172841.GA23419@light.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld Simonsen <keld@keldix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 10 Feb 2010 18:28:41 +0100
Keld Simonsen <keld@keldix.com> wrote:

> Hi
> 
> Is there some bindings between mdadm and which versions of the kernel
> it can work with?

There shouldn't be.  When mdadm tries to use functionality that is only in
certain kernels, it either copes correctly with failure, or tests for the
kernel version.

> 
> I am running kernel 2.6.18 and 2.6.22 - would the newest mdadm source
> run without problems here?

It should do.  However I don't test against older kernels, so I cannot make
guarantees.

NeilBrown
