From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 0 of 12] Introduction
Date: Wed, 23 Mar 2005 16:47:10 +1100
Message-ID: <20050323164208.16240.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Here are 12 patches for the bitmap write-intent logging in md in
2.6.12-rc1-mm1 With this, it is getting quite close to being really
usable (though there are a couple of issues that I haven't resolved
yet.

Andrew: Are you happy to keep collecting these as a list of patches
(bugs followed by bug-fixes :-), or would it be easier if I merged all
the bug fixes into earlier patches and just resent a small number of
"add-functionality" patches??

NeilBrown

[PATCH md 1 of 12] Check return value of write_page, rather than ignore it
[PATCH md 2 of 12] Enable the bitmap write-back daemon and wait for it.
[PATCH md 3 of 12] Improve debug-printing of bitmap superblock.
[PATCH md 4 of 12] Minor code rearrangement in bitmap_init_from_disk
[PATCH md 5 of 12] Print correct pid for newly created  bitmap-writeback-daemon.
[PATCH md 6 of 12] Call bitmap_daemon_work regularly
[PATCH md 7 of 12] Don't skip bitmap pages due to lack of bit that we just cleared.
[PATCH md 8 of 12] A couple of tidyups relating to the bitmap file.
[PATCH md 9 of 12] Make sure md bitmap is cleared on a clean start.
[PATCH md 10 of 12] Fix bug when raid1 attempts a partial reconstruct.
[PATCH md 11 of 12] Allow md to update multiple superblocks in parallel.
[PATCH md 12 of 12] Allow md intent bitmap to be stored near the superblock.
