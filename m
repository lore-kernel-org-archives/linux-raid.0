From: Neil Brown <neilb@suse.de>
Subject: Re: Bitmaps & Kernel Versions
Date: Wed, 15 Mar 2006 21:08:17 +1100
Message-ID: <17431.59281.909724.299333@cse.unsw.edu.au>
References: <4417DA8B.3040306@unix-scripts.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Laurent CARON on Wednesday March 15
Sender: linux-raid-owner@vger.kernel.org
To: Laurent CARON <lcaron@unix-scripts.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday March 15, lcaron@unix-scripts.info wrote:
> Hi,
> 
> I'm planning to use bitmaps on some of our RAID1 arrays.
> 
> I'm wondering how bitmaps are handeled by older kernels.
> 
> Eg: I create a raid array with a bitmap under a 2.6.15 kernel.
> 
> I now want to boot under 2.6.12, or even 2.4
> 
> 
> Hos is it handeled?
> Will it work even if this is my / partition?

On older kernel will not notice the bitmap and will behave
'normally'. 

When you go back to a kernel that understands bitmaps, it will notice
that the bitmap is now out-of-date and will not trust it, but should
start putting fresh data into it.

So it *should* all "just work".  However it hasn't been extensively
tested so I'm not giving any guarantees.

NeilBrown
