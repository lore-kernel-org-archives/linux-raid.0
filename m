From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v3] mdadm: change in add-journal support
Date: Fri, 17 Mar 2017 16:31:10 -0700
Message-ID: <20170317233111.2452831-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

I have made some confusion with previous versions of the change set, so
I would like to resend and clarify.

The very first version of this set has two patches, one for changes
in --add-journal the other for new option of --remove-journal:

http://marc.info/?l=linux-raid&m=148960265129793
http://marc.info/?l=linux-raid&m=148960267329810

After getting feedback from Shaohua, I realized that there is issue
with the add-journal patch, and the remove-journal patch is not
necessary. Therefore, I sent the second version of this set:

http://marc.info/?l=linux-raid&m=148978754820615

However, I forgot to make it clear that the first set should be discarded,
which caused confusion.

To make it clear, please discard all the patches above, and only apply the
following patch.

Thanks,
Song

Song Liu (1):
  mdadm/r5cache: allow adding journal to array without journal

 Manage.c   | 9 ---------
 mdadm.8.in | 5 ++---
 2 files changed, 2 insertions(+), 12 deletions(-)

--
2.9.3
