From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: Suspend_hi mamagment during reshape
Date: Thu, 9 Dec 2010 08:42:35 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176A1B088@irsmsx503.ger.corp.intel.com>
References: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
	<20101206132108.21125.54920.stgit@gklab-170-024.igk.intel.com>
	<20101208141016.437dfd2d@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D17676EAED@irsmsx503.ger.corp.intel.com>
 <20101209090558.32f48daa@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101209090558.32f48daa@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Hi,

I've got a problem with suspend_hi management during check-pointing, as we discuss this a while ago.

Currently, I've corrected check-pointing in the way that mdmon sets suspend_hi to the place that sync_max is set in current pass to guard access.
This assumption looks for me ok in general, problem is when mdadm decides to set sync_max to max. mdmon cannot set max due to fact that this would block
rest of array to user. This means that mdmon should move sync_max and suspend_hi in parallel through the rest of array by some distances.
This can gives us additional opportunities to store checkpoints. I would like to know your opinion about such solution.

Second problem is about cleanup after reshape. 
From uses space after reshape, I'm not able to set suspend_hi to 0. This is up to suspend_hi_store() checks.(suspend_lo cannot be set to 0, and suspend_hi cannot be less than suspend_lo).
I think that part of Maciek's patch should be applied to md in raid5.c, so at the end of raid5_finish_reshape() the following code should be placed:

if (mddev->external) {
	mddev->suspend_hi = 0;
	mddev->suspend_lo = 0;
	mddev->pers->quiesce(mddev, 1);
	mddev->pers->quiesce(mddev, 0);
}

The other option is accept for setting suspend_lo/hi to 0 when there is no array processing (reshape), but first change I think is better.
What is your opinion?

BR
Adam

