From: mwilck@arcor.de
Subject: Patches related to current discussion
Date: Tue,  6 Aug 2013 23:37:59 +0200
Message-ID: <1375825083-7856-1-git-send-email-mwilck@arcor.de>
References: <52016A06.8070400@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52016A06.8070400@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Hi Neal

This series contains some fine tuning of Albert's spare activation
test, the new race condition test announced earlier, and two proposed
fixes to avoid it.

Starting at 6 to avoid confusion with the previous series.

Note that without reverting 273989b9 and ce45c819, the ddf tests will
fail anyway. I have a respective patch in my tree, but I'll leave it
to you how to solve that.

Martin


Martin Wilck (4):
  tests/10ddf-fail-spare: more sophisticated result checks
  tests/10ddf-fail-create-race: test handling of fail/create race
  DDF: ddf_open_new: check device status for new subarray
  Create: set array status to frozen until monitoring starts

 Create.c                     |    8 ++++
 managemon.c                  |    6 +++
 super-ddf.c                  |   27 +++++++++++++-
 tests/10ddf-fail-create-race |   66 +++++++++++++++++++++++++++++++++
 tests/10ddf-fail-spare       |   83 +++++++++++++++++++++++++++++++++---------
 5 files changed, 172 insertions(+), 18 deletions(-)
 create mode 100644 tests/10ddf-fail-create-race
