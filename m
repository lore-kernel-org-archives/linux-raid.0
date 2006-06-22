From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: New FAQ entry? (was IBM xSeries stop responding during RAID1
 reconstruction)
Date: Wed, 21 Jun 2006 22:20:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0606212219120.10004-100000@coffee.psychology.mcmaster.ca>
References: <4499951B.8040306@tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4499951B.8040306@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> There's much easier/simpler way to set default scheduler.  As

personally, I don't see any point to worrying about the default,
compile-time or boot time:

for f in `find /sys/block/* -name scheduler`; do echo cfq > $f; done

