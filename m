From: hpa@zytor.com (H. Peter Anvin)
Subject: Re: raid6 raidreconf progress
Date: Tue, 4 May 2004 20:18:51 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <c78trb$4gj$1@terminus.zytor.com>
References: <4087C14D.6030605@wasp.net.au> <4087DC41.8060206@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <4087DC41.8060206@wasp.net.au>
By author:    Brad Campbell <brad@wasp.net.au>
In newsgroup: linux.dev.raid
>
> Brad Campbell wrote:
> > G'day all,
> > 
> > I'm currently adding raid6 support to raidreconf, and as part of my 
> > testing I'm doing all sorts of
> > nasty things to a 200GB usb2 hard disk.
> 
> Ok, false alarm (sort of, I'm still interested in what happens with odd device sizes), but it was a 
> thinko in the raid6 parity block locator.

In the kernel or in raidreconf?

> We have liftoff. It has now performed 2 raid5->raid6 and back again cycles.
> I test it by using dd to dump 400mb of /dev/urandom to the device and then running md5sum on it, so 
> far we have 4 complete cycles to differing devices in different orders and different sizes (As long 
> as it stays above 400MB of course) and it's all good.
> Hope to have something cleaned up and presentable in the near future.

Kick ass.

	-hpa
