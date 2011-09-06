From: Michal Soltys <soltys@ziu.info>
Subject: v2 - keep incremental, check types
Date: Tue,  6 Sep 2011 23:39:12 +0200
Message-ID: <1315345153-1673-1-git-send-email-soltys@ziu.info>
References: <1315140164-6991-1-git-send-email-soltys@ziu.info>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1315140164-6991-1-git-send-email-soltys@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Similar to the earlier patch, without removing incremental assembly - add ddf,
use $tempnode, comments, check for exact types.


Michal Soltys (1):
  udev rules: add ddf, shorten checks, use $tempnode

 udev-md-raid.rules |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

-- 
1.7.5.3

