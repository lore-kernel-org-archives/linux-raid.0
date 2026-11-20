Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795200143;
	b=BooILx0tykGQo/EKQSeUGbi3SOQsuY0oMjTVX7XTvO7RHoZTeWiR9Ze9zQcTWYDZXVHn
	 bJyjDxQoQSFgYOGv4WAeYiS2+0aeCk7lZaHHuprWS1ZT/BeCl6F1iNZt9/f8AplCpplAR
	 JQ8fOiz9ufIRjIK9QW59iDxIfni1b0Hi0fxge7MPO1+IDOOZQMJ1yrlXDhKfy4Er6JJWz
	 /LzA+KbKP71+9TTgxl4bvxqA62ktPf5oKTkaA40bBS5qrgA/638eZpdz0E3CeDNSIFWVQ
	 xeYvONF8Arq0VgPhOrmM2Yo7AE/5hWHXeicTZ881oSOm1zM3div4tdBm0iyCLPss09Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795200143;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=uB6Wtxz06vMdMNj6Z6jJ4VbMDyZslEE2FTR0Qhz4yDQ=;
	b=3bFzCjKuOCD96sSsZ0iN0+fd7/6NI20aZouK/xyzLEQFRi0FDCuaY+e0iBFe8M8UJZo0
	 zTpFFM9sVlxDaIkZb6CE0pzsk7T0xM7TFkBrnYFl+lVQ5arG0P3m4+8+vD6UL3bR1MKve
	 o+Jp9z/x0wfLtVZVv0S531ua4zWPF9xSa/kl37kLCSVy6U2XWv/v3IjP0JSZAdtr3qKfs
	 SuLHnbQOvtfHVdmMNFS9ASrdbkLNLMi/r1zr61tWEOcaVSnsKV5MQbOx+WtrzNM5ZcaKH
	 mi9mQkD+dYfNyP/dGe24FYeK2rFhyx7bcnOe6eYySKjLIdBAukMedBoeSH6A9lc8aNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=vUxleCYI;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=UqoL+UGm;
	arc=none smtp.remote-ip=148.163.135.74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F198D60A261D
	for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 18:42:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F198D60A261D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=vUxleCYI;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=UqoL+UGm
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKHYSAg2543070
	for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 13:42:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=uB6W
	txz06vMdMNj6Z6jJ4VbMDyZslEE2FTR0Qhz4yDQ=; b=vUxleCYIa7LQ5WfLMCpE
	+neRa0dQfNehF0u+/2F4sX+OCCXRhrMzVKgzDksDPaIqb6cyYEYHHDzl+e1Rd2uI
	CY10lXg071r8+mP8m5p1WUCtxDsmKsetQi4wBxcXR6BsckyIZkqEW34NJYq5O3zY
	8pYtgPYQV/6vjuVJkHD82wKe6hMdJoeccdJ24rxQgRG4bG7bXuvrB4PBlL2GhLQ/
	9ctIFMowxEh4Pb6k6QXpmB+IgmZpk/2/MEjwZKfnBNPjtHQJ8Dv5gH7qBJcFhs1s
	suHgTG8G2Sct66g6Msg5T/rPNhfYJcu95ZSNGBapcqGziRVrJx14qJAYaoh+pLSY
	+A==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j2ser9d89-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 13:42:19 -0500 (EST)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-55d414ff1e9so24654201cf.3
        for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 10:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1795200138; x=1795804938; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uB6Wtxz06vMdMNj6Z6jJ4VbMDyZslEE2FTR0Qhz4yDQ=;
        b=UqoL+UGmRM/Qg52R88zJT9V0XD3osHQ4MVBbzmVm6OAlg02fpKXyy6fvOEgyx8UbXK
         2DZAyrJzzUKFhsl6lOqNBVnWcIiVFbk8KPBIAQnmCr4j37aVIZhx1gOybymQGvp275jG
         XzWedrrmNiE7LgajFCSMBsbaaaiPavHN+A+aLteorjEgFXAIFh6NBo4H6sbOPMCkhiGj
         9uAUxkWD3IvpGfwqa1NjvGaYFBXXmBwbEMTEfzPBj7g+/oyOn4AIRg/k/NAPT673AUOe
         R1Y39d+yAsr1DieNQfDMQBdjrrtEyzCiHUMwUwjOINGfmd+m8gnMJvDGNLmHmwCqm3pO
         UGHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795200138; x=1795804938;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uB6Wtxz06vMdMNj6Z6jJ4VbMDyZslEE2FTR0Qhz4yDQ=;
        b=WettsCAsM6VjUy35e89fC5q7vOURC6IZP4eP20EDUtH7jLufoJ38+36N7hr+Bsjo2E
         Lb5LteMMl5ThL9TtnvofSQhcjOu/KU61jcj4M5wvIfYzP+OM4oXRGjiFCwCgrBTBmRof
         dQC8jy7CnG2Jjx7PQfbCRg7fV+4Hw5RY26vL34TXCY2Nu6ckKHd0kaPToks41GghPkVc
         QSWipWtlH0Bioxz7t6Xp7r8B65729qkJ6wItQtxdTO5B1YGSmQcNx50TrlsCOwV67K+R
         q+z6wHes3tF2ViJK5jMN0qyRRAua4SpwmTTC9p6/W2A6QS6H2TE3A9yYgvhwaJuSvGzY
         Ar+A==
X-Gm-Message-State: APuU4Z+5zx0R8r6e6JLTW8bGWYAbBTPk9IytKwuFxJelwrPhyGR6wZBT
	a67qFRYK+TzvnUhvFmmHeFCKlmdlgc8v5+aXCf3ZumRA78HfinFXeljvu0yy1v/fsPzuN0C/A5P
	TpbNHTe4dD9GKeY3MmkEZ+i7HinrSd1jsmU414lOuXmudOtufPuJ8wJ1juYc=
X-Gm-Gg: AYBFou3qpvPta0uLxu7r5f65enzb42RUfFVms6/roXcpQGh9IRfAkEjgYB0WQY5sNzJ
	HPlGFiOO98Bq4hFy99G5wxxP5iaNgI52l5wV1OvDqCKW5uAradFMvOUwyNw/Hfnb/pw89Em8sCF
	EezXqJFdITp8IvQfu/z2BVQRam82lrZFNy3dHWmVzAtAysm2D6rGySiXEFcsFSIzHrLhzSj+TWY
	PTTKNdp365Ks+YO2P83iBP63KcjOOgqg4qoJQ2UMqzGNUCTAI7TJyrDfmGl5bxCxllNqEfJVUhQ
	dT3SkxKNHkHUQtV3Jh1qYV6OHAP5Sfv7IAk9hRRxbtt3TnYQRwQtyD3GbfSaWaaflElxJuumCGj
	qX+Dwsdgw5VyMv4vMgl2OElmYCkLSpxhvzLy5fmwws1wuPKUerhjK4oQwfGmIoqpEZdqAgFZn0h
	7jX7u00WJs8BjAdFPtn4EN
X-Received: by 2002:a05:622a:5ce:b0:536:b7a:2ce8 with SMTP id d75a77b69052e-55d76a88b06mr74193141cf.51.1795200136573;
        Fri, 20 Nov 2026 10:42:16 -0800 (PST)
X-Received: by 2002:a05:622a:5ce:b0:536:b7a:2ce8 with SMTP id d75a77b69052e-55d76a88b06mr74192821cf.51.1795200136180;
        Fri, 20 Nov 2026 10:42:16 -0800 (PST)
Received: from [127.0.1.1] (nat-128-59-178-217.net.columbia.edu. [128.59.178.217])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d788ae02fsm28895301cf.29.2026.11.20.10.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 10:42:15 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Fri, 20 Nov 2026 13:42:07 -0500
Subject: [PATCH 2/2] md: free the superblock and bad block pages with
 __free_page()
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-md-sb-page-cleanup-v1-2-117d8d686737@columbia.edu>
References: <20261120-md-sb-page-cleanup-v1-0-117d8d686737@columbia.edu>
In-Reply-To: <20261120-md-sb-page-cleanup-v1-0-117d8d686737@columbia.edu>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
        Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795200133; l=1612;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=2QvXtn1wYHVVOm/IWc20/yG/3xx5860mWyf6um1peOw=;
 b=6qAU+WjRmhTUxSVMLKxIty9y06V3VGx222XrYCEdRYsLHX70B+D5APINxDKfItl6NDyntUfVw
 GoQDnfd/iEDCHwXmQr2n2xf2K7EIHjiu6CDxIeCrArm4fn98x3DHjHG
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=Tr9zFzXh c=1 sm=1 tr=0 ts=6b00948b cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=lnglQuR7XRqnmjDHco/WZg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=UiJXAB5W49XqtTlGKSQA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA3NCBTYWx0ZWRfX0vmXcSMK7+BS
 EdtxB3yHf2DFYF/YjW0k+h92f/88a9gBHlVyB9E2CzsPsOSF2qKUGOAuBln8NnAQXno7KCxWaRQ
 6RwnOdy1A4Qm3CLoqKtWu8OHNoNWULTNIFPuVgOpuxMYXNwf53s/
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA3NCBTYWx0ZWRfX7nHMC7LrhhHh
 AZVrCGdHahn1zndJF3cfIn+e1ZzRTX/VPBMUiv+zKn/5uGeqdPy/Ovbc/RpJVCCZnO0nM4N1uTL
 qpA+RonGEKD4SgqlV9duWEbhT2UbTUIe73amdUmUMd1raE+afEPuqSftUegdsuObgTGc0YzEF2b
 QDOSRKUQUXq4iS9xEpFpbyTLNtqaADfHSY0afYfSiLKT6vbjqVmrlEwBTCbSNFOxtEjBsewt56q
 r4pwUr8e1ywRSLXD7gHOgZHQHuqwkE7HsXzxjZFrEv4RiWBxeNZcmDQIg6NpAru8rynhDs7iZqn
 drLc1NqcUBNHjv0+slz8/dvgYiOpED0HoF+zkJi2ISKJ58L+z/eqGRI59FmXTvJvnEKa9TseNQa
 PjCeFzs3/wbjWYyumqMta9dj6ZrvvcS2Uv6YqtJ3mo6xVPt0v5xRhUqKr6Ck2pNcA6ZetdNH6yJ
 3zLIW7kCKH/dInlMZHg==
X-Proofpoint-GUID: 0FwfjUcxC6-lGwVuM5BoM6qVXK44fdVJ
X-Proofpoint-ORIG-GUID: 0FwfjUcxC6-lGwVuM5BoM6qVXK44fdVJ
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11972
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 clxscore=1015 malwarescore=0 phishscore=0 priorityscore=1501
 impostorscore=10 adultscore=0 lowpriorityscore=10 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611200074

rdev->sb_page and rdev->bb_page come from alloc_page(), and md never
takes another reference on them, so put_page() only ever frees them.
put_page() treats the page as a folio, which these buffers are not. Use
__free_page() instead.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 drivers/md/md.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c5a7f0697f7d..ef4a1141d8be 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1089,14 +1089,14 @@ static int alloc_disk_sb(struct md_rdev *rdev)
 void md_rdev_clear(struct md_rdev *rdev)
 {
 	if (rdev->sb_page) {
-		put_page(rdev->sb_page);
+		__free_page(rdev->sb_page);
 		rdev->sb_loaded = 0;
 		rdev->sb_page = NULL;
 		rdev->sb_start = 0;
 		rdev->sectors = 0;
 	}
 	if (rdev->bb_page) {
-		put_page(rdev->bb_page);
+		__free_page(rdev->bb_page);
 		rdev->bb_page = NULL;
 	}
 	badblocks_exit(&rdev->badblocks);
@@ -10961,7 +10961,7 @@ static int read_rdev(struct mddev *mddev, struct md_rdev *rdev)
 		pr_warn("%s: %d Could not reload rdev(%d) err: %d. Restoring old values\n",
 				__func__, __LINE__, rdev->desc_nr, err);
 		if (rdev->sb_page)
-			put_page(rdev->sb_page);
+			__free_page(rdev->sb_page);
 		rdev->sb_page = swapout;
 		rdev->sb_loaded = 1;
 		return err;
@@ -10983,7 +10983,7 @@ static int read_rdev(struct mddev *mddev, struct md_rdev *rdev)
 	    mddev->pers->spare_active(mddev))
 		sysfs_notify_dirent_safe(mddev->sysfs_degraded);
 
-	put_page(swapout);
+	__free_page(swapout);
 	return 0;
 }
 

-- 
2.39.5

