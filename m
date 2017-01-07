From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/1] md/raid5 - fix build error
Date: Fri,  6 Jan 2017 19:31:34 -0500
Message-ID: <20170107003135.8276-1-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

commit 6995f0b247e15e34fbcd10852c08b30bdc1a78da
Author: Shaohua Li <shli@fb.com>
Date:   Thu Dec 8 15:48:17 2016 -0800

    md: takeover should clear unrelated bits

Introduced a bug comparing a pointer against an integer, which fails
the build when stricter checking is in place. This should ideally be
included in 4.10.

Cheers,
Jes

Jes Sorensen (1):
  md/raid5: Use correct IS_ERR() variation on pointer check

 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.9.3

