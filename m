From: Neil Brown <neilb@suse.de>
Subject: Please revert 5b479c91da90eef605f851508744bfe8269591a0 (md partition rescan)
Date: Thu, 10 May 2007 10:37:06 +1000
Message-ID: <17986.26930.952993.510918@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759826AbXEJAh5@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: akpm@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, David Greaves <david@dgreaves.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids


Hi Linus,
 Could you please revert

    5b479c91da90eef605f851508744bfe8269591a0

It causes an oops when auto-detecting raid arrays, and it doesn't seem
easy to fix.
The array may not be 'open' when do_md_run is called, so bdev->bd_disk
might be NULL, so bd_set_size can oops.
I cannot really open the array (blkdev_get) at this point as I
deadlock on mddev->reconfig_mutex.
I could simply guard against bdev->bd_disk being NULL, but that is too
ugly as sometimes the partitions would be found, and sometimes not.

This whole approach of opening an md device before it has been
assembled just seems to get more and more painful.  I think I'm going
to have to come up with something clever to provide both backward
comparability with usage expectation, and sane integration into the
rest of the kernel.
Maybe if you open before the array is assembled you get a completely
different bdev somehow, and on array assembly, a new bdev, or gendisk
or something, gets swapped in so the next open finds it....

Anyway, if that patch can go I'd appreciate it.

Thanks,
NeilBrown
