Received: from mr85p00im-zteg06011501.me.com (mr85p00im-zteg06011501.me.com [17.58.23.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE257318C
	for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 15:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=17.58.23.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706197709; cv=none; b=k0SYFu3vilQ9wYOFKJCS8EwU8mgrkVv6uV3W/+yo2rKMtgHBbUFHitnynmtQCGccE+LoY8Ro/umbiqsAlVBJGNefeEggJ/Bpp6M6X+lu4FC2NdHzuLclE7nNaMyQR1PVds4Xsm6kBKxvMiTDv/WXWXmhcRc9XNZgOinrCvWQtBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706197709; c=relaxed/simple;
	bh=C2CpzF4Rr3D4xIjluLeGkxm2svn9TQgh+WVBs9+YGmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZuqUrP/YkYisGKfJpk9zVgqF/H8dKav1C9Qj9hBMjv5UsKKlkGnKvfLwd8rbvc41LMGN8yZRHYUPn0B5ueP0ItCZ5cOGvpAGFc4WpL9wYtSsD7PfASYSKYrtQm4hTOWB9qvvcZqtVP0XFajh6DewcwawMD+hOiPrfGet1WKy7GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net; spf=pass smtp.mailfrom=danm.net; dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b=eO5qkWu4; arc=none smtp.client-ip=17.58.23.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danm.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b="eO5qkWu4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=danm.net; s=sig1;
	t=1706197707; bh=C2CpzF4Rr3D4xIjluLeGkxm2svn9TQgh+WVBs9+YGmM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=eO5qkWu4mUX6T8hih8yDP99CxeDvs5v4hE/pqEhzHah7SqV1lyM1WeBChphicfktP
	 xZxs4xXRIE6/0cu2uU8MWsGOYvlGYOBOsWF5DuM7h48+I8Ed2+734wMa+nJ5FU8oIv
	 CIjJ4ewOhuKnjZ7ZL/SgsQuf2YJey4DKhd+oanpYl6aNeyp3Rwf7zsgmu6fj6D+VnH
	 fdbiEBw8ruMtIals+5PiyKd8RFMe0PiUK00tPR3ro4WUBBxULVefw0vFvpRSXT06sX
	 GXiBtrhfgQkKsaWLO4VJTHhoMo3aSS4gSeGIGUAhR0xH/Hd7/ZAeYDz1N47VUQ5N7C
	 iKBONovgc9gIQ==
Received: from hitch.danm.net (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
	by mr85p00im-zteg06011501.me.com (Postfix) with ESMTPSA id 66BA94807F5;
	Thu, 25 Jan 2024 15:48:26 +0000 (UTC)
From: Dan Moulding <dan@danm.net>
To: song@kernel.org
Cc: dan@danm.net,
	junxiao.bi@oracle.com,
	linux-raid@vger.kernel.org,
	stable@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yukuai3@huawei.com
Subject: [PATCH] Revert "Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d""
Date: Thu, 25 Jan 2024 08:48:24 -0700
Message-ID: <20240125154824.18847-1-dan@danm.net>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240125082131.788600-1-song@kernel.org>
References: <20240125082131.788600-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: I16QoiFrwA8tuBy2MdenLAPiYovMEKBH
X-Proofpoint-ORIG-GUID: I16QoiFrwA8tuBy2MdenLAPiYovMEKBH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-25_09,2024-01-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 clxscore=1030 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=395
 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2308100000 definitions=main-2401250111

Thank you Song. Let me know if there is any more information I can
provide to help diagnose or reproduce this.

-- Dan
