Received: from mailer241.gate86.rs.smtp.com (mailer241.gate86.rs.smtp.com [74.91.86.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3A93596E3
	for <linux-raid@vger.kernel.org>; Wed, 25 Mar 2026 12:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.91.86.241
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774441429; cv=none; b=F+EttC7+Y+ZqQ1q7jrSfjBFd+podu03CKS2uT/v/M4M4b6mfUmNXGQ5LdY1qSlLu6qfJZ7KZANlamI2hNp2JjZQGnbRzI3SEYpTZdZqr5CozldH2SuNUQpHtE3kRG55tIPaliUbMptoEK1i3rtcNzALJg2Ns/nXKBm+WtDWo2KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774441429; c=relaxed/simple;
	bh=uyBuyb6eTIl2z3SHqwzKykKBS4979JGMlH/I/Iv9KkM=;
	h=From:Subject:To:Content-Type:Date:Message-Id; b=ikgYlDsYqDRxtWHzeLt4lT/WmcCqUCULq9BEMRDqEX+oYOJPvI6dl7i4UWKWouHhmeLglSV9b+jlgcDCP8IW5GeH053y6FdgBqBQ6VNhyrWdS8zE9Asp9RYTbDulvQ+bptkHmolxqVMeJQNStLSdjOVI+twVsggJ7/BxnV4Up00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=computergamingpc.com; spf=fail smtp.mailfrom=computergamingpc.com; dkim=pass (2048-bit key) header.d=computergamingpc.com header.i=@computergamingpc.com header.b=LCQS8Psl; dkim=pass (2048-bit key) header.d=smtpmessage.com header.i=@smtpmessage.com header.b=d+34KrRv; arc=none smtp.client-ip=74.91.86.241
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=computergamingpc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=computergamingpc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=computergamingpc.com header.i=@computergamingpc.com header.b="LCQS8Psl";
	dkim=pass (2048-bit key) header.d=smtpmessage.com header.i=@smtpmessage.com header.b="d+34KrRv"
X-Report-Abuse: SMTP.com is an email service provider. Our abuse team cares
 about your feedback. Please contact abuse@smtp.com for further investigation.
Received: from [10.0.16.178] (unknown [10.138.12.203])
	by mtl-mta02-out1 (Halon) with ESMTP
	id a4e3f873-e853-49ed-82c6-fe4f14d1a1f5;
	Wed, 25 Mar 2026 12:23:47 +0000 (UTC)
Received: Received from 10.138.12.40 by Caffeine (s0-aws-app2-swarm-manager-3)
 with SMTP id a36ff8b3-1aa4-4a44-a25d-4d3fd62c4048  for
 linux-raid@vger.kernel.org;  Wed, 25 Mar 2026 12:23:38 +0000 (UTC)
Feedback-ID: 9194450:SMTPCOM
Received: from ObaTech (unknown [73.109.61.186])
	by s0-aws-app-mta-in-1 (Halon) with ESMTPSA
	id a36ff8b3-1aa4-4a44-a25d-4d3fd62c4048;
	Wed, 25 Mar 2026 12:23:37 +0000 (UTC)
From: "Computer Gaming pc" <sales@computergamingpc.com>
Subject: Current GPU and Server Component Inventory Update
To: <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Reply-To: <sales@computergamingpc.com>
Date: Wed, 25 Mar 2026 12:23:37 +0000
Priority: urgent
X-Priority: 1
Importance: high
Message-Id: <25362026032312355F789058$7B94D1FC65@computergamingpc.com>
X-SMTPCOM-Sender-ID: 9194450
X-SMTPCOM-Tracking-Number: a36ff8b3-1aa4-4a44-a25d-4d3fd62c4048
X-SMTPCOM-Message-ID: a7037788-f034-4f1b-88bc-5dd8cdb0afd6
X-SMTPCOM-Payload: 
 vhfBHaE_aTq1YRtWyJlQLd5WsxnCr-FD0GM9lrXeqbsmttKIzSA2lTWJQSnaiMfylY9mup07cBHFYvlhiRLZq-O9_VyKK-lmbndVXxOb4L0OtoCanh1_ny1T396cCnp-j5FQ7yzuiZnkWp7ABNpOYKbvp6wL9qPNjJ827QlBiR5Q2n8UEQuHCo0c2YltUH3C
List-Unsubscribe-Post: List-Unsubscribe=One-Click
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=computergamingpc.com; i=@computergamingpc.com; q=dns/txt; s=smtpkey;
 t=1774441420; h=feedback-id : from : subject : to : content-type :
 content-transfer-encoding : reply-to : date : message-id :
 list-unsubscribe : list-unsubscribe-post : from : subject : to : date;
 bh=uyBuyb6eTIl2z3SHqwzKykKBS4979JGMlH/I/Iv9KkM=;
 b=LCQS8Psl5Gmg+5nLZGwa7iVKzUH9ASEsiuFv0M4S8HCKoMir6YXq1CeitVkYBQ6vhd8ZN
 PRqWM2K/v9VazOQJjfsKPmnRwbmA4mdoQzuNe1HVtpimdSg+D+soD36MjSqdoSviK4XuI4A
 MV11dJcLgSExGhJXCuFs1osE8OU88oTBkOSK6JTldcQI2vZeHdx44JZbYW9Vx7C1Rtp6IN1
 NVqnkjsayZJ5tqNjdurGd/COcvdgnbcWzEQ9i+bs/hJcmOLGo/iA6S32NIxLPnUB1583dpo
 u1vxLcsch7Dx2GLbHogLhmBQr9uYqRwdxGPaQcZPwT3orTDyTyX+W7ueqsmg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=smtpmessage.com;
 i=@smtpmessage.com; q=dns/txt; s=smtpcustomer; t=1774441420;
 h=feedback-id : from : subject : to : content-type :
 content-transfer-encoding : reply-to : date : message-id :
 list-unsubscribe : list-unsubscribe-post : from : subject : to : date;
 bh=uyBuyb6eTIl2z3SHqwzKykKBS4979JGMlH/I/Iv9KkM=;
 b=d+34KrRvGheiOgu2Xrqm11to//Jt/OKxrAZdJ+4gle0sKGkvSwklPunNcGJ/fDsNRe/q9
 kxwZQBCATaVnAWHbfqCeVj7yFVRlBl7FBbRHMPdHMgTeQxyG58MNwY+znTSIlOLXbLt0+wb
 enODklpsqdK6qvfb3E0k0vFvLEG7cYfLRQlRrSTF6eqJWwcyc0iPvDELiNPJ/az5TWXAJYm
 Oaf9+JDI4SQx6H6hgA0hL6Vot2rVXRYEiCJ6u44ZvP7VMEInuDQ/r4/8oMGEczxwLr1wzQ2
 Yxmgqp/Vg25hWxzG/Mw1HpADGiRg75djuEcuGL7pM1tWxW/BOwLbOo4X4RYA==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Dear Partner,
We're pleased to share a current snapshot of our available inventory.

* RTX 5090 Founders Edition 32GB (90 units) - $2,000
* RTX Asus/Gigabyte 4090 24GB (45 units) - $1,600
* RTX 4090 Founders Edition 24GB (90 units) - $1,800
* RTX A6000 48GB Ada (54 units) - $1,100
* RTX 6000 48GB Ada (51 units) - $1,200
* Nvidia L40s GPU (12 units) - $3,000
* Nvidia H100 80GB PCIe (9 units) - $20,000

Samsung PM9A3 2.5" SSD PCIe 4.0 7.68TB (115 units) - $250
7.68TB SAS SSD 2.5" 12G Server Drive (140 units) - $250
* 32GB 2Rx4 PC4-2400T (Qty: 1,500) - USD 14
* 32GB 2Rx4 PC4-3200AA (Qty: 1,500) - USD 15
* 16GB 2Rx8 PC4-3200AA (Qty: 1,500) - USD 10
* 128GB 4DRx4 DDR4 PC4-2933Y REG ECC LRDIMM (Qty: 980) - USD 70

- DDR5 64GB 4800Mhz ECC RDimm 2Rx4 P43331-B21 (Qty: 500) - USD 550
- DDR5 64GB 5600Mhz ECC RDimm 2Rx4 P64707-B21 (Qty: 500) - USD 550
- DDR4 64GB 3200Mhz ECC RDimm 2Rx4 SK Hynix (Qty: 500) - USD 450
- DDR5 64GB 4800Mhz ECC RDimm 2Rx4 SK Hynix (Qty: 500) - USD 450
- DDR5 64GB 5600Mhz ECC RDimm 2Rx4 Samsung (Qty: 500) - USD 550

For quotes, availability, or inspection scheduling, please reach outdirectly:
sales@computergamingpc.com
Call or WhatsApp: +1(774) 559-1248 | +1 (641)232-4364 
Thank you for your continued partnership.
Ann Kamila
Computer Gaming PC Trading
2500 US-6, Iowa City, IA 52240, USA
To unsubscribe from future updates, reply with "REMOVE" in the subject line.
