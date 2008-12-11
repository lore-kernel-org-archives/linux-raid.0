From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: Re: status of raid 4/5 disk reduce
Date: Thu, 11 Dec 2008 14:52:52 +0100
Message-ID: <20081211135252.GA23891@apartia.fr>
References: <493D8A95.2020700@mikebrancato.com> <493EDF02.5090500@redwax.co.uk> <A20315AE59B5C34585629E258D76A97C02F476F7@34093-C3-EVS3.exchange.rackspace.com> <20081209215149.GA21523@cthulhu.home.robinhill.me.uk> <7d86ddb90812091515m1e0ee2f9w95a86ca2b56a98fe@mail.gmail.com> <493FB2AC.7000902@redwax.co.uk> <494059A4.8050702@mikebrancato.com> <A20315AE59B5C34585629E258D76A97C02FA1D78@34093-C3-EVS3.exchange.rackspace.com> <4940B44F.9000000@mikebrancato.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4940B44F.9000000@mikebrancato.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Dec 11, 2008 at 01:33:51AM -0500, Michael Brancato wrote:
>
> David Lethe wrote:
>
>>   Respectfully, go bother the LVM, jfs, ext, afs, and all the other 
>> file
>> system people.  You have zero chance of getting them on board to support
>> online file system shrinking without any guarantee of scratch space.
>> My advice is that you don't tell them you also want them to resize while
>> the md volume is being resized, and also don't tell them that the array
>> might be degraded.
>
> I didn't bring up nor argued the filesystem online resize issue, you  
> did.  Why does the filesystem have to be online during the reshape or  
> the shrink?  People shrink filesystems and partitions while offline  
> everyday, and the sun still rises.  Filesystem support for reshaping  
> (not resizing) should be a non-issue.  Resizing shrink exists today.

Not for xfs.

-- 
http://www.critikart.net
