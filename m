From: Nigel Croxon <ncroxon@redhat.com>
Subject: [PATCH] clean up meaning of small typo
Date: Mon,  4 May 2020 12:27:45 -0400
Message-ID: <20200504162745.22665-1-ncroxon@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Clean up the typo which leads to wrong understanding.

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
 mdadm.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 5d00faf..484644e 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -2872,7 +2872,7 @@ operation, as described below under LAYOUT CHANGES.
=20
 .SS CHUNK-SIZE AND LAYOUT CHANGES
=20
-Changing the chunk-size of layout without also changing the number of
+Changing the chunk-size or layout without also changing the number of
 devices as the same time will involve re-writing all blocks in-place.
 To ensure against data loss in the case of a crash, a
 .B --backup-file
--=20
2.20.1
