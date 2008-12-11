From: Michael Brancato <mike@mikebrancato.com>
Subject: Re: status of raid 4/5 disk reduce
Date: Thu, 11 Dec 2008 01:33:51 -0500
Message-ID: <4940B44F.9000000@mikebrancato.com>
References: <493D8A95.2020700@mikebrancato.com> <493EDF02.5090500@redwax.co.uk>	 <A20315AE59B5C34585629E258D76A97C02F476F7@34093-C3-EVS3.exchange.rackspace.com>	 <20081209215149.GA21523@cthulhu.home.robinhill.me.uk> <7d86ddb90812091515m1e0ee2f9w95a86ca2b56a98fe@mail.gmail.com> <493FB2AC.7000902@redwax.co.uk> <494059A4.8050702@mikebrancato.com> <A20315AE59B5C34585629E258D76A97C02FA1D78@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C02FA1D78@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Alex Lilley <alex@redwax.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


David Lethe wrote:

>   
> Respectfully, go bother the LVM, jfs, ext, afs, and all the other file
> system people.  You have zero chance of getting them on board to support
> online file system shrinking without any guarantee of scratch space.
> My advice is that you don't tell them you also want them to resize while
> the md volume is being resized, and also don't tell them that the array
> might be degraded.

I didn't bring up nor argued the filesystem online resize issue, you 
did.  Why does the filesystem have to be online during the reshape or 
the shrink?  People shrink filesystems and partitions while offline 
everyday, and the sun still rises.  Filesystem support for reshaping 
(not resizing) should be a non-issue.  Resizing shrink exists today.

> If you want to copy 4x120 into 3x500 ... mount all the disks and COPY
> the data.  If you are truly limited to 4 disks, and are too cheap to
> spend $10-20 for another controller, after buying 1.5TB worth of disk
> drives, then you really need to get your priorities in order.

Words fail me....  Why support reshaping RAID arrays by adding disks 
then if we should just go buy more disks and create a new array to copy 
the data to?

I don't know why you oppose the flexibility of reshape shrinking, but at 
one point it was planned.  I simply tried to see what the status was of 
the development and what was needed to get support for reshape shrink. 
When it comes to actually using it, to each his own.
