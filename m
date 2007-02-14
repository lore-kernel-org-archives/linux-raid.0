From: Neil Brown <neilb@suse.de>
Subject: Re: RAID 10 resync leading to attempt to access beyond end of device
Date: Thu, 15 Feb 2007 10:37:47 +1100
Message-ID: <17875.40267.951634.476979@notabene.brown>
References: <e1e9d81a0702141408k4f42887by4d4c4c9aa9d536c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John Stilson on Wednesday February 14
Sender: linux-raid-owner@vger.kernel.org
To: John Stilson <john9601@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday February 14, john9601@gmail.com wrote:
> Feb 14 16:23:45 testsvr kernel: attempt to access beyond end of device
> Feb 14 16:23:45 testsvr kernel: sdc1: rw=1, want=901904331651136,
> limit=16081002

That 'want=' value is an enormous number! 52 bits.  Looks a lot like an
uninitialised variable somewhere.

What does
 grep . /sys/block/md*/md/dev-*/offset

show while the resync is running?  How about

  grep . /sys/block/md*/md/dev-*/size

And can you give me the output of "mdadm --detail' on the array?

Thanks,
NeilBrown
