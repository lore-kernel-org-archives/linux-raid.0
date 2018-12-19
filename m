From: Kai Heng Feng <kai.heng.feng@canonical.com>
Subject: BUG_ON() hit in drivers/md/raid5.c
Date: Wed, 19 Dec 2018 16:46:31 +0800
Message-ID: <BFD51561-092F-4791-A42E-72F1373AEB50@canonical.com>
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dan.j.williams@intel.com
Cc: Steve Kowalik <steven@wedontsleep.org>, linux-raid@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Hi Dan,

There are two different BUG_ON() incidents get recently reported on Launchpad [1].

The first one is BUG_ON(dev->written) in ops_run_biodrain().
The second one (comment #23) is BUG_ON(!test_bit(R5_UPTODATE, &dev->flags)) in handle_parity_checks5().

I am not familiar with raid 5 so I am not sure these BUG_ON() are expected to be hit.

[1] https://bugs.launchpad.net/bugs/1780628

Kai-Heng
