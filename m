From: ilmari@ilmari.org (Dagfinn Ilmari =?utf-8?Q?Manns=C3=A5ker?=)
Subject: Re: [PATCH 00/16] raid acceleration and asynchronous offload api for 2.6.22
Date: Wed, 02 May 2007 17:36:07 +0100
Message-ID: <d8jy7k7rxmw.fsf@nygaard.ping.uio.no>
References: <Pine.LNX.4.64.0705021154410.25382@p34.internal.lan>
	<0C7297FA1D2D244A9C7F6959C0BF1E5201CA8E4D@azsmsx413.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S2993502AbXEBQgh@vger.kernel.org>
In-Reply-To: <0C7297FA1D2D244A9C7F6959C0BF1E5201CA8E4D@azsmsx413.amr.corp.intel.com>
	(Dan J. Williams's message of "Wed, 2 May 2007 09:17:13 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Nick Piggin <nickpiggin@yahoo.com.au>, neilb@suse.de, akpm@linux-foundation.org, "Leech, Christopher" <christopher.leech@intel.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Williams, Dan J" <dan.j.williams@intel.com> writes:

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

How about hard drive controllers with RAID accelleration features (but
not full hardware RAID capability) such as the Promise SX4
(http://linux-ata.org/faq-sata-raid.html#sx4)?

-- 
ilmari
"A disappointingly low fraction of the human race is,
 at any given time, on fire." - Stig Sandbeck Mathisen
