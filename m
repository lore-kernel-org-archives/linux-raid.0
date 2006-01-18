From: Neil Brown <neilb@suse.de>
Subject: Re: why md request buffers will not across devices
Date: Thu, 19 Jan 2006 10:58:32 +1100
Message-ID: <17358.54824.759837.196287@cse.unsw.edu.au>
References: <200601181552442344275@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Zhikun Wang on Wednesday January 18
Sender: linux-raid-owner@vger.kernel.org
To: Zhikun Wang <raidwang@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday January 18, raidwang@gmail.com wrote:
> hi,
> 	I have a silly question. Why md request buffers will not
> across devices? That means Why a bh will only locate in a single
> storage device? I guess maybe file system has aligned the bh? Who
> can tell me the exact reasons? Thanks a lot! 
> 

If you are talking 'bh' then you are talking '2.4'.
In 2.4. all requests match the 'blocksize' of the device (typically 1K
or 4K) and are aligned to that size.  As the chunksize is always a
multiple of the block size a block will never cross a chunk boundary
and so never cross a device boundary.

2.6 is quite different and md sometimes needs to split a 'bio' request
to feed part to one device and part to another.

NeilBrown
