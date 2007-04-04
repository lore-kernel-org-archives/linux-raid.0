From: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: raid6 rebuild
Date: Wed, 4 Apr 2007 21:46:38 +0200
Message-ID: <20070404194638.GB3712@xi.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: mingo@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(please CC on replies, not subscribed to linux-raid@)

Hi!

While my RAID6 array was rebuilding after one disk had failed (which
I replaced), a second disk failed[*], and this caused the rebuild
process to start over from the beginning.

Why would the rebuild need to start over from the beginning in this
case?  Why couldn't it just continue from where it was?


thanks,
Lennert

[*] probably an entirely defective batch of 14 Samsung Spinpoint 500G disks
