From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Fastest Chunk Size w/XFS For MD Software RAID = 1024k
Date: Tue, 3 Jul 2007 04:42:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0707030442080.19015@p34.internal.lan>
References: <Pine.LNX.4.64.0706271918010.29111@p34.internal.lan>
 <46832E60.9000006@rabbit.us> <Pine.LNX.4.64.0706280406520.1406@p34.internal.lan>
 <46837056.4050306@rabbit.us> <Pine.LNX.4.64.0706280426500.1406@p34.internal.lan>
 <46837307.20005@rabbit.us> <Pine.LNX.4.64.0706280437170.1406@p34.internal.lan>
 <Pine.LNX.4.64.0707022120380.2378@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707022120380.2378@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Mon, 2 Jul 2007, Mr. James W. Laferriere wrote:

> 	Hello Justin (& all) ,
>
>> 
>> My read ahead is set to 64 megabytes and 16384 for the stripe_size_cache.
>
> 	Might you know of a tool for acquiring these (*) parameters for a 
> scsi drive ?  hdrarm really doesn't like real scsi drives so that doesn't 
> seem to work for me .
>
> (*)	"BuffType=DualPortCache, BuffSize=7936kB,"  Stolen from above .
>
>
> 		Tia ,  JimL

Best bet is to benchmark and test, try 128,256,512,1024 for the chunk 
size, also if your drives are on the PCI bus, it probably won't matter 
much.

Justin.
