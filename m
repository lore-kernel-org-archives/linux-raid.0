From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: mdadm RAID and drives spinning up/down
Date: Sun, 21 Mar 2010 22:01:34 +0000
Message-ID: <4BA6973E.7080401@anonymous.org.uk>
References: <5bdc1c8b1003211440n7e0b7848s7c069c3394d487a3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5bdc1c8b1003211440n7e0b7848s7c069c3394d487a3@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21/03/2010 21:40, Mark Knecht wrote:
> I'm moving forward on my first machine using RAID. This will be a
> fairly lightly used home server storing MythTV recordings and backups
> coming from other Linux machine. Due to the light workload I expect
> there will be times, sometimes lasting hours or maybe days, when the
> drives are unused and might (should?) spin down. Additionally with
> everyone trying to save power and be 'green' more and more drives
> probably do this by design anyway.
> 
> OK, so never having build a RAID array and knowing nothing about this
> I'm curious about how mdadm handles this sort of thing. If the drives,
> using something like hdparm to set parameters, have times that shut
> them down for a while, when the system needs them spinning again are
> there ways to buffer write data and delay read data until everything
> is ready to roll again? I.e. - it's the middle of the night and Myth
> wants to start a recording. Everything is shut down and not it needs
> to start.
> 
> Is it a problem if one drive spins up more slowly? Could that fool the
> RAID software into thinking the drive has died when it's actually just
> asleep?
> 
> Sorry for such newbish questions.

I think the answer to this is much the same as the other thread about 
using "RAID-class" drives: md doesn't set timeouts itself, so whether 
things work or not depends on whether the device driver underneath fails 
reads while a drive is waking up.

I'd say if you can make single drives sleep and spin up again without 
problems, you can make md arrays do it - because the Linux md layer 
knows nothing about it.

The ReadyNAS, formerly from Infrant but now from Netgear, does precisely 
this and works well, and uses Linux md, but I don't know whether they've 
tuned anything. It's open source of course, so it might be worth taking 
a look.

Cheers,

John.

