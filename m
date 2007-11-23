From: Neil Brown <neilb@suse.de>
Subject: Re: md RAID 10 on Linux 2.6.20?
Date: Fri, 23 Nov 2007 14:27:37 +1100
Message-ID: <18246.18601.167303.785264@notabene.brown>
References: <8C9FB9564550DC0-464-E73@FWM-D05.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from thomas62186218@aol.com on Thursday November 22
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 22, thomas62186218@aol.com wrote:
> Hi all,
> 
> I am running a home-grown Linux 2.6.20.11 SMP 64-bit build, and I am 
> wondering if there is indeed a RAID 10 "personality" defined in md that 
> can be implemented using mdadm. If so, is it available in 2.6.20.11, or 
> is it in a later kernel version? In the past, to create RAID 10, I 
> created RAID 1's and a RAID 0, so an 8 drive RAID 10 would actually 
> consist of 5 md devices (four RAID 1's and one RAID 0). But if I could 
> just use RAID 10 natively, and simply create one RAID 10, that would of 
> course be better both in terms of management and probably performance I 
> would guess. Is this possible?

Why don't you try it and see, or check the documentation?

But yes, there is native RAID10 in 2.6.20.

NeilBrown
