From: Neil Brown <neilb@suse.de>
Subject: ANNOUNCE: mdadm 2.6.7 - A tool for managing Soft RAID under Linux
Date: Fri, 6 Jun 2008 16:12:08 +1000
Message-ID: <18504.54584.520384.655282@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I am pleased to announce the availability of
   mdadm version 2.6.7

It is available at the usual places:
   countrycode=xx.
   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
and via git at
   git://neil.brown.name/mdadm
   http://neil.brown.name/git?p=mdadm

mdadm is a tool for creating, managing and monitoring
device arrays using the "md" driver in Linux, also
known as Software RAID arrays.

Release 2.6.7 fixes a few bugs in 2.6.5 which 2.6.6 didn't fix.

Changelog Entries:
    -   Avoid NULL reference calling free_super and elsewhere.
    -   Remove stray semicolon (Causes compile error with gcc-2.95)
    -   Fix autoassemble for stack arrays.

Development of mdadm is sponsored by
 SUSE Labs, Novell Inc.

NeilBrown  6th June 2008
