From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: What is the exacting meaning of Striped_Cache_Size?
Date: Sun, 21 Jan 2007 23:06:37 -0700
Message-ID: <e9c3a7c20701212206p2316e02he13eebe8efc3889e@mail.gmail.com>
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan>
	 <Pine.LNX.4.64.0701200745420.3756@p34.internal.lan>
	 <BAY125-DAV159818650D5FE72FE853E393AE0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY125-DAV159818650D5FE72FE853E393AE0@phx.gbl>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Liang Yang <multisyncfe991@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/21/07, Liang Yang <multisyncfe991@hotmail.com> wrote:
> Hello,
>
> I have tried to increase the Striped_Cache_Size from 256 (default for my
> MD-RAID5 array) to 8192, it does improve the MD-RAID5 Write performance
> which varies with the size of I/O packet.
>
> However, I'm still not very clean the meaning and the potential performance
> impact of this Striped_Cache_Size? Is the unit for this parameter Byte or
> KiloByte?
>
> Could anyone here explain with a little bit more details?
>
stripe_cache_size is the number of stripes in the cache.  Each stripe
(strip) is composed one PAGE_SIZE block per disk.  If your page size
is 4k and you have 4 disks in your array then a stripe_cache_size of
256 is 4k * 4 * 256 = 4MB.

Increasing this number increases the chances that a write to the array
will not generate reads to satisfy the parity calculation.

> Thanks,
>
> Liang
>
Regards,

Dan
