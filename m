From: "NeilBrown" <neilb@suse.de>
Subject: Re: Whole drives or Only partitions for mdadm software RAIDs?
Date: Tue, 1 Jul 2008 08:57:22 +1000 (EST)
Message-ID: <55572.192.168.1.70.1214866642.squirrel@neil.brown.name>
References: <8CAA8FD62E1D4D0-594-672@webmail-nb10.sysops.aol.com>
    <alpine.DEB.1.10.0806301549580.4791@p34.internal.lan>
    <8CAA902C7CC8B09-594-8CF@webmail-nb10.sysops.aol.com>
    <48693E94.4080309@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48693E94.4080309@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: thomas62186218@aol.com, jpiszcz@lucidpixels.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, July 1, 2008 6:14 am, David Greaves wrote:
> Also, if you ever replace a drive there is a distinct chance that the
> drive will
> be a different size (even if it is the same model).
>
> After being bitten by this I always make partition a few Mb smaller than
> the device.

If you are concerned by this (and it is a valid concern) then you can still
use the whole device, and give the --size option to mdadm --create to
tell it to use a little bit less than the whole device.
You give a size in kilobytes (I really should change that to
accept M or G suffixes I guess).

Personally, I prefer to use whole devices.

NeilBrown


