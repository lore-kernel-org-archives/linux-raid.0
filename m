From: Kyler Laird <kyler-keyword-linuxraid00.a7e7f0@lairds.com>
Subject: Re: recovering from a controller failure
Date: Mon, 31 May 2010 13:27:34 -0500
Message-ID: <20100531182734.GB2980@flews.lairds.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I appreciate the help that everyone here has been providing with this
frustrating problem.  It looks like there's agreement that I need to
use "--force" to assemble the array with the disk devices specified. 
Here's my first cut at a command to try:
	mdadm --force --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1
	http://lairds.us/temp/ucmeng_md/suggested_recovery
I'm sure I'm missing something.  Corrections are welcome.

(It would be comforting if mdadm had a "--dry-run" option.)

Thank you, all!

--kyler
