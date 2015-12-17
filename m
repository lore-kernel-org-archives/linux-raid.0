From: Christoph Hellwig <hch@lst.de>
Subject: raid5-cache: avoid GFP_NOFAIL allocation
Date: Thu, 17 Dec 2015 23:09:54 +0100
Message-ID: <1450390197-19479-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com, shli@fb.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

bio_sets, mempools and high level retries are our friends:

