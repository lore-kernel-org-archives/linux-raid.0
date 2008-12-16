From: Neil Brown <neilb@suse.de>
Subject: Re: MD: Feature Request: Estimate of blocks necessary to complete sync
Date: Tue, 16 Dec 2008 14:07:52 +1100
Message-ID: <18759.7048.623851.9550@notabene.brown>
References: <cccedfc60812110727p18abcf49v909cb0860c2d4c02@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Thursday December 11
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday December 11, jnelson-linux-raid@jamponi.net wrote:
> When one is using a bitmap-enabled raid1 (or raid5 or whatever), MD
> prints messages like this to the kernel log when a previously-used
> device is re-added:
> 
> 
> Dec 11 08:59:40 turnip kernel: md: recovery of RAID array md10
> Dec 11 08:59:40 turnip kernel: md: minimum _guaranteed_  speed: 1000
> KB/sec/disk.
> Dec 11 08:59:40 turnip kernel: md: using maximum available idle IO
> bandwidth (but not more than 200000 KB/sec) for recovery.
> Dec 11 08:59:40 turnip kernel: md: using 128k window, over a total of
> 78123968 blocks.
> Dec 11 08:59:41 turnip nbd0-frank: mdadm: /dev/nbd0 attached to
> /dev/md10 which is already active.
> Dec 11 09:00:22 turnip kernel: md: md10: recovery done.
> 
> What would be nice is the addition of something like this:
> Dec 11 08:59:40 turnip kernel: md: bitmap shows 27 128K blocks requiring sync
> or
> Dec 11 08:59:40 turnip kernel: md: bitmap shows 3456K blocks requiring sync
> or some other analogue.
> 
> Seem reasonable?

Probably.  I wouldn't be too hard to could the number of bits that are
set.  I guess it could be useful.

I'll put it on my list :-)
NeilBrown
