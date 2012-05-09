From: Daniel Pocock <daniel@pocock.com.au>
Subject: md RAID with enterprise-class SATA or SAS drives
Date: Wed, 09 May 2012 22:00:17 +0000
Message-ID: <4FAAE8F1.8000600@pocock.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



There is various information about
- enterprise-class drives (either SAS or just enterprise SATA)
- the SCSI/SAS protocols themselves vs SATA
having more advanced features (e.g. for dealing with error conditions)
than the average block device

For example, Adaptec recommends that such drives will work better with
their hardware RAID cards:

http://ask.adaptec.com/cgi-bin/adaptec_tic.cfg/php/enduser/std_adp.php?p_faqid=14596
"Desktop class disk drives have an error recovery feature that will
result in a continuous retry of the drive (read or write) when an error
is encountered, such as a bad sector. In a RAID array this can cause the
RAID controller to time-out while waiting for the drive to respond."

and this blog:
http://www.adaptec.com/blog/?p=901
"major advantages to enterprise drives (TLER for one) ... opt for the
enterprise drives in a RAID environment no matter what the cost of the
drive over the desktop drive"

My question..

- does Linux md RAID actively use the more advanced features of these
drives, e.g. to work around errors?

- if a non-RAID SAS card is used, does it matter which card is chosen?
Does md work equally well with all of them?

- ignoring the better MTBF and seek times of these drives, do any of the
other features passively contribute to a better RAID experience when
using md?

- for someone using SAS or enterprise SATA drives with Linux, is there
any particular benefit to using md RAID, dmraid or filesystem (e.g.
btrfs) RAID (apart from the btrfs having checksums)?
