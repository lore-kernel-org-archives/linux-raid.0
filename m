From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 4/6] md: raid0: Make raid0_run() return a proper error code.
Date: Thu, 14 May 2009 11:31:00 +0200
Message-ID: <1242293462-4181-5-git-send-email-maan@systemlinux.org>
References: <1242293462-4181-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242293462-4181-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

Currently raid0_run() always returns -ENOMEM on errors. This is
incorrect as running the array might fail for other reasons, for
example because not all component devices were available.

This patch changes create_strip_zones() so that it returns a proper
error code (either -ENOMEM or -EINVAL) rather than 1 on errors and
makes raid0_run(), its single caller, return that value instead
of -ENOMEM.

Signed-off-by: Andre Noll <maan@systemlinux.org>

 drivers/md/raid0.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)
-- 
1.5.4.3

