From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 00/14] Final set of patches head for 2.6.30
Date: Tue, 31 Mar 2009 15:54:42 +1100
Message-ID: <20090331044827.2589.95894.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again,
 following are some more patches that are heading for 2.6.30.
 I'll probably send a pull request in a day or two.

 There is some overlap between this set and the previous as I
 had to significantly change
      md: add explicit method to signal the end of a reshape.
 as I found out that some things need to be done in the reshape
 thread, and some needs to be done under the mddev_lock in the
 raid5d thread.

 The main new functionality here is the ability to change chunk_size
 and layout during reshape.  This means that we can really change
 a RAID5 into a RAID6, though it needs some mdadm support to do it
 safely.

 e.g. if you write a new number of .../md/chunk_size and then write
 'reshape' to 'sync_action' it will restripe the whole array with
 the new chunk size.  If you get a system crash during this, you lose
 your data (sorry).  Mdadm will not do this for you until it is able
 to backup each few stripes while they are being reshaped so that in
 the event of a crash you can restore from backup and not lose all
 your data.

 Any review comments most welcome.

NeilBrown

---

NeilBrown (14):
      md/raid5 revise rules for when to update metadata during reshape
      md/raid5: minor code cleanups in make_request.
      md: remove CONFIG_MD_RAID_RESHAPE config option.
      md/raid5: be more careful about write ordering when reshaping.
      md: don't display meaningless values in sysfs files resync_start and sync_speed
      md/raid5: allow layout and chunksize to be changed on active array.
      md/raid5: reshape using largest of old and new chunk size
      md/raid5: prepare for allowing reshape to change layout
      md/raid5: prepare for allowing reshape to change chunksize.
      md/raid5: clearly differentiate 'before' and 'after' stripes during reshape.
      Documentation/md.txt update
      md: allow number of drives in raid5 to be reduced
      md/raid5: change reshape-progress measurement to cope with reshaping backwards.
      md: add explicit method to signal the end of a reshape.


 Documentation/md.txt |   37 +++-
 drivers/md/Kconfig   |   29 ---
 drivers/md/md.c      |   15 +
 drivers/md/md.h      |    2 
 drivers/md/raid5.c   |  506 +++++++++++++++++++++++++++++++++++---------------
 drivers/md/raid5.h   |   21 ++
 6 files changed, 411 insertions(+), 199 deletions(-)

-- 
Signature

