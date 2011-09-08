From: Michal Soltys <soltys@ziu.info>
Subject: v2 once more, for current head
Date: Thu,  8 Sep 2011 09:25:07 +0200
Message-ID: <1315466708-5431-1-git-send-email-soltys@ziu.info>
References: <1315140164-6991-1-git-send-email-soltys@ziu.info>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1315140164-6991-1-git-send-email-soltys@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As the earlier v2 was after 2/2 was commited, this one adds missing
stuff on top.

Michal Soltys (1):
  udev rules: use $tempnode, check for supported types, comments

 udev-md-raid.rules |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

-- 
1.7.5.3

