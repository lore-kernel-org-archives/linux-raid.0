From: Neil Brown <neilb@suse.de>
Subject: Re: [RFC][PATCH 000 of 3] MD Acceleration and the ADMA interface:
	Introduction
Date: Fri, 3 Feb 2006 12:25:44 +1100
Message-ID: <17378.45336.742764.939328@cse.unsw.edu.au>
References: <1138929127.20036.42.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Thursday February 2
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Chris Leech <christopher.leech@intel.com>, "Grover, Andrew" <andrew.grover@intel.com>, Deepak Saxena <dsaxena@plexity.net>
List-Id: linux-raid.ids

On Thursday February 2, dan.j.williams@intel.com wrote:
> Per the discussion in this thread (http://marc.theaimsgroup.com/?
> t=112603120100004&r=1&w=2) these patches implement the first phase of MD
> acceleration, pre-emptible xor.  To date these patches only cover raid5
> calls to compute_parity for read/modify and reconstruct writes.  The
> plan is to expand this to cover raid5 check parity, raid5 compute block,
> as well as the raid6 equivalents.

Thanks.  I'll try to have a look through these in the next week or so.

Given the nature of the changes (adding a new subsystem) it might be
worth sending the patches to linux-kernel as well.  Suspect there are
people there who would be interested.

NeilBrown


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
> 
> Ideally, with some coordination, the I/OAT DMA, ACRYPTO, and ADMA
> efforts can unify to present a consistent asynchronous off-load engine
> interface.
> 
> [RFC][PATCH 001 of 3] MD Acceleration: Base ADMA interface
> [RFC][PATCH 002 of 3] MD Acceleration: md_adma driver for raid5 offload
> [RFC][PATCH 003 of 3] MD Acceleration: raid5 changes to support asynchronous operation
> 
> NOTE: These patches are against Linus' git tree as of commit_id
> 0271fc2db6260dd46f196191e24281af2fddb879 (they should apply to 2.6.16-
> rc1).  They have only passed basic run time sanity checks on ARM, and
> compile testing on i386.
> 
> The next phase of this development will target the remainder of raid5,
> raid6, and the outcome of the asynchronous off-load engine unification
> effort.  The known asynchronous interface stakeholders have been CC'd.
> 
> Dan Williams
> Linux Development Team
> Storage Group - Intel Corporation
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
