From: raid@ddx.a2000.nu
Subject: Re: Is Read speed faster when 1 disk is failed on raid5 ?
Date: Tue, 22 Oct 2002 11:58:56 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210221154500.26127-100000@ddx.a2000.nu>
References: <02Oct22.043816edt.62658@gpu.utcc.utoronto.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <02Oct22.043816edt.62658@gpu.utcc.utoronto.ca>
To: Chris Siebenmann <cks@utcc.utoronto.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 22 Oct 2002, Chris Siebenmann wrote:
>  At a guess: when RAID-5 is intact, the kernel must read the entire
> stripe size worth of data to verify the parity. When a RAID-5 array has
> a dead disk, any intact data block can be handed to the application
> the moment it comes off the disk as there is no point in doing parity
> verification. (The kernel has to reconstruct the missing blocks, but
> most of the blocks are present and good.)

i thought raid5 was doing parity calculation when writing ?
difference between rading from failed an intact raid5 is almost twice the
speed (failed is doing 150MB/sec, intact is doing 80MB/sec)



