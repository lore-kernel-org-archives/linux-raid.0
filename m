From: Jes.Sorensen@redhat.com
Subject: [PATCH 08/13] Handle malloc() failures in devline()
Date: Wed, 26 Oct 2011 17:30:21 +0200
Message-ID: <1319643026-11501-9-git-send-email-Jes.Sorensen@redhat.com>
References: <1319643026-11501-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319643026-11501-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

In addition let the error ripple down and handle it in the calling
functions.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 config.c |   99 +++++++++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 73 insertions(+), 26 deletions(-)

diff --git a/config.c b/config.c
index c0a6baa..97c39e6 100644
--- a/config.c
+++ b/config.c
@@ -179,6 +179,11 @@ struct mddev_dev *load_partitions(void)
 		if (!name)
 			continue;
 		d = malloc(sizeof(*d));
+		if (!d) {
+			fprintf(stderr, Name ": %s unable to allocate memory\n",
+				__func__);
+			continue;
+		}
 		d->devname = strdup(name);
 		d->next = rv;
 		d->used = 0;
@@ -343,15 +348,22 @@ static void createline(char *line)
 	}
 }
 
-void devline(char *line)
+int devline(char *line)
 {
 	char *w;
 	struct conf_dev *cd;
+	int rv = 0;
 
 	for (w=dl_next(line); w != line; w=dl_next(w)) {
 		if (w[0] == '/' || strcasecmp(w, "partitions") == 0 ||
 		    strcasecmp(w, "containers") == 0) {
 			cd = malloc(sizeof(*cd));
+			if (!cd) {
+				fprintf(stderr, Name ": %s unable to allocate "
+					"memory\n", __func__);
+				rv = -ENOMEM;
+				goto fail;
+			}
 			cd->name = strdup(w);
 			cd->next = cdevlist;
 			cdevlist = cd;
@@ -360,6 +372,15 @@ void devline(char *line)
 				w);
 		}
 	}
+out:
+	return rv;
+fail:
+	while(cdevlist) {
+		cd = cdevlist->next;
+		free(cdevlist);
+		cdevlist = cd;
+	}
+	goto out;
 }
 
 struct mddev_ident *mddevlist = NULL;
@@ -711,7 +732,7 @@ void autoline(char *line)
 	free(seen);
 }
 
-int loaded = 0;
+static int loaded = 0;
 
 static char *conffile = NULL;
 void set_conffile(char *file)
@@ -719,27 +740,34 @@ void set_conffile(char *file)
 	conffile = file;
 }
 
-void load_conffile(void)
+int load_conffile(void)
 {
 	FILE *f;
 	char *line;
+	int rv = 0;
 
-	if (loaded) return;
+	if (loaded > 0)
+		return rv;
+	if (loaded < 0)
+		return loaded;
 	if (conffile == NULL)
 		conffile = DefaultConfFile;
 
 	if (strcmp(conffile, "none") == 0) {
 		loaded = 1;
-		return;
+		return rv;
 	}
 	if (strcmp(conffile, "partitions")==0) {
 		char *list = dl_strdup("DEV");
 		dl_init(list);
 		dl_add(list, dl_strdup("partitions"));
-		devline(list);
+		rv = devline(list);
 		free_line(list);
-		loaded = 1;
-		return;
+		if (!rv)
+			loaded = 1;
+		else
+			loaded = -1;
+		return rv;
 	}
 	f = fopen(conffile, "r");
 	/* Debian chose to relocate mdadm.conf into /etc/mdadm/.
@@ -753,14 +781,20 @@ void load_conffile(void)
 		if (f)
 			conffile = DefaultAltConfFile;
 	}
-	if (f == NULL)
-		return;
+	if (f == NULL) {
+		rv = -errno;
+		goto out;
+	}
 
 	loaded = 1;
 	while ((line=conf_line(f))) {
 		switch(match_keyword(line)) {
 		case Devices:
-			devline(line);
+			rv = devline(line);
+			if (rv) {
+				loaded = -1;
+				goto out;
+			}
 			break;
 		case Array:
 			arrayline(line);
@@ -795,47 +829,60 @@ void load_conffile(void)
 		free_line(line);
 	}
 
+out:
 	fclose(f);
-
-/*    printf("got file\n"); */
+	return rv;
 }
 
 char *conf_get_mailaddr(void)
 {
-	load_conffile();
-	return alert_email;
+	if (!load_conffile())
+		return alert_email;
+	else
+		return NULL;
 }
 
 char *conf_get_mailfrom(void)
 {
-	load_conffile();
-	return alert_mail_from;
+	if (!load_conffile())
+		return alert_mail_from;
+	else
+		return NULL;
 }
 
 char *conf_get_program(void)
 {
-	load_conffile();
-	return alert_program;
+	if (!load_conffile())
+		return alert_program;
+	else
+		return NULL;
 }
 
 char *conf_get_homehost(int *require_homehostp)
 {
-	load_conffile();
-	if (require_homehostp)
-		*require_homehostp = require_homehost;
-	return home_host;
+	if (!load_conffile()) {
+		if (require_homehostp)
+			*require_homehostp = require_homehost;
+		return home_host;
+	} else
+		return NULL;
 }
 
 struct createinfo *conf_get_create_info(void)
 {
-	load_conffile();
-	return &createinfo;
+	if (!load_conffile())
+		return &createinfo;
+	else
+		return NULL;
 }
 
 struct mddev_ident *conf_get_ident(char *dev)
 {
 	struct mddev_ident *rv;
-	load_conffile();
+	int r;
+	r = load_conffile();
+	if (r)
+		return NULL;
 	rv = mddevlist;
 	while (dev && rv && (rv->devname == NULL
 			     || !devname_matches(dev, rv->devname)))
-- 
1.7.6.4

