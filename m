Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD74B170845
	for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 13:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716904320; cv=none; b=IrdDYspMSaUz6Iy6wxDCoqiZQ9o+7wbsFWBOCO/y2yX2cs01vjgP7DEX+Qp2KO3m6Z9okPttyMSiCX+Z3NcaWOzx0XxkKOsEts+SQo5S3QeablK3Q1VT11IADnpi0V5gF9cpRNBlSYfIQ7KhwdC9RTQ0AOxe3s4t9umquo421yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716904320; c=relaxed/simple;
	bh=YW64+hrRV4fnjsHUZd94cr39m4v3d2sa8FHVHsR1YF8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GqJiythqeG4FGH2OD4podZA8CDqKOoWQ7V7+At1wp5zkL/wVq/XmsThZKCs3VWoYsdfn3WpOU1MRbzgaIWHTMadrk9J1jGWavwlWfoczZ2AmBdA8fegVPJ5as6YOyKdsqpm3qbZMUe+CJlvhHgdQRLmhfPU0DqaP0favX3uNXx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WyL55SZz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WyL55SZz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716904317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5W+Wd7fy40YYrlcNM6OqhH3hDsOtF6bFuUzol0sl0O8=;
	b=WyL55SZzuC7vgsmM9arzI1tSGtJmQyLRk2DCn9ImTLHGgCRv9yUPMz15cJVf7iIYm1D4El
	jEe7VkuUCScFiHqk/3WoowQBgWlDMhz/Tn//waXnmud+X1zgzUS/efW//uME+wIXa0zTKW
	zOS87GKnJGrhBC6ycKC7Z9wpJ3MKibk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-332-2c849KxNOA6G7dXqJfgItw-1; Tue,
 28 May 2024 09:51:56 -0400
X-MC-Unique: 2c849KxNOA6G7dXqJfgItw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3645A29AA382;
	Tue, 28 May 2024 13:51:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C9DF940005C;
	Tue, 28 May 2024 13:51:54 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org
Subject: [PATCH 1/4] mdadm/tests: bitmap cases enhance
Date: Tue, 28 May 2024 21:51:47 +0800
Message-Id: <20240528135150.26823-2-xni@redhat.com>
In-Reply-To: <20240528135150.26823-1-xni@redhat.com>
References: <20240528135150.26823-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

It fails because bitmap dirty number is smaller than 400 sometimes. It's not
good to compare bitmap dirty bits with a number. It depends on the test
machine, it can flush soon before checking the number. So remove related codes.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/05r1-grow-internal      | 11 ++++-------
 tests/05r1-grow-internal-1    | 12 ++++--------
 tests/05r1-internalbitmap     | 22 ++++++++++------------
 tests/05r1-internalbitmap-v1a | 22 ++++++++++------------
 tests/05r1-internalbitmap-v1b | 23 ++++++++++-------------
 tests/05r1-internalbitmap-v1c | 22 ++++++++++------------
 6 files changed, 48 insertions(+), 64 deletions(-)

diff --git a/tests/05r1-grow-internal b/tests/05r1-grow-internal
index 24b3aece2bfd..f7fff989a9ce 100644
--- a/tests/05r1-grow-internal
+++ b/tests/05r1-grow-internal
@@ -8,18 +8,15 @@ testdev $md0 1 $mdsize1a 64
 
 #mdadm -E $dev1
 mdadm --grow $md0 --bitmap=internal --bitmap-chunk=4 --delay=1 || { mdadm -X $dev2 ; exit 1; }
-dirty1=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 sleep 4
-dirty2=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
+dirty1=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 
 testdev $md0 1 $mdsize1a 64
-dirty3=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 sleep 4
-dirty4=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
+dirty2=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 
-#echo $dirty1 $dirty2 $dirty3 $dirty4
-if [ $dirty2 -ne 0 -o $dirty4 -ne 0 -o $dirty3 -lt 400 ]
-then
+if [ $dirty1 -ne 0 -o $dirty2 -ne 0 ]
+then  echo >&2 "ERROR bad 'dirty' counts: dirty1 $dirty1, dirty2 $dirty2"
    echo bad dirty counts
    exit 1
 fi
diff --git a/tests/05r1-grow-internal-1 b/tests/05r1-grow-internal-1
index 2f0d82376164..f0f8349f8ccf 100644
--- a/tests/05r1-grow-internal-1
+++ b/tests/05r1-grow-internal-1
@@ -8,19 +8,15 @@ testdev $md0 1 $mdsize1b 64
 
 #mdadm -E $dev1
 mdadm --grow $md0 --bitmap=internal --bitmap-chunk=4 --delay=1
-dirty1=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 sleep 4
-dirty2=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
+dirty1=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 
 testdev $md0 1 $mdsize1b 64
-dirty3=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 sleep 4
-dirty4=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
+dirty2=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 
-#echo $dirty1 $dirty2 $dirty3 $dirty4
-if [ $dirty2 -ne 0 -o $dirty4 -ne 0 -o $dirty3 -lt 400 ]
-then
-   echo bad dirty counts
+if [ $dirty1 -ne 0 -o $dirty2 -ne 0 ]
+then  echo >&2 "ERROR bad 'dirty' counts: dirty1 $dirty1, dirty2 $dirty2"
    exit 1
 fi
 
diff --git a/tests/05r1-internalbitmap b/tests/05r1-internalbitmap
index dd7232a7ad5a..f1a2843efa10 100644
--- a/tests/05r1-internalbitmap
+++ b/tests/05r1-internalbitmap
@@ -9,21 +9,20 @@ mdadm -S $md0
 
 mdadm --assemble $md0 $dev1 $dev2
 testdev $md0 1 $mdsize0 64
-dirty1=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 sleep 4
-dirty2=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
+dirty1=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 
-if [ $dirty1 -lt 400 -o $dirty2 -ne 0 ]
-then  echo >&2 "ERROR bad 'dirty' counts: $dirty1 and $dirty2"
+if [ $dirty1 -ne 0 ]
+then  echo >&2 "ERROR bad 'dirty' counts: $dirty1"
   exit 1
 fi
 mdadm $md0 -f $dev1
 testdev $md0 1 $mdsize0 64
 sleep 4
-dirty3=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
-if [ $dirty3 -lt 400 ]
-then
-   echo >&2 "ERROR dirty count $dirty3 is too small"
+total=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) bits.*/\1/p'`
+dirty2=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
+if [ $dirty2 -ne $total ]
+then  echo >&2 "ERROR bad 'dirty' counts: total $total, dirty2 $dirty2"
    exit 2
 fi
 
@@ -34,13 +33,12 @@ mdadm --zero-superblock $dev1
 mdadm $md0 --add $dev1
 check recovery
 
-dirty4=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 check wait
 sleep 4
-dirty5=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
+dirty3=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 
-if [ $dirty4 -lt 400 -o $dirty5 -ne 0 ]
-then echo echo >&2 "ERROR bad 'dirty' counts at end: $dirty4 $dirty5"
+if [ $dirty3 -ne 0 ]
+then  echo >&2 "ERROR bad 'dirty' counts: $dirty3"
   exit 1
 fi
 
diff --git a/tests/05r1-internalbitmap-v1a b/tests/05r1-internalbitmap-v1a
index 3ddc082feafc..cf3f39722d83 100644
--- a/tests/05r1-internalbitmap-v1a
+++ b/tests/05r1-internalbitmap-v1a
@@ -10,21 +10,20 @@ mdadm -S $md0
 
 mdadm --assemble $md0 $dev1 $dev2
 testdev $md0 1 $mdsize1b 64
-dirty1=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 sleep 4
-dirty2=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
+dirty1=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 
-if [ $dirty1 -lt 400 -o $dirty2 -ne 0 ]
-then  echo >&2 "ERROR bad 'dirty' counts: $dirty1 and $dirty2"
+if [ $dirty1 -ne 0 ]
+then  echo >&2 "ERROR bad 'dirty' counts: $dirty1"
   exit 1
 fi
 mdadm $md0 -f $dev1
 testdev $md0 1 $mdsize1b 64
 sleep 4
-dirty3=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
-if [ $dirty3 -lt 400 ]
-then
-   echo >&2 "ERROR dirty count $dirty3 is too small"
+total=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) bits.*/\1/p'`
+dirty2=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
+if [ $dirty2 -ne $total ]
+then  echo >&2 "ERROR bad 'dirty' counts: total $total, dirty2 $dirty2"
    exit 2
 fi
 
@@ -35,13 +34,12 @@ mdadm --assemble -R $md0  $dev2
 mdadm $md0 --add $dev1
 check recovery
 
-dirty4=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 check wait
 sleep 4
-dirty5=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
+dirty3=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 
-if [ $dirty4 -lt 400 -o $dirty5 -ne 0 ]
-then echo echo >&2 "ERROR bad 'dirty' counts at end: $dirty4 $dirty5"
+if [ $dirty3 -ne 0 ]
+then  echo >&2 "ERROR bad 'dirty' counts: $dirty3"
   exit 1
 fi
 
diff --git a/tests/05r1-internalbitmap-v1b b/tests/05r1-internalbitmap-v1b
index 40f7abea46a3..4952887e8ab9 100644
--- a/tests/05r1-internalbitmap-v1b
+++ b/tests/05r1-internalbitmap-v1b
@@ -11,21 +11,20 @@ mdadm -S $md0
 mdadm --assemble $md0 $dev1 $dev2
 check bitmap
 testdev $md0 1 $mdsize11 64
-dirty1=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 sleep 4
-dirty2=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
+dirty1=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 
-if [ $dirty1 -lt 400 -o $dirty2 -ne 0 ]
-then  echo >&2 "ERROR bad 'dirty' counts: $dirty1 and $dirty2"
+if [ $dirty1 -ne 0 ]
+then  echo >&2 "ERROR bad 'dirty' counts: $dirty1"
   exit 1
 fi
 mdadm $md0 -f $dev1
 testdev $md0 1 $mdsize11 64
 sleep 4
-dirty3=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
-if [ $dirty3 -lt 400 ]
-then
-   echo >&2 "ERROR dirty count $dirty3 is too small"
+total=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) bits.*/\1/p'`
+dirty2=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
+if [ $dirty2 -ne $total ]
+then  echo >&2 "ERROR bad 'dirty' counts: total $total, dirty2 $dirty2"
    exit 2
 fi
 
@@ -35,14 +34,12 @@ mdadm --zero-superblock $dev1
 mdadm --assemble -R $md0  $dev2
 mdadm $md0 --add $dev1
 check recovery
-
-dirty4=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 check wait
 sleep 4
-dirty5=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
+dirty3=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 
-if [ $dirty4 -lt 400 -o $dirty5 -ne 0 ]
-then echo echo >&2 "ERROR bad 'dirty' counts at end: $dirty4 $dirty5"
+if [ $dirty3 -ne 0 ]
+then  echo >&2 "ERROR bad 'dirty' counts: $dirty3"
   exit 1
 fi
 
diff --git a/tests/05r1-internalbitmap-v1c b/tests/05r1-internalbitmap-v1c
index 2eaea59b79c0..e1e4472f0929 100644
--- a/tests/05r1-internalbitmap-v1c
+++ b/tests/05r1-internalbitmap-v1c
@@ -10,21 +10,20 @@ mdadm -S $md0
 
 mdadm --assemble $md0 $dev1 $dev2
 testdev $md0 1 $mdsize12 64
-dirty1=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 sleep 4
-dirty2=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
+dirty1=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 
-if [ $dirty1 -lt 400 -o $dirty2 -ne 0 ]
-then  echo >&2 "ERROR bad 'dirty' counts: $dirty1 and $dirty2"
+if [ $dirty1 -ne 0 ]
+then  echo >&2 "ERROR bad 'dirty' counts: $dirty1"
   exit 1
 fi
 mdadm $md0 -f $dev1
 testdev $md0 1 $mdsize12 64
 sleep 4
-dirty3=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
-if [ $dirty3 -lt 400 ]
-then
-   echo >&2 "ERROR dirty count $dirty3 is too small"
+total=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) bits.*/\1/p'`
+dirty2=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
+if [ $dirty2 -ne $total ]
+then  echo >&2 "ERROR bad 'dirty' counts: total $total, dirty2 $dirty2"
    exit 2
 fi
 
@@ -35,13 +34,12 @@ mdadm --assemble -R $md0  $dev2
 mdadm $md0 --add $dev1
 check recovery
 
-dirty4=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 check wait
 sleep 4
-dirty5=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
+dirty3=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
 
-if [ $dirty4 -lt 400 -o $dirty5 -ne 0 ]
-then echo echo >&2 "ERROR bad 'dirty' counts at end: $dirty4 $dirty5"
+if [ $dirty3 -ne 0 ]
+then  echo >&2 "ERROR bad 'dirty' counts: $dirty3"
   exit 1
 fi
 
-- 
2.32.0 (Apple Git-132)

