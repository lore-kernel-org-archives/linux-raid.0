From: Neil Brown <neilb@suse.de>
Subject: ANNOUNCE: mdadm 2.6.6 - A tool for managing Soft RAID under Linux
Date: Mon, 19 May 2008 12:12:03 +1000
Message-ID: <18480.57843.902199.867827@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I am pleased to announce the availability of
   mdadm version 2.6.6

It is available at the usual places:
   countrycode=xx.
   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
and via git at
   git://neil.brown.name/mdadm
   http://neil.brown.name/git?p=mdadm

mdadm is a tool for creating, managing and monitoring
device arrays using the "md" driver in Linux, also
known as Software RAID arrays.

Release 2.6.6 fixes a compile problem in 2.6.5 and adds a small manpage update.

Changelog Entries:
    -   "make everything" now make mdassemble.auto
    -   fix compile problem with mdassemble.auto
    -   Update FAQ URLs in man page again.

Development of mdadm is sponsored by
 SUSE Labs, Novell Inc.

NeilBrown  19th May 2007
