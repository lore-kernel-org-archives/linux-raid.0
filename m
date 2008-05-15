From: Neil Brown <neilb@suse.de>
Subject: ANNOUNCE: mdadm 2.6.5 - A tool for managing Soft RAID under Linux
Date: Thu, 15 May 2008 15:53:52 +1000
Message-ID: <18475.53232.830327.694140@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



I am pleased to announce the availability of
   mdadm version 2.6.5

It is available at the usual places:
   countrycode=xx.
   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
and via git at
   git://neil.brown.name/mdadm
   http://neil.brown.name/git?p=mdadm

mdadm is a tool for creating, managing and monitoring
device arrays using the "md" driver in Linux, also
known as Software RAID arrays.

Release 2.6.5 adds a few minor bug fixes to 2.6.4

Changelog Entries:
    -   Avoid segfault when parsing /proc/mdstat with auto-read-only
	arrays.
    -   Fix problem with failing to add devices to v.large (>4TB) arrays,
	cause by problems with device-size overflow.
    -   For v0.90 superblocks, print the 'Events' count as a real count,
	not 2 numbers separated by a dot.
    -   Updates some URLs in the man page.
    -   Allow creation of a RAID6 with exactly one missing device.
    -   Use LOG_PID for syslog, so you get the pid of mdadm in the log
	files.
    -   --export now works with --examine too (not just --detail)
    -   Improve auto-creation of device special file when using
        --incremental
    -   Simple locking for --incremental so mdadm doesn't get confused
	when run concurrently with itself.
    -   Make --incremental cope better with arrays that are being reshaped.

Development of mdadm is sponsored by
 SUSE Labs, Novell Inc.

NeilBrown  15th May 2007
