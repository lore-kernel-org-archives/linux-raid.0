From: "Jonathan Vardy" <jonathanv@explainerdc.com>
Subject: Re: RAID 5 performance problems
Date: Thu, 3 Apr 2003 23:42:47 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <009c01c2fa29$f7b2d290$2e77c23e@pentium4>
References: <Pine.GSO.4.30.0304030858080.20118-100000@multivac.sdsc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: "Peter L. Ashford" <ashford@sdsc.edu>, Jonathan Vardy <jonathan@explainerdc.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

> The ONLY reason that I can think of to use round cables would be for
> looks.  From a performance or reliability standpoint, they are a waste of
> money.  I routinely build systems with dual 8-channel IDE RAID cards
> (3Ware 7500-8) and 16 disks, and ONLY use flat cables.

I use rounded cables in my case for a few reasons:
- The distance between my promise and my drives is small yet the promise
cables are long, the rounded cables I have are 12" long and fit very neatly
- The promise cables had two IDE connectors but I only wanted to put one
drive per channel; the rounded cables are single cables
- Air flow; because of my small casing the flat promise cables were
contricting the airflow quite a bit, the rounded less
- flexibility; I found the flat cables hard to bend in to place whereas the
round cables you could twist easily

I've added a link which should make it clear that rounded cables in my case
are a benefit to me. What I was worried about was that they could be
inferior quality and thus be a factor in my raid performance.

http://www.datzegik.com/DSC00056.JPG

