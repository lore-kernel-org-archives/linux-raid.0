From: David Brown <david.brown@hesbynett.no>
Subject: Re: mdadm does not create partition devices whatsoever, "partitionable"
 functionality broken
Date: Sat, 14 May 2011 12:10:56 +0200
Message-ID: <iqlkfg$1s9$1@dough.gmane.org>
References: <4DCD4A83.8060202@pulseforce.com>	<4DCD6119.3080705@turmel.org>	<4DCD67EF.1070602@pulseforce.com>	<4DCD6B27.70402@pulseforce.com>	<20110513234055.4307c536@natsu>	<4DCD72AF.1070809@pulseforce.com>	<4DCD75FE.8010703@turmel.org>	<4DCD7E78.6050000@pulseforce.com>	<4DCD84E1.3040704@turmel.org> <20110514013221.552dc8ef@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110514013221.552dc8ef@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/05/11 21:32, Roman Mamedov wrote:
> On Fri, 13 May 2011 15:22:09 -0400
> Phil Turmel<philip@turmel.org>  wrote:
>
>> I always use LVM.  While the lack of attention to MD partitions might
>> justify that, the real reason is the sheer convenience of creating,
>> manipulating, and deleting logical volumes on the fly.  While you may not
>> need it *now*, when you discover that you *do* need it, you won't be able to
>> use it.  Online resizing of any of your LVs is the killer feature.
>
> Can it defragment non-contiguous LVs yet?
>

What is perhaps more relevant, is can filesystems see the fragmentation 
of the LV's?  I don't know the answer.

Fragmentation of files is not a problem unless files are split into 
/lots/ of small pieces.  The bad reputation of fragmentation has come 
from the DOS/Windows world, where poor filesystems combined with 
shotgun-style allocators give you much slower performance than necessary.

Modern Linux filesystems have various techniques to keep fragmentation 
to a minimum.  But (AFAIK) they make the assumption that the underlying 
device is contiguous.  If the filesystem /knows/ that the device is in 
bits, then it could take that into account in its allocation policy (in 
the same way that it takes raid stripes into account).

Still, you don't usually have many segments in an LV - if you want the 
LV to be fast, you can request it to be contiguous when creating it. 
Then you only get a fragment for each time it is grown.  It's a price 
often worth paying for the flexibility.


