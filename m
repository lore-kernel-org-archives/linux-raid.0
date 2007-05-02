From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: RE: [PATCH 00/16] raid acceleration and asynchronous offload api for 2.6.22
Date: Wed, 2 May 2007 09:17:13 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5201CA8E4D@azsmsx413.amr.corp.intel.com>
References: <Pine.LNX.4.64.0705021154410.25382@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <Pine.LNX.4.64.0705021154410.25382@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, neilb@suse.de, akpm@linux-foundation.org, "Leech, Christopher" <christopher.leech@intel.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com]
> I have not been following this closely, must you have an
> CONFIG_INTEL_IOP_ADMA piece of hardware and/or chipset to use this
> feature or can regular desktop users take hold of it as well?
> 
Currently this feature is available on the iop series of processors,
e.g. http://www.intel.com/design/iio/iop348.htm

And there is a driver in the works to support the 440spe platform
(http://marc.info/?l=linux-raid&m=117400143317440&w=2)

Desktops currently take advantage of architecture specific SIMD
instructions to accelerate xor calculations.

> Justin.

Dan
