Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458A13603C0;
	Sun, 19 Jul 2026 11:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784459115; cv=none; b=QqOmrDp16JsjEwt0GJwoOiBaIhki0wEZ9s2A2H1qHDWTyCVHJ1GcWIyeMI/U4GhY50eWdxcaJa0KNpLWM0p8KePPl1cA4eeKTksPbiWKoycOvxm+4mHe6sU6MITJ3VikIPbErzI4Ut8kCJ3xiaRz4J5Z5Dz8MEFlML2UqW25zck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784459115; c=relaxed/simple;
	bh=HzRnLzQRcq6hoUnenYNLfSMWsgm5yUI6AWR0vu8yZ8Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RwVxp4ht37kurmSBdJgpJ32eN/AC2kHVx7wp9N/o5ESiIW+2nsV0iFVQLJ64nsCwtBBuSSq1uveJtBP3e7SrSmSRcet7KJdKyE3KnLG6a0sExRQRA3dSg+nBygC0vJwzuAI0F8QfvpzjaolT6scz/upP3WxykS3HLNY2vM2H77g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Su16s4mT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Su16s4mT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8DB1F000E9;
	Sun, 19 Jul 2026 11:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784459113;
	bh=oP7vvMFpRDPfDaszczWHJMC//8ZQkAMSWY/7STXwx7o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Su16s4mTynnplWcQruvVVYbvld7eRzHkbURZzBHSj2xTkiU9iq2sPWJZoPND10ZLG
	 36ASwTIStnSQqILBTijSq2p3WaLp1LRwzd7RzDPDNQr2D33sFBZrb2NkEGjHTfnx6H
	 9xuRIF/oY0Z5qqryVfDz3J731cXrZ87ozDT1NhoVGHqIUJ8EiACk7Mni0P4EMdC6Qy
	 4JlAVn/xBnbgb1rzZX3HDm19PB8g3dVjFk+Nah2IwgxSU0Hcci+HlWs4WTUGlpVZPN
	 /7uE/OkxCI0jt8t3j+l6xDlLD7fC2LLQa36l9fdQRTNlAzWqCC8XCzfTdOvadtPRi7
	 eLRRrteKdhnyA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/7] md/raid1: don't use write-behind for P2PDMA bios
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-pci@vger.kernel.org, linux-raid@vger.kernel.org
In-Reply-To: <20260719105327.864949-5-mykola@meshstor.io>
References: <20260719105327.864949-1-mykola@meshstor.io>
 <20260719105327.864949-5-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 19 Jul 2026 11:05:13 +0000
Message-Id: <20260719110513.9B8DB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

> alloc_behind_master_bio() copies the bio's data with bio_copy_data(),
> a CPU copy. P2PDMA pages are peer device (BAR) memory; generic code
> must not assume CPU load/store access to them is safe or fast on
> every architecture, and bouncing peer memory through the CPU defeats
> the point of a peer-to-peer transfer.
>=20
> Skip write-behind for P2PDMA bios: they are written directly to all
> members, including write-mostly ones.  Ordering against write-behind
> I/O in flight to overlapping sectors is preserved: the non-behind
> clone path serializes on CollisionCheck rdevs (see the preceding
> fix), which covers these bios like any other write that bypasses
> write-behind.
>=20
> Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devic=
es to RAID device")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260719105327.8649=
49-1-mykola@meshstor.io?part=3D4

