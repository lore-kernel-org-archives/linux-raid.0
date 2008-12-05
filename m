From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Velociraptor drive related to the use of NCQ.
Date: Fri, 5 Dec 2008 08:59:54 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812050855140.4713@p34.internal.lan>
References: <alpine.DEB.1.10.0812050602400.3188@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812050602400.3188@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, smartmontools-support@lists.sourceforge.net
Cc: Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids



On Fri, 5 Dec 2008, Justin Piszcz wrote:

> I swapped out my power supply, changed ALL cables and bought a $1000 raid
> controller with BBU, the drives are still having problems, when writing to
> them in a RAID10 configuration, it locks up the card:
>
> SMART shows the same thing on many of the disks in the RAID10:
>
> Error 1 occurred at disk power-on lifetime: 3708 hours (154 days + 12 hours)
>  When the command that caused the error occurred, the device was active or 
> idle.

I spoke to soon, turning off NCQ helped dramatically, it worked three times!

writing to raid10
dd: writing `file2': No space left on device
1430328+0 records in
1430327+0 records out
1499806973952 bytes (1.5 TB) copied, 3914.51 s, 383 MB/s
Fri Dec  5 06:00:25 EST 2008
writing to raid10
dd: writing `file2': No space left on device
1430328+0 records in
1430327+0 records out
1499806973952 bytes (1.5 TB) copied, 4063.25 s, 369 MB/s
Fri Dec  5 07:08:11 EST 2008
writing to raid10
dd: writing `file2': No space left on device
1430328+0 records in
1430327+0 records out
1499806973952 bytes (1.5 TB) copied, 3926.71 s, 382 MB/s
Fri Dec  5 08:13:41 EST 2008

Then it crashed again, with NCQ enabled, it would not even complete one test,
So basically a new system, new PSU, new cables, its on a new APC UPS and the 
problem persists even when all disks are on a RAID card, SW raid, it does not 
matter, Velociraptors have problems, I think its time for me to get regular
1TiB disks and be done with it.

Justin.

