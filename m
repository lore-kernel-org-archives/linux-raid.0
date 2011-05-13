From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm does not create partition devices whatsoever, "partitionable"
 functionality broken
Date: Fri, 13 May 2011 15:39:54 -0400
Message-ID: <4DCD890A.8000706@turmel.org>
References: <4DCD4A83.8060202@pulseforce.com>	<4DCD6119.3080705@turmel.org>	<4DCD67EF.1070602@pulseforce.com>	<4DCD6B27.70402@pulseforce.com>	<20110513234055.4307c536@natsu>	<4DCD72AF.1070809@pulseforce.com>	<4DCD75FE.8010703@turmel.org>	<4DCD7E78.6050000@pulseforce.com>	<4DCD84E1.3040704@turmel.org> <20110514013221.552dc8ef@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110514013221.552dc8ef@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Christopher White <linux@pulseforce.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/13/2011 03:32 PM, Roman Mamedov wrote:
> On Fri, 13 May 2011 15:22:09 -0400
> Phil Turmel <philip@turmel.org> wrote:
> 
>> I always use LVM.  While the lack of attention to MD partitions might
>> justify that, the real reason is the sheer convenience of creating,
>> manipulating, and deleting logical volumes on the fly.  While you may not
>> need it *now*, when you discover that you *do* need it, you won't be able to
>> use it.  Online resizing of any of your LVs is the killer feature.
> 
> Can it defragment non-contiguous LVs yet?

Automatically, no (so far as I've seen).  If you have a suitable free space chunk in the group, though, you can manually create a contiguous mirror, let it sync, then remove the original segments.  Do it twice if placement is critical.

Phil
