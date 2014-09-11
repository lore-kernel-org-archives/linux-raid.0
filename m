From: Marco Schindler <marco.schindler@gmail.com>
Subject: frequent disk activity with mdadm-3.3
Date: Fri, 12 Sep 2014 00:05:08 +0200
Message-ID: <AB305DF4-9DCC-47E1-9B29-130E211D4B4E@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Hello,

Im seeing frequent disk activity on all raid drives from mdadm since upgrading to 3.3.1/3.3.2 from 3.2.
It keeps drives from sleeping (disk access every ~15 minutes). Is it intentional?

I reported a similar issue for udev a few weeks ago: https://bugs.gentoo.org/show_bug.cgi?id=518748

Marco