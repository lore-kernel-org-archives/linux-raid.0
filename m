From: NeilBrown <neilb@suse.com>
Subject: [GIT PULL REQUEST] md updates for 4.2-rc
Date: Wed, 5 Aug 2015 08:10:22 +1000
Message-ID: <20150805081022.0ee9dac5@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, Tomas Papan <tomas.papan@gmail.com>, Benjamin Randazzo <benjamin@randazzo.fr>, Josh Boyer <jwboyer@fedoraproject.org>, Alexander Lyakas <alex.bolshoy@gmail.com>
List-Id: linux-raid.ids


One of these patches is for a CVE:  CVE-2015-5697

I'm not convinced it is serious (data leak from CAP_SYS_ADMIN ioctl)
but as people seem to want to back-port it, I've included a minimal
version here.  The remainder of that patch from Benjamin is
code-cleanup and will arrive in the 4.3 merge window.

NeilBrown

The following changes since commit 74d33293e467df61de1b1d8b2fbe29e550dec33b:

  Linux 4.2-rc5 (2015-08-02 18:34:55 -0700)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md/4.2-rc5-fixes

for you to fetch changes up to 49895bcc7e566ba455eb2996607d6fbd3447ce16:

  md/raid5: don't let shrink_slab shrink too far. (2015-08-03 17:10:56
  +1000)

----------------------------------------------------------------
Three more fixes for md in 4.2

Mostly corner-case stuff.

----------------------------------------------------------------
Benjamin Randazzo (1):
      md: use kzalloc() when bitmap is disabled

NeilBrown (2):
      md/raid1: extend spinlock to protect raid1_end_read_request
                against inconsistencies
      md/raid5: don't let shrink_slab shrink too far.

 drivers/md/md.c    |  2 +-
 drivers/md/raid1.c | 10 ++++++----
 drivers/md/raid5.c |  5 +++--
 3 files changed, 10 insertions(+), 7 deletions(-)
