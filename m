From: Jim Kukunas <james.t.kukunas@linux.intel.com>
Subject: AVX RAID5 xor checksumming
Date: Thu, 29 Mar 2012 14:44:17 -0700
Message-ID: <1333057458-2986-1-git-send-email-james.t.kukunas@linux.intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: hpa@zytor.com, neilb@suse.de
List-Id: linux-raid.ids

Hi Folks,

The following patch adds an AVX implementation of the RAID5 xor checksumming
functions.

Based on xor_speed, the AVX implementation appears to be ~32% faster than the
SSE implementation on my i7 2600:

	generic_sse: 15088.000 MB/sec
	avx: 19936.000 MB/sec

Thanks.

