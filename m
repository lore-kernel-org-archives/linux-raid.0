From: Marko Hauptvogel <marko.hauptvogel@googlemail.com>
Subject: [PATCH] Consistent use of IEC 80000-13 prefix in manpage
Date: Wed, 30 Mar 2016 21:48:58 +0200
Message-ID: <56FC2DAA.2020605@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Marko Hauptvogel <marko.hauptvogel@googlemail.com>

Added the optional K suffix for completeness, as it
is allowed by util.c's parse_size(char*).

Signed-off-by: Marko Hauptvogel <marko.hauptvogel@googlemail.com>
---
 mdadm.8.in | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 50be1aa..80b0826 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -467,8 +467,8 @@ If this is not specified
 size, though if there is a variance among the drives of greater than
1%, a warning is
 issued.

-A suffix of 'M' or 'G' can be given to indicate Megabytes or
-Gigabytes respectively.
+A suffix of 'K', 'M' or 'G' can be given to indicate Kibibytes,
Mebibytes or
+Gibibytes respectively.

 Sometimes a replacement drive can be a little smaller than the
 original drives though this should be minimised by IDEMA standards.
@@ -534,8 +534,8 @@ problems the array can be made bigger again with no
loss with another
 .B "\-\-grow \-\-array\-size="
 command.

-A suffix of 'M' or 'G' can be given to indicate Megabytes or
-Gigabytes respectively.
+A suffix of 'K', 'M' or 'G' can be given to indicate Kibibytes,
Mebibytes or
+Gibibytes respectively.
 A value of
 .B max
 restores the apparent size of the array to be whatever the real
@@ -551,8 +551,8 @@ This is only meaningful for RAID0, RAID4, RAID5,
RAID6, and RAID10.
 RAID4, RAID5, RAID6, and RAID10 require the chunk size to be a power
 of 2.  In any case it must be a multiple of 4KB.

-A suffix of 'M' or 'G' can be given to indicate Megabytes or
-Gigabytes respectively.
+A suffix of 'K', 'M' or 'G' can be given to indicate Kibibytes,
Mebibytes or
+Gibibytes respectively.

 .TP
 .BR \-\-rounding=
@@ -729,7 +729,7 @@ beneficial.  This can be suppressed with
 .TP
 .BR \-\-bitmap\-chunk=
 Set the chunksize of the bitmap.  Each bit corresponds to that many
-Kilobytes of storage.
+Kibibytes of storage.
 When using a file based bitmap, the default is to use the smallest
 size that is at-least 4 and requires no more than 2^21 chunks.
 When using an
@@ -737,8 +737,8 @@ When using an
 bitmap, the chunksize defaults to 64Meg, or larger if necessary to
 fit the bitmap into the available space.

-A suffix of 'M' or 'G' can be given to indicate Megabytes or
-Gigabytes respectively.
+A suffix of 'K', 'M' or 'G' can be given to indicate Kibibytes,
Mebibytes or
+Gibibytes respectively.

 .TP
 .BR \-W ", " \-\-write\-mostly
@@ -808,7 +808,8 @@ an array which was originally created using a
different version of
 which computed a different offset.

 Setting the offset explicitly over-rides the default.  The value given
-is in Kilobytes unless an 'M' or 'G' suffix is given.
+is in Kibibytes unless a suffix of 'K', 'M' or 'G' is given to indicate
+Kibibytes, Mebibytes or Gibibytes respectively.

 Since Linux 3.4,
 .B \-\-data\-offset
-- 
2.7.4
