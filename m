From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC][PATCH 000 of 3] MD Acceleration and the ADMA interface:
	Introduction
Date: Thu, 02 Feb 2006 18:12:07 -0700
Message-ID: <1138929127.20036.42.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Chris Leech <christopher.leech@intel.com>, "Grover, Andrew" <andrew.grover@intel.com>, Deepak Saxena <dsaxena@plexity.net>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Per the discussion in this thread (http://marc.theaimsgroup.com/?
t=112603120100004&r=1&w=2) these patches implement the first phase of MD
acceleration, pre-emptible xor.  To date these patches only cover raid5
calls to compute_parity for read/modify and reconstruct writes.  The
plan is to expand this to cover raid5 check parity, raid5 compute block,
as well as the raid6 equivalents.

The ADMA (Asynchronous / Application Specific DMA) interface is proposed
as a cross platform mechanism for supporting system CPU offload engines.
The goal is to provide a unified asynchronous interface to support
memory copies, block xor, block pattern setting, block compare, CRC
calculation, cryptography etc.  The ADMA interface should support a PIO
fallback mode allowing a given ADMA engine implementation to use the
system CPU for operations without a hardware accelerated backend.  In
other words a client coded to the ADMA interface transparently receives
hardware acceleration for its operations depending on the features of
the underlying platform.

Ideally, with some coordination, the I/OAT DMA, ACRYPTO, and ADMA
efforts can unify to present a consistent asynchronous off-load engine
interface.

[RFC][PATCH 001 of 3] MD Acceleration: Base ADMA interface
[RFC][PATCH 002 of 3] MD Acceleration: md_adma driver for raid5 offload
[RFC][PATCH 003 of 3] MD Acceleration: raid5 changes to support asynchronous operation

NOTE: These patches are against Linus' git tree as of commit_id
0271fc2db6260dd46f196191e24281af2fddb879 (they should apply to 2.6.16-
rc1).  They have only passed basic run time sanity checks on ARM, and
compile testing on i386.

The next phase of this development will target the remainder of raid5,
raid6, and the outcome of the asynchronous off-load engine unification
effort.  The known asynchronous interface stakeholders have been CC'd.

Dan Williams
Linux Development Team
Storage Group - Intel Corporation


