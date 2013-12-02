From: Wakko Warner <wakko@animx.eu.org>
Subject: Creating new raid5 or 6 with --assume-clean
Date: Sun, 1 Dec 2013 22:07:07 -0500
Message-ID: <20131202030707.GB19621@animx.eu.org>
Reply-To: Wakko Warner <wakko@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a general question, but I'll give a specific.

If I create an array with assume clean and proceed to write to the device,
what happens with the parity?

EX:
mdadm -C /dev/md0 -n 4 -l 6 -e 1.0 -b internal -c 128 --assume-clean \
	sdc2 sdd2 sdf2 sde2

Then:
dd if=/dev/zero of=/dev/md0 bs=1M

When it finishes, will all the parity blocks be correct for raid 5 and
raid6?

Would changing md/stripe_cache_size up/down make a difference to the
parities?

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
