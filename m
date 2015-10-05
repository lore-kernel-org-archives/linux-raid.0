From: Christoph Hellwig <hch@lst.de>
Subject: raid5-cache I/O path improvements V3
Date: Mon,  5 Oct 2015 09:31:05 +0200
Message-ID: <1444030276-30850-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, neilb@suse.de
Cc: dan.j.williams@intel.com, Kernel-team@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Shaohua, hi Neil,

this series contains a few updates to the raid5-cache feature, and goes
on top of dm/devel + the series Shaohua sent yesterday.

Besides the rebase the only changes compared to the previous version
is that we only bypasss the batch and flush state for devices that
do not have a volatile cache at all like persistent memory or high
performance flash devices.

