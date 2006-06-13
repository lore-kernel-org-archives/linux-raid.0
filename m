From: Neil Brown <neilb@suse.de>
Subject: Re: why raid5 not like this?
Date: Tue, 13 Jun 2006 14:08:38 +1000
Message-ID: <17550.14918.436201.233748@cse.unsw.edu.au>
References: <7de068fd0606122032t5641c96fm62a208d074750f12@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from  =?ISO-8859-1?Q?=20=1B$(AJfPG=1B(B?= on Tuesday June 13
Sender: linux-raid-owner@vger.kernel.org
To: =?GB2312?B?yubQxw==?= <xshu2006@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 13, xshu2006@gmail.com wrote:
> in linux raid4/5/6  ,one big bio will span several devices,and There
> may be several bio's per stripe+device.if the bio arrived in bi_sector
> with overlap,we must wait the former bio to be finished.
> why not we split the bigger bio into small ones?we can attach the
> smaller bio to the stripe+device (here we may can do some merge ).one
> disk i/o we can finish many small bios.if all the small bios of the
> request be finished ,we can return the request.

Overlapping bios are expected to be extremely uncommon, so any
optimisation is pointless.

Do you have reason to believe that overlapping bios are sufficiently
common that the current code is causing problems?

NeilBrown
