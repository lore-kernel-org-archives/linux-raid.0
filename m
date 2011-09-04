From: Michal Soltys <soltys@ziu.info>
Subject: [PATCH 0/2] udev rules behaviour
Date: Sun,  4 Sep 2011 14:42:42 +0200
Message-ID: <1315140164-6991-1-git-send-email-soltys@ziu.info>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Current udev rules installed cause autoassembly of everything that is possible
during coldplug - due to mdadm -I calls for each matching device.

This causes two immediate problems:

- mdadm.conf kind-of rendered pointless, as the assembly of any array will be
  attempted either way

- 65-md-inc*.rules (e.g. present in dracut and different distributions)
  offering more fine grained controls (e.g. incremental assembly limited to
  certain uuids) are also shadowed by mdadm's default rules

If this is not expected behaviour, following patch removes -I calls.
Second patch adds ddf (and any future) containers to -If calls.


Alternatively, we could detect presence of 65-md-inc* and mdadm.conf and
attempt assemlby only if none of those are present ? Not perfect, but
a bit more flexible.


Michal Soltys (2):
  udev rules: don't incrementally autoassemble everything
  shorten remove rules

 udev-md-raid.rules |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

-- 
1.7.5.3

