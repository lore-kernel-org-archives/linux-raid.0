From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 6/6] md: raid0: Simplify raid0_run().
Date: Thu, 14 May 2009 11:31:02 +0200
Message-ID: <1242293462-4181-7-git-send-email-maan@systemlinux.org>
References: <1242293462-4181-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242293462-4181-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

Get rid of the local variable "conf" and of an unnecessary cast.

Signed-off-by: Andre Noll <maan@systemlinux.org>

 drivers/md/raid0.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)
-- 
1.5.4.3

