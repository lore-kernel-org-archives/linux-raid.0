From: Petr Vorel <pvorel@suse.cz>
Subject: [PATCH v2 1/1] mdadm.8: add note information for raid0 growing operation
Date: Mon, 24 Feb 2020 12:34:09 +0100
Message-ID: <20200224113409.11137-1-pvorel@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, Petr Vorel <pvorel@suse.cz>, NeilBrown <neilb@suse.de>, Jes Sorensen <jsorensen@fb.com>, Paul Menzel <pmenzel@molgen.mpg.de>, Wols Lists <antlists@youngman.org.uk>, Nix <nix@esperi.org.uk>
List-Id: linux-raid.ids

From: Coly Li <colyli@suse.de>

When growing a raid0 device, if the new component disk size is not
big enough, the grow operation may fail due to lack of backup space.

The minimum backup space should be larger than:
 LCM(old, new) * chunk-size * 2

where LCM() is the least common multiple of the old and new count of
component disks, and "* 2" comes from the fact that mdadm refuses to
use more than half of a spare device for backup space.

There are users reporting such failure when they grew a raid0 array
with small component disk. Neil Brown points out this is not a bug
and how the failure comes. This patch adds note information into
mdadm(8) man page in the Notes part of GROW MODE section to explain
the minimum size requirement of new component disk size or external
backup size.

Reviewed-by: Petr Vorel <pvorel@suse.cz>
Cc: NeilBrown <neilb@suse.de>
Cc: Jes Sorensen <jsorensen@fb.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Wols Lists <antlists@youngman.org.uk>
Cc: Nix <nix@esperi.org.uk>
Signed-off-by: Coly Li <colyli@suse.de>
---
Hi,

Coly haven't sent v2, but it's already prepared in openSUSE package [1],
therefore sending it on his behalf.

Kind regards,
Petr

[1] https://build.opensuse.org/package/view_file/Base:System/mdadm/1002-mdadm.8-add-note-information-for-raid0-growing-opera.patch?expand=1

 mdadm.8.in | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mdadm.8.in b/mdadm.8.in
index 5d00faf..a3494a1 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -2768,6 +2768,12 @@ option and it is transparent for assembly feature.
 .IP \(bu 4
 Roaming between Windows(R) and Linux systems for IMSM metadata is not
 supported during grow process.
+.IP \(bu 4
+When growing a raid0 device, the new component disk size (or external
+backup size) should be larger than LCM(old, new) * chunk-size * 2,
+where LCM() is the least common multiple of the old and new count of
+component disks, and "* 2" comes from the fact that mdadm refuses to
+use more than half of a spare device for backup space.
 
 .SS SIZE CHANGES
 Normally when an array is built the "size" is taken from the smallest
-- 
2.25.1
