From: Neil Brown <neilb@suse.de>
Subject: ANNOUNCE: mdadm 3.0.3 - A tool for managing Soft RAID under Linux
Date: Thu, 22 Oct 2009 12:11:38 +1100
Message-ID: <19167.45386.830132.54567@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I am pleased to announce the availability of
   mdadm version 3.0.3

It is available at the usual places:
   countrycode=xx.
   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
and via git at
   git://neil.brown.name/mdadm
   http://neil.brown.name/git?p=mdadm


This contains a collection of bug fixes and minor enhancements over
3.0.2 (which itself had a single bugfix over 3.0.1 which I didn't
bother emailing an announcement about).

The brief change log is:
   -    Improvements for creating arrays giving just a name, like 'foo',
	rather than the full '/dev/md/foo'.
   -    Improvements for assembling member arrays of containers.
   -    Improvements to test suite
   -    Add option to change increment for RebuildNN messages reported
	by "mdadm --monitor"
   -    Improvements to mdmon 'hand-over' from initrd to final root.
   -    Handle merging of devices that have left an IMSM array and are
	being re-incorporated.
   -    Add missing space in "--detail --brief" output.
	
NeilBrown 22nd October 2009
