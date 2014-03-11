From: Simon Guinot <simon.guinot@sequanux.org>
Subject: [PATCH 0/2] md: fix fix deadlock while suspending RAID array
Date: Tue, 11 Mar 2014 20:12:08 +0100
Message-ID: <1394565130-24233-1-git-send-email-simon.guinot@sequanux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?q?R=C3=A9mi=20R=C3=A9rolle?= <remi.rerolle@seagate.com>, Simon Guinot <simon.guinot@sequanux.org>
List-Id: linux-raid.ids

Hi,

This patch series fixes a deadlock which have been observed while
updating a RAID array level, using the mdadm --grow command. A full
description of the issue (hopefully understandable enough) is provided
by the commit message in the second patch.

Please, let me know if this patches are correct and/or if there is an
another way (maybe more handy) to solve this deadlock issue.

Thanks,

Simon

Simon Guinot (2):
  md: move up mddev locking functions
  md: fix deadlock while suspending RAID array

 drivers/md/md.c | 154 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 83 insertions(+), 71 deletions(-)

-- 
1.8.5.3
