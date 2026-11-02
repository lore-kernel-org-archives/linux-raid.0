Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793615654;
	b=EIc4t6SZ1KyBhGSCboB3uoexwIvVL5Xx1G9iz6DLoIFHFftMOpRtkEHp/8r+DsJOSzyY
	 la0lPr1Dap3J4VJN8ScUThQHjQYmTRVjfkhmMjnibe9/GAX5944wLkazMHOMESU9xjXFS
	 ZV++pssJYh0R1dQrnTgZ7qxF+KRhHeUpLiE+uOTP/5cKMYPD42acTfVExKEcKX046LUyT
	 tiFjRCJ+53hONAGKZ+8Zt1cyYaOHQAJFwPs8daxYFjzq/zkgXY6i7s9cbseDUoXrYfJ//
	 ZPB+Tnn9TgmtqDL7a2AIVPc07pjKffK5uLpWf1XXeuDj5QdIiR/CgKNGlpEuCkwzmdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793615654;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3Lx5RB799LPUl/QCEDmBv3XwoKpIjZRdriPttvEFeZ8=;
	b=tyqL43cm5NAQLQgWVENCQmYZPsHS9INqP5ioIMatL5CGoKbasPE7OgYBUUE9HZVVlDbS
	 7X1V4gVh4xT96nSPiNCySFkeylu6fhPp3gKWEeCYW9mFBMW2ZUuVMxOQz5w2EDiVXKwxM
	 YhwvsfZkAaGo8v/OCp1h/Qt9y9IWZsjuB8xH4rez0Y9ku6RoTJYY5cax1Bcb38ObTSlJu
	 lLDexgwjlPxBV65F06VjuRx1AOIiEcFaSCqvvUknFLqoSnK4txHuP2uhlwDjJbt/4Nq+b
	 oXz6+TbZSkTIXJQtsSVYPQLhyhxOZxFU2PoA8jraiRIANoicJnZXh9it8tmVAMiNwkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YnOkgJeP;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=NayNW+Ia;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445B9606A324
	for <linux-raid@vger.kernel.org>; Mon,  2 Nov 2026 10:34:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 445B9606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YnOkgJeP;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=NayNW+Ia
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793615653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3Lx5RB799LPUl/QCEDmBv3XwoKpIjZRdriPttvEFeZ8=;
	b=YnOkgJePwQ20WyOE4zqf3R4C95l7EkrvqvPQBtvRNs+/k5rfz4jL3jobOp2o9uyR2r9wr7
	ZIvGJ0gUGWAvt+w2TSziq9PsjhCfOwQ9gHVw5Nh2cczsUw2nQC/sU1KyGQWTQc+rvAelSv
	ER4+diEWPcyv+s249vfABv71FjsqunE=
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com
 [74.125.82.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-GBm45Uw_OPy_yGN05Amdug-1; Mon, 02 Nov 2026 05:34:12 -0500
X-MC-Unique: GBm45Uw_OPy_yGN05Amdug-1
X-Mimecast-MFC-AGG-ID: GBm45Uw_OPy_yGN05Amdug_1793615651
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3698bd5392cso2609621eec.1
        for <linux-raid@vger.kernel.org>; Mon, 02 Nov 2026 02:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793615651; x=1794220451; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3Lx5RB799LPUl/QCEDmBv3XwoKpIjZRdriPttvEFeZ8=;
        b=NayNW+Ia3gR7boUCzDzCJpYLRDpCzlCq54RssEAUM1MLZb7lRWgARdBAhpmwI/sy5e
         sftbfa5FNfiW0hSF0IOGrrdiUnu8sS5LWSt8Y+4hxxZPeSQ50yegDabqGo/TpM+bYgG5
         xWV/oQ3NZ26Ij2zMjX5QdnIpf55oH47ysmtpXk7qYypVqjoOw6Lrh7HZvnDGVKTNA2m0
         lD9ShCj7zS7/cu19D/OWgEZA42nHJuDSxCC8oHh8apTUnhH98/LtF9i54ULE3ZR9NdEW
         h4Ov3flT36tbeQ4HEwgxKk8IB24dg4sr0847ZLlIdw1zH9CsCOuxFNfvd8unvBShiy/1
         NlDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793615651; x=1794220451;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3Lx5RB799LPUl/QCEDmBv3XwoKpIjZRdriPttvEFeZ8=;
        b=BIuvV1DribExHEeKg+a1gpxzGe9fx2D82DCkQAXgz9J0VL86ZuNwIqbhY9BwWfIFgU
         LZqmSto3fd2AE+5rPupQAtu4/NEuphl4pyBj7iHg9eG0ZNQx9gYk6i2TUdrnbE6l5sI2
         pAbQzcfn3RRcgzb2bS4papAqlxpelo0sZZ6YfBRvoxYp+e06sgo1etbp5IYbGeHS0rsP
         IyhOS7ETWdMZL6Jwrut/4tZ6iko6Cj/zBI3X68zPGjEYrnBdtOAuFIVNO9oFe6uIIBvZ
         sqI3LvOGIPdlIrbtYxQWwMUPfqXEGQAhQMRZJPHPwiPyc1oD6W2nWuMdbTJ+s4m7LeqN
         VPiQ==
X-Gm-Message-State: APuU4Z8nQrgNZQF+boRr0dXypSJsAaqxCbiA0u20NbsW4PxNuN8ueCbD
	z258gPc6Y9UPgHnBagkIVUj9mis0Qj9nueGlh3y8VPgIosKvir8zr+uzB5TqCk6PbLJnvD5MCPp
	8Gqx57hk8M1gLaXB42GALqmOuqtP7LmzYpYLz+y2p8+6uKnJ1zB/00Kzkw2D6go48UGEdIx4wFf
	1vEGOMEeasykiRRH9TGjiz0h1is/9Nuh9fO1PtS5VD6X79Hg==
X-Gm-Gg: AYBFou026Qyw+LszwOGZQPRelrUqsiwA8FM88Nn8/tn/wtANV9umJanAmczzKs2fddn
	og/BEN3WJCziUWirtwXBpo7bSuY04GvsDZ3j3krTpA/jymxrBNURyQCe4Hvpz7oaRfDOQA+Ddbd
	HsepWEnnuA/UpJbensYWrJIQcaaXWehugZCrS6Kh0vBiycAsg98uHqjquNuTrj+EPcFjoplvCXW
	164ddwIm/gWxPeSZhP0EC+Onv8cSePdrkF7poCzLLuPlXJkC0pwxaBEQNt3ErMUSDa9F5ewq5ED
	9pKBAJVwsZw4ATli28z3j+V2fie3du0QzkDBFeXVxp0Uv1bhLBjh89VSbNBci0mvtxwQ93/7JWu
	m0Xorwg7uWTjJ2tWzDM1vNYywomeKoXHVD3nAkrJqOxot+OWUUUt6hqin8u7av1YM2Y1fn6kqRi
	TSj0thvtT8DCk19bgWGJR8beSNqz2Dlt3nhnl3xPNo
X-Received: by 2002:a05:7300:26a8:b0:361:2a55:b94e with SMTP id 5a478bee46e88-36a30032646mr19684556eec.15.1793615650635;
        Mon, 02 Nov 2026 02:34:10 -0800 (PST)
X-Received: by 2002:a05:7300:26a8:b0:361:2a55:b94e with SMTP id 5a478bee46e88-36a30032646mr19684502eec.15.1793615649726;
        Mon, 02 Nov 2026 02:34:09 -0800 (PST)
Received: from mgandhi-thinkpadp16vgen1.redhat.corp ([2401:4900:88fb:4f5c:533e:8bfd:3ede:2cf9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a4294419dsm34886790eec.18.2026.11.02.02.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 02:34:09 -0800 (PST)
From: "Milan P. Gandhi" <mgandhi@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org,
	"Milan P. Gandhi" <mgandhi@redhat.com>
Subject: [PATCH] mapfile: fix relative devname resolution in resolve_md_path
Date: Mon,  2 Nov 2026 16:01:36 +0530
Message-ID: <20261102103136.163554-1-mgandhi@redhat.com>
X-Mailer: git-send-email 2.56.0
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

When an array is defined in mdadm.conf using a relative device name
(e.g., 'ARRAY customalias UUID=...'), resolve_md_path() fails to resolve
it under DEV_MD_DIR during mapfile reconstruction.

The outer condition:
    if (match && match->devname && match->devname[0] == '/')
requires the configured devname to start with '/', rendering the nested
relative path handling unreachable:
    if (path[0] != '/') {
        strcpy(namebuf, DEV_MD_DIR);
        strcat(namebuf, path);
        path = namebuf;
    }

Consequently, commands that rebuild the runtime map (such as 'mdadm
--incremental --rebuild-map') bypass the configured relative alias and
fall back to the superblock's metadata name, creating an inconsistency
with assemble-time symlink creation.

Drop the redundant 'match->devname[0] == '/'' check from the outer
conditional so relative device names configured in mdadm.conf reach the
nested block, receive the DEV_MD_DIR prefix, and resolve to
/dev/md/<name>.

Test reproduction (RAID1 created with metadata name 'origarray',
mdadm.conf configured with 'ARRAY customalias UUID=<UUID>'):

    # rm -f /run/mdadm/map /dev/md/customalias

    Before patch (unpatched mdadm):
    # mdadm --incremental --rebuild-map --config=/tmp/test_mdadm.conf
    # cat /run/mdadm/map
    md99 1.2 fb1db62a:62817869:f8c2ab3f:f422a06d /dev/md/origarray

    After patch (patched mdadm):
    # ./mdadm --incremental --rebuild-map --config=/tmp/test_mdadm.conf
    # cat /run/mdadm/map
    md99 1.2 55f91d31:c1cc4a13:a18b124d:a8b77987 /dev/md/customalias

Fixes: 360b463696e8 ("mapfile - when rebuilding, choose an appropriate name is none is found.")
Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
---
 mapfile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mapfile.c b/mapfile.c
index 2f198a92..f1cdee7a 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -381,7 +381,7 @@ static char *resolve_md_path(struct supertype *st, struct mdinfo *info, char *ho
 	struct stat stb;
 	int unum = -1;
 
-	if (match && match->devname && match->devname[0] == '/') {
+	if (match && match->devname) {
 		char *path = match->devname;
 
 		if (path[0] != '/') {
-- 
2.56.0

