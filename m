From: David Greaves <david@dgreaves.com>
Subject: Re: Fastest Chunk Size w/XFS For MD Software RAID = 1024k
Date: Thu, 28 Jun 2007 08:53:54 +0100
Message-ID: <46836912.4000508@dgreaves.com>
References: <Pine.LNX.4.64.0706271918010.29111@p34.internal.lan> <Pine.LNX.4.64.0706271920350.29111@p34.internal.lan> <20070628050837.GG989688@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070628050837.GG989688@sgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

David Chinner wrote:
> On Wed, Jun 27, 2007 at 07:20:42PM -0400, Justin Piszcz wrote:
>> For drives with 16MB of cache (in this case, raptors).
> 
> That's four (4) drives, right?

I'm pretty sure he's using 10 - email a few days back...
>>>>>> Justin Piszcz wrote:
>>>>> Running test with 10 RAPTOR 150 hard drives, expect it to take 
>>>>> awhile until I get the results, avg them etc. :)

> If so, how do you get a block read rate of 578MB/s from
> 4 drives? That's 145MB/s per drive....

Which gives a far more reasonable 60MB/s per drive...

David

