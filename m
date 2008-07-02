From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: new bottleneck section in wiki
Date: Thu, 03 Jul 2008 08:24:57 +1200
Message-ID: <486BE419.7030700@sauce.co.nz>
References: <20080702155603.GA11156@rap.rap.dk> <A20315AE59B5C34585629E258D76A97CF1FCCC@34093-C3-EVS3.exchange.rackspace.com> <20080702175117.GC12081@rap.rap.dk> <A20315AE59B5C34585629E258D76A97CF1FDB5@34093-C3-EVS3.exchange.rackspace.com> <20080702194546.GB2311@sewage.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080702194546.GB2311@sewage.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Matt Garman wrote:

> Anyone have any suggestions on getting a motherboard with the most
> I/O bandwidth?

Ideally you want to be avoiding the south bridge altogether.

A board like the Tyan S5396 has an MCH with 2 x 16 lane PCIe slots, so a 
high bandwidth storage controller can go in one slot and quad GigE or 
10GE in the other and both have direct access to CPUs/RAM.

These slots are also PCIe V2.0 capable, although I am not aware of any 
card that take advantage of this.

Regards,

Richard
