From: Tim Small <tim@seoss.co.uk>
Subject: Upgrading the firmware on the underlying drives of a RAID5 safely.
Date: Tue, 20 Apr 2010 15:30:55 +0100
Message-ID: <4BCDBA9F.7010903@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a RAID5 with 3x 1TB Seagate Barracuda ES.2 ST31000340NS SATA
drives + 1 hot spare.  I'd like to upgrade the firmware on two of the
member drives using hdparm (I've already done this on the spare).  The
drives are on an ICH9, and the system uses Debian 5 (2.6.27) 64bit on an
Intel "Core2" Xeon.  The drives keep locking up, and needing a reset by
the kernel, and I'd like to fix that (the firmware changelog indicates
that the firmware has fixes for similar behaviour).

The upgrade process takes about 40 seconds, so I'd prefer the drives to
be "idle" during this time (blocking would also be all right, but if the
kernel tries to access the drives, and then times out and resets them
drives, then at the very least the firmware update will fail).

So... an easy way to do this would be to fail one of the drives, and get
it rebuilt onto the the spare, but of course, that puts the array into a
non-redundant state for the duration of the operation.  Some sort of
temporary write-behind would be nice, but I understand that this is only
supported for RAID1.  Is migrating to RAID6, then failing out one drive
at a time a reasonable option, or upping libata/md timeouts?

Any other thoughts options?  As I seem to be doing drive firmware
updates more and more frequently recently (maybe I'm just getting
unlucky), some sort of infrastructure to support doing this on a live
system/array would be cool!

Cheers,

Tim.
