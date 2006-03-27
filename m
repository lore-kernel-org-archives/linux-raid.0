From: Jens Axboe <axboe@suse.de>
Subject: Re: raid and elevator
Date: Mon, 27 Mar 2006 14:27:47 +0200
Message-ID: <20060327122747.GK8186@suse.de>
References: <5d96567b0603261329o39a5e777w5bc39ad5251b4ecb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5d96567b0603261329o39a5e777w5bc39ad5251b4ecb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Sun, Mar 26 2006, Raz Ben-Jehuda(caro) wrote:
> It is my belief that the linux elevators are not optimized for
> raid throughout.
> 
> Basically when IO initiator generates IO over a single disk he can control
> the amount of IOs and this way control IOs latencies.
> 
> This is not the case in raided volumes.
> 
> Example:
> 
> An IO initiator intiates bulks of asynchronous IOs over a raided
> volume. since the user does not know the target destination of each IO
> he
> might cause imbalance over the disks. one disk may become overflooded
> with IOs while the other is may starve. So eventually we are ending with
> a non balaned raided volume in terms of bad latencies.
> 
> I am trying to deal with this problem by fixing the deadline elevator code
> to batch IOs , meaning , when n IOs are reaching the disk, each m deadlined
> IOs are sorted and then dispatced.

You do realize that the io scheduler resides _below_ the raid
personality? So if you want to balance what goes to what io scheduler
(and thus, disk), you'd want to mess with the raid personality.

-- 
Jens Axboe

