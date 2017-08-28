From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 0/2] mdadm patches for r5cache and mdadm.spec
Date: Mon, 28 Aug 2017 15:20:34 -0700
Message-ID: <20170828222036.3278481-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

These two patches are not related to each other. I just found
them recently.

The first patch is found when building rpm with mdadm.spec.

The send patch fixes an --incremental issue when there is
mismatch in "Events" in an array with r5cache.

Thanks,
Song

Song Liu (2):
  mdadm: install two more udev rules in mdadm.spec
  mdadm: save previous journal_clean when reload super

 Incremental.c | 3 +++
 mdadm.spec    | 2 ++
 2 files changed, 5 insertions(+)

--
2.9.5
