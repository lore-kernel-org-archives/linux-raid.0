From: NeilBrown <neilb@suse.com>
Subject: [PATCH 0/4] Assorted mdadm patches.
Date: Fri, 04 Aug 2017 15:30:02 +1000
Message-ID: <150182450644.25561.9683614144764209335.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

One real bugfix - that a customer might have hit.
Another real bugfix, which proves no-one is using that feature.
And a couple of minor consistency improvements.

Can you guess which is which :-?

NeilBrown


---

NeilBrown (4):
      Error messages should end with a newline character.
      Use correct syntax for passing DEVLINKS to mdadm from udev
      super1: only set clustered flag when bitmap is present
      Don't use exit(ERANGE)


 Build.c                     |    4 ++--
 Grow.c                      |    4 ++--
 Manage.c                    |    2 +-
 mdadm.8.in                  |    2 +-
 mdadm.c                     |    2 +-
 mdopen.c                    |    2 +-
 super1.c                    |    4 ++--
 udev-md-raid-assembly.rules |    2 +-
 8 files changed, 11 insertions(+), 11 deletions(-)

--
Signature

