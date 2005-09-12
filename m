From: Neil Brown <neilb@suse.de>
Subject: ANNOUNCE: mdadm 2.1 - A tool for managing Soft RAID under Linux
Date: Mon, 12 Sep 2005 17:42:57 +1000
Message-ID: <17189.12673.432061.932394@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



I am pleased to announce the availability of
   mdadm version 2.1

It is available at the usual places:
   http://www.cse.unsw.edu.au/~neilb/source/mdadm/
and (soon)
   http://www.{countrycode}.kernel.org/pub/linux/utils/raid/mdadm/

mdadm is a tool for creating, managing and monitoring
device arrays using the "md" driver in Linux, also
known as Software RAID arrays.

Release 2.1 fixes a few problems found after the release of 2.0.
If you are using raid10 or version-1 superblocks and upgrade is
recommended.

Specifically:
    -   Fix assembling of raid10 array when devices are missing.
	  mdadm now correctly detects if a array is workable or not
	  depending on which devices are present, and so will correctly
	  handle "--assemble --force"  if multiple devices have failed.
    -   Report raid10 layout in --examine output.
    -   Fix assembling of arrays that use the version-1 superblock and
	  have spares.  Previously the spares would be ignored.
    -   Fix bug so that multiple drives can be re-added at once.
    -   Fix problem with hot-adding a bitmap to version-1-superblock
	  arrays.


Development of mdadm is sponsored by
 SUSE Labs, Novell Inc.

NeilBrown  12th September 2005


