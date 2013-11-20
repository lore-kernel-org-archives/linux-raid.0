From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Triple parity and beyond
Date: Tue, 19 Nov 2013 17:54:29 -0700
Message-ID: <7668D159-6B70-4DE9-A381-EFC15A77E0CC@colorremedies.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com> <528A90B7.5010905@zytor.com> <CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com> <528AA1EB.3010909@zytor.com> <528B3A6F.2010304@hesbynett.no> <CAGKKSfX6xx2SoDeMy7QOcGgLx5ApfbOF1pvhwixwnvEktWAWUw@mail.gmail.com> <CACJz6QtP9TXKX9ZB2J5nfLCCn0yfNExwZ-VYm-xiN53aA9vfLw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CACJz6QtP9TXKX9ZB2J5nfLCCn0yfNExwZ-VYm-xiN53aA9vfLw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
List-Id: linux-raid.ids


On Nov 19, 2013, at 3:51 PM, Drew <drew.kay@gmail.com> wrote:

> I'm not going to claim any expert status on this discussion (the
> theory makes my head spin) but I will say I agree with Andrea as far
> as prefering his implementation for triple parity and beyond.
> 
> PSHUFB has been around the intel platform since the Core2 introduced
> it as part of SSSE3 back in Q1 2006. The generation of Intel based
> servers that ran pre-Core Xeons are long in the tooth and this is a
> value judgement but if your data is big enough you need triple parity,
> you probably shouldn't be running it from an ten year old platform.

If anything, I'd like to see two implementations of RAID 6 dual parity. The existing implementation in the md driver and btrfs could remain the default, but users could opt into Cauchy matrix based dual parity which would then enable them an easy (and live) migration path to triple parity and beyond.


Chris Murphy