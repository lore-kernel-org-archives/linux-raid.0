From: Neil Brown <neilb@suse.de>
Subject: ANNOUNCE: mdadm 2.5.4 - A tool for managing Soft RAID under Linux
Date: Fri, 13 Oct 2006 10:15:35 +1000
Message-ID: <17710.55975.316262.98110@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I am pleased to announce the availability of
   mdadm version 2.5.4

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

Release 2.5.4 is a bugfix release over 2.5.3

Changelog Entries:
    -   When creating devices in /dev/md/ create matching symlinks
	from /dev.  e.g. /dev/md0 -> /dev/md/0.
	Allow this to be disabled in mdadm.conf or on command line.
    -   Fix some endian-ness issues with version-1 superblocks (affects
	bigendian only).
    -   Fix endian problem with 'bitmap' metadata
    -   Allow a number (of partitions) after the 'yes' option to --auto=
	This is particularly useful in the 'create' line in mdadm.conf.
    -   Remove partitions from any whole device that is made part of
	an md array.  This is a work-around for annoying messages
	when the first block on some drive accidentally looks like a
	partition table.

Development of mdadm is sponsored by
 SUSE Labs, Novell Inc.

NeilBrown 13th October 2006
