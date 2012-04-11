From: Jim Kukunas <james.t.kukunas@linux.intel.com>
Subject: lib/raid6: SSSE3 optimized recovery functions v2
Date: Wed, 11 Apr 2012 12:40:27 -0700
Message-ID: <1334173231-28595-1-git-send-email-james.t.kukunas@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, hpa@zytor.com
List-Id: linux-raid.ids

Hi Folks,

The following patchset adds SSSE3 optimized recovery
functions to RAID6.

This version differs from version 1, in that:
        0) cpu_has_ssse3 is moved to within the #ifdef block
	1) the functions are moved into their own file, recov_ssse3.c
	2) a superfluous memory load is removed from raid6_2data_recov_ssse3

A technical description of the algorithm can be found
at http://www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf

Thanks.
