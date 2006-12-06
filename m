From: Neil Brown <neilb@suse.de>
Subject: Re: chunk size must be power of two?
Date: Thu, 7 Dec 2006 08:54:17 +1100
Message-ID: <17783.15369.828178.167586@cse.unsw.edu.au>
References: <45773622.8020704@loreland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from James Braid on Wednesday December 6
Sender: linux-raid-owner@vger.kernel.org
To: James Braid <jamesb@loreland.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday December 6, jamesb@loreland.org wrote:
> Is there any reason the chunk size has to be a power of two?

It makes division a lot easier and faster.

> 
> We're trying to use md devices to stripe over hardware RAID5 arrays, so 
> to align the I/O correctly, I want to set the chunk size to (n - 1) * 
> stripe_size for the underlying array. Which is impossible to do because 
> mdadm (and the kernel) insist on the chunk size being a power of
> two.

Surely you want to set chunk_size to 1 * stripe_size for the
underlying array ... or maybe 1/(n-1) * stripe_size.  But certainly
not (n-1) * stripe_size.  That wouldn't make any sense at all.

> 
> I haven't tried just removing the kernel checks yet ... is there a 
> reason why md is limited to power of two chunk sizes?

You would need to check all the div and mod operations based on chunk
size and make sure they don't implicitly assume it is a power of 2.

What exactly is the geometry of the array you wan to access with md??

NeilBrown



> 
> Failing that, does anyone know of anything else I can use to stripe 
> block devices together which doesn't have the power of two limitation? 
> device-mapper/LVM seems to have the same problem...
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
