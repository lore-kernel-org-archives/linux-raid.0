From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Spares and partitioning huge disks
Date: Sat, 15 Jan 2005 12:10:30 +0100 (CET)
Message-ID: <Pine.LNX.4.44.0501151208050.3584-100000@uplift.swm.pp.se>
References: <41E8F0FB.4090104@wasp.net.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41E8F0FB.4090104@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 15 Jan 2005, Brad Campbell wrote:

> Make sure the logging is done in such a way as mdadm can send you an
> E-mail and say. "Hey, sda just had a bad block. Be aware.

Definately. The 3ware daemon does this when it detects the drive did a 
relocation (I guess it does it via SMART) and I definately like the way 
this is done.

As far as I can understand, the 3ware hw raid5 will kick any drive that 
has read errors on it though, but I am not 100% sure of this, this is just 
my guess from experience with it. I have successfully re-introduced a 
failed drive into the raid though, so I guess it'll relocate just the way 
we discussed, when it actually tries to write again to the bad sector.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

