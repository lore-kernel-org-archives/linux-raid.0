From: Neil Brown <neilb@suse.de>
Subject: ANNOUNCE: mdadm 2.6.1 - A tool for managing Soft RAID under Linux
Date: Thu, 22 Feb 2007 15:12:24 +1100
Message-ID: <17885.6184.283089.605103@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



I am pleased to announce the availability of
   mdadm version 2.6.1

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

Release 2.6.1  adds a  few minor bug  fixes to 2.6  including improved
support for growing a RAID6 array.

Changelog Entries:
    -   --monitor was producing some meaningless warnings due to a bug.
    -   Fix some compiler warnings.
    -   Fully support --grow for raid6.  If a reshape crashed during the
	critical period, mdadm wouldn't restore the Q information
	properly.
    -   Update documentation for --grow.

Development of mdadm is sponsored by
 SUSE Labs, Novell Inc.

NeilBrown  22nd February 2007
