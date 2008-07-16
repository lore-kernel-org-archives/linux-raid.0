From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Tue, 15 Jul 2008 22:38:56 -0500
Message-ID: <487D6D50.2050901@sandeen.net>
References: <1216130769.5633.318.camel@sam.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1216130769.5633.318.camel@sam.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Martin <monkeyiq@users.sourceforge.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ben Martin wrote:
> Hi,
>   Apologies if posting this here is inappropriate but a recent article
> of mine compares the Linux Kernel RAID code to an $800 hardware RAID
> card and might be of interest to list members:
> 
> http://www.linux.com/feature/140734
> 

Ben, if you get fired up, you might run ext4 over the same suite of
tests... :)  The ext4 allocator is a bit more raid-geometry-aware than ext3.

-Eric
