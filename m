From: Neil Brown <neilb@suse.de>
Subject: ANNOUNCE: mdadm 2.5.2 - A tool for managing Soft RAID under Linux
Date: Tue, 27 Jun 2006 21:37:56 +1000
Message-ID: <17569.6292.142280.859690@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



I am pleased to announce the availability of
   mdadm version 2.5.2

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

Release 2.5.2 is primarily a bugfix release over 2.5.1.
It also contains a work-around for a kernel bug which affects
hot-adding to arrays with a version-1 superblock.

Changelog Entries:
    -   Fix problem with compiling with gcc-2 compilers
    -   Fix compile problem of post-incrmenting a variable in a macro arg.
    -   Stop map_dev from returning [0:0], as that breaks things.
    -   Add 'Array Slot' line to --examine for version-1 superblocks
	to make it a bit easier to see what is happening.
    -   Work around bug in --add handling for  version-1 superblocks
	in 2.6.17 (and prior).
    -   Make -assemble a bit more resilient to finding strange
	information in superblocks.
    -   Don't claim newly added spares are InSync!! (don't know why that
	code was ever in there)
    -   Work better when no 'ftw' is available, and check to see
	if current uclibc provides ftw.
    -   Never use /etc/mdadm.conf if --config file is given (previously
	some code used one, some used the other).

Development of mdadm is sponsored by
 SUSE Labs, Novell Inc.

NeilBrown  27th June 2006


