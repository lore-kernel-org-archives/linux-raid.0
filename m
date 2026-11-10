Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794289506;
	b=o8Twvvgcop+bli4fEHdje/hG9yZAYxlntcl9y2pYpBWtX8hT64S9zwmF2tvF/SFhR2I8
	 66a9VQJstVynlCP1AusIVDQIHkrD1hkHgjcJkqN2yDc04czSQK7mPMymik9W3SNJOmGul
	 JM0dS3o4PZXBaZls98EZIriOKd2ffxz4AldbW8yiTLqIxWPizGMJ5IaiPjZXTynHc6mXM
	 nA46jrqs0cmiUrmOrfGmcbrAo+Mi+RNaf3s2+zobsQJQCUTccVyAKWwlrJuzIKIMksv3m
	 L3sx5/yW9siL1QNgCyvHuLSHYB063uolpdwoBQWAQDb6q20Q6dfGhivVgNZ8yL9Nghg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794289506;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p+m90ZHP6p5x4AVs4ojsWRq2UWvQJVYuVb7I16eMYE0=;
	b=WpeJeJjjBuE+6Y1xj+fIRGElslVuTY1VFcKHRJhxHRt+6kCMKVoiEVNYnQPnvZOWYvnr
	 p0+kXPiBLXKYM7om/VN7q34zOOAwBSFRk5b0lPIB8/0W8vxvbJw2bZJcFFpPt0qFAPocc
	 VDQ5coQwxQCApxoiTkIxVeZQ0SRP7zA8kqw8fBJ7lfaUN88sk1vVSyRZiUrSknF8MFcnW
	 QtlQio4gvL83fQ2jdHvPDbkyEd6BdutOl1clVn1PMV+cnHXfnAc3uhqiaXWRyUc/mPubn
	 gKmgBSKfOM4//Boi8aZtjB+Y6nOAWAgiDTcQ1kFOFbGRni0OOisXHrLfpvRqRnSJc4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CnZ8C7h5;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D44606A330
	for <linux-raid@vger.kernel.org>; Tue, 10 Nov 2026 05:45:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0D44606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CnZ8C7h5
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48e47347279so1000364f8f.1
        for <linux-raid@vger.kernel.org>; Mon, 09 Nov 2026 21:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794289504; x=1794894304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p+m90ZHP6p5x4AVs4ojsWRq2UWvQJVYuVb7I16eMYE0=;
        b=CnZ8C7h5094DmlshNeGptAMnvcSxnLAeyMg8K/R3q+alRDLFABRomdJnRcergKmB3S
         51RfVxdzAx82FnvV3pyNPgZcTOcTei24JRyX4rc5R+0h5RDUc/Dt9iTqrob60+wuwzBz
         ZpMM4yiGR0SZ7TlAjZLozlqJbWctfFkfa7yeHINDvW41NcJN/Frae+iLfbX8OBnJZHqh
         2wMLhFOlWcp/DI23lfYsIQ+062ENiDQPILuRF8eMUu5IjwhyRf3sT8HBBLwHOZuenMDn
         11mcSyLPcR1eDkjPct+01O2JlNKgiEYjfI41OdXC8KJ0obKKrprZHdHl1xdHGru0rZLv
         63mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289504; x=1794894304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=p+m90ZHP6p5x4AVs4ojsWRq2UWvQJVYuVb7I16eMYE0=;
        b=DabZ3Yp7bt4TBlorejQpHfCre2uWf3bUsH+2z1jPPdgtIbhStl3DvOQ5w51Ld5K8OB
         xMR3bfwYZPRfI5lFcNGXCOrRqXZkSSVjG41+cjFj6mjaK4uBLR4a6f4FcTt7J6efjqP9
         qAET9tHQgAOUEKK1ufEe+JutrOqYLe3ayk1ysd6DqhWBfOSD5c/HVdRfq4vLWnY81cUR
         +PGHhInLWNPR1vmNIk9tyFtJKtDewFQAUXfNMVHAYtNBItNabR42s959TmE3FoJh3Zig
         iLN2vz7OImImeaTmPlwEvryL38dEX7kq1Dtg2yGj5Kf+Qt92flLFfpNpkkxg07OpFrGK
         5KVA==
X-Forwarded-Encrypted: i=1; AL+hErFosBUDegh9s2RUJIAVZV530u2yYBEV0WFyOJhTubiDfiTGuXIl3mczlFLTiItxAKwTSpNu01XRvAVi@vger.kernel.org
X-Gm-Message-State: APuU4Z+Sc3oOU6dm82whXyfcfBEYeprhrTgpl8rZhf5ntrlD6EGJPp66
	7VbiTx6HAefFpO0K1/TtblwCM7p70bSd0t01AfAmYRXkc+mXW3Cft/Qy
X-Gm-Gg: AYBFou2hvfcqxfke5T/FI3J5ibEapAcfsNR2BwxN9DY3vUlzNffPI+H+PPxaxw61kEu
	De+6PGX176oc8hcHG8nRdELLKsVlym1OnntzG2kYRpDN6hIafhXmkm5HjnFmDzx467QfvYs4OXi
	s6DqFzx4Nwy5qgtyeDzUmFG8X7zDUPmj/oLp3MkNrnWgwnZVYAblQxvC8qHW3aOJ7xgfneFdENl
	+10W8NX+eKtuJRxtfypCC7YrEb3xqJA4RhZCX1QZdhYJM4Ny1Ldeumba/JXwuE22fOWK5W6KfpM
	sBW8Z+HWgSKy7XgqdCWMpQJ5mWqAR94zLXX6/w+fLrFLstABn+lR1et8HzIdh+CRs01RKeYD8GE
	xA3hHSwN2MUZVMO4LrZjTbJm304dTypIKEFkn3Ut3sr5Xa4/HAjGMps/or9Onqx6HS+O+xIhEHV
	9A45MGTwNyYEAMGk68qbX3/viNKgGJHuC86OA0DpEPgmkX07lgdD+DeCqRqqB4hwSGgdElYtEZH
	i0dB1GgaqZNKhJxWSvnnbgsMe1L4vbMMnAKMnBxBYN/0NNKNttyJ9LtfK0wASp6nilXQ+xkIqvw
	DOqfQlgnjrJP1Y1DKycPlpszlsBVs+HL9vAmu3M4YufWkWHebnHUhfu4sinjU0NoUFA399sAriZ
	EFaVohoFxjd05+w==
X-Received: by 2002:a05:6000:2482:b0:48e:353b:9f28 with SMTP id ffacd0b85a97d-4982b28ac5emr3169751f8f.1.1794289504112;
        Mon, 09 Nov 2026 21:45:04 -0800 (PST)
Received: from DESKTOP-OL07BOP.localdomain (109-92-113-33.dynamic.isp.telekom.rs. [109.92.113.33])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498365cbfc6sm3083123f8f.41.2026.11.09.21.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:45:03 -0800 (PST)
From: Hristos Nenkov <nenkov2004@gmail.com>
To: Song Liu <song@kernel.org>,
	linux-raid@vger.kernel.org
Cc: Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	NeilBrown <neil@brown.name>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	syzbot+8b22a0459202f76b4096@syzkaller.appspotmail.com,
	Hristos Nenkov <nenkov2004@gmail.com>
Subject: [PATCH] md/raid10: preserve recovery flags on reshape abort
Date: Tue, 10 Nov 2026 06:44:56 +0100
Message-ID: <20261110054456.625-1-nenkov2004@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6aec6738.059f5055.2712e4.0005.GAE@google.com>
References: <6aec6738.059f5055.2712e4.0005.GAE@google.com>
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

raid10_start_reshape() can fail while resizing a bitmap before it
changes any recovery bits on its success path. Its abort path nevertheless
clears the entire mddev->recovery bitmap.

dm-raid keeps MD_RECOVERY_FROZEN set across suspend and resume. If RAID10
reshape setup fails, raid_preresume() logs the failure and continues with
resume. Clearing the bitmap removes MD_RECOVERY_FROZEN and makes
raid_resume() hit its invariant warning.

Do not clear mddev->recovery from the RAID10 abort path. The error paths
reach abort before raid10_start_reshape() modifies the recovery bits, so
there is no personality-owned recovery state to roll back there.

Fixes: bb63a7019df9 ("md/raid10: resize bitmap when required during reshape.")
Reported-by: syzbot+8b22a0459202f76b4096@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8b22a0459202f76b4096
Signed-off-by: Hristos Nenkov <nenkov2004@gmail.com>
---
 drivers/md/raid10.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 066c43154..1fd3f5f4f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4490,7 +4490,6 @@ static int raid10_start_reshape(struct mddev *mddev)
 	return 0;
 
 abort:
-	mddev->recovery = 0;
 	spin_lock_irq(&conf->device_lock);
 	conf->geo = conf->prev;
 	mddev->raid_disks = conf->geo.raid_disks;

base-commit: b3dfbde62cf1981c4638939c159dfd087b7a72e9
-- 
2.43.0

