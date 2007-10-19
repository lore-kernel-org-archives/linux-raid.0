From: Neil Brown <neilb@suse.de>
Subject: ANNOUNCE: mdadm 2.6.4 - A tool for managing Soft RAID under Linux
Date: Fri, 19 Oct 2007 16:06:29 +1000
Message-ID: <18200.18789.190714.387367@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



I am pleased to announce the availability of
   mdadm version 2.6.4

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

Release 2.6.4 adds a few minor bug fixes to 2.6.3

Changelog Entries:
    -   Make "--create --auto=mdp" work for non-standard device names.
    -   Fix restarting of a 'reshape' if it was stopped in the middle.
    -   Fix a segfault when using v1 superblock.
    -   Make --write-mostly effective when re-adding a device to an array.
    -   Various minor fixes

Development of mdadm is sponsored by
 SUSE Labs, Novell Inc.

NeilBrown  19th October 2007
