From: Hai Wu <haiwu.us@gmail.com>
Subject: mdadm rebuild
Date: Sun, 8 Dec 2013 11:53:00 -0600
Message-ID: <B49ACD0F-BAD8-4D61-B87C-A06295B58A56@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am wondering whether it is possible for mdadm to auto-rebuild a failed
raid1 driver upon its replacement with a new drive? The following lines
from some RedHat website URL seems to indicate vaguely that it might be possible:

Previously, mdadm was not able to rebuild newly-connected drives
automatically. This update adds the array auto-rebuild feature and allows a
RAID stack to automatically rebuild newly-connected drives.

The goal is to get mdadm software raid1 to behave the same as hardware
raid1, when replacing failed hard drive. It should automatically detect new
drive and rebuild the new drive into part of raid1 ..