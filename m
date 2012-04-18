From: Jim Kukunas <james.t.kukunas@linux.intel.com>
Subject: arch/86: AVX RAID5 xor checksumming v1
Date: Wed, 18 Apr 2012 15:58:47 -0700
Message-ID: <1334789928-7238-1-git-send-email-james.t.kukunas@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Folks,

The following patch adds an AVX implementation of the RAID5 xor checksumming
functions.

This version differs from version 0, in that it:
	0) checks whether assembler supports AVX
	1) replaces __attribute__(aligned(32)) with __aligned(32)
	2) adds do/while(0); to macro blocks

Based on xor_speed, the AVX implementation appears to be ~32% faster than the
SSE implementation on my i7 2600:

        generic_sse: 15088.000 MB/sec
	avx: 19936.000 MB/sec

Thanks.
