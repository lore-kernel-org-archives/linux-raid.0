Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=root.for.sabi.co.uk header.i=@root.for.sabi.co.uk header.b="R6nODuo3"
Received: from SMTP.sabi.co.uk (SMTP.sabi.co.UK [185.17.255.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFB9102
	for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 13:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=root.for.sabi.co.uk; s=dkim-00; h=From:Subject:To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:Date:Message-ID;
	bh=qa64tfup1ObFpsLhBvi4/thVKrCERfTdPZT7XLxYcCA=; b=R6nODuo3DFXZ2JeAdzWKzsQSPg
	cqFLqCqrasckg/INBh+3WvdzEvQtI492vN/g3LU7OOqn1yuv+lyEVWtZhfJymrbICqJ10Y0EjEFcc
	+0i+OvyVDcvhW2TzTUh4F0n/qqeCThP/aSep2gNuzf4viKBiByKR/vXFzU+kaJQM7PlHh9iUP9JPr
	HRQQkSBs4KlpjJO2EHzAQG+4LnjHf+vMWsOg922SSY2WNAbOGYjIYOfBx84hMnlX6RjP+wytnVkPG
	+y6Jq9g/sr+q5038X7cRNk4aTfeV40rHNmMmLZqNb+gIAFYNyqULrOTWo4HX5BT/eGQ0beckQjtlo
	1FpjwE0w==;
Received: from [92.40.184.78] (helo=petal.ty.sabi.co.uk)
	by SMTP.sabi.co.uk with esmtpsa(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)Exim 4.93
	id 1r7MV8-002Yg9-Hfby authid <sabity>with cram
	for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 21:17:14 +0000
Received: from localhost ([127.0.0.1] helo=petal.ty.sabi.co.uk)
	by petal.ty.sabi.co.uk with esmtps(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)Exim 4.93
	id 1r7MV1-004YBh-Cl
	for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 21:17:07 +0000
Message-ID: <25955.46546.87389.883190@petal.ty.sabi.co.uk>
Date: Sun, 26 Nov 2023 21:17:06 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Face: SMJE]JPYVBO-9UR%/8d'mG.F!@.,l@c[f'[%S8'BZIcbQc3/">GrXDwb#;fTRGNmHr^JFb
 SAptvwWc,0+z+~p~"Gdr4H$(|N(yF(wwCM2bW0~U?HPEE^fkPGx^u[*[yV.gyB!hDOli}EF[\cW*S
 H<GG"+i\3#fp@@EeWZWBv;]LA5n1pS2VO%Vv[yH?kY'lEWr30WfIU?%>&spRGFL}{`bj1TaD^l/"[
 msn( /TH#THs{Hpj>)]f><W}Ck9%2?H"AEM)+9<@D;3Kv=^?4$1/+#Qs:-aSsBTUS]iJ$6
Precedence: air-mail
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Subject: Re: SMR or SSD disks?
In-Reply-To: <20938de4-65f2-4bab-90c0-018fe485c0e7@suse.de>
References: <CAJH6TXh-FB0HaCJGFKHHgzaSqh+cQefPsK45Y_UBTsrcxaa6ww@mail.gmail.com>
	<ZWMf+lg/CgRlxKtb@mail.bitfolk.com>
	<20938de4-65f2-4bab-90c0-018fe485c0e7@suse.de>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From: pg@mdread.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions

>>> Are SSD drives still subject to SMR ? I've thought that it
>>> was related only to magnetic drives not on SSD.

Indeed SMR is a magnetic recording technique that potentially
results in very expensive read-modify-write operations.

> And the warning really is outdated. What matters is that the
> HDD needs to support TLER (ie scterc capabilities)

SCT/ERC/TLER is indeed an important feature in case HDD fail
*and* long latencies (like 30-100s) are not a good idea. Most
SSD either have SCT/ERC/TLER or don't need it as their retry
cycles are very short. What matters more is setting the Linux
driver retry timeout (which ought to be must always be higher
than that of the drive)

SSDs can have different issues that are undesirable for most
"business" applications, usually:

* Volatile write buffers (lack of "Power Loss Protection").

* Low endurance (low Device Writes Per Day).

* Potential high latencies in mixed workloads (interleaved read
  and write streams).

* Long term reduction in data transfer rates because
  FTL "compaction" cannot run faster than erase block
  fragmentation.

These can all affect an MD RAID set, in particular if bitmaps or
write logs are used or if the workload is challenging.
