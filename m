From: Neil Brown <neilb@suse.de>
Subject: ANNOUNCE: mdadm 2.5.3 - A tool for managing Soft RAID under Linux
Date: Mon, 7 Aug 2006 12:10:46 +1000
Message-ID: <17622.41254.755573.381773@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I am pleased to announce the availability of
   mdadm version 2.5.3

It is available at the usual places:
   http://www.cse.unsw.edu.au/~neilb/source/mdadm/
and
   countrycode=xx.
   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
and via git at
   git://neil.brown.name/mdadm
   http://neil.brown.name/git?p=mdadm

mdadm is a tool for creating, managing and monitoring
device arrays using the "md" driver in Linux, also
known as Software RAID arrays.

Release 2.5.3 is a bugfix release over 2.5.2.

Changelog Entries:
    -   Document v0.91 superblocks in md.4
    -   Make GPL explicit in man pages.
    -   Fix recent breakage of starting degraded arrays.
    -   Tidyup automatic name choice for v-1 arrays:
	  /dev/md_d0 now becomes '0', not '_d0'.

Development of mdadm is sponsored by
 SUSE Labs, Novell Inc.

NeilBrown  7th August 2006


