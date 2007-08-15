From: Mike Accetta <maccetta@laurelnetworks.com>
Subject: detecting read errors after RAID1 check operation
Date: Wed, 15 Aug 2007 18:03:03 -0400
Message-ID: <11774.1187215383@mdt.ecitele.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


We run a "check" operation periodically to try and turn up problems with
drives about to go bad before they become too severe.  In particularly,
if there were any drive read errors during the check operation I would
like to be able to notice and raise an alarm for human attention so that
the failing drive can be replaced sooner than later.  I'm looking for a
programatic way to detect this reliably without having to grovel through
the log files looking for kernel hard drive error messages that may have
occurred during the check operation.

There are already files like /sys/block/md_d0/md/dev-sdb/errors in /sys
which would be very convenient to consult but according to the kernel
driver implementation the error counts reported there are apparently
for corrected errors and not relevant for read errors during a "check"
operation.

I am contemplating adding a parallel /sys file that would report
all errors, not just the corrected ones.  Does this seem reasonable?
Are there other alternatives that might make sense here?
--
Mike Accetta

ECI Telecom Ltd.
Transport Networking Division, US (previously Laurel Networks)
