From: Luca Berra <bluca@comedia.it>
Subject: [mdadm PATCH 3/9] add missing newline to mdmon usage message
Date: Sun, 28 Feb 2010 15:42:24 +0100
Message-ID: <20100228144224.GB24781@maude.comedia.it>
References: <cover.1267282753.git.bluca@comedia.it> <20100228144123.GA24781@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1267282753.git.bluca@comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
List-Id: linux-raid.ids

Signed-off-by: Luca Berra <bluca@comedia.it>
---
  mdmon.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index a2b7946..11b4f32 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -244,7 +244,7 @@ static int do_fork(void)
  
  void usage(void)
  {
-	fprintf(stderr, "Usage: mdmon [--all] [--takeover] CONTAINER");
+	fprintf(stderr, "Usage: mdmon [--all] [--takeover] CONTAINER\n");
  	exit(2);
  }
  
-- 
1.7.0


-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
