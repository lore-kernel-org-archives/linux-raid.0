Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A4E80C02
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367902; cv=none; b=L6wuMWPczN7lcxy0KctzkJW3/MkviUtnDCyXxaxg5J/G8FtNzawz+nODp3zyd0TEhLHRpvSMzjfRA0mmd7SxGytfNRc5/hqYQmJ/AwloBTrgHTQ4D7CGOhqk7WqFEt1nkwq/JTGlk8F5flpwECnVdTGXKlAFSFXgZcz8tQo/e2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367902; c=relaxed/simple;
	bh=5xUPaEtqmOH8zFJI1HONRBqiaBrlA20Z+OEw6MAFYIM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hnoSuDE/xMDFJGY1Dz7wkoAZ5bot1WqM4u1EIdYolqatfdVOU6I1cuQEiHewcu08cxIf9TIscDRpttwcHIWE4qY3rZHTv0EB5JAs5YjDQhOp2luBqNRxJwr1MOcnWNoqYrJN48G9b1Di46kxle9lTOIFws0zwybOExVvBMoczVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WFqWveE1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WFqWveE1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PYaQDtJHmMpCb8zjIGzjwPFn0qKa2wuj0i0b+ergjwc=;
	b=WFqWveE1Nb2jxTo9be6DrFoK+nz3aUyU9OXOKDj7Ppcj69U/WXCwyQPaa5fjD0FPkd5cFD
	N8GmbIxvYSyyJSb/mEMVm3YMgZJZ8GnoXpWxTCZGGg9WX+yiih+5QE6wJArwNgqbtKpG/2
	TKtuVRWkn88OzTU5bj5IBS74zfVvMuc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-3ZcGD0kpPRmyWXnaHWKLzg-1; Wed,
 22 May 2024 04:51:38 -0400
X-MC-Unique: 3ZcGD0kpPRmyWXnaHWKLzg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40A5A3800089;
	Wed, 22 May 2024 08:51:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 33863C15BB1;
	Wed, 22 May 2024 08:51:35 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	heinzm@redhat.com,
	ncroxon@redhat.com
Subject: [PATCH 13/19] mdadm/tests: 05r5-internalbitmap
Date: Wed, 22 May 2024 16:50:50 +0800
Message-Id: <20240522085056.54818-14-xni@redhat.com>
In-Reply-To: <20240522085056.54818-1-xni@redhat.com>
References: <20240522085056.54818-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

It's not right to compare bitmap bits with a number after io comes.
Because maybe those bits are already flused. Remove the related
tests.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/05r5-internalbitmap | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/tests/05r5-internalbitmap b/tests/05r5-internalbitmap
index 13dc59215c1c..1a64482f11dd 100644
--- a/tests/05r5-internalbitmap
+++ b/tests/05r5-internalbitmap
@@ -9,21 +9,20 @@ mdadm -S $md0
 
 mdadm --assemble $md0 $dev1 $dev2 $dev3
 testdev $md0 2 $mdsize1 512
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
 testdev $md0 2 $mdsize1 512
 sleep 4
-dirty3=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
-if [ $dirty3 -lt 400 ]
+dirty2=`mdadm -X $dev2 | sed -n -e 's/.*Bitmap.* \([0-9]*\) dirty.*/\1/p'`
+if [ $dirty2 -lt 400 ]
 then
-   echo >&2 "ERROR dirty count $dirty3 is too small"
+   echo >&2 "ERROR dirty count $dirty2 is too small"
    exit 2
 fi
 
@@ -33,14 +32,12 @@ mdadm --assemble -R $md0  $dev2 $dev3
 mdadm --zero $dev1 # force --add, not --re-add
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
+then echo echo >&2 "ERROR bad 'dirty' counts at end: $dirty3"
   exit 1
 fi
 
-- 
2.32.0 (Apple Git-132)

