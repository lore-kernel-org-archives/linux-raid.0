Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795200143;
	b=iXnAm4DYXZVeMI5UvyVpXQDnwLW4s7USpNQzu6gW7VJU/HQi1prztyyeNTxNVvSW9ynl
	 98v99xWHEqqemePZnzY/KE75TFvAfh5lDW1jQeUEauQnzQB2ECg0lLi6apYp9QNWi+k4x
	 RQYFIzHlccl9E9Aikg/qLq6B7BoK+t7z/cWR8b1Rh/UH4ob862NM1Ow3K5L8ULSUDH3Kp
	 9CLJ8YCGXc53uu8yZnEtWm5e31iN58nt0LndaNxr3alnOFLFJGEyHRV2heyn5f7pn5406
	 UD3LWDiPw1w12slJPtp1H8aLe9aSa+7iCezpAGS+Ngy6vheSE8zCa9Ny9fmLG9djXNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795200143;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=xiUWDrCGEyCx/uwQdbOrIDGnkXqbylBfLpHJy8XTsWQ=;
	b=UZPH1RhwfBwF2IJZtuk3Z80zpIRPQWKFmhEBe1q4ot/CXVEbjRkpd5uDcZeN10+r4Cpt
	 K6zXFOFr6q6jqrzehl6Y7p20P+ARvAzYM+U1ZOzo+zLrLc5mfkz844mkZPEvinZgi+exf
	 j7DzziTdHF9cDBDJ2tGRwa619V3ZBHQho9DMzYuvJuZqh1qfbrctG29j/u4CND68fOTCk
	 QH0aHtbzX3KZSMPIYP8mP7DG3Cth0eauYnRvV6GIBPXslqSNH677g3thh7FVh7UlYDj8K
	 L80h+mcOcS3eCCouq4D44ta1BPMe/EPOBy/VhLucYRhvk3tZCxcN2VlCpb0dX8ol2Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=REcCXneO;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=EzEfUw+I;
	arc=none smtp.remote-ip=148.163.135.74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA134606A325
	for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 18:42:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA134606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=REcCXneO;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=EzEfUw+I
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKI5RFb1113996
	for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 13:42:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=xiUW
	DrCGEyCx/uwQdbOrIDGnkXqbylBfLpHJy8XTsWQ=; b=REcCXneOPYbpyCmfGUMP
	pOZF93uc4L8vfd0VFx0ydzNSsXS+VueRfsq34gtjmTOTQN2dtL9KHITYKufJ8rLW
	OaqT9XzCcZZ9X2P5DHHHTHUJT1VYUDc9+xdrDdw4sWfpoDhESlg9hWHIgl+z/YYA
	7Yr7l/EEvKFlaf8xpAv1tThHQX1UVXaMGOF24+Kc/zdvSIOaF51NueNSLWP1rtyA
	BaQZYwOXaa+6qjmAiaWcLz1ok2mUWHXrRpzKuhlZJx56aw/AM7z5+2C14VkgB8V4
	sSS8bXSJvPG040v4kPEyPaDFr7b/5QsXd4JZv8yeYKvEj94uLqf5X+6aUmnry7NA
	MQ==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j2u698a5g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 13:42:16 -0500 (EST)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-9213c7a506fso14133096d6.1
        for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 10:42:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1795200136; x=1795804936; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xiUWDrCGEyCx/uwQdbOrIDGnkXqbylBfLpHJy8XTsWQ=;
        b=EzEfUw+IuT09XDs2EVfi8QD3CQrbHwxWuF51+m82WzXzNs32Pj49nG6OB5iW+vlwWX
         /52SS5YXXl6+1v8k9p9sMqcavAQuCdiABGVJXvQTg0JZbA72vylXA6KAHzojpmuV8qC4
         AW5HT+XiOim7dAM2OgzoGf40wGhEGkxf2EkEMcRTohludXiycmko4F2D8aLXAuqJyBo1
         m2Isn95+3I2NCB9l8HELa788t/Nwfk9TrVBnej9VxwzNNq5bEJoU5iC4qUFw/RIsOBHP
         zAbT9VDSU/sTDPe6ol3GLEiqtcc+lFhzvBQEQDXYRy8fCLxGccQitmPRiFLMiu166/qF
         TGDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795200136; x=1795804936;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xiUWDrCGEyCx/uwQdbOrIDGnkXqbylBfLpHJy8XTsWQ=;
        b=fKEDtuFXb0HfHC/E+F/dZ2x9VFMjpnVvAFqu4JEof5Q8Gyl3EmgCVjH1Hmyc4fBbEc
         fcCydfBMgKlhds/tcFSeYv+jqRFzLplI9zH4xuWzxPUSPkIpWtgPmHlDhdq54CxYlH/8
         JlFgUDddcQHRNEbqmFgE8LYFTZtFSxo7DWiwIS8mSiaK/fAYc1lNSF14W55EefKIvnnS
         jPQiWcYFqcEsgxbXWUO4+YPQ/V6qADSb1GrUd0TYx1n1TyZxlAJEYYbYpn2dLJJTA1a/
         bKRgadFtMbYIcF/6B2G3RG0tiGhskmN6Ymtl5MN7S6TYiDGo8PZzz7kAezxA9/k7GOxN
         ZfXw==
X-Gm-Message-State: APuU4Z8h8Agzkhti5o8y8pz4g230GCurdP+cMfmz12FgNcdcc0lxX0fa
	xdk+gzifoHKJGFwIzfvQIErbP8+Sx8wVl5G5ykrlqhan46zqHj+olQsaZJQCUN6Rsk46AfG5KkX
	s+KlmpRNo9BrbQbQ8wlozm8fcC3F/GnfTSE2G1N72yEtRM6jAX3cmgcgJ0Ng=
X-Gm-Gg: AYBFou2yAWx0JGwYZxpAyXliT3vmAmMYiZobpGYqPIZHUQHL5O2Lr7tRvOmeweJGZ6U
	6vkMJeZ3oDPWfFBETyMJD/v3uEkg40uu+bfNmdLa3OlZxe0oVGj71MCIQfvGP3atTyKfnkMe5lK
	aRSm2WepJWH5Z6CafJ1JriZnIZatLnQGmX8Kf5tqF402S5WqRSsjiDVd79ZOKnvpc7run3Nk1PH
	nZMOLN9751+XmhEDQnxR9ZZQlPj3Jtth4MYaBFJTx9/Y7GzScY+s/6VUA/sZ/KLf8ej1KYr86px
	CGUW5zdBXdDxVslwdr+Nxc/2zwnDGkir4R7hWlBXmrOqN23PXGCczleCwxOEF3sO7FKHtPZtHYY
	QzNtZkl6RAv8kpOf/kKwOY1LLM8wVF68YCSQmjTB9u0JYGI4WkBJuAFxTcrxjGT9+04iae3OJQS
	IxxsLAM4xPW7WRRcF3sbTf
X-Received: by 2002:a05:622a:98d:b0:55b:ba5b:c60f with SMTP id d75a77b69052e-55d76ac73e9mr63060221cf.64.1795200135799;
        Fri, 20 Nov 2026 10:42:15 -0800 (PST)
X-Received: by 2002:a05:622a:98d:b0:55b:ba5b:c60f with SMTP id d75a77b69052e-55d76ac73e9mr63059941cf.64.1795200135426;
        Fri, 20 Nov 2026 10:42:15 -0800 (PST)
Received: from [127.0.1.1] (nat-128-59-178-217.net.columbia.edu. [128.59.178.217])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d788ae02fsm28895301cf.29.2026.11.20.10.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 10:42:14 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Fri, 20 Nov 2026 13:42:06 -0500
Subject: [PATCH 1/2] md: remove ClearPageUptodate() from read_rdev()
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
Message-Id: <20261120-md-sb-page-cleanup-v1-1-117d8d686737@columbia.edu>
References: <20261120-md-sb-page-cleanup-v1-0-117d8d686737@columbia.edu>
In-Reply-To: <20261120-md-sb-page-cleanup-v1-0-117d8d686737@columbia.edu>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
        Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795200133; l=821;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=+oFMMptBtYTbW8cg4Pb3z8QNEU4fHnVT50XtPeMAibY=;
 b=SYHQ6YfLAYGBTBZJr8B4f+Izhf6lSaW28AZsCVMHorCOWxGSLB0NynSdHFZnSAiSPWRmSJDGD
 TVqJlUU1TV3ARoV3hIS0foQGXmA3d06ritJprtQoGeEiRLkXE+OlZLJ
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=eOCGH3p1 c=1 sm=1 tr=0 ts=6b009489 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=lnglQuR7XRqnmjDHco/WZg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=Tkn2swf4pztK5bFHqvMA:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA3NCBTYWx0ZWRfX7t4dX0bXgpkv
 trOis9ANjq4EAzKLBmGWnEcvKCrmvQF81kkvTERYqNbnXowi9KJDwA8MIMG7ytC9ZgkaOS/Ewwe
 i3+R4Uu0YCVZgyF2uEnv+3u1FXkZ0JEpFyNjEmE/6vN1OCXaLWjINFOK4l97/qVusxoUOohb2De
 cfqVu8PBXvCvlZClvfldvAwvmwtPZUvcFAqh9UTj4CXlGZzWHOV1e9hskW+1k8xnlsqRb8w9zMG
 JUF+/tMD5OWb1i4sGEIaAMTr3mYJ4cUwFufZG+QWzFJCw2SnBDdK+ueS1i51H7gEqZvjZG9LIgW
 nuUhf0tg+tqNI8CYEtfCGlHZLn5nvLavxUzk68r0N87eqlWTBYb3Lq6oQnlVcc84cX44s/dRbF/
 xHy76qtR+kAIJfY/awmL3npeMhuhI5zgT84NGbQtoL9Hq0gN+u6s8RPLfuKhEk1O1egyVLjSchD
 zVDi2BuYv4P1wPSbKEg==
X-Proofpoint-ORIG-GUID: Mr8Gml2nk5DPjlPka9S4EvN2cYLnlJJN
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA3NCBTYWx0ZWRfXwGBfOZzLJLth
 IDAdDMucTSiHDG92vm3fIE2ki/fOGnu/ZPyLUGjUMX18T1KAxsX9iBchuy5En1oM5vckhuJUMCD
 NgcuZl9NdwVzzHphZXpji/BwFgrBJgpfpcs6FG4N/vEX7hHm0tQ2
X-Proofpoint-GUID: Mr8Gml2nk5DPjlPka9S4EvN2cYLnlJJN
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11972
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 malwarescore=0 bulkscore=10 lowpriorityscore=10
 priorityscore=1501 spamscore=0 suspectscore=0 clxscore=1011 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611200074

read_rdev() clears PG_uptodate on the superblock page it has just
allocated with alloc_page(), before reading the superblock into it. The
flag is never set on a newly allocated page, and nothing in md tests it.

Remove the call.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 drivers/md/md.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c71c3b043496..c5a7f0697f7d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -10953,7 +10953,6 @@ static int read_rdev(struct mddev *mddev, struct md_rdev *rdev)
 	rdev->sb_page = NULL;
 	err = alloc_disk_sb(rdev);
 	if (err == 0) {
-		ClearPageUptodate(rdev->sb_page);
 		rdev->sb_loaded = 0;
 		err = super_types[mddev->major_version].
 			load_super(rdev, NULL, mddev->minor_version);

-- 
2.39.5

