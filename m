From: NeilBrown <neilb@suse.com>
Subject: Subject: ANNOUNCE: mdadm 3.3.3 - A tool for managing md Soft RAID
 under Linux
Date: Fri, 24 Jul 2015 16:35:30 +1000
Message-ID: <20150724163530.768da131@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



I am pleased to announce the availability of
   mdadm version 3.3.3

It is available at the usual places:
   http://www.kernel.org/pub/linux/utils/raid/mdadm/
and via git at
   git://github.com/neilbrown/mdadm
   git://neil.brown.name/mdadm
   http://git.neil.brown.name/git/mdadm.git

The 100 changes since 3.3.3 are mostly little bugfixes and some improvements
to the selftests.
raid6check now handle all RAID6 layouts including DDF correctly.
See git log for the rest.

NeilBrown 24th July 2015
