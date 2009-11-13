From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] a few more md patches....
Date: Fri, 13 Nov 2009 20:36:13 +1100
Message-ID: <19197.10381.201071.987808@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


[I just realised that when I sent this to Linus a couple of hours ago
I forgot to cc to linux-raid - sorry]

I know it is getting late, but continued testing showed that an
unclean shutdown during a RAID level migration can leave the array
in a slightly inconsistent state.  If after that you get a device 
failure, md may not respond exactly the right way.  There is room for
data corruption in there.

Thanks,
NeilBrown


The following changes since commit aa021baa3295fa6e3f367d80f8955dd5176656eb:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../mason/btrfs-unstable

are available in the git repository at:

  git://neil.brown.name/md for-linus

NeilBrown (4):
      md: factor out updating of 'recovery_offset'.
      md: allow v0.91 metadata to record devices as being active but not in-sync.
      Don't unconditionally set in_sync on newly added device in raid5_reshape
      md/raid5: Allow dirty-degraded arrays to be assembled when only party is degraded.

 drivers/md/md.c    |   41 ++++++++++++++++++++-----
 drivers/md/raid5.c |   85 ++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 112 insertions(+), 14 deletions(-)
