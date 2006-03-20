From: Neil Brown <neilb@suse.de>
Subject: ANNOUNCE: mdadm 2.4-pre1 - development release for testing only
Date: Mon, 20 Mar 2006 14:59:25 +1100
Message-ID: <17438.10397.11438.191944@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



I am somewhat cautious in announcing the availability of
   mdadm version 2.4-pre1

It is available at the usual places:
   http://www.cse.unsw.edu.au/~neilb/source/mdadm/
and
   http://www.{countrycode}.kernel.org/pub/linux/utils/raid/mdadm/

pre-release 2.4-pre1 contains support for growing a raid5 array i.e.
adding extra drives and restriping the whole arrays.

This requires a kernel more recent than 2.6.16-rc6-mm2.

During a restripe, there is a crtical section at the start where a
system crash can leave the contents of the raid5 unrecoverable.  This
version of mdadm will backup that section, and can restore it when
reassembling the array after a crash.

Have fun, but use it carefully and report any problems.

NeilBrown 20th March 2006

