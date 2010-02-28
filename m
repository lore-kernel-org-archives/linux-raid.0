From: Luca Berra <bluca@comedia.it>
Subject: [mdadm PATCH 7/9] mdmon: move pid_dir to mdmon.c
Date: Sun, 28 Feb 2010 15:45:01 +0100
Message-ID: <20100228144501.GF24781@maude.comedia.it>
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

since it is not used elsewere anymore

Signed-off-by: Luca Berra <bluca@comedia.it>
---
  mdadm.h |    1 -
  mdmon.c |    2 ++
  util.c  |    1 -
  3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 7efa8bf..825e3c2 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -895,7 +895,6 @@ extern int create_mddev(char *dev, char *name, int autof, int trustworthy,
  extern int open_mddev(char *dev, int report_errors);
  extern int open_container(int fd);
  
-extern char *pid_dir;
  extern int mdmon_running(int devnum);
  extern int mdmon_pid(int devnum, const char *pid_dir);
  extern int check_env(char *name);
diff --git a/mdmon.c b/mdmon.c
index 3627a80..eef4bfa 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -71,6 +71,8 @@ int mon_tid, mgr_tid;
  
  int sigterm;
  
+static char *pid_dir = VAR_RUN;
+
  int run_child(void *v)
  {
  	struct supertype *c = v;
diff --git a/util.c b/util.c
index c22886b..800d4b2 100644
--- a/util.c
+++ b/util.c
@@ -1463,7 +1463,6 @@ int fd2devnum(int fd)
  	return NoMdDev;
  }
  
-char *pid_dir = VAR_RUN;
  
  int mdmon_pid(int devnum, const char *pid_dir)
  {
-- 
1.7.0


-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
