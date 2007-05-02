From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: RE: [PATCH 00/16] raid acceleration and asynchronous offload api
 for 2.6.22
Date: Wed, 2 May 2007 12:19:14 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0705021218380.25382@p34.internal.lan>
References: <0C7297FA1D2D244A9C7F6959C0BF1E5201CA8E4D@azsmsx413.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0C7297FA1D2D244A9C7F6959C0BF1E5201CA8E4D@azsmsx413.amr.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, neilb@suse.de, akpm@linux-foundation.org, "Leech, Christopher" <christopher.leech@intel.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 2 May 2007, Williams, Dan J wrote:

>> From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com]
>> I have not been following this closely, must you have an
>> CONFIG_INTEL_IOP_ADMA piece of hardware and/or chipset to use this
>> feature or can regular desktop users take hold of it as well?
>>
> Currently this feature is available on the iop series of processors,
> e.g. http://www.intel.com/design/iio/iop348.htm
>
> And there is a driver in the works to support the 440spe platform
> (http://marc.info/?l=linux-raid&m=117400143317440&w=2)
>
> Desktops currently take advantage of architecture specific SIMD
> instructions to accelerate xor calculations.
>
>> Justin.
>
> Dan
>

Ahh-- these are the family of chips in the Areca controllers (or close to 
them)-- so md/software raid will utilize the HW functions of the chip? 
If so, that is pretty slick :)

Justin.
