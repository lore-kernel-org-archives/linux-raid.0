From: Phil Turmel <philip@turmel.org>
Subject: [PATCH] Add more warnings to --grow documentation (was: RAID5 Shrinking
 array-size nearly killed the system)
Date: Sat, 12 Mar 2011 12:47:40 -0500
Message-ID: <4D7BB1BC.4010400@turmel.org>
References: <AANLkTimrq904HRZfx6RpPrVNd0EJ5AkUZtytY7TqcFYv@mail.gmail.com>	<AANLkTikQ5_xm3+JKP8pR=oYO5xi6Qk1=VrSsiBkgtB6q@mail.gmail.com>	<alpine.DEB.1.10.1103120655370.7942@uplift.swm.pp.se>	<4D7B85EB.60505@turmel.org> <AANLkTik2qk2ep7fsQPjAesnjur-0AB-Xx7EeZ5YfeCSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik2qk2ep7fsQPjAesnjur-0AB-Xx7EeZ5YfeCSA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rory Jaffe <rsjaffe@gmail.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[CC restored.  Always use reply-to-all on kernel.org lists.]

On 03/12/2011 11:07 AM, Rory Jaffe wrote:
> It's ext4. I've backed up the critical data, so a complete loss of the
> files won't be a catastrophe, just a major pain. I was planning to
> unmount the filesystem, shrink it, remount it, then proceed with
> shrinking the block device.
> 
> Mikael also asked about what I would change in the documentation. I'd
> change the following two paragraphs (my changes are in all caps).
> 
> Note that when an array changes size, any filesystem that may be stored
>      in the array will  not  automatically  grow  OR SHRINK to  use
> the  space.   The
>      filesystem will need to be explicitly told to use the extra space
> AFTER GROWING THE ARRAY, OR TO REDUCE ITS SIZE PRIOR TO SHRINKING THE
> ARRAY.
> 
> When  decreasing the number of devices, the size of the array will also
>      decrease.  If there was data in the array, it could get  destroyed  and
>      this is not reversible. FIRST, SHRINK THE FILESYSTEMS ON THE
> ARRAY TO ACCOMODATE THE NEW SIZE. To help prevent accidents, mdadm
> requires that
>      the size of the array be decreased first  with  mdadm  --grow  --array-
>      size.   This  is  a reversible change which simply makes the end of the
>      array inaccessible.  The integrity of any  data  can  then  be  checked
>      before  the  non-reversible  reduction  in  the  number  of  devices is
>      request.

I've incorporated some of the above suggestions in the following patch,
paraphrased somewhat, with additional text in the summary section.

8<======================
From 027600b0db6bb9043fc5141a5ad6db32f5ba5ab5 Mon Sep 17 00:00:00 2001
From: Philip J. Turmel <philip@turmel.org>
Date: Sat, 12 Mar 2011 12:30:23 -0500
Subject: [PATCH] Grow: Improve the documentation of shrinking

Users often report difficulties caused by shrinking an array
without having shrunk the contained filesystem.  Add a note
warning about this in the summary description for --grow, and
elaborate in the SIZE CHANGES subsection of the GROW mode
detailed description.

Inspired-by: Rory Jaffe <rsjaffe@gmail.com>
Signed-off-by: Philip J. Turmel <philip@turmel.org>
---
 mdadm.8.in |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 08e4255..43c2022 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -126,6 +126,13 @@ of component devices and changing the number of active devices in RAID
 levels 1/4/5/6, changing the RAID level between 1, 5, and 6, changing
 the chunk size and layout for RAID5 and RAID5, as well as adding or
 removing a write-intent bitmap.
+.B "Note:"
+The contained filesystem, if any, is
+.B NOT
+adjusted automatically.
+Shrinking without prior filesystem adjustment
+.B WILL
+do irreversible damage.
 
 .TP
 .B "Incremental Assembly"
@@ -2158,8 +2165,12 @@ space to start being used.  If the size is increased in this way, a
 are synchronised.
 
 Note that when an array changes size, any filesystem that may be
-stored in the array will not automatically grow to use the space.  The
-filesystem will need to be explicitly told to use the extra space.
+stored in the array will not automatically grow to use the space.
+Nor will it automatically shrink to fit a smaller size.  The
+filesystem will need to be explicitly told to use the new size.
+.B "Note:"
+Some filesystems can not be shrunk at all.  Most filesystems can not
+be shrunk while mounted.
 
 Also the size of an array cannot be changed while it has an active
 bitmap.  If an array has a bitmap, it must be removed before the size
-- 
1.7.4.1


