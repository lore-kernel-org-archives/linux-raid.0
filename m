From: jbass@dmsd.com (John L. Bass)
Subject: RE: Robustness in the face of errors
Date: Mon, 18 Nov 2002 13:18:49 -0700 (MST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021118201849.D67251A9823@dmsd.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: andrew.r.cress@intel.com, jbass@dmsd.com, neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

	Yeah, this is logic that scsi couldn't do by itself, but md can, since it
	can recover the data.

	Also, wouldn't we want to check (and even set) the auto-reallocation
	(AWRE/ARRE) mode page bits on the drive when md loads, to let the disk do as
	much as it can with remapping?  Or does that belong outside of md?

	Andy

There are limited spare resources in a drive, which are wasted if consumed by
"normal" transient errors. It's much better to recover/rewrite the sector inside
md, and if persistant then spare the sector at the drive level.

At Fortune Systems (largest M68K Unix mfgr in early 1980's) we tried auto sparing
on first error and it completely drove us crazy when the errors were introduced by
poor power and EMI coupling. The drives that were returned, were almost always good,
it was the system environment that triggered the majority of the errors.

I've been running software raid here on a large FC array ... and a number of relatively
normal errors have repeatedly taken the raid array off-line and potentially exposed
the data to corruption since the only recover is to "mkraid -R" and accept the data
state as it is.

John
