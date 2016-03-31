From: Marko Hauptvogel <marko.hauptvogel@googlemail.com>
Subject: [PATCH v2] Consistent use of metric prefix in manpage
Date: Fri, 1 Apr 2016 00:21:53 +0200
Message-ID: <56FDA301.1080304@googlemail.com>
References: <56FC2DAA.2020605@googlemail.com> <wrfjio028nxk.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjio028nxk.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31.03.2016 21:09, Jes Sorensen wrote:
> Marko Hauptvogel <marko.hauptvogel@googlemail.com> writes:
>> > From: Marko Hauptvogel <marko.hauptvogel@googlemail.com>
>> >
>> > Added the optional K suffix for completeness, as it
>> > is allowed by util.c's parse_size(char*).
>> >
>> > Signed-off-by: Marko Hauptvogel <marko.hauptvogel@googlemail.com>
> I am not very much in favor of this patch. Any normal sane person still
> refers to megabytes and kilobytes as referring to 1024 base sizes,
> despite the pointless standard trying to mess them up to accommodate the
> harddrive vendors. Nobody normal knows what a kibibyte is.
> 
> Jes
> 

I am fine either way, but it should be used consistently throughout the man page. The mix up was what made me cringe.

Greetings

--------

From eaad00be960ff1d60861cba75cc7e5eb07f7e330 Mon Sep 17 00:00:00 2001
From: Marko Hauptvogel <marko.hauptvogel@googlemail.com>
Date: Fri, 1 Apr 2016 00:13:44 +0200
Subject: [PATCH] Consistent use of metric prefix in manpage

Added the optional K suffix for completeness, as it
is allowed by util.c's parse_size(char*).

Signed-off-by: Marko Hauptvogel <marko.hauptvogel@googlemail.com>
---
 mdadm.8.in | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 50be1aa..1a04bd1 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -459,7 +459,7 @@ number of spare devices.

 .TP
 .BR \-z ", " \-\-size=
-Amount (in Kibibytes) of space to use from each drive in RAID levels 1/4/5/6.
+Amount (in Kilobytes) of space to use from each drive in RAID levels 1/4/5/6.
 This must be a multiple of the chunk size, and must leave about 128Kb
 of space at the end of the drive for the RAID superblock.
 If this is not specified
@@ -467,7 +467,7 @@ If this is not specified
 size, though if there is a variance among the drives of greater than 1%, a warning is
 issued.

-A suffix of 'M' or 'G' can be given to indicate Megabytes or
+A suffix of 'K', 'M' or 'G' can be given to indicate Kilobytes, Megabytes or
 Gigabytes respectively.

 Sometimes a replacement drive can be a little smaller than the
@@ -534,7 +534,7 @@ problems the array can be made bigger again with no loss with another
 .B "\-\-grow \-\-array\-size="
 command.

-A suffix of 'M' or 'G' can be given to indicate Megabytes or
+A suffix of 'K', 'M' or 'G' can be given to indicate Kilobytes, Megabytes or
 Gigabytes respectively.
 A value of
 .B max
@@ -543,7 +543,7 @@ amount of available space is.

 .TP
 .BR \-c ", " \-\-chunk=
-Specify chunk size of kibibytes.  The default when creating an
+Specify chunk size of kilobytes.  The default when creating an
 array is 512KB.  To ensure compatibility with earlier versions, the
 default when building an array with no persistent metadata is 64KB.
 This is only meaningful for RAID0, RAID4, RAID5, RAID6, and RAID10.
@@ -551,7 +551,7 @@ This is only meaningful for RAID0, RAID4, RAID5, RAID6, and RAID10.
 RAID4, RAID5, RAID6, and RAID10 require the chunk size to be a power
 of 2.  In any case it must be a multiple of 4KB.

-A suffix of 'M' or 'G' can be given to indicate Megabytes or
+A suffix of 'K', 'M' or 'G' can be given to indicate Kilobytes, Megabytes or
 Gigabytes respectively.

 .TP
@@ -737,7 +737,7 @@ When using an
 bitmap, the chunksize defaults to 64Meg, or larger if necessary to
 fit the bitmap into the available space.

-A suffix of 'M' or 'G' can be given to indicate Megabytes or
+A suffix of 'K', 'M' or 'G' can be given to indicate Kilobytes, Megabytes or
 Gigabytes respectively.

 .TP
@@ -808,7 +808,8 @@ an array which was originally created using a different version of
 which computed a different offset.

 Setting the offset explicitly over-rides the default.  The value given
-is in Kilobytes unless an 'M' or 'G' suffix is given.
+is in Kilobytes unless a suffix of 'K', 'M' or 'G' is used to explicitly
+indicate Kilobytes, Megabytes or Gigabytes respectively.

 Since Linux 3.4,
 .B \-\-data\-offset
-- 
2.8.0

