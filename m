From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] md: Deletion of a few unnecessary checks
Date: Mon, 02 Feb 2015 16:11:55 +0100
Message-ID: <54CF93BB.40206@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 2 Feb 2015 15:51:43 +0100

Further update suggestions were taken into account together with results
from static source code analysis.

Markus Elfring (3):
  dm snapshot: Deletion of unnecessary checks before the function call "vfree"
  md/bitmap: Delete an unnecessary check before the function call "kfree"
  dm ioctl: Delete an unnecessary check before the function call "dm_table_destroy"

 drivers/md/bitmap.c             | 10 +++++-----
 drivers/md/dm-ioctl.c           |  3 +--
 drivers/md/dm-snap-persistent.c | 14 ++++----------
 3 files changed, 10 insertions(+), 17 deletions(-)

-- 
2.2.2

