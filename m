Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B3D41B366;
	Tue, 21 Jul 2026 06:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784616675; cv=none; b=QKoRfk9JusQv7rgW2nhUOxP5bbSsxAQJoDJaXqh8QImni4d6Wv9ikvVpjCHbOmJz+KVi4zNjq4Ah3QgDrQQKjGm43tPdYU7zHh9ricdCG5gETzRa/Oi32yjkYSy21jLk0Jrxo5zzK+gJhuhJyvuDdZPnn//RZuQxnlTu131pUjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784616675; c=relaxed/simple;
	bh=Dc33vAc3v+XVxehd19mEai/0bRAPw8R6ND1gxZf8g/w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=pKShT2GS2bN9TZ4RBVwZNXCvOCL5OY2Yetx5pFbeK1xNHVdUOdkq6kW26AZUeKi4qephyvNUwH7E+QZeX5DjOqr5T1Xf8vSLYT1gM/z84yzdPjDbCV38SrTCcvzlPC+tGqVohr8R3NFkj+dRQARvTaXb2QaJljdeMBe3fJDVBuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=nXMfablK; arc=none smtp.client-ip=220.197.31.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="nXMfablK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=Dc33vAc3v+XVxehd19mEai/0bRAPw8R6ND1gxZf8g/w=; b=n
	XMfablKFIUxepfB4d52G+8xNZcnnl9KErdFuZWJ317l14qV+aBQDF+2xSuMOQrMu
	NQRMMOTxPESXA7RtvW20YpBGHSPgzHNQuQyoFLeLZPq0nqE6liVfS3j4ubU3gIVd
	uVLdQTLBOF6a00HeIvyz/RP+sf6B2p7Yhj5hAG4CT0=
Received: from zhanggenjian$126.com ( [116.128.244.171] ) by
 ajax-webmail-wmsvr-41-111 (Coremail) ; Tue, 21 Jul 2026 14:48:19 +0800
 (CST)
Date: Tue, 21 Jul 2026 14:48:19 +0800 (CST)
From: "genjian zhang" <zhanggenjian@126.com>
To: yukuai@fygo.io
Cc: song@kernel.org, magiclinan@didiglobal.com, xiao@kernel.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Genjian Zhang" <zhanggenjian@kylinos.cn>
Subject: Re: [PATCH] md/raid5: complete discard bios while reshape is active
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 126com
In-Reply-To: <8ff91547-4841-4cea-87bc-9d6979df61ab@fygo.io>
References: <20260711161326.962336-1-zhanggenjian@126.com>
 <8ff91547-4841-4cea-87bc-9d6979df61ab@fygo.io>
X-NTES-SC: AL_Qu2TBvqauUwi7yaaYukdmkwUheY2WcW2s/4n34BWc/MOkj7nwCEFbHl5Flf4/MWDFiySjzipYjJXz8ZWWKJZpBR3I/ZzcBRrBmIjr1go6A==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <67782c56.401d.19f836eb9b0.Coremail.zhanggenjian@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:bykvCgD3X6s0Fl9qX_YgAA--.50505W
X-CM-SenderInfo: x2kd0wxjhqyxldq6ij2wof0z/xtbBtBQFg2pfFjQv4wAA39
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

QXQgMjAyNi0wNy0xOSAyMDo1NDo0MiwgInl1IGt1YWkiIDx5dWt1YWlAZnlnby5pbz4gd3JvdGU6
Cj5IaSwKPgo+1NogMjAyNi83LzEyIDA6MTMsIEdlbmppYW4g0LS1wDoKPj4gRnJvbTogR2Vuamlh
biBaaGFuZyA8emhhbmdnZW5qaWFuQGt5bGlub3MuY24+Cj4+Cj4+IG1ha2VfZGlzY2FyZF9yZXF1
ZXN0KCkgcmV0dXJucyB3aXRob3V0IGNvbXBsZXRpbmcgdGhlIGJpbyB3aGVuIHJlc2hhcGUKPj4g
aXMgaW4gcHJvZ3Jlc3MuIERpc2NhcmQgY2FsbGVycyBibG9jayBpbiBzdWJtaXRfYmlvX3dhaXQo
KQo+PiB3YWl0aW5nIGZvciBhIGNvbXBsZXRpb24gdGhhdCBuZXZlciBhcnJpdmVzLiAgVGhlIGNh
bGxlciBoYW5ncyBpbgo+PiB1bmludGVycnVwdGlibGUgc2xlZXAsIGFuZCB0aGlzIGRvZXMgbm90
IHJlc29sdmUgd2hlbiByZXNoYXBlIGZpbmlzaGVzLgo+Pgo+PiBDb21wbGV0ZSB0aGUgYmlvIHdp
dGggQkxLX1NUU19BR0FJTiBzbyB1c2Vyc3BhY2UgY2FuIHJldHJ5IGFmdGVyIHJlc2hhcGUsCj4+
IGNvbnNpc3RlbnQgd2l0aCB0aGUgZXhpc3RpbmcgcG9saWN5IG9mIG5vdCBwcm9jZXNzaW5nIGRp
c2NhcmQgZHVyaW5nCj4+IHJlc2hhcGUuCj4+Cj4+IFRlc3RlZCBvbiBhIGxvb3AtYmFja2VkIFJB
SUQ1IGFycmF5IGR1cmluZyBtZGFkbSAtLWdyb3c6IHdpdGhvdXQgdGhpcwo+PiBwYXRjaCwgYmxr
ZGlzY2FyZCBoYW5ncyBpbiBiaW9fYXdhaXQoKSBhbmQgcmVtYWlucyBpbiB1bmludGVycnVwdGli
bGUKPj4gc2xlZXAgYWZ0ZXIgbWQgcmVwb3J0cyAicmVzaGFwZSBkb25lIjsgd2l0aCB0aGlzIHBh
dGNoIGl0IHJldHVybnMKPj4gLUVBR0FJTiBpbnN0ZWFkLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBH
ZW5qaWFuIFpoYW5nIDx6aGFuZ2dlbmppYW5Aa3lsaW5vcy5jbj4KPj4gLS0tCj4+ICAgZHJpdmVy
cy9tZC9yYWlkNS5jIHwgNCArKystCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbigtKQo+Pgo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9yYWlkNS5jIGIv
ZHJpdmVycy9tZC9yYWlkNS5jCj4+IGluZGV4IGZmYjVmY2RlNTRhOS4uNGMzYjQyYjJhZjg1IDEw
MDY0NAo+PiAtLS0gYS9kcml2ZXJzL21kL3JhaWQ1LmMKPj4gKysrIGIvZHJpdmVycy9tZC9yYWlk
NS5jCj4+IEBAIC01NzIyLDkgKzU3MjIsMTEgQEAgc3RhdGljIHZvaWQgbWFrZV9kaXNjYXJkX3Jl
cXVlc3Qoc3RydWN0IG1kZGV2ICptZGRldiwgc3RydWN0IGJpbyAqYmkpCj4+ICAgCWlmIChXQVJO
X09OX09OQ0UoYmktPmJpX29wZiAmIFJFUV9OT1dBSVQpKQo+PiAgIAkJcmV0dXJuOwo+Cj5BcyBu
b3dhaXQgd2lsbCBiZSByZW1vdmVkIHNvb24sIEknbSBmaW5lIGxlYXZpbmcgaXQgaGVyZS4KPgo+
UmV2aWV3ZWQtYnk6IFl1IEt1YWkgPHl1a3VhaUBmeWdvLmlvPgo+Cj4+ICAgCj4+IC0JaWYgKG1k
ZGV2LT5yZXNoYXBlX3Bvc2l0aW9uICE9IE1heFNlY3RvcikKPj4gKwlpZiAobWRkZXYtPnJlc2hh
cGVfcG9zaXRpb24gIT0gTWF4U2VjdG9yKSB7Cj4+ICAgCQkvKiBTa2lwIGRpc2NhcmQgd2hpbGUg
cmVzaGFwZSBpcyBoYXBwZW5pbmcgKi8KPj4gKwkJYmlvX2VuZGlvX3N0YXR1cyhiaSwgQkxLX1NU
U19BR0FJTik7Cj4+ICAgCQlyZXR1cm47Cj4+ICsJfQo+PiAgIAo+PiAgIAlpZiAoIXJhaWQ1X2Rp
c2NhcmRfbGltaXRzKG1kZGV2LCBiaSkpCj4+ICAgCQlyZXR1cm47Cj4KPi0tIAo+VGhhbmtzLAo+
S3VhaQoKVGhhbmtzIGZvciB0aGUgcmV2aWV3LgpJJ2xsIGxlYXZlIHRoZSBSRVFfTk9XQUlUIHBh
dGggdW5jaGFuZ2VkIGFuZCB3b24ndCBzZW5kIGEgdjIgZm9yIGl0LgoKVGhhbmtzLApHZW5qaWFu
Cg==
