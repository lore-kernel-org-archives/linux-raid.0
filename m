From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 0/3] mdadm patches for some trivial fixes
Date: Tue,  5 Sep 2017 17:41:35 +0800
Message-ID: <1504604498-26048-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Hi, Jes;
  mdadm is not willing to set component size as '0' actually,
does the first patch make sense for this scenario?

Thanks,
Zhilong

Zhilong Liu (3):
  mdadm/grow: Component size must be larger than chunk size
  mdadm/manpage: disable bitmap_resize for external file bitmap
  mdadm: fixes some trivial typos in comments

 Grow.c     | 6 ++++++
 ReadMe.c   | 2 +-
 mdadm.8.in | 5 +++++
 super1.c   | 8 ++++----
 4 files changed, 16 insertions(+), 5 deletions(-)

-- 
2.6.6

