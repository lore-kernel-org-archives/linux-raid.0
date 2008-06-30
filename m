From: David Greaves <david@dgreaves.com>
Subject: Re: Whole drives or Only partitions for mdadm software RAIDs?
Date: Mon, 30 Jun 2008 21:14:12 +0100
Message-ID: <48693E94.4080309@dgreaves.com>
References: <8CAA8FD62E1D4D0-594-672@webmail-nb10.sysops.aol.com> <alpine.DEB.1.10.0806301549580.4791@p34.internal.lan> <8CAA902C7CC8B09-594-8CF@webmail-nb10.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8CAA902C7CC8B09-594-8CF@webmail-nb10.sysops.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: jpiszcz@lucidpixels.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Also, if you ever replace a drive there is a distinct chance that the drive will
be a different size (even if it is the same model).

After being bitten by this I always make partition a few Mb smaller than the device.

David

thomas62186218@aol.com wrote:
> 
> Thanks Justin. If that's the only risk, I'll go with full devices. This
> will ultimately be a headless system with a separate boot drive and only
> administered by me and used internally, so I'll be careful. :-)
> 
> Many thanks!
> -Thomas

