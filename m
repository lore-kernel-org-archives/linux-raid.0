From: FDi <fld@r00t3d.com>
Subject: creating degraded raid1 with imsm metadata
Date: Thu, 26 May 2011 10:42:59 +0300
Message-ID: <20110526074259.GA31623@r00t3d.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello *,

Since Intel's Matrix Storage Manager option ROM doesn't support creating
of degraded arrays I was wondering if I could use mdadm to make one? I
had a very hard time finding documentation about how mdadm is supposed
to work with imsm.

The plan is to make a 2x1TB raid1 with one device missing and then later 
add the other disk in once all the data has been copied to the degraded 
array. So a typical raid1 migration scenario, which Intel oddly enough 
doesn't seem to support with their option ROM.

EOF
