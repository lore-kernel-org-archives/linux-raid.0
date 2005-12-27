From: Ewan Grantham <ewan.grantham@gmail.com>
Subject: RAID-5 using CLOOP devices
Date: Tue, 27 Dec 2005 13:08:32 -0600
Message-ID: <6d5bedd80512271108q6dda3d2ax23b226caba823caa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have been successfully using a RAID-5 array under Windows XP using
the coLinux 0.7 embedded Linux software (colinux.sourceforge.net) with
a Debian setup and mdadm (and Samba to make the array available to the
Windows side of the machine).

I've been toying with the idea of going back to a full Linux setup,
but am not sure if the headache would be worth the effort.
Specifically, the folks who wrote coLinux told me that I should be
able to access my partitions using cloop under Linux. But I wonder
what mdadm would make of a RAID-5 array of cloop devices?

Just trying to see if there's any easy way of migrating short of
degrading the array, copying what I can to my remaining space, and
then rebuilding everything after the conversion.

TIA,
Ewan
