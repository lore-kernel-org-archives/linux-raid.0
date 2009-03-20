From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 00/13] Asynchronous raid6 acceleration (part 1 of 2)
Date: Fri, 20 Mar 2009 11:30:11 +1100
Message-ID: <18882.58259.565999.429909@notabene.brown>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Wednesday March 18
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

On Wednesday March 18, dan.j.williams@intel.com wrote:
> This series constitutes the pieces of the raid6 acceleration work that are
> aimed at the next merge window.  It implements:
> 1/ An api for asynchronous raid6 parity generation and recovery routines
> 2/ Extensions to the dmaengine framework and dmatest
> 3/ RAID6 support for iop13xx
> 4/ Removal of the BUILD_BUG_ON in async_xor to support platforms with
>    sizeof(dma_addr_t) > sizeof(void *).  This increases the stack
>    utilization in the asynchronous path.
> 
> This series is available via git at:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git raid6
> 
> ...it is based on git://neil.brown.name/md md-scratch

Thanks.

I'll take the first patch (which is the only one that affects md
directly) and feed it to -next and eventually -linus.  I'll leave the
rest for you.

> 
> Part 2, which needs more testing, is the conversion of md/raid6.  It is
> available at:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/djbw/md.git raid6-for-neil

Thanks.  I might have a look if I get a moment.

NeilBrown
