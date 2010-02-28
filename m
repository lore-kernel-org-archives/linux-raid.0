From: Luca Berra <bluca@comedia.it>
Subject: [mdadm PATCH 4/9] mdmon: check select a writable pid_dir
Date: Sun, 28 Feb 2010 15:42:57 +0100
Message-ID: <20100228144257.GC24781@maude.comedia.it>
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

Check that either VAR_DIR or ALT_DIR is actually writable before
selecting it.

Signed-off-by: Luca Berra <bluca@comedia.it>
---
  mdmon.c |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index 11b4f32..57fd492 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -480,9 +480,9 @@ static int mdmon(char *devname, int devnum, int must_fork, int takeover)
  	 */
  	if (victim > 0)
  		remove_pidfile(devname);
-	if (mkdir(VAR_RUN, 0600) >= 0 || errno == EEXIST)
+	if (mkdir(VAR_RUN, 0600) >= 0 || (errno == EEXIST && access(VAR_RUN, W_OK) >= 0))
  		pid_dir = VAR_RUN;
-	else if (mkdir(ALT_RUN, 0600) >= 0 || errno == EEXIST)
+	else if (mkdir(ALT_RUN, 0600) >= 0 || (errno == EEXIST && access(ALT_RUN, W_OK) >= 0))
  		pid_dir = ALT_RUN;
  	else {
  		fprintf(stderr, "mdmon: Neither %s nor %s are writable\n"
-- 
1.7.0


-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
