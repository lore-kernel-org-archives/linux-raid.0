From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: reshape success story
Date: Tue, 02 Nov 2010 01:14:27 +0000
Message-ID: <4CCF65F3.3040307@anonymous.org.uk>
References: <AANLkTinnaRECf9grA6-VEAg7YNvN6M4cHWKBYsfj4v6B@mail.gmail.com>	<4CCD7AE1.8000705@anonymous.org.uk> <20101031114655.36e627e3@notabene>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000100030304060105030602"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101031114655.36e627e3@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------000100030304060105030602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 31/10/2010 15:46, Neil Brown wrote:
> On Sun, 31 Oct 2010 14:19:13 +0000
> John Robinson<john.robinson@anonymous.org.uk>  wrote:
[...]
>> Perhaps the man page needs updating then.
[...]
>> If I've got the above right (someone please correct me if I'm not)
>> perhaps I could make a modest contribution (for a change) by updating/
>> patching the man page...
>
> That would certainly be appreciated.   Your understanding appear to be
> correct!

Is the attached of any use? I started with 3.1.4. I've fixed a couple of 
typos as well as hopefully improving the explanations about backup files 
and reshapes, and added a couple of your remarks about metadata types 
from another thread. Some of the text was cribbed from your blog about 
reshaping.

Cheers,

John.

--------------000100030304060105030602
Content-Type: text/plain;
 name="mdadm.8.in.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mdadm.8.in.patch"

--- a/mdadm.8.in	2010-08-31 08:21:13.000000000 +0100
+++ b/mdadm.8.in	2010-11-02 01:05:44.000000000 +0000
@@ -322,16 +322,20 @@
 ..
 Use the original 0.90 format superblock.  This format limits arrays to
 28 component devices and limits component devices of levels 1 and
-greater to 2 terabytes.
+greater to 2 terabytes.  It is also possible for there to be confusion
+about whether the superblock applies to a whole device or just the
+last partition, if the partition starts on a 64K boundary.
 .ie '{DEFAULT_METADATA}'0.90'
 .IP "1, 1.0, 1.1, 1.2"
 .el
 .IP "1, 1.0, 1.1, 1.2 default"
 ..
 Use the new version-1 format superblock.  This has few restrictions.
-The different sub-versions store the superblock at different locations
-on the device, either at the end (for 1.0), at the start (for 1.1) or
-4K from the start (for 1.2).  "1" is equivalent to "1.0".
+It can easily be moved between hosts with different endian-ness, and a
+recovery operation can be checkpointed and restarted.  The different
+sub-versions store the superblock at different locations on the
+device, either at the end (for 1.0), at the start (for 1.1) or 4K from
+the start (for 1.2).  "1" is equivalent to "1.0".
 'if '{DEFAULT_METADATA}'1.2'  "default" is equivalent to "1.2".
 .IP ddf
 Use the "Industry Standard" DDF (Disk Data Format) format defined by
@@ -493,7 +497,7 @@
 The default is
 .BR left\-symmetric .
 
-It is also possibly to cause RAID5 to use a RAID4-like layout by
+It is also possible to cause RAID5 to use a RAID4-like layout by
 choosing
 .BR parity\-first ,
 or
@@ -660,11 +664,11 @@
 .BR \-\-backup\-file=
 This is needed when
 .B \-\-grow
-is used to increase the number of
-raid-devices in a RAID5 if there are no spare devices available.
-See the GROW MODE section below on RAID\-DEVICES CHANGES.  The file
-should be stored on a separate device, not on the RAID array being
-reshaped.
+is used to increase the number of raid-devices in a RAID5 or RAID6 if
+there are no spare devices available, or to shrink, change RAID level
+or layout.  See the GROW MODE section below on RAID\-DEVICES CHANGES.
+The file must be stored on a separate device, not on the RAID array
+being reshaped.
 
 .TP
 .BR \-\-array-size= ", " \-Z
@@ -883,12 +887,14 @@
 .BR \-\-backup\-file=
 If
 .B \-\-backup\-file
-was used to grow the number of raid-devices in a RAID5, and the system
-crashed during the critical section, then the same
+was used when requesting a grow, shrink, RAID level change or other
+reshape, and the system crashed during the critical section, then the
+same
 .B \-\-backup\-file
 must be presented to
 .B \-\-assemble
-to allow possibly corrupted data to be restored.
+to allow possibly corrupted data to be restored, and the reshape
+to be completed.
 
 .TP
 .BR \-U ", " \-\-update=
@@ -2171,27 +2177,36 @@
 inaccessible.  The integrity of any data can then be checked before
 the non-reversible reduction in the number of devices is request.
 
-When relocating the first few stripes on a RAID5, it is not possible
-to keep the data on disk completely consistent and crash-proof.  To
-provide the required safety, mdadm disables writes to the array while
-this "critical section" is reshaped, and takes a backup of the data
-that is in that section.  This backup is normally stored in any spare
-devices that the array has, however it can also be stored in a
-separate file specified with the
+When relocating the first few stripes on a RAID5 or RAID6, it is not
+possible to keep the data on disk completely consistent and
+crash-proof.  To provide the required safety, mdadm disables writes to
+the array while this "critical section" is reshaped, and takes a
+backup of the data that is in that section.  For grows, this backup may be
+stored in any spare devices that the array has, however it can also be
+stored in a separate file specified with the
 .B \-\-backup\-file
-option.  If this option is used, and the system does crash during the
-critical period, the same file must be passed to
+option, and is required to be specified for shrinks, RAID level
+changes and layout changes.  If this option is used, and the system
+does crash during the critical period, the same file must be passed to
 .B \-\-assemble
-to restore the backup and reassemble the array.
+to restore the backup and reassemble the array.  When shrinking rather
+than growing the array, the reshape is done from the end towards the
+beginning, so the "critical section" is at the end of the reshape.
 
 .SS LEVEL CHANGES
 
 Changing the RAID level of any array happens instantaneously.  However
-in the RAID to RAID6 case this requires a non-standard layout of the
+in the RAID5 to RAID6 case this requires a non-standard layout of the
 RAID6 data, and in the RAID6 to RAID5 case that non-standard layout is
-required before the change can be accomplish.  So while the level
+required before the change can be accomplished.  So while the level
 change is instant, the accompanying layout change can take quite a
-long time.
+long time.  A
+.B \-\-backup\-file
+is required.  If the array is not simultaneously being grown or
+shrunk, so that the array size will remain the same - for example,
+reshaping a 3-drive RAID5 into a 4-drive RAID6 - the backup file will
+be used not just for a "cricital section" but throughout the reshape
+operation, as described below under LAYOUT CHANGES.
 
 .SS CHUNK-SIZE AND LAYOUT CHANGES
 
@@ -2200,10 +2215,13 @@
 To ensure against data loss in the case of a crash, a
 .B --backup-file
 must be provided for these changes.  Small sections of the array will
-be copied to the backup file while they are being rearranged.
+be copied to the backup file while they are being rearranged.  This
+means that all the data is copied twice, once to the backup and once
+to the new layout on the array, so this type of reshape will go very
+slowly.
 
 If the reshape is interrupted for any reason, this backup file must be
-make available to
+made available to
 .B "mdadm --assemble"
 so the array can be reassembled.  Consequently the file cannot be
 stored on the device being reshaped.

--------------000100030304060105030602--
