From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Without tweaking ,
Date: Wed, 26 Sep 2007 16:46:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0709261645460.4199@p34.internal.lan>
References: <Pine.LNX.4.64.0709260953580.12074@filesrv1.baby-dragons.com>
 <Pine.LNX.4.64.0709261406010.24646@p34.internal.lan> <46FAB899.6050201@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46FAB899.6050201@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Thu, 27 Sep 2007, Richard Scobie wrote:

> Justin Piszcz wrote:
>
>> For raptors, they are inheriently known for their poor speed when NCQ is
>> enabled, I see 20-30MiB/s better performance with NCQ off.
>
> Hi Justin,
>
> Have you tested this for multiple reader/writers?
>
> Regards,
>
> Richard
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

If you have a good repeatable benchmark you want me to run with it on/off 
let me know, no I only used bonnie++/iozone/tiobench/dd but not any 
parallelism with those utilities.

Justin.
