Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709212;
	b=KSOgUgwxBZF1/yI76v2cvqJneplcgAF1lYgWqpOepwHYAt12v1Vd0Wja/qVEtbj2FK0a
	 Rfyit6zTHvm8WfNK9Fw5dIDU1wTwlifDflYKRkFo2R6Nw4iHK5pgaSiWHMIvZkCwhyfau
	 nR8LNB5wAmIFagr0uFGpNYfYO+V11lZUeaQ2YT9N05fgVtWIrc8m8uWHUOYLaYKDqQj3i
	 P+9EB2Bnbq2jVB6+1r2CcLpUNDM+fRaeNvhe5Kh3Wh/ej/Uyw/UiqbVkVe74DvXN5rFzI
	 xALOCo5WLKq4uJ+lbb6UXphxR2t4mrvn55xsP8pOWq0Vp152612u2B/gZCmIYi734QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709212;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=oXMJpEB1SAlRxcq+SoC4OVx2mtps+6gke2HzvVwNibI=;
	b=hL0JFBKo7BRoAuOjiNaF0F2epi8bXqmL9aGWcG7XCtdrH4jV1gpwDIaWKGgedy3oVqzl
	 mQkGrjzNqEs/jLneQzEs39ongnHLpfGR2GNoYcZKIQQJANACw32wNGYQqZC4w9TqqBeO4
	 luFYMKqbMCKZgSh+4T36OJLp8x3OkH1BwHiyXI0JrOJfsCKyb4DmksPXVmN/ya1cJM1bC
	 0hmnSwSSLmGOD8XhNVSBc5fd8I5YKNW8Of6unwbSFIJV8aeRIWpGzPJqpaf+k7YpMSScG
	 LypiqBzGJ9/RIbuy3UFOGfk3c59eAv4abgcbJjA9em9oz4AsK8lm9EAUUYZR7k0UGkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1483606A334
	for <linux-raid@vger.kernel.org>; Tue,  3 Nov 2026 12:33:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1483606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4cc89e86e9eso5380149b6e.3
        for <linux-raid@vger.kernel.org>; Tue, 03 Nov 2026 04:33:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793709210; x=1794314010;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oXMJpEB1SAlRxcq+SoC4OVx2mtps+6gke2HzvVwNibI=;
        b=F4+Kla8IBluGYsgD7uU/wwR6XrUq8Iw2d5eZOLoQjdQXxGB01XdYcOjXACjDtblzwX
         VjSruOLSWzusxcBdSdC02Di5QjrXWRUGxO01X7jI8sNff6GzMHqAw52nj4dhBQaYKqN6
         5kmXPOKfl05ZK7udnhwyulyeuxm8806JcUyDo8G0Xw8BSFSFVjur9WDh7HEZGqJdEBHm
         LcP3O5JWw9T3aCdEaTLkUP3XfPJR1TO8BbgEqT1PP/fH7VRaSUsjEmUTSBzxy9/gOfUp
         ZhCTeeA3KJgli4IpyiSoyddd9DqIozWkPvNbk2X2TfRQ9fwg3kyrdWt8y2h3NaN30WsN
         zazg==
X-Forwarded-Encrypted: i=1; AKwUvBwrI1N6Hd5T/BiCSa2w5prtA8QyV4ujvNurKobTg8b1kM5rcnKkZ0B4gFnFCIopJZHSHrOZfJ4nYhNl@vger.kernel.org
X-Gm-Message-State: APuU4Z+pbYpLCBVN45YRdcwFlkeAiNEnrIm1fxdFXt6Wl1nnCZvE4yU4
	yB3glFS+Fj+yFGyVRVuBVriIXTRI/X7MFGHbvVnfGDOzdOsF5KprlooZ9H4lqhVGDdwK2lCEeBs
	WbRM8B0jjWzPPaQWtbeD04GmisRrvz8mlQJXmfqg3SOHKcWDvREdRtOMJybo=
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1b2a:b0:4b3:7549:d3c0 with SMTP id
 5614622812f47-5640ddb5e3emr8203490b6e.18.1793709210654; Tue, 03 Nov 2026
 04:33:30 -0800 (PST)
Date: Tue, 03 Nov 2026 04:33:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae9d49a.26d36f6c.15fe18.0009.GAE@google.com>
Subject: [syzbot] Monthly raid report (Nov 2026)
From: syzbot <syzbot+listb80138072a82b574f50f@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org, 
	syzkaller-bugs@googlegroups.com, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"

Hello raid maintainers/developers,

This is a 31-day syzbot report for the raid subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/raid

During the period, 0 new issues were detected and 1 were fixed.
In total, 3 issues are still open and 11 have already been fixed.
There are also 4 low-priority issues.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 43      Yes   BUG: unable to handle kernel paging request in free_conf
                  https://syzkaller.appspot.com/bug?extid=270624bb31d478afe62e
<2> 29      Yes   general protection fault in md_handle_request
                  https://syzkaller.appspot.com/bug?extid=89a9ab2a134d092fffae
<3> 21      Yes   UBSAN: array-index-out-of-bounds in super_90_sync
                  https://syzkaller.appspot.com/bug?extid=9e3014263a35700ab49b

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.
