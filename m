From: Neil Brown <neilb@suse.de>
Subject: ANNOUNCE: mdadm 3.0.1 - A tool for managing Soft RAID under Linux
Date: Fri, 25 Sep 2009 17:09:48 +1000
Message-ID: <19132.27836.474548.540600@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I am pleased to announce the availability of
   mdadm version 3.0.1

It is available at the usual places:
   countrycode=xx.
   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
and via git at
   git://neil.brown.name/mdadm
   http://neil.brown.name/git?p=mdadm


This contains only minor bug fixes over 3.0.  If you are using
3.0, you could consider upgrading.

The brief change log is:
   -    Fix various segfaults
   -    Fixed for --examine with containers
   -    Lots of other little fixes.

NeilBrown 25th September 2009
