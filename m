From: Eivind Sarto <eivindsarto@gmail.com>
Subject: [patch 1/1] raid0: discard requests do not align to chunk boundary
Date: Tue, 3 Jun 2014 14:18:53 -0700
Message-ID: <4267B3A0-F0E8-407C-86D8-45ABC46D1464@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Raid0 only sets max_discard_sectors, but does not force alignment of discard requests.  Discard request
will be broken up into chunk-sized REQ_DISCARD by blkdev_issue_discard(), but if the sector is not 
chunk-aligned, each REQ_DISCARD to raid0 will all remain unaligned and raid0 will ned to split them all.

This patch will prevent splitting of REQ_DISCARD requests.

-eivind