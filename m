From: Andrew Walrond <andrew@walrond.org>
Subject: Re: No swap can be dangerous (was Re: swap on RAID (was Re: swp - Re: ext3 journal on software raid))
Date: Thu, 6 Jan 2005 22:08:39 +0000
Message-ID: <200501062208.39563.andrew@walrond.org>
References: <41DC9420.5030701@h3c.com> <20050106093811.GB99565@caffreys.strugglers.net> <41DD798F.8030902@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41DD798F.8030902@h3c.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 06 January 2005 17:46, Mike Hardy wrote:
>
> You are correct that I was getting at the zero swap argument - and I
> agree that it is vastly different from simply not expecting it. It is
> important to know that there is no inherent need for swap in the kernel
> though - it is simply used as more "memory" (albeit slower, and with
> some optimizations to work better with real memory) and if you don't
> need it, you don't need it.
>

If I recollect a recent thread on LKML correctly, your 'no inherent need for 
swap' might be wrong.

I think the gist was this: the kernel can sometimes needs to move bits of 
memory in order to free up dma-able ram, or lowmem. If I recall correctly, 
the kernel can only do this move via swap, even if there is stacks of free 
(non-dmaable or highmem) memory.

I distinctly remember the moral of the thread being "Always mount some swap, 
if you can"

This might have changed though, or I might have got it completely wrong. - 
I've cc'ed LKML incase somebody more knowledgeable can comment...

Andrew Walrond
