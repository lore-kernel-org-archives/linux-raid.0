Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D6D46522
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367867; cv=none; b=H6nH5Ig0dLZuEHlvPiJEOrxYOYn0A3ha2cY5Ep85nNilLn0K+PYM8MMGz+tKWSUh7IwBT7y0dNPW158pCupWoYwI4t4BASlcOqwivPTdf2ljTbgKFo90UBW8X67rI6PD5CrSbchJc67yU3obaEguyu8MOCcAMTbL4+S6zX2Kc10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367867; c=relaxed/simple;
	bh=G8ek2W3ZcrzHWD46DM3SvPzJ4gojbURKnEOvUGCCh/o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oaRT3JMmV30O2Dnbk4PT+2QovnHn0Ctrxs3CwsdkAy5bpsPKWEJnU0muXpd/VEos0UoiKejcFF26IMDglv9z9cPx16H/D2/xKrJFMEXoF8eY8luHaSxoKJwHcbr1CWrGGh+qU2tOwMG4IP1C7ueTYjcAwG45ccoms7G76CmK9o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XjnWNur7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XjnWNur7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XeyEQC+THPlD4t2V2CUgB4JTswNDT5/6yMxcKu8wNW8=;
	b=XjnWNur7PNO0NVoFivV/yY4qYgeuXKwzZhb5R5YWV5SQ+O5UtN6RQpRxgSVS47fVmxAIV0
	5OYh+03oYuHvPN8/RGNwxAcg63KnKVwthSkEloKWxKqMVlt1WZGtNlKgOFlpbYO6v0Jr/F
	CBJfUyhVzaln9uBcuG4QI/Du92UhiHQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-479-r6iHBsIiN0-zzJ5LxmlmNA-1; Wed,
 22 May 2024 04:51:01 -0400
X-MC-Unique: r6iHBsIiN0-zzJ5LxmlmNA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21F501C29EA1;
	Wed, 22 May 2024 08:51:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CDEB1C15BB1;
	Wed, 22 May 2024 08:50:58 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	heinzm@redhat.com,
	ncroxon@redhat.com
Subject: [PATCH 00/19] mdadm/tests: enhance/fix regression cases
Date: Wed, 22 May 2024 16:50:37 +0800
Message-Id: <20240522085056.54818-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Hi all

This is the first set which has fixed and enhanced some cases. I'll
go on fixing/enhancing the following cases.

Xiao Ni (19):
  Change some error messages to info level
  mdadm: Start update_opt from 0
  Don't control reshape speed in daemon
  mdadm/tests: test enhance
  mdadm/tests: test don't fail when systemd reports error
  mdadm/tests: names_template enhance
  mdadm/tests: 03assem-incr enhance
  mdadm/tests 03r0assem enhance
  mdadm/tests: remove 03r5assem-failed
  mdadm/tests: 03r5assemV1
  mdadm/tests: remove 04r5swap.broken
  tests/04update-metadata skip linear
  mdadm/tests: 05r5-internalbitmap
  mdadm/tests: 05r6-bitmapfile
  mdadm/tests: 06name enhance
  mdadm/tests: 07autoassemble
  mdadm/tests: 07autodetect.broken can be removed
  mdadm/tests: 07changelevelintr
  mdadm/tests: disable selinux

 Assemble.c                     | 16 ++++-------
 Grow.c                         |  7 -----
 Manage.c                       |  2 +-
 mdadm.h                        |  4 +--
 test                           | 28 +++++++++++++++----
 tests/03assem-incr             | 20 ++++++++-----
 tests/03r0assem                | 10 -------
 tests/03r5assem-failed         | 12 --------
 tests/03r5assemV1              | 17 ------------
 tests/04r5swap.broken          |  7 -----
 tests/04update-metadata        | 35 +++++++++++++----------
 tests/05r5-internalbitmap      | 21 ++++++--------
 tests/05r6-bitmapfile          | 21 ++++++--------
 tests/06name                   | 10 +++++--
 tests/07autoassemble           | 37 ++++++++++++++++++++++--
 tests/07autoassemble.broken    |  8 ------
 tests/07autodetect.broken      |  5 ----
 tests/07changelevelintr        |  9 +++---
 tests/07changelevelintr.broken |  9 ------
 tests/func.sh                  | 51 ++++++++++++++++++++++++++++++++--
 tests/templates/names_template | 14 ++++++++--
 util.c                         |  4 +--
 22 files changed, 192 insertions(+), 155 deletions(-)
 delete mode 100644 tests/03r5assem-failed
 delete mode 100644 tests/04r5swap.broken
 delete mode 100644 tests/07autoassemble.broken
 delete mode 100644 tests/07autodetect.broken
 delete mode 100644 tests/07changelevelintr.broken

-- 
2.32.0 (Apple Git-132)

