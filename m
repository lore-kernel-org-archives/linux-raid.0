From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Is it possible to create a single zone RAID0 with different size
 member disks?
Date: Sun, 12 Apr 2020 10:38:46 +0100
Message-ID: <5E92E1A6.5000107@youngman.org.uk>
References: <5ng5lZpZoJjtdf9Xkshn3CSzsLIErcNWAzPPARDbDdzNY9Kr-tgMjy6djUaqRVo9r9KmB2HMV0ZQuurdV7wNDYGOP4azAiw1jPkcoF10-SM=@protonmail.com>
 <20200412141259.14955b2e@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200412141259.14955b2e@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>, Fisher <fisherthepooh@protonmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/04/20 10:12, Roman Mamedov wrote:
> You can make one 4x2TB RAID0, and one 2x1TB RAID0 from the tails of 3TB disks.
> 
> Or 4x2TB RAID5 and 2x1TB RAID1.

This last would be way the best.

Remember, with raid-0 you only need ONE failure to trash your partition.
And with say four disks, you quadruple your chances of said failure.

What size are these disks? And given the price of disks, if you're
trying to combine small disks ( <1TB typically) what's the point? It'll
probably cost more in electric to run all these disks than to just buy a
new large disk and bin the old ones.

Cheers,
Wol
