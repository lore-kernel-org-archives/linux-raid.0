From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC][PATCH 000 of 3] MD Acceleration and the ADMA interface:
 Introduction
Date: Thu, 02 Feb 2006 21:01:35 -0500
Message-ID: <43E2B97F.305@pobox.com>
References: <1138931168.6620.8.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1138931168.6620.8.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Chris Leech <christopher.leech@intel.com>, "Grover, Andrew" <andrew.grover@intel.com>, Deepak Saxena <dsaxena@plexity.net>
List-Id: linux-raid.ids

Dan Williams wrote:
> This patch set was originally posted to linux-raid, Neil suggested that
> I send to linux-kernel as well:
> 
> Per the discussion in this thread (http://marc.theaimsgroup.com/?
> t=112603120100004&r=1&w=2) these patches implement the first phase of MD
> acceleration, pre-emptible xor.  To date these patches only cover raid5
> calls to compute_parity for read/modify and reconstruct writes.  The
> plan is to expand this to cover raid5 check parity, raid5 compute block,
> as well as the raid6 equivalents.
> 
> The ADMA (Asynchronous / Application Specific DMA) interface is proposed
> as a cross platform mechanism for supporting system CPU offload engines.
> The goal is to provide a unified asynchronous interface to support
> memory copies, block xor, block pattern setting, block compare, CRC
> calculation, cryptography etc.  The ADMA interface should support a PIO
> fallback mode allowing a given ADMA engine implementation to use the
> system CPU for operations without a hardware accelerated backend.  In
> other words a client coded to the ADMA interface transparently receives
> hardware acceleration for its operations depending on the features of
> the underlying platform.

Here are some other things out there worth considering:

* SCSI XOR commands

* Figuring out how to support Promise SX4 (e.g. device offload), which 
is a chip with integrated XOR engine and attached DIMM.  RAID1 and RAID5 
are best implemented on-card, but the Linux driver is responsible for 
implementing all on-card actions, not a firmware.

	Jeff


