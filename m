From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Fastest Chunk Size w/XFS For MD Software RAID = 1024k
Date: Thu, 28 Jun 2007 04:07:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706280407420.1406@p34.internal.lan>
References: <Pine.LNX.4.64.0706271918010.29111@p34.internal.lan>
 <Pine.LNX.4.64.0706271920350.29111@p34.internal.lan> <20070628050837.GG989688@sgi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070628050837.GG989688@sgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

10 disks total.

Justin.

On Thu, 28 Jun 2007, David Chinner wrote:

> On Wed, Jun 27, 2007 at 07:20:42PM -0400, Justin Piszcz wrote:
>> For drives with 16MB of cache (in this case, raptors).
>
> That's four (4) drives, right?
>
> If so, how do you get a block read rate of 578MB/s from
> 4 drives? That's 145MB/s per drive....
>
> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>
