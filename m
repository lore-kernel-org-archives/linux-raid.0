From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [md-raid6-accel PATCH 02/12] async_tx: RAID-6 recovery implementation
Date: Thu, 27 Dec 2007 18:29:31 -0800
Message-ID: <47745F8B.8070805@zytor.com>
References: <200712041428.12094.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200712041428.12094.yur@emcraft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yuri Tikhonov wrote:
>  This patch adds support for asynchronous RAID-6 recovery operations.
> 
>  An asynchronous implementation using async_tx API is provided to compute
> two missing data blocks (async_r6_dd_recov) and to compute one missing data
> block and one missing parity_block (async_r6_dp_recov).
> 
>  In general, the RAID-6 recovery API is the wrappers which organize the
> calculations algorithms using async_pqxor().
> 
>  Please refer to the "The mathematics of RAID-6" wtite-paper written by
> H.Peter Anvin available at www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf
> for the theoretical basement of the algorithms implemented here.
> 
>  Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
>  Signed-off-by: Mikhail Cherkashin <mike@emcraft.com>
> --

I really, *really*, don't like the name "pqxor", because it is actively 
misleading.  The P syndrome is an XOR, but the Q syndrome is not, and in 
particular, does not exhibit the same properties as one would expect 
from an XOR, in particular commutativity.

	-hpa
