From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: What is the exacting meaning of Striped_Cache_Size?
Date: Mon, 22 Jan 2007 09:36:36 -0700
Message-ID: <e9c3a7c20701220836m29a1650cocd538aa9a66e7394@mail.gmail.com>
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan>
	 <Pine.LNX.4.64.0701200745420.3756@p34.internal.lan>
	 <BAY125-DAV159818650D5FE72FE853E393AE0@phx.gbl>
	 <e9c3a7c20701212206p2316e02he13eebe8efc3889e@mail.gmail.com>
	 <BAY125-DAV20A23F0F57329431B65FBE93AE0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY125-DAV20A23F0F57329431B65FBE93AE0@phx.gbl>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Liang Yang <multisyncfe991@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/21/07, Liang Yang <multisyncfe991@hotmail.com> wrote:
> Dan,
>
> Thanks for your reply. Still get two questions left.
>
> Suppose I have a MD-RAID5 array which consists of 8 disks.
> 1. Do we need to consider the chunk size of the RAID array when we set the
> value of Striped_Cache_Size? For example, if the chunk size is changed from
> 64k to 256k, do we need to adjust the Striped_Cache_Size accordingly?
>
stripe_cache_size and the chunk size are completely independent
settings.  The chunk size only determines how much data will be
accessed from one disk before proceeding to the next disk.

> 2. The performance improvement of large size I/O packets (128k, 256k) is
> larger than small size I/O packets (512B, 1KB) when I change the
> Striped_Cache_Size. How do you explain the difference here?
>
With smaller I/Os the chances that you are staying within one stripe
are higher so you would see less benefit of having more stripes in the
cache.
> Liang
>

Dan
