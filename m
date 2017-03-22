From: heinzm@redhat.com
Subject: [PATCH 0/2] md/dm-raid: add/use API to switch raid4/5/6 journal cache modes
Date: Wed, 22 Mar 2017 17:44:21 +0100
Message-ID: <20170322164423.20972-1-heinzm@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: heinzm@redhat.com
List-Id: linux-raid.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Upstream commit 7a771ceac771d009f7203c40b256b0608d7ea2f8 added
journal support to dm-raid to close the raid4/5/6 "write hole"
but doesn't provide an API to switch modes from device-mapper.

Add missing API to MD and use it from device-mapper dm-raid
thus supporting 'write-back' journal caching in the raid target.


Heinz Mauelshagen (2):
  md: add raid4/5/6 journal mode API (for dm-raid use)
  dm raid: add raid4/5/6 journal mode support

 Documentation/device-mapper/dm-raid.txt | 11 +++-
 drivers/md/dm-raid.c                    | 91 ++++++++++++++++++++++++++++-----
 drivers/md/raid5-cache.c                | 62 ++++++++++++----------
 drivers/md/raid5.h                      | 11 ++++
 4 files changed, 133 insertions(+), 42 deletions(-)

-- 
2.9.3

