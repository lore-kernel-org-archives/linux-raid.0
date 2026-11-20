Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.135.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795200146;
	b=JNthlTCY0rq0502/C7BR+2hrcWb7DGT9iqqlmOVRldu4fTTYSonyJKDnQAxTlmd64x2g
	 k4uaRcLlk2sPzfnDcBuTNYI680KR7YCCDjAbZCa906+DRQwNmsLVZUtWgHlajQZREinP8
	 iQ24KUM0g49Hpc+3BWtKInrxM3ki686SnQIbn99iCOetz2rJ2y/MiouRhho68H2FJIiQ9
	 aktuwjna9DG3dkk+gt+/atYK0jx85IDGIRBjb25a4R6p7YoZ+HBgBJN7suVrhGSaAgGHQ
	 q+PDluPGvn0LhsXmzEkOnqzHXH7/SH5W6bBRirvtvf3W+txfmEU5cjMlAyvcSX2CmVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795200146;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=z80gyuIqWTFja7sZqkIB5MePzAprHfhp31UStX1NblI=;
	b=PpOAnnki/NQkoGeVzi9gj2ErBUd9G/sBQRPlnoFhDbaWJWYBwWRiba5fsWsl2nqWCaaH
	 eeRvI75fkTU5VtLPIuPXibJqb5uVChEqd+x6cyfEUdDOD3pvvzqkWjUElHmps3AJJdjA4
	 w7lBuqfEX9RHChd7ZBUlZHqL4eK7xFVifYS+caKFhppyw3uDpcvmuw9oorbMhfSNSVEpe
	 7DmijHxj29QtzOvvTLVlrBjNprbzAMKGXBAxlZZbEZ61NZ3qdTcahf97FLWw2H6dGpzV5
	 +DNcZHtyTtkYo312xBpDCWwcQ7YYJhozByLgwiFRPiacqFOiRpXCO0vqwwDseILLsHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=T5o6yG9n;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=ua5D4q+T;
	arc=none smtp.remote-ip=148.163.135.74
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0944460A2613
	for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 18:42:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0944460A2613
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=T5o6yG9n;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=ua5D4q+T
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKHYSlU2543062
	for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 13:42:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=z80gyuIqWTFja7sZqkIB5MePzA
	prHfhp31UStX1NblI=; b=T5o6yG9nrbMSKzyS1f+5xRTAKiCKwanE7R3ScqNrNt
	8HaVthg1JsR1O8AHAlGKMwF2ACDl/hgsBGxJvvzmMRjDZnjGu66cse/JG/6Zw4DW
	Oe4U8/vYwOVdBvorzbhItA4FccEwHuJPug564ikBAJtYXn3Q/6inqqJhjE6QAS0Y
	owjwo0+UOAn3UonbstwZUbPuVAHGlDD2jrNuduYG0lObw4GCKwWpsUiYGFhvr0KN
	3yz03TphBd/3aE4oYUQOp1orNuIcEpnhRRq/YM9Nh//0g+JfDQkYxTQH0ucOFCy3
	GxED9Xp0aDOkAQTIBqB7+BNxzFeHt/Si1c9uyrxLlZWw==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j2ser9d7q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 13:42:16 -0500 (EST)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-54af6c38092so17018811cf.0
        for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 10:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1795200135; x=1795804935; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=z80gyuIqWTFja7sZqkIB5MePzAprHfhp31UStX1NblI=;
        b=ua5D4q+TvOxl5HuvJ+f/RwXcRcOaiknfqgtqvMq3YgyrTCh7pB1Lgfum9y0uJEkio6
         4ZfxVuCAdJcN0FLWAQuV+LrX0kIRgAn0hG8SAatgLQa0e4QdiPkSBQ92vMkZI+2eFyhJ
         PYSldqRvLlhgnS5yl5hZrb3d1iVynZKZ52oBGBoHkKe+NN6ySt0fYE9tZELqI+Fcctaa
         FEkUteHNTfaRDk72nMQk05dAt2jJAoAkM7yzr5NGL8ZImDzkWHu/iSYrOpt97z15M/on
         hH9Lp3+7AEmND2elbTuH8B6f0K681+n94IT1HWX+Iyiy0e9DlF+WGCGyfFZBIYgyFVDo
         M1zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795200135; x=1795804935;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=z80gyuIqWTFja7sZqkIB5MePzAprHfhp31UStX1NblI=;
        b=i61Y4aPvxvLtOBJMUw6b1lKn9a2jedMr8FDLBd+/bEvC4/suJWN/lOb8wFa1JYozzM
         kzEaCmSJ/69+hr71Ake/6sl9XaOjs5yi6W0eQX5pzi0fKOAGp9U0EdZZ0DgQmyQ0ducg
         2hfdUSVF6wA7coYv0zfBJ/tXJnPlZ8NiCjbiyeUlJgIDWOPMyd+oF7l7mKHeK0p3a3WR
         KWvjOegigPJzAySMOayG/sAkPwx8rX6QmjPwo4a6XXxhRWGLOTKuQmdhhqvbBHE4qFyr
         bohYVLP+N9fLw7hJQ4SaG9S4L/EOYxLtYVbfyn22YEHsQb1nltayddTqWquv8o4EYsmS
         jxxw==
X-Gm-Message-State: APuU4Z9wqtay4aBbqM0FY+B+CQLwm2YetQnrl5jndx6qg4SXVbQguMn3
	o1ybvfLnV4/ejX8W8ZRIJOgkIO1g+CFrB00iu8Cmx0c2H+mdwHgtowYsdvYkVMUVMVMYkDvrX4j
	e9S+grXgCOmSsjIWiUDgBULE6db0ZSpKd0idPzGRyurqrBxR7LCoqinJ7p50=
X-Gm-Gg: AYBFou1eSsd57tYUqMAy4QfPdztXIFMQIRAiQKG6F80zi4TeVt7LNU4VhmCTkVL92XH
	AH5MZBeVhhIJuEx/D4j3ngEOm+i9Dxlo92O34cH6GvMfQsDb89nDhdC/tIs0yO2Y1ctMnkoNKNl
	rujB0q1SFyKaW62lOrzLG6mcRt8GCOj8hDsxzPRE1N5Clyd13p1oQ6tr7ZFRgFYOgyHprYDF0VT
	4yQk3Iv43jhI4PZfUvuJWd/5BxE5ijFeXNMme12c5ygPx8Ahw9u3Gtv5ie0IOljQ0xwj0/5xTn7
	xbiRm6jonUON5LtKtrekSgnMnyVW9Vtma1NgRDkTRkAlOtk9apE5WeBcZBPMte7vqZCSAEqCvvE
	Z+/ssje3z6s7Tim5xFIxrtnw6rPq/leusZ0/3KUfT0u7Y9od7SzJUpW8K2iH3NKqRf8I5ZJwgWa
	R2eL9ZE5wgyVR9Y6sarkJ+
X-Received: by 2002:ac8:5753:0:b0:536:6946:748c with SMTP id d75a77b69052e-55d76a343dbmr79596371cf.53.1795200135023;
        Fri, 20 Nov 2026 10:42:15 -0800 (PST)
X-Received: by 2002:ac8:5753:0:b0:536:6946:748c with SMTP id d75a77b69052e-55d76a343dbmr79595971cf.53.1795200134582;
        Fri, 20 Nov 2026 10:42:14 -0800 (PST)
Received: from [127.0.1.1] (nat-128-59-178-217.net.columbia.edu. [128.59.178.217])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d788ae02fsm28895301cf.29.2026.11.20.10.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 10:42:14 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH 0/2] md: superblock page cleanups
Date: Fri, 20 Nov 2026 13:42:05 -0500
Message-Id: <20261120-md-sb-page-cleanup-v1-0-117d8d686737@columbia.edu>
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
X-B4-Tracking: v=1; b=H4sIAH2UAGsC/yXMQQqDMBCF4avIrDvQZKGkVykuMsmoU9oYMloK4
 t2NdvnxeP8GykVY4dFsUPgrKnOqMLcGwuTTyCixGuzdtsYYh5+ISph9XcKbfVozsotEnSMbBgf
 1mAsP8ruiz/5vXenFYTlLsO8HtsRedHYAAAA=
X-Change-ID: 20261119-md-sb-page-cleanup-e9dbb79b2cf9
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
        Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795200133; l=901;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=/S0qzvulfFJ+jOnMFaYFKELpLXYmh9PO4ZKS+y68i6E=;
 b=VUl/F2PKUXdZOgz3lQICD6po6ewre9vgEIKEWq6ZhFTzQNvJDn1wP014zRKDa9iSYh4L84CGu
 tUwfO6wwY1xBIMuvrCpjWkYsWYfP9de/pEfaNYvvtX/28TjgSVxZbQu
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=Tr9zFzXh c=1 sm=1 tr=0 ts=6b009488 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=lnglQuR7XRqnmjDHco/WZg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=5_fZDExAL0lJENZ0V4cA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA3NCBTYWx0ZWRfX2d/gjfcrLptG
 sn0F5aLqGsqI9MYFJYGvUnJvBX+NSRi6+j2opTEzMvqhSYlOF3xPymUh3SpdoJuQRTFNIz2ASDT
 D6pW7D3Wcf97lqgOi/OEdm2O+8c00ghYkUhZSo+w7QLnbNEmgIC8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA3NCBTYWx0ZWRfXyiRPwSUwRBe+
 eF2KQjtSkhDlyQqNlXIAjrrNInKr3phA5JiiNyDK9qQl+AVL1XEp6RHzg24fmARpdI/KjZD4Mcc
 nwBx91K9MV6U+2fHziop1x+uwfcL9rkELjqjX2jEOI7IXZGGihcef4SI3QfqvPJk0NBRPMRlxi1
 c9LvhvVPnzM+uYZTbbjKm/oi9oFJrWnh3+a4UzjdpmDWHJrDIwJqdfTGedg0t0iimjkwxg5QoT7
 9BNbkmZ0Bp2iV0rmt+OqD/hSBFmfJqsxX+n9XU9KXz+YnpPOhymDieCP0tzuuwSKYXO/MzeY0ZL
 6HW+LXsAD+zAlfZuupfUEuEjTaZyD1fkmCLJmaFPnHVpuGcp4Bi35aEZA2lLJKfo0MEbmyh+fSI
 qusqW2EECO5+SVmc0uUCIvd4nGTm0Lwxl9+hObGOadfZNXgOk7dE1ndw1r5Wc3ow+/Jow7t62fE
 B3yHoaK4d0CMxWsrjDA==
X-Proofpoint-GUID: zr-R3tWvpBYIE6p9N7UHs6IQpD-vqF_c
X-Proofpoint-ORIG-GUID: zr-R3tWvpBYIE6p9N7UHs6IQpD-vqF_c
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11972
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 clxscore=1011 malwarescore=0 phishscore=0 priorityscore=1501
 impostorscore=10 adultscore=0 lowpriorityscore=10 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611200074

read_rdev() clears PG_uptodate on a superblock page it has just
allocated, which does nothing. Patch 1 removes the call, which is one of
the last users of ClearPageUptodate(). Patch 2 frees the rdev superblock
and bad block pages with __free_page() instead of put_page(), as md
holds the only reference to them.

These buffers don't need to be pages at all and could be plain kmalloc()
allocations, but that is a larger change, so I left it out for now.

No functional change intended.

---
Tal Zussman (2):
      md: remove ClearPageUptodate() from read_rdev()
      md: free the superblock and bad block pages with __free_page()

 drivers/md/md.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)
---
base-commit: c526b7cd32f75fea6021ffdab287b81cf38ddeb7
change-id: 20261119-md-sb-page-cleanup-e9dbb79b2cf9

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

