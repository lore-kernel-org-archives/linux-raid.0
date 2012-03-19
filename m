From: Jim Kukunas <james.t.kukunas@linux.intel.com>
Subject: lib/raid6: SSSE3 optimized recovery functions v1
Date: Mon, 19 Mar 2012 11:10:45 -0700
Message-ID: <1332180649-9709-1-git-send-email-james.t.kukunas@linux.intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: hpa@zytor.com
List-Id: linux-raid.ids

Hi Folks,

The following patchset adds SSSE3 optimized recovery
functions to RAID6.

This version differs from version 0, in that the build fix for the
test program was split into a separate patch.

A technical description of the algorithm can be found
at http://www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf

Thanks.


