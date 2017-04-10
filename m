From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 0/2] mdadm/manpage: update manpage for readonly and array-size
Date: Mon, 10 Apr 2017 16:01:36 +0800
Message-ID: <1491811296-9118-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Hi, Jes;
  These two patches is to update the description for readonly and array-size
sectors.

Thanks,
Zhilong

---

Zhilong Liu (2):
  mdadm/manpage:update description for readonly in manpage
  mdadm/manpage:clustered array doesn't support --array-size yet

 mdadm.8.in | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

-- 
2.6.6

