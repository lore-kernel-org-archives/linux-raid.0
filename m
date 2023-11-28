Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i/iQCL7C"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E13DC
	for <linux-raid@vger.kernel.org>; Tue, 28 Nov 2023 10:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701195208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UEv5/FQTwAlugqAwgELzWvPZ7WGczHsdEHt1++gNw/Y=;
	b=i/iQCL7C7CKTBkXneovEvGb7jR3/Fvb5wjKhG4aoY8vzyGNkmXzjKSZ4zL7K4nXQVkiRKw
	GJrCEaiI503+ZKYmN38esghWCR9eeSmyQafonOo5KioP+FZSTadzl9Xm4i7MDAJ01JNg/H
	DrQ9yIADP09SlfIRCGgk23Z4hNQ6bVw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-8-I2kcf0jLOTu8hInmuDAC7w-1; Tue,
 28 Nov 2023 13:13:26 -0500
X-MC-Unique: I2kcf0jLOTu8hInmuDAC7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E3591C0512D;
	Tue, 28 Nov 2023 18:13:26 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.17.97])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B81351121307;
	Tue, 28 Nov 2023 18:13:25 +0000 (UTC)
From: David Jeffery <djeffery@redhat.com>
To: Song Liu <song@kernel.org>,
	linux-raid@vger.kernel.org
Cc: David Jeffery <djeffery@redhat.com>,
	Laurence Oberman <loberman@redhat.com>
Subject: [PATCH] md/raid6: use valid sector values to determine if an I/O should wait on the reshape
Date: Tue, 28 Nov 2023 13:11:39 -0500
Message-ID: <20231128181233.6187-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

During a reshape or a RAID6 array such as expanding by adding an additional
disk, I/Os to the region of the array which have not yet been reshaped can
stall indefinitely. This is from errors in the stripe_ahead_of_reshape
function causing md to think the I/O is to a region in the actively
undergoing the reshape.

stripe_ahead_of_reshape fails to account for the q disk having a sector
value of 0. By not excluding the q disk from the for loop, raid6 will always
generate a min_sector value of 0, causing a return value which stalls.

The function's max_sector calculation also uses min() when it should use
max(), causing the max_sector value to always be 0. During a backwards
rebuild this can cause the opposite problem where it allows I/O to advance
when it should wait.

Fixing these errors will allow safe I/O to advance in a timely manner and
delay only I/O which is unsafe due to stripes in the middle of undergoing
the reshape.

Fixes: 486f60558607 ("md/raid5: Check all disks in a stripe_head for reshape progress")
Signed-off-by: David Jeffery <djeffery@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/md/raid5.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dc031d42f53b..26e1e8a5e941 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5892,11 +5892,11 @@ static bool stripe_ahead_of_reshape(struct mddev *mddev, struct r5conf *conf,
 	int dd_idx;
 
 	for (dd_idx = 0; dd_idx < sh->disks; dd_idx++) {
-		if (dd_idx == sh->pd_idx)
+		if (dd_idx == sh->pd_idx || dd_idx == sh->qd_idx)
 			continue;
 
 		min_sector = min(min_sector, sh->dev[dd_idx].sector);
-		max_sector = min(max_sector, sh->dev[dd_idx].sector);
+		max_sector = max(max_sector, sh->dev[dd_idx].sector);
 	}
 
 	spin_lock_irq(&conf->device_lock);
-- 
2.43.0

