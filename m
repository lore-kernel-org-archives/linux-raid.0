From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/1] RFC: Unreliable discard performance can cripple RAID1
Date: Tue, 23 Jun 2015 20:26:12 -0400
Message-ID: <1435105573-1373-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Neil,

I have been hitting issues with discard being ridiculously slow on
arrays with certain typs of SSDs that seem to serialize discard
processing.

This is particularly bad as I have seen systems where the IMSM BIOS
defaults to 4KB chunk size, combined with these badly performing
drives, it could bump the mkfs on an array from seconds to over 40
minutes. Most users will stick to the defaults and then hit the
problem during install without understanding why it goes wrong :(

The problem is that there is no way to benchmark our way to this or
somehow test if a drive performs discard at reasonable speed. I
suggest we take an approach similar to that of RAID456 and default to
disabling discard, except for the case where the user knows the drives
are safe.

Thoughts?

Cheers,
Jes


Jes Sorensen (1):
  raid0: Disable discard per default due to performance uncertainty

 drivers/md/raid0.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

-- 
2.4.3

