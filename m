From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 0/6] md: Make linear raid use sector_t for internal representations
Date: Thu, 21 Aug 2008 15:35:29 +0200
Message-ID: <1219325735-4111-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

[try #2, rebased to Neil's for-next branch as of today]

here's a bunch of patches that convert all representations of
internal variables in linear.c to sectors. Patches 1-3 are only
trivial cleanups.

Patches #4 and #5 are straight-forward replacements of the size and
offset fields of struct dev_info and some local variables respectively.

The only patch in this series that is not self-explanatory is #6 that
converts the hash_spacing and the preshift fields of struct dev_info
to sectors. I've added a detailed changelog message for this patch
that explains the details of the changes introduced by this patch.

checkpatch.pl is happy with all six patches, and the patched kernel
was tested by the test suite of mdadm. While the 00linear test was
successful, a couple of other tests failed. However, this seems to
be unrelated to the changes of this series because the same tests
also failed with an unpached ubuntu-hardy kernel.

