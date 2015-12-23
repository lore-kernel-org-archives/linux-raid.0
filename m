From: Doug Dumitru <doug@easyco.com>
Subject: Re: Create Lock to Eliminate RMW in RAID/456 when writing perfect stripes
Date: Wed, 23 Dec 2015 12:37:15 -0800
Message-ID: <CAFx4rwS-_XKpuiT2TJMNbRc+uDOUL-EstNGZcCqektSLO72C8Q@mail.gmail.com>
References: <CAFx4rwR1gtLZUF6MUx71QTvw3hT5GKhsEMU2xcBpAz5wZWBUCw@mail.gmail.com>
 <F7761B9B1D11B64BBB666019E9378117FE6820@CFWEX01.americas.cray.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F7761B9B1D11B64BBB666019E9378117FE6820@CFWEX01.americas.cray.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Kierski <rkierski@cray.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Bob,

In thinking about this, I suspect this is somewhat less of an edge
case than just the full stripe test.  Even partial stripes probably
fire early increasing the amount of IO.

My issue with SSD wear is that my particular application stack
generates writes that are "perfect" and even very subtle deviations
from this can scramble some SSDs FTLs.  Workloads that are more
typical will already push the SSDs into heavier wear amplification, so
this issue might be in the noise.



On Wed, Dec 23, 2015 at 12:28 PM, Robert Kierski <rkierski@cray.com> wrote:
> Hey Doug,
>
> I have a comment about the last line of your message -- 'Then again, if this is too much of an "edge case", I will just keep my patches in-house.'
>
> As the use of SSD's in RAID configurations becomes more common, and SSD's become faster, the case you're talking about will be a major issue preventing customers from getting all that they expect from the equipment they purchased.  I would encourage you to continue pursuing better performance.
>
> Bob Kierski
> Senior Storage Performance Engineer
> Cray Inc.
> 380 Jackson Street
> Suite 210
> St. Paul, MN 55101
> Tele: 651-967-9590
> Fax:  651-605-9001
> Cell: 651-890-7461
>



-- 
Doug Dumitru
WildFire Storage
