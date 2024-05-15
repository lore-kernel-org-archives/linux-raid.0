Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F0A14AB4
	for <linux-raid@vger.kernel.org>; Wed, 15 May 2024 11:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715774167; cv=none; b=Izy8l72g6TlCcwrFpXo2c/wEjJfRH6jv/F9eBp7lkGMRLYUxbpkS1l6T5W/1SGxBGW3N2Apv2VFXphq1gO2pshHZH1lTQT5jUEwdQQcU83dOPuru8vGzQ/CJnZ9mIRFJh7VHCAUyJvrRyqRd4N8FJU/k4/s5WDOydO6femNORio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715774167; c=relaxed/simple;
	bh=azwj0G0LvbbR8FmE5RUdNQKFznds5u0+vZDLBZDx/eQ=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=LtoKji7CzHBrzkrnVWsLUIT4PYg5U7qxVlWmUVzYT/2XXBTjLP7gofbrhB18eE4aWac/iW7iasqm6lB/5un3XWdZMyWxYGNbUHol/fhCjVGCNONEpBEQLX2mbUoOLnfb/9fcyUvMKtNFCsW5bbmJ5/SRQXgkmagR+RESrpysV/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DHSQSP11; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DHSQSP11"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715774163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iS+jmcy4DpAj29EHcXSdb47Kk/mutq36RL0ufMSUoLQ=;
	b=DHSQSP119iPrGBZPu8dCMhvDdIdZQvPSGNlMI7yn+hWVy8i/+9o/foMpuPM5WhCM7xjZct
	a5D1SQYOZs69XPRTTe37iw+y+LU5/9plEwKho4AyQKNI1ebSgFY14TnwmKv54DYMq99/gN
	yKy8RWS7Sz36DbUm2+usQqyEsxLp5kQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-qqr4XG5CNKSsyGS1SGEhJw-1; Wed, 15 May 2024 07:56:01 -0400
X-MC-Unique: qqr4XG5CNKSsyGS1SGEhJw-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-78ed2a710efso989826885a.1
        for <linux-raid@vger.kernel.org>; Wed, 15 May 2024 04:56:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715774159; x=1716378959;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iS+jmcy4DpAj29EHcXSdb47Kk/mutq36RL0ufMSUoLQ=;
        b=X0ygXDaVPUiOMcxqY5oMQp2qQ6D7PY4NhffQoc3Ah93L8WUJ00QcjnbkPhHOrw0jVs
         wACS5c4H27/O9O6yBor3qDejGXuOKUkzsBPvdg9Zg5cSz1OuHcS28SqDzIUQoBwUTUkZ
         flo2o62Wme8zyQU253NAnvSTta66w6sixJkGoF3pL5TjbuCmLhbxBci/+anPeWcdMfGo
         H6dri9WwgeqwFwNIN30tLMgQIugoW9NQJSZ55HRrQjiDJU5TRf5Dqe2qgn4DsCubgTjw
         PLrQog1x+WvNdYm8DB4hS5SW7mvGze7lzwuW2OhejV2LY4bf3470Ij8fZsP2K3ycrIQu
         BOEA==
X-Forwarded-Encrypted: i=1; AJvYcCX5RFUlZpkjjp8Y+bCdsY+8CG/xRJ2Rg8wX6kPiEJIB3AjGYkOTvpgMr8cLAcLPrdsMrN6xly661VwEJA3vs7UGnPp8lmbQFrWKhw==
X-Gm-Message-State: AOJu0Yw8S+WXxHXu9bmQnpfs4RvFNuc6271OvBgOl2YFzooS4viIMela
	mkI3Vh0cWNXj979tRVM8PPo2FtQHNpPU+3c6dDVBbBcDDTnVhKjhlncsyq1+M+e/qgP3SVtui1M
	0NoG40mC9zlrZwKEv2z8QXe8BIbJjtclx4ZmMP6sXgzoc7c9q/4PvwJdq+LxHdkFdln8=
X-Received: by 2002:a05:620a:3bca:b0:792:9576:9592 with SMTP id af79cd13be357-792c75f0c88mr1605017785a.53.1715774159279;
        Wed, 15 May 2024 04:55:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQZTWx1OH7Meh8t1qJYo6X7XPbjSgOmATx5mO1q5UB4M/hnBjys7K3ibquCH6rrO2j8QQeMg==
X-Received: by 2002:a05:620a:3bca:b0:792:9576:9592 with SMTP id af79cd13be357-792c75f0c88mr1605016685a.53.1715774158811;
        Wed, 15 May 2024 04:55:58 -0700 (PDT)
Received: from [192.168.50.193] ([134.195.185.129])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-792bf2a35e0sm675886585a.64.2024.05.15.04.55.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 04:55:58 -0700 (PDT)
Message-ID: <bc9e94e6-96c5-411b-977b-30aea31cf9c3@redhat.com>
Date: Wed, 15 May 2024 07:55:57 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: mariusz.tkaczyk@linux.intel.com,
 "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
 Xiao Ni <xni@redhat.com>, Jes Sorensen <jes@trained-monkey.org>
From: Nigel Croxon <ncroxon@redhat.com>
Subject: [PATCH] add checking of return status on fstat calls
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

From 99c48231fe50845f622572d10fbb91a5ece0501f Mon Sep 17 00:00:00 2001
From: Nigel Croxon <ncroxon@redhat.com>
Date: Fri, 10 May 2024 09:08:02 -0400
Subject: [PATCH] add checking of return status on fstat calls

There are a few places we don't check the return status when
calling fstat for success. Clean up the calls by adding a
check before continuing.

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
  Assemble.c    | 42 +++++++++++++++++++++++-------------------
  Dump.c        | 13 +++++++++++--
  Grow.c        | 14 ++++++++++----
  config.c      |  3 ++-
  mdstat.c      |  3 ++-
  super-ddf.c   |  8 ++++++--
  super-intel.c |  8 ++++++--
  7 files changed, 60 insertions(+), 31 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index f5e9ab1f..ac22fe6e 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -652,8 +652,9 @@ static int load_devices(struct devs *devices, char 
*devmap,
              /* prepare useful information in info structures */
              struct stat stb2;
              int err;
-            fstat(mdfd, &stb2);
-
+            if (fstat(mdfd, &stb2) != 0) {
+                goto error;
+            }
              if (c->update == UOPT_UUID && !ident->uuid_set)
                  random_uuid((__u8 *)ident->uuid);

@@ -675,13 +676,10 @@ static int load_devices(struct devs *devices, char 
*devmap,
                         devname);
                  if (dfd >= 0)
                      close(dfd);
-                close(mdfd);
-                free(devices);
-                free(devmap);
                  tst->ss->free_super(tst);
                  free(tst);
                  *stp = st;
-                return -1;
+                goto error;
              }
              tst->ss->getinfo_super(tst, content, devmap + devcnt * 
content->array.raid_disks);

@@ -715,12 +713,9 @@ static int load_devices(struct devs *devices, char 
*devmap,
                             map_num(update_options, c->update), 
tst->ss->name);
                  tst->ss->free_super(tst);
                  free(tst);
-                close(mdfd);
                  close(dfd);
-                free(devices);
-                free(devmap);
                  *stp = st;
-                return -1;
+                goto error;
              }
              if (c->update == UOPT_UUID &&
                  !ident->uuid_set) {
@@ -751,18 +746,23 @@ static int load_devices(struct devs *devices, char 
*devmap,
                         devname);
                  if (dfd >= 0)
                      close(dfd);
-                close(mdfd);
-                free(devices);
-                free(devmap);
                  tst->ss->free_super(tst);
                  free(tst);
                  *stp = st;
-                return -1;
+                goto error;
              }
              tst->ss->getinfo_super(tst, content, devmap + devcnt * 
content->array.raid_disks);
          }

-        fstat(dfd, &stb);
+        if (fstat(dfd, &stb) != 0) {
+            close(dfd);
+            free(devices);
+            free(devmap);
+            tst->ss->free_super(tst);
+            free(tst);
+            *stp = st;
+            return -1;
+        }
          close(dfd);

          if (c->verbose > 0)
@@ -842,12 +842,9 @@ static int load_devices(struct devs *devices, char 
*devmap,
                         inargv ? "the list" :
                         "the\n      DEVICE list in mdadm.conf"
                      );
-                close(mdfd);
-                free(devices);
-                free(devmap);
                  free(best);
                  *stp = st;
-                return -1;
+                goto error;
              }
              if (best[i] == -1 || (devices[best[i]].i.events
                            < devices[devcnt].i.events))
@@ -863,6 +860,13 @@ static int load_devices(struct devs *devices, char 
*devmap,
      *bestp = best;
      *stp = st;
      return devcnt;
+
+error:
+    close(mdfd);
+    free(devices);
+    free(devmap);
+    return -1;
+
  }

  static int force_array(struct mdinfo *content,
diff --git a/Dump.c b/Dump.c
index 736bcb60..8186c5f8 100644
--- a/Dump.c
+++ b/Dump.c
@@ -37,6 +37,7 @@ int Dump_metadata(char *dev, char *dir, struct context *c,
      unsigned long long size;
      DIR *dirp;
      struct dirent *de;
+    int ret=0;

      if (stat(dir, &stb) != 0 ||
          (S_IFMT & stb.st_mode) != S_IFDIR) {
@@ -110,9 +111,17 @@ int Dump_metadata(char *dev, char *dir, struct 
context *c,
          free(fname);
          return 1;
      }
-    if (c->verbose >= 0)
+    if (c->verbose >= 0) {
          printf("%s saved as %s.\n", dev, fname);
-    fstat(fd, &dstb);
+        ret = fstat(fd, &dstb);
+        close(fd);
+        close(fl);
+        if (ret) {
+            unlink(fname);
+            free(fname);
+            return 1;
+        }
+    }
      close(fd);
      close(fl);
      if ((dstb.st_mode & S_IFMT) != S_IFBLK) {
diff --git a/Grow.c b/Grow.c
index 87ed9214..2321441d 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1223,13 +1223,16 @@ int reshape_open_backup_file(char *backup_file,
       * way this will not notice, but it is better than
       * nothing.
       */
-    fstat(*fdlist, &stb);
+    if (fstat(*fdlist, &stb) != 0) {
+        goto error;
+    }
      dev = stb.st_dev;
-    fstat(fd, &stb);
+    if (fstat(fd, &stb) != 0) {
+        goto error;
+    }
      if (stb.st_rdev == dev) {
          pr_err("backup file must NOT be on the array being reshaped.\n");
-        close(*fdlist);
-        return 0;
+        goto error;
      }

      memset(buf, 0, 512);
@@ -1255,6 +1258,9 @@ int reshape_open_backup_file(char *backup_file,
      }

      return 1;
+error:
+    close(*fdlist);
+    return 0;
  }

  unsigned long compute_backup_blocks(int nchunk, int ochunk,
diff --git a/config.c b/config.c
index b46d71cb..612e700d 100644
--- a/config.c
+++ b/config.c
@@ -949,7 +949,8 @@ void conf_file_or_dir(FILE *f)
      struct dirent *dp;
      struct fname *list = NULL;

-    fstat(fileno(f), &st);
+    if (fstat(fileno(f), &st) != 0)
+        return;
      if (S_ISREG(st.st_mode))
          conf_file(f);
      else if (!S_ISDIR(st.st_mode))
diff --git a/mdstat.c b/mdstat.c
index 2fd792c5..e233f094 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -348,7 +348,8 @@ void mdstat_wait_fd(int fd, const sigset_t *sigmask)

      if (fd >= 0) {
          struct stat stb;
-        fstat(fd, &stb);
+        if (fstat(fd, &stb) != 0)
+            return;
          if ((stb.st_mode & S_IFMT) == S_IFREG)
              /* Must be a /proc or /sys fd, so expect
               * POLLPRI
diff --git a/super-ddf.c b/super-ddf.c
index 21426c75..311001c1 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1053,7 +1053,10 @@ static int load_ddf_local(int fd, struct 
ddf_super *super,
               0);
      dl->devname = devname ? xstrdup(devname) : NULL;

-    fstat(fd, &stb);
+    if (fstat(fd, &stb) != 0) {
+        free(dl);
+        return 1;
+    }
      dl->major = major(stb.st_rdev);
      dl->minor = minor(stb.st_rdev);
      dl->next = super->dlist;
@@ -2786,7 +2789,8 @@ static int add_to_super_ddf(struct supertype *st,
      /* This is device numbered dk->number.  We need to create
       * a phys_disk entry and a more detailed disk_data entry.
       */
-    fstat(fd, &stb);
+    if (fstat(fd, &stb) != 0)
+        return 1;
      n = find_unused_pde(ddf);
      if (n == DDF_NOTFOUND) {
          pr_err("No free slot in array, cannot add disk\n");
diff --git a/super-intel.c b/super-intel.c
index 2b8b6fda..4d257371 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4239,7 +4239,10 @@ load_imsm_disk(int fd, struct intel_super *super, 
char *devname, int keep_fd)

      dl = xcalloc(1, sizeof(*dl));

-    fstat(fd, &stb);
+    if (fstat(fd, &stb) != 0) {
+        free(dl);
+        return 1;
+    }
      dl->major = major(stb.st_rdev);
      dl->minor = minor(stb.st_rdev);
      dl->next = super->disks;
@@ -5981,7 +5984,8 @@ static int add_to_super_imsm(struct supertype *st, 
mdu_disk_info_t *dk,
      if (super->current_vol >= 0)
          return add_to_super_imsm_volume(st, dk, fd, devname);

-    fstat(fd, &stb);
+    if (fstat(fd, &stb) != 0)
+        return 1;
      dd = xcalloc(sizeof(*dd), 1);
      dd->major = major(stb.st_rdev);
      dd->minor = minor(stb.st_rdev);
-- 
2.31.1

