From: Prarit Bhargava <prarit@sgi.com>
Subject: [PATCH 0/2] Fix RAID5 + IA64 compile
Date: Fri, 28 Jul 2006 09:52:03 -0400
Message-ID: <20060728135203.29357.64980.sendpatchset@prarit.boston.redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-ia64@vger.kernel.org
Cc: Prarit Bhargava <prarit@sgi.com>
List-Id: linux-raid.ids

Patchset to fix RAID5 on ia64.  Removes dead CONFIG options and
introduces a new CONFIG option.

Patch is against 2.6.17 + 2.6.18-rc2-git5

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
