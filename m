From: Martin Wilck <mwilck@arcor.de>
Subject: mke2fs with discard option breaks RAID5 array
Date: Sat, 14 Sep 2013 21:50:22 +0200
Message-ID: <5234BDFE.7050700@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I just had the following weird effect under OpenSUSE 12.3, kernel
3.7.10-1.16. I am wondering if it's a known problem.

Creating a RAID5 array (format doesn't seem to matter) either with the
openSUSE native mdadm 3.2.6 or mdadm 3.3, and running mke2fs on it,
fails. The RAID array is broken after that, all disks faulty, any IO fails.

Further examination shows that the problem is related to mke2fs trying
to discard blocks. Running "-E nodiscard" or setting "discard=no" in
mke2fs.conf fixes the problem. Unfortnately, "discard" seems to be the
default.

Details under https://bugzilla.novell.com/show_bug.cgi?id=840413

Has anyone seen this before?
Martin
