From: "Catalin(ux aka Dino) BOIE" <util@deuroconsult.ro>
Subject: Re: syncing RAID1 with more than 10MB/sec
Date: Wed, 30 Mar 2005 12:15:11 +0300 (EEST)
Message-ID: <Pine.LNX.4.62.0503301214340.25361@webhosting.rdsbv.ro>
References: <424A6D99.6070501@netuse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <424A6D99.6070501@netuse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Nils-Henner Krueger <nhk@netuse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Is it possible to raise this value (without recompiling)?
> I know about possible performance tradeoffs with other
> processes, I'm just generally interested.
>
> Thanks.

echo xxx > /proc/sys/dev/raid/speed_limit_max

---
Catalin(ux aka Dino) BOIE
catab at deuroconsult.ro
http://kernel.umbrella.ro/
