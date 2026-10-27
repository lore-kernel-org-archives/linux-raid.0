Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793109875;
	b=JLDSDZwge1HIhtzwPUIXBS2lOfAHnDClo2XYx0xHJZLBeoe8O/y51T4siwVrxiAGJhaE
	 AkZT47YzBJYHJ2H+nFigAwkNi1YnzELOZwnROlzhJoDJmQ7PTQiKch1VtKvWVfh5My2PV
	 GPwbpPdfM2nhPNGkC4O7Gz7rqQvq1Om8jGrM210oGWnbY8GsAn6xV19G3+s2injiJna5P
	 WpcIZ+JQTuqjN4a2oIKAyvk/br9Jwxr6Bd5/7wThJdp9y6MUs06V0agRfEm1m04wWaa/g
	 VjVD3vPCud00303ffiGjjWXwT2RcgvsbxF+0HJ8QqQXP5/AijJK4u+MV+M6YHsXn9gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793109875;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=dcMC4C8aiIn90FkXDmWHDpW6ixktMAy9eTrhE8iyesw=;
	b=Xf29T1BSyXQ3vncsxK+LdnVfqsrs/kXDcJ8XnkOhvM34jYRmanNVjHCBZtFjHcLnt/rh
	 3DNYL60KR4C4rDuThjc6QfrFCGZPRq9NKmJ77t9Txa97cvUv5kIQ0pMUsNqrFkS9DM5BO
	 xZAde2X1H/dHoT2b3P2WZjoUjPhBDDRwLTAlq6jog3Gg2m0amCpxU2YhTf/NZO4NpXdSF
	 iYIrs5LYs792suVvWZjdqjznwFclXmvfqlGZzlEUEy/wNHEW99iLMQWCJJT/caYRT0DGQ
	 1vM4Ui2hO2EfcmatRjd5/VlEpkrLaLTCpdRLfuB3gSCK6xkWVuQ5aa0dzQNSirHBz/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rVwUo8wW;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FE9606A31A
	for <linux-raid@vger.kernel.org>; Tue, 27 Oct 2026 14:04:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50FE9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rVwUo8wW
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so20244475e9.2
        for <linux-raid@vger.kernel.org>; Tue, 27 Oct 2026 07:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793109874; x=1793714674; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dcMC4C8aiIn90FkXDmWHDpW6ixktMAy9eTrhE8iyesw=;
        b=rVwUo8wW5xJwAVNuo051WLkBfDycFG/Yn0ufnIzxcrIHyyUUaR8iMKGCADg1jAvb1j
         w9SPfdZsjVhYP0rgRu4Ql3yd1ikc2A3tsWdnSD6K3CT2BcUfSW5lBzLQqWi4VCHXb99H
         sp1jYBWqvvA6x26mapECP7NifpMGf63Nzog8QClT3pdAdoPeRu6KxcJ769x2y8RY2c+m
         BdxU71rPY7jqtZwNckWvQfPArpXHzR9u3J6vdfYTstBBkP9r9mmOwo5hE63N3YVHql7U
         H4eq1ADRAZcT7LZ0mGxWPgYJILmUK625ElUEGmAs6gst1yvOwtB0w1TU5NKWce37r9LL
         ODeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793109874; x=1793714674;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dcMC4C8aiIn90FkXDmWHDpW6ixktMAy9eTrhE8iyesw=;
        b=r2kFKRXzZIpFouXXaiEK5pnFUjfiyxuQ8cdbcfFRcog8nlKxwvkP+27TKFUgWmX9qP
         hIIkvqgwxrEGaT9jD7qQuEtHot+ArinyJK8gfFjDgEYVpS1H188x/+UObC/3MN55q7yx
         bBEtP1GuOtDiUDtYWgUyStMLQkyux3n3MFE4vJ5igvHsiYxymZevk5AlKC6HCt3HEF7b
         zeI/m8ESyMokR4tlahj9Rc+UzX32BMguuew5+9bVTeO8DeSty6kF0Um6+AGZ0ZFfFrqi
         BJ2xD1P56I8DaNeReBzGxbyRCTgSHxNTRYMzjAV2eqIOnLplxAGwzg3Ysa/WsfLcRJ5y
         uiYQ==
X-Gm-Message-State: AFq9FYIIzFj9IANYnsqVt2xctcmjPo/iQ8KCv2kWp8PetqWLQdUc14cE
	47SaZYAOBhJhvjvBUqg2ynz8tfcs2Vg5iXZUpMhmkTMzef6AP3toVURBQm2ibg==
X-Gm-Gg: AYBFou2RD2TZDY0974pC2LsMHPgbM7YCeeLUCejyGO+Uu+ngRelDA+qpy1sA9dZDHwt
	rQaXYbhgKiHgnbwe2c1ArPU+IYsMputc2s8XJid70R9nxIwKr2HBhtvpLxLanlx3JhctCT+1A5a
	HUtY8jGRCCygzBGemawHI/nqN5d6GR7soEJJ5gdDAFTktMl35fNqC9u8ueIpwLOvBa8AouWRZR6
	3bqR18dBN3g14VYc9uJ4/fQjYZ3GdGPkLmn/xxC7T+J0wm3W35LHWEkbLUBkBpENb7MNdV4lr3E
	tk3KEfh1anOoTP193QiKTPTb5efXlU2t+h/RWkOBhE4SuGMm4YlafhofGturzE4QXV51ZhXOLW7
	kO43yED/Eo9Si+LgiOELclzB7rQb08szLagbUER0Jrolf9iShr4M3VU4bMB+Z3qa6YCOjJgce3e
	vQat7PrQAgwnTx1Y1jC259aiuEM9xik3moxaSYVeahSiwYbpBMMfCyRRIpJdDL6Ie6/KSCSfgtI
	cEbGYCAeWoZqc2AouQ2hdgSm5RusvVbTLbZsFPYkDQ299TG3w==
X-Received: by 2002:a05:600c:3b96:b0:4a3:5a42:b2a4 with SMTP id 5b1f17b1804b1-4a35ac8dd4fmr233322035e9.12.1793109873296;
        Tue, 27 Oct 2026 07:04:33 -0700 (PDT)
Received: from env.. ([195.72.110.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a359f59750sm180466775e9.0.2026.10.27.07.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 07:04:32 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: blazej.kucman@graidtech.com,
	mtkaczyk@kernel.org,
	ncroxon@redhat.com,
	xni@redhat.com,
	song@kernel.org,
	yukuai@kernel.org
Cc: linux-raid@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH] mdadm: fix dangling file descriptor when calling Manage_ro
Date: Tue, 27 Oct 2026 14:04:29 +0000
Message-ID: <20261027140429.243352-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When managing an externally managed array, Manage_ro() closes the file
descriptor and writes the read-only state to the array's array_state
sysfs file. Since the file descriptor is passed by value, the caller
retains a descriptor that refers to a closed file. Any subsequent
attempt to use it will fail.

In such cases, when specifying --stop alongside --readonly, mdadm fails
to stop the array and reports "Cannot get exclusive access"

Fixes: 1b4b73fd535a ("mdadm: Manage.c fix coverity issues")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 Manage.c | 32 +++++++++++++++++++++++++-------
 mdadm.c  | 18 +++++++++++++-----
 mdadm.h  |  3 ++-
 3 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/Manage.c b/Manage.c
index 40d52cfc913b..b0ba1e31bcb0 100644
--- a/Manage.c
+++ b/Manage.c
@@ -30,7 +30,15 @@
 
 #include <ctype.h>
 
-int Manage_ro(char *devname, int fd, int readonly)
+/*
+ * Switch the array to read-only (readonly > 0) or read-write (readonly < 0).
+ *
+ * Switching to read-only may close *fd: writing "readonly" to array_state
+ * and the control node both need zero openers. *fd is then set to -1.
+ * Switching to read-write never closes *fd, it is better to use Manage_rw()
+ * for it.
+ */
+int Manage_ro(char *devname, int *fd, int readonly)
 {
 	/* switch to readonly or rw
 	 *
@@ -45,7 +53,7 @@ int Manage_ro(char *devname, int fd, int readonly)
 	/* If this is an externally-managed array, we need to modify the
 	 * metadata_version so that mdmon doesn't undo our change.
 	 */
-	mdi = sysfs_read(fd, NULL, GET_LEVEL|GET_VERSION);
+	mdi = sysfs_read(*fd, NULL, GET_LEVEL|GET_VERSION);
 	if (mdi &&
 	    mdi->array.major_version == -1 &&
 	    is_subarray(mdi->text_version)) {
@@ -58,7 +66,7 @@ int Manage_ro(char *devname, int fd, int readonly)
 			vers[MD_VER_BLOCKED_IDX] = '-';
 			sysfs_set_str(mdi, NULL, "metadata_version", vers);
 
-			close_fd(&fd);
+			close_fd(fd);
 			rv = sysfs_set_str(mdi, NULL, "array_state", "readonly");
 
 			if (rv < 0) {
@@ -86,21 +94,21 @@ int Manage_ro(char *devname, int fd, int readonly)
 		goto out;
 	}
 
-	if (!md_array_active(fd)) {
+	if (!md_array_active(*fd)) {
 		pr_err("%s does not appear to be active.\n", devname);
 		rv = 1;
 		goto out;
 	}
 
 	if (readonly > 0) {
-		if (ioctl(fd, STOP_ARRAY_RO, NULL)) {
+		if (ioctl(*fd, STOP_ARRAY_RO, NULL)) {
 			pr_err("failed to set readonly for %s: %s\n",
 				devname, strerror(errno));
 			rv = 1;
 			goto out;
 		}
 	} else if (readonly < 0) {
-		if (ioctl(fd, RESTART_ARRAY_RW, NULL)) {
+		if (ioctl(*fd, RESTART_ARRAY_RW, NULL)) {
 			pr_err("failed to set writable for %s: %s\n",
 				devname, strerror(errno));
 			rv = 1;
@@ -112,6 +120,16 @@ out:
 	return rv;
 }
 
+int Manage_rw(char *devname, int fd)
+{
+	int tmp = fd;
+	int rv = Manage_ro(devname, &tmp, -1);
+
+	/* read-write must not close the caller's fd */
+	assert(tmp == fd);
+	return rv;
+}
+
 static void remove_devices(char *devnm, char *path)
 {
 	/*
@@ -1072,7 +1090,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 		}
 		if (dv->disposition == 'j') {
 			pr_err("Journal added successfully, making %s read-write\n", devname);
-			if (Manage_ro(devname, fd, -1))
+			if (Manage_rw(devname, fd))
 				pr_err("Failed to make %s read-write\n", devname);
 		}
 
diff --git a/mdadm.c b/mdadm.c
index 2517b037c1bc..98f352afb66d 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1453,13 +1453,21 @@ int main(int argc, char *argv[])
 	case MANAGE:
 		/* readonly, add/remove, readwrite, runstop */
 		if (c.readonly > 0)
-			rv = Manage_ro(ident.devname, mdfd, c.readonly);
+			rv = Manage_ro(ident.devname, &mdfd, c.readonly);
+
+		/* Manage_ro() might have closed the md device if needed. */
+		if (!rv && mdfd < 0 && (devs_found > 1 || c.runstop)) {
+			mdfd = open_mddev(ident.devname, 1);
+			if (mdfd < 0)
+				rv = 1;
+		}
+
 		if (!rv && devs_found > 1)
 			rv = Manage_subdevs(ident.devname, mdfd,
 					    devlist->next, c.verbose,
 					    c.test, c.update, c.force);
 		if (!rv && c.readonly < 0)
-			rv = Manage_ro(ident.devname, mdfd, c.readonly);
+			rv = Manage_rw(ident.devname, mdfd);
 		if (!rv && c.runstop > 0)
 			rv = Manage_run(ident.devname, mdfd, &c);
 		if (!rv && c.runstop < 0)
@@ -2013,13 +2021,13 @@ static int misc_list(struct mddev_dev *devlist,
 				rv |= Manage_stop(dv->devname, mdfd, c->verbose, 0);
 				break;
 			case 'o':
-				rv |= Manage_ro(dv->devname, mdfd, 1);
+				rv |= Manage_ro(dv->devname, &mdfd, 1);
 				break;
 			case 'w':
-				rv |= Manage_ro(dv->devname, mdfd, -1);
+				rv |= Manage_rw(dv->devname, mdfd);
 				break;
 			}
-			close(mdfd);
+			close_fd(&mdfd);
 		} else
 			rv |= 1;
 	}
diff --git a/mdadm.h b/mdadm.h
index deac7a56f6f8..e2f725e01f9b 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1427,7 +1427,8 @@ struct stat64;
 
 extern int add_dev(const char *name, const struct stat *stb, int flag, struct FTW *s);
 
-extern int Manage_ro(char *devname, int fd, int readonly);
+extern int Manage_ro(char *devname, int *fd, int readonly);
+extern int Manage_rw(char *devname, int fd);
 extern int Manage_run(char *devname, int fd, struct context *c);
 extern int Manage_stop(char *devname, int fd, int quiet,
 		       int will_retry);
-- 
2.43.0

