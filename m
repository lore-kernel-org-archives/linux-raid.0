From: Martin Wilck <mwilck@arcor.de>
Subject: RFC: handling of missing disks in DDF
Date: Wed, 07 Aug 2013 23:03:47 +0200
Message-ID: <5202B633.3080807@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil, everyone,

I'd like to get comments on the following concept for handling missing
disks. Currently we handle "Missing" and "Failed" almost equally, that's
not optimal.

1. Try to detect missing disks and mark them so in the meta data.
ddf_open_new() could do this. At the latest, it must be done before
writing the meta data (write_super or sync_metadata).

2. Detection of a missing disk should not force an immediate meta data
write, because the disk may be added soon. It's sufficient to mark a
disk as missing when we write the meta data for other reasons.

3. Try to be smart when loading headers. A disk that was missing in a
previous run must have a lower seq number and time stamp in the meta
data than the other disks, and must be marked "Missing" there (but not
"Failed"). The meta data on the preciously missing disk should mark it
as "active/Online". In this case, use the newer meta data, and try to
re-integrate the previously missing disk (i.e. treat it as preferred
global spare).

4. It's possible that an array wasn't written to while a disk had been
missing. In that case the disk could be re-added to the array without
recovery. The question is if we can detect this situation. I thought
first  the "Not Consistent" bit might be usable for that, but I doubt it
now. The spec isn't clear about whether "consistent" state means
consistency over all configured disks or only over present ones.

Comments?
Martin
