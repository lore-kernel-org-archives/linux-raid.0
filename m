From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH RESEND 0/5] md/raid10 changes
Date: Wed, 15 Jun 2011 11:01:59 +0900
Message-ID: <1308103324-2375-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,

This is a resend of my previous raid10 patches. Some of them are revised
according to your comments and some of them are not reviewed at all.
Please take a look.

Thanks.


Namhyung Kim (5):
  md/raid10: optimize read_balance() for 'far offset' arrays
  md/raid10: get rid of duplicated conditional expression
  md/raid10: factor out common bio handling code
  md/raid10: share pages between read and write bio's during recovery
  md/raid10: spread read for subordinate r10bios during recovery

 drivers/md/raid10.c |   83 +++++++++++++++++++++++++++-----------------------
 1 files changed, 45 insertions(+), 38 deletions(-)

--
1.7.5.2

