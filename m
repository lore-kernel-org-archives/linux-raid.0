Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5772B22EE0
	for <linux-raid@vger.kernel.org>; Wed, 17 Jan 2024 18:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705515619; cv=none; b=Lm9jkq0A/zTxFmjfNTuV19MLdZgrIr0xOzcws0Qmvru1VSYafWpPdky8lp7Y0vw5L2PyiVo3EkcD7RXY/8rs85CC8t1jTiQEhRAyxZ0xP9nyI2vj4nLNKIF1GIRnaHcOspeVTka7Dd+JZRW27JupBHd4Pzb60WlRPR8OfQA1e1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705515619; c=relaxed/simple;
	bh=etaA6fhQ5wBt/qt9TCxoYJgxUmhq3AgF6IM1tgMIjUw=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Received:
	 Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type:X-Scanned-By; b=boYCpeN1cEACMmx1ELypcAxwfdcSv0/sBfgpaSUKHF4oakzlNkTKd8geXyVY0mVhn9ObvJfsdrB/WH+5gGOei6DWneyFUahH30p+lAqRK380lPNpe871SNrZiHx2sp1rGyjf1rttvhWcpGm/G/e9/5wP6J77/58qxbhebUXr8dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QVI5Cs67; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QVI5Cs67"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705515617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8ivHleY87+YYgQ50ZwaeuC85r8tVB0aEOPq+W73pVX4=;
	b=QVI5Cs67uEYOy3KUtVCQdF10HlzVTO5iiCTtsM8wYvbNjZk3mYhvqaeZIt6oGEYTe7i4le
	P2MX4/OubPSOGP8GBIATCuyZVP6b3fSYpnLw3uNxwGSJOADeaO+hj1Tem+nRFokDKWUIt4
	grVMoYj1Uf40gOsRSZsr30bOCHwVJc0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-9QVdjnIHMv67seNjxi-7sQ-1; Wed,
 17 Jan 2024 13:20:14 -0500
X-MC-Unique: 9QVdjnIHMv67seNjxi-7sQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99E021C41B21;
	Wed, 17 Jan 2024 18:20:13 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9386DFEEE;
	Wed, 17 Jan 2024 18:20:13 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 8B42E30C039C; Wed, 17 Jan 2024 18:20:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 8A80B3FB50;
	Wed, 17 Jan 2024 19:20:13 +0100 (CET)
Date: Wed, 17 Jan 2024 19:20:13 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yu Kuai <yukuai3@huawei.com>, Song Liu <song@kernel.org>, 
    David Jeffery <djeffery@redhat.com>, Li Nan <linan122@huawei.com>
cc: dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
    Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 4/7] md: call md_reap_sync_thread from __md_stop_writes
In-Reply-To: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
Message-ID: <ceeca667-ecc5-a776-8c89-9bf6facb93c9@redhat.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

The commit f52f5c71f3d4 ("md: fix stopping sync thread") breaks the LVM2
test shell/lvconvert-raid-reshape-linear_to_raid6-single-type.sh

There are many places that test for MD_RECOVERY_RUNNING or
mddev->sync_thread. If we don't reap the thread, they would be confused.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
Cc: stable@vger.kernel.org	# v6.7

---
 drivers/md/md.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -6308,6 +6308,12 @@ static void md_clean(struct mddev *mddev
 static void __md_stop_writes(struct mddev *mddev)
 {
 	stop_sync_thread(mddev, true, false);
+
+	if (mddev->sync_thread) {
+		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+		md_reap_sync_thread(mddev);
+	}
+
 	del_timer_sync(&mddev->safemode_timer);
 
 	if (mddev->pers && mddev->pers->quiesce) {

