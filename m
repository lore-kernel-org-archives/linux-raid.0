From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: ANNOUNCE: mdadm 2.6.2 - A tool for managing Soft RAID under Linux
Date: Wed, 30 May 2007 11:43:43 +0200
Message-ID: <200705301143.43918.thomas.jarosch@intra2net.com>
References: <18001.9765.808761.531809@notabene.brown> <200705291829.54274.thomas.jarosch@intra2net.com> <18012.37348.161496.473678@notabene.brown>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_PdUXGLssr05tnAX"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18012.37348.161496.473678@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Boundary-00=_PdUXGLssr05tnAX
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Neil,

On Tuesday, 29. May 2007, you wrote:
> > cc1: warnings being treated as errors
> > sysfs.c: In function 'sysfs_read':
> > sysfs.c:97: warning: value computed is not used
> > sysfs.c:119: warning: value computed is not used
> > sysfs.c:127: warning: value computed is not used
> > sysfs.c:133: warning: value computed is not used
> > sysfs.c:139: warning: value computed is not used
> > sysfs.c:178: warning: value computed is not used
>
> Those are bogus warnings. Each is
> 	strcpy(base, "xxxxx");
> and base most certainly is used., though I can see how gcc might not
> notice if it is being too clever. Maybe you need to get gcc-4.1.2?
> or
>    make CWFLAGS=-Wall

Holger Kiehl was right, it complained about the unused return value.
Please see the attached patch.

Thomas

--Boundary-00=_PdUXGLssr05tnAX
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="mdadm-warning-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mdadm-warning-fix.patch"

diff -u -r -p mdadm-2.6.2/Detail.c mdadm.warning/Detail.c
--- mdadm-2.6.2/Detail.c	Mon May 21 06:25:50 2007
+++ mdadm.warning/Detail.c	Wed May 30 10:52:32 2007
@@ -59,7 +59,7 @@ int Detail(char *dev, int brief, int exp
 	void *super = NULL;
 	int rv = test ? 4 : 1;
 	int avail_disks = 0;
-	char *avail;
+	char *avail = NULL;
 
 	if (fd < 0) {
 		fprintf(stderr, Name ": cannot open %s: %s\n",
diff -u -r -p mdadm-2.6.2/sysfs.c mdadm.warning/sysfs.c
--- mdadm-2.6.2/sysfs.c	Thu Dec 21 06:44:22 2006
+++ mdadm.warning/sysfs.c	Wed May 30 10:55:43 2007
@@ -94,7 +94,7 @@ struct sysarray *sysfs_read(int fd, int 
 
 	sra->devs = NULL;
 	if (options & GET_VERSION) {
-		strcpy(base, "metadata_version");
+		(void)strcpy(base, "metadata_version");
 		if (load_sys(fname, buf))
 			goto abort;
 		if (strncmp(buf, "none", 4) == 0)
@@ -104,19 +104,19 @@ struct sysarray *sysfs_read(int fd, int 
 			       &sra->major_version, &sra->minor_version);
 	}
 	if (options & GET_LEVEL) {
-		strcpy(base, "level");
+		(void)strcpy(base, "level");
 		if (load_sys(fname, buf))
 			goto abort;
 		sra->level = map_name(pers, buf);
 	}
 	if (options & GET_LAYOUT) {
-		strcpy(base, "layout");
+		(void)strcpy(base, "layout");
 		if (load_sys(fname, buf))
 			goto abort;
 		sra->layout = strtoul(buf, NULL, 0);
 	}
 	if (options & GET_COMPONENT) {
-		strcpy(base, "component_size");
+		(void)strcpy(base, "component_size");
 		if (load_sys(fname, buf))
 			goto abort;
 		sra->component_size = strtoull(buf, NULL, 0);
@@ -124,19 +124,19 @@ struct sysarray *sysfs_read(int fd, int 
 		sra->component_size *= 2;
 	}
 	if (options & GET_CHUNK) {
-		strcpy(base, "chunk_size");
+		(void)strcpy(base, "chunk_size");
 		if (load_sys(fname, buf))
 			goto abort;
 		sra->chunk = strtoul(buf, NULL, 0);
 	}
 	if (options & GET_CACHE) {
-		strcpy(base, "stripe_cache_size");
+		(void)strcpy(base, "stripe_cache_size");
 		if (load_sys(fname, buf))
 			goto abort;
 		sra->cache_size = strtoul(buf, NULL, 0);
 	}
 	if (options & GET_MISMATCH) {
-		strcpy(base, "mismatch_cnt");
+		(void)strcpy(base, "mismatch_cnt");
 		if (load_sys(fname, buf))
 			goto abort;
 		sra->mismatch_cnt = strtoul(buf, NULL, 0);
@@ -175,7 +175,7 @@ struct sysarray *sysfs_read(int fd, int 
 		dev->role = strtoul(buf, &ep, 10);
 		if (*ep) dev->role = -1;
 
-		strcpy(dbase, "block/dev");
+		(void)strcpy(dbase, "block/dev");
 		if (load_sys(fname, buf))
 			goto abort;
 		sscanf(buf, "%d:%d", &dev->major, &dev->minor);

--Boundary-00=_PdUXGLssr05tnAX--
