From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Which raid card to buy for Sarge
Date: Thu, 01 Apr 2004 00:58:23 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <406BAF7F.2030307@pobox.com>
References: <008f01c41737$8b57be40$6405a8c0@a30> <006401c417a1$36a45790$6405a8c0@a30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <006401c417a1$36a45790$6405a8c0@a30>
To: me@heyjay.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

me@heyjay.com wrote:
> I'd like to thank everyone who responded, and I didn't mean to start a
> software vs hardware war.  But now that I did I'm sort of happy, because
> it's made me question if my direction is proper for my goals.

Not your fault, it's inevitable ;-)


> - I'm using a (fairly) old machine, I have to figure processor speed has to
> be an issue with software raid
> - When the box is being stressed most of the work is computational, the
> process I run puts the CPU% at 98% (according to top).

98% cpu doing just raid 1?  That sounds highly strange, even on an older 
CPU.

Typically RAID1 doesn't stress the cpu as much as PCI bus bandwidth and 
the drives...

	Jeff



