From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Spares and partitioning huge disks
Date: Sat, 15 Jan 2005 10:54:51 +0100 (CET)
Message-ID: <Pine.LNX.4.44.0501151050110.3584-100000@uplift.swm.pp.se>
References: <4m4nb2-20f.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4m4nb2-20f.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 15 Jan 2005, Peter T. Breuer wrote:

> I also agree that "redundancy per block" is probably a much better idea
> than "redundancy per disk". Probably needs a "how hot are you?"
> primitive, though!

Would a methodology that'll do

if read error then
  recreate the block from parity
  write to sector that had read error
  wait until write has completed
  flush buffers
  read back block from drive
    if block still bad
      fail disk
  log result

This would give the drive a chance to relocate the block to its spare 
blocks it has available for just this instance?

If you get a write error then the drive is obviously (?) out of spare 
sectors and should be rightfully failed.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

