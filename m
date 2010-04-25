From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Questions about 4k sector drives
Date: Sun, 25 Apr 2010 10:43:21 -0400
Message-ID: <1272206601.7734.4.camel@faldara>
References: <4BD42B57.9000703@kusche.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD42B57.9000703@kusche.de>
Sender: linux-raid-owner@vger.kernel.org
To: Florian Kusche <flox@kusche.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 2010-04-25 at 13:45 +0200, Florian Kusche wrote:
> Hello,
> 
> I have a few questions about Software RAID and 4k-sector drives. I
>  already searched the web, but some questions are left.
> 
> 1) (this one is not directly raid-related) I understand, that newer
>  kernels can determine whether a drive uses 4k physical sectors even if
>  it presents 512-byte logical sectors to the outside. (via the
>  sector_size_supported() patch by Matthew Wilcox)
> 
> Is this only an information given to userland tools, or will the linux
>  kernel change its behavior (e.g. use 4k-blocks for such block
>  devices)? (I guess it's only an information for userland tools.)

If the device reports it, then the kernel knows it and exports it to
user space.  The new 4k drives from WD unfortunately, lie and report
their physical sector size is 512 bytes.

> 2)
> Will Software RAID work with physical 4k-sector drives...
> - that simulate logical 512 byte sectors?
> - that also have logical 4k-sectors?
> (I'm pretty sure, the answer to both questions is yes.)

Yes.


