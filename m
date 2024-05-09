Received: from mo-csw-fb.securemx.jp (mo-csw-fb1122.securemx.jp [210.130.202.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220211487C4;
	Thu,  9 May 2024 07:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.130.202.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715240570; cv=none; b=KskHDtYyg4wyLbbU+T3B/GHLHeMMC8tFrZEaB4s3WBT4fdMUkA7Pu0eGpLYGkglk4LICGZUXUxFjSonkTmCzsMubl1MSGtTPNB6V6mpNqTOHs6LxkUEk/d2kSoTcPF0wJcsTdlhz75uayk0Ym7qOqWxHps82Cp5+BvJJHmhA51Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715240570; c=relaxed/simple;
	bh=Q8A4ZWBhm+FkdjNTyel34h10uhabTN0TdGEkGQPyJlY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YgiWOt7LWgWN3dIzjsvy7L67VJV4oDJQkxTFL2D1Q94sOGRKsvbt7OoM17Ntu8LzcjfmUcgOdzhVx+eA7ZfkXWH6mdEExXmkS5MD3heOxqog7dAG/dZwde4JE0fRjQ6TkT+hXAn/NTbd5wiQIF5nV+RumKCdW7pZiY4nhgRdQSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kioxia.com; spf=pass smtp.mailfrom=kioxia.com; arc=none smtp.client-ip=210.130.202.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kioxia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kioxia.com
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1122) id 4496lJ8E3038899; Thu, 9 May 2024 15:47:19 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1122) id 4496kgSH1189120; Thu, 9 May 2024 15:46:43 +0900
X-Iguazu-Qid: 2rWhAUbYjDZzAIbjO5
X-Iguazu-QSIG: v=2; s=0; t=1715237202; q=2rWhAUbYjDZzAIbjO5; m=rVo8ivCXEV/8n6eXdPXY2XauacTTqXsZoNFpmTS+/tE=
Received: from CNN1EMTA03.test.kioxia.com ([202.248.33.144])
	by relay.securemx.jp (mx-mr1121) id 4496keNB2614440
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 9 May 2024 15:46:40 +0900
Received: from Switcher-Post_Send (gateway [10.232.20.1])
	by CNN1EMTA03.test.kioxia.com (Postfix) with ESMTP id 4D7EF2FE0E;
	Thu,  9 May 2024 15:46:40 +0900 (JST)
Received: from CNN1ESTR04.kioxia.com (localhost [127.0.0.1])
	by Switcher-Post_Send (Postfix) with ESMTP id 3E9921900001E1;
	Thu,  9 May 2024 15:33:42 +0900 (JST)
Received: from localhost [127.0.0.1] 
	 by CNN1ESTR04.kioxia.com with ESMTP id 0003RAAAAAA00CDC;
	 Thu, 9 May 2024 15:33:42 +0900
Received: from CNN1EXMB01.r1.kioxia.com (CNN1EXMB01.r1.kioxia.com [10.232.20.150])
	by Switcher-Pre_Send (Postfix) with ESMTP id 330E4A29E1A01;
	Thu,  9 May 2024 15:33:42 +0900 (JST)
Received: from CNN1EXMB03.r1.kioxia.com (10.232.20.152) by
 CNN1EXMB01.r1.kioxia.com (10.232.20.150) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 9 May 2024 15:46:39 +0900
Received: from CNN1EXMB03.r1.kioxia.com ([10.13.100.22]) by
 CNN1EXMB03.r1.kioxia.com ([10.13.100.22]) with mapi id 15.01.2507.035; Thu, 9
 May 2024 15:46:39 +0900
From: tada keisuke <keisuke1.tada@kioxia.com>
To: Paul E Luse <paul.e.luse@linux.intel.com>
CC: Yu Kuai <yukuai1@huaweicloud.com>, "song@kernel.org" <song@kernel.org>,
        "yukuai (C)" <yukuai3@huawei.com>,
        "linux-raid@vger.kernel.org"
	<linux-raid@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "Luse, Paul E" <paul.e.luse@intel.com>
Subject: RE: [PATCH v2 08/11] md: add atomic mode switching in RAID 1/10
Thread-Topic: [PATCH v2 08/11] md: add atomic mode switching in RAID 1/10
Thread-Index: AdqLx+XD0n9rpAUxRba5DThcEUS6pAF1ejgc//zL4YD/937IgIAVxDgA/+myr2A=
Date: Thu, 9 May 2024 06:46:39 +0000
Message-ID: <170ff038967543228fef9d0868332620@kioxia.com>
References: <47c035c3e741418b80eb6b73d96e7e92@kioxia.com>
	<8d21354c-9e67-b19c-1986-b4c027dff125@huaweicloud.com>
	<20240416073806.50e3ff5d@peluse-desk5>	<20240416154113.114dc42f@peluse-desk5>
	<4b8f2f7499bd497c9db280775ae4ea81@kioxia.com>
 <20240425021224.6419ee2c@peluse-desk5>
In-Reply-To: <20240425021224.6419ee2c@peluse-desk5>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-tm-as-product-ver: ISME-14.0.0.2080-9.0.1002-28370.001
x-tm-as-result: No-10--5.508700-8.000000
x-tmase-matchedrid: OcgHo5wAKs6magT1k9kBpu5i6weAmSDKQV99ahimM1VYC5LPd7Bvbf3c
	g9WGG5V+HkAOv6n9gx5hoUIS5GGeElqzeP+fKaZirltvlARhKR0Jlr1xKkE5ucC5DTEMxpeQfiq
	1gj2xET/uo3YBjUsFh2kzi5An54UG0UwGeYlGH8nOvXpg7ONnXYiuaoNXJrK/njPfVXLnMPpdvd
	jb5IwdboBsLAy4Xg8nk60UwrkrF+Q7mT8/EEC+/t5x7RpGJf1aWC/7aMfV0JHyXa/7gO3s/eQ5w
	ujMC0dGS8TZctow9KAknOGoeIQzlp8vF/w0o6V88irf7wNB3Siy2aVB7PCjFdWM2x6EZ/S9ZGW8
	RjUnk4hyoaUUcpft+zbrDVUpYRxNexXX42Ne5dSeAiCmPx4NwHJnzNw42kCxxEHRux+uk8h+ICq
	uNi0WJHlopxU3vsREUA/xSjvb0UyfhQMuJvQjg2rpSf8F71FIftwZ3X11IV0=
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
x-tmase-result: 10--5.508700-8.000000
x-tmase-version: ISME-14.0.0.2080-9.0.1002-28370.001
x-tm-snts-smtp: 739F0219183FC94ECBD3494D1D761986D5367130C8B67479549B9001C8A02CB62000:8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CrossPremisesHeadersFilteredBySendConnector: CNN1EXMB01.r1.kioxia.com
X-OrganizationHeadersPreserved: CNN1EXMB01.r1.kioxia.com

PiA+ID4gPiA+IEhpLA0KPiA+ID4gPiA+DQo+ID4gPiA+ID4g5ZyoIDIwMjQvMDQvMTggMTM6NDQs
IHRhZGEga2Vpc3VrZSDlhpnpgZM6DQo+ID4gPiA+ID4gPiBUaGlzIHBhdGNoIGRlcGVuZHMgb24g
cGF0Y2ggMDcuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gQWxsIHJkZXZzIHJ1bm5pbmcgaW4g
UkFJRCAxLzEwIHN3aXRjaCBucl9wZW5kaW5nIHRvIGF0b21pYw0KPiA+ID4gPiA+ID4gbW9kZS4g
VGhlIHZhbHVlIG9mIG5yX3BlbmRpbmcgaXMgcmVhZCBpbiBhIG5vcm1hbCBvcGVyYXRpb24NCj4g
PiA+ID4gPiA+IChjaG9vc2VfYmVzdF9yZGV2KCkpLiBUaGVyZWZvcmUsIG5yX3BlbmRpbmcgbXVz
dCBhbHdheXMgYmUNCj4gPiA+ID4gPiA+IGNvbnNpc3RlbnQuDQo+ID4gPiA+ID4gPg0KPiA+ID4g
PiA+ID4gU2lnbmVkLW9mZi1ieTogS2Vpc3VrZSBUQURBIDxrZWlzdWtlMS50YWRhQGtpb3hpYS5j
b20+DQo+ID4gPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBUb3NoaWZ1bWkgT0hUQUtFIDx0b3NoaWZ1
bWkub290YWtlQGtpb3hpYS5jb20+DQo+ID4gPiA+ID4gPiAtLS0NCj4gPiA+ID4gPiA+ICAgZHJp
dmVycy9tZC9tZC5oICAgICB8IDE0ICsrKysrKysrKysrKysrDQo+ID4gPiA+ID4gPiAgIGRyaXZl
cnMvbWQvcmFpZDEuYyAgfCAgNyArKysrKysrDQo+ID4gPiA+ID4gPiAgIGRyaXZlcnMvbWQvcmFp
ZDEwLmMgfCAgNCArKysrDQo+ID4gPiA+ID4gPiAgIDMgZmlsZXMgY2hhbmdlZCwgMjUgaW5zZXJ0
aW9ucygrKQ0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21k
L21kLmggYi9kcml2ZXJzL21kL21kLmgNCj4gPiA+ID4gPiA+IGluZGV4IGFiMDllMzEyYzliYi4u
NTdiMDliNTY3ZmZhIDEwMDY0NA0KPiA+ID4gPiA+ID4gLS0tIGEvZHJpdmVycy9tZC9tZC5oDQo+
ID4gPiA+ID4gPiArKysgYi9kcml2ZXJzL21kL21kLmgNCj4gPiA+ID4gPiA+IEBAIC0yMzYsNiAr
MjM2LDIwIEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZw0KPiA+ID4gPiA+ID4gbnJfcGVu
ZGluZ19yZWFkKHN0cnVjdCBtZF9yZGV2ICpyZGV2KSByZXR1cm4NCj4gPiA+ID4gPiA+IGF0b21p
Y19sb25nX3JlYWQoJnJkZXYtPm5yX3BlbmRpbmcuZGF0YS0+Y291bnQpOyB9DQo+ID4gPiA+ID4g
Pg0KPiA+ID4gPiA+ID4gK3N0YXRpYyBpbmxpbmUgYm9vbCBucl9wZW5kaW5nX2lzX3BlcmNwdV9t
b2RlKHN0cnVjdCBtZF9yZGV2DQo+ID4gPiA+ID4gPiAqcmRldikgK3sNCj4gPiA+ID4gPiA+ICsJ
dW5zaWduZWQgbG9uZyBfX3BlcmNwdSAqcGVyY3B1X2NvdW50Ow0KPiA+ID4gPiA+ID4gKw0KPiA+
ID4gPiA+ID4gKwlyZXR1cm4gX19yZWZfaXNfcGVyY3B1KCZyZGV2LT5ucl9wZW5kaW5nLA0KPiA+
ID4gPiA+ID4gJnBlcmNwdV9jb3VudCk7ICt9DQo+ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiAr
c3RhdGljIGlubGluZSBib29sIG5yX3BlbmRpbmdfaXNfYXRvbWljX21vZGUoc3RydWN0IG1kX3Jk
ZXYNCj4gPiA+ID4gPiA+ICpyZGV2KSArew0KPiA+ID4gPiA+ID4gKwl1bnNpZ25lZCBsb25nIF9f
cGVyY3B1ICpwZXJjcHVfY291bnQ7DQo+ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiArCXJldHVy
biAhX19yZWZfaXNfcGVyY3B1KCZyZGV2LT5ucl9wZW5kaW5nLA0KPiA+ID4gPiA+ID4gJnBlcmNw
dV9jb3VudCk7ICt9DQo+ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiAgIHN0YXRpYyBpbmxpbmUg
aW50IGlzX2JhZGJsb2NrKHN0cnVjdCBtZF9yZGV2ICpyZGV2LA0KPiA+ID4gPiA+ID4gc2VjdG9y
X3QgcywgaW50IHNlY3RvcnMsIHNlY3Rvcl90ICpmaXJzdF9iYWQsIGludA0KPiA+ID4gPiA+ID4g
KmJhZF9zZWN0b3JzKSB7DQo+ID4gPiA+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9yYWlk
MS5jIGIvZHJpdmVycy9tZC9yYWlkMS5jDQo+ID4gPiA+ID4gPiBpbmRleCAxMjMxOGZiMTVhODgu
LmMzOGFlMTNhYWRhYiAxMDA2NDQNCj4gPiA+ID4gPiA+IC0tLSBhL2RyaXZlcnMvbWQvcmFpZDEu
Yw0KPiA+ID4gPiA+ID4gKysrIGIvZHJpdmVycy9tZC9yYWlkMS5jDQo+ID4gPiA+ID4gPiBAQCAt
Nzg0LDYgKzc4NCw3IEBAIHN0YXRpYyBpbnQgY2hvb3NlX2Jlc3RfcmRldihzdHJ1Y3QgcjFjb25m
DQo+ID4gPiA+ID4gPiAqY29uZiwgc3RydWN0IHIxYmlvICpyMV9iaW8pIGlmIChjdGwucmVhZGFi
bGVfZGlza3MrKyA9PSAxKQ0KPiA+ID4gPiA+ID4gICAJCQlzZXRfYml0KFIxQklPX0ZhaWxGYXN0
LA0KPiA+ID4gPiA+ID4gJnIxX2Jpby0+c3RhdGUpOw0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+
ICsNCj4gPiA+ID4gPiA+IFdBUk5fT05fT05DRShucl9wZW5kaW5nX2lzX3BlcmNwdV9tb2RlKHJk
ZXYpKTsgcGVuZGluZyA9DQo+ID4gPiA+ID4gPiBucl9wZW5kaW5nX3JlYWQocmRldik7IGRpc3Qg
PSBhYnMocjFfYmlvLT5zZWN0b3IgLQ0KPiA+ID4gPiA+ID4gY29uZi0+bWlycm9yc1tkaXNrXS5o
ZWFkX3Bvc2l0aW9uKTsNCj4gPiA+ID4gPiA+IEBAIC0xOTMwLDYgKzE5MzEsNyBAQCBzdGF0aWMg
aW50IHJhaWQxX2FkZF9kaXNrKHN0cnVjdCBtZGRldg0KPiA+ID4gPiA+ID4gKm1kZGV2LCBzdHJ1
Y3QgbWRfcmRldiAqcmRldikgaWYgKGVycikNCj4gPiA+ID4gPiA+ICAgCQkJCXJldHVybiBlcnI7
DQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gcGVyY3B1X3JlZl9zd2l0
Y2hfdG9fYXRvbWljX3N5bmMoJnJkZXYtPm5yX3BlbmRpbmcpOw0KPiA+ID4gPiA+ID4gcmFpZDFf
YWRkX2NvbmYoY29uZiwgcmRldiwgbWlycm9yLCBmYWxzZSk7IC8qIEFzIGFsbCBkZXZpY2VzDQo+
ID4gPiA+ID4gPiBhcmUgZXF1aXZhbGVudCwgd2UgZG9uJ3QgbmVlZCBhIGZ1bGwgcmVjb3ZlcnkN
Cj4gPiA+ID4gPiA+ICAgCQkJICogaWYgdGhpcyB3YXMgcmVjZW50bHkgYW55IGRyaXZlDQo+ID4g
PiA+ID4gPiBvZiB0aGUgYXJyYXkgQEAgLTE5NDksNiArMTk1MSw3IEBAIHN0YXRpYyBpbnQNCj4g
PiA+ID4gPiA+IHJhaWQxX2FkZF9kaXNrKHN0cnVjdCBtZGRldiAqbWRkZXYsIHN0cnVjdCBtZF9y
ZGV2ICpyZGV2KQ0KPiA+ID4gPiA+ID4gc2V0X2JpdChSZXBsYWNlbWVudCwgJnJkZXYtPmZsYWdz
KTsgcmFpZDFfYWRkX2NvbmYoY29uZiwNCj4gPiA+ID4gPiA+IHJkZXYsIHJlcGxfc2xvdCwgdHJ1
ZSk7IGVyciA9IDA7DQo+ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiBwZXJjcHVfcmVmX3N3aXRj
aF90b19hdG9taWNfc3luYygmcmRldi0+bnJfcGVuZGluZyk7DQo+ID4gPiA+ID4NCj4gPiA+ID4g
PiBJIGRvbid0IHVuZGVyc3RhbmQgd2hhdCdzIHRoZSBwb2ludCBoZXJlLCAnbnJfcGVuZGluZycg
d2lsbCBiZQ0KPiA+ID4gPiA+IHVzZWQgd2hlbiB0aGUgcmRldiBpc3N1aW5nIElPLCBhbmQgaXQn
cyBhbHdheXMgdXNlZCBhcyBhdG9taWMNCj4gPiA+ID4gPiBtb2RlLCB0aGVyZSBpcyBubyBkaWZm
ZXJlbmNlLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gQ29uc2lkZXIgdGhhdCAnbnJfcGVuZGluZycg
bXVzdCBiZSByZWFkIGZyb20gSU8gZmFzdCBwYXRoLCB1c2UNCj4gPiA+ID4gPiBpdCBhcyBhdG9t
aWMgaXMgc29tZXRoaW5nIHdlIG11c3QgYWNjZXB0LiBVbmxlc3Mgc29tZW9uZSBjb21lcw0KPiA+
ID4gPiA+IHVwIHdpdGggYSBwbGFuIHRvIGF2b2lkIHJlYWRpbmcgJ2luZmxpZ2h0JyBjb3VudGVy
IGZyb20gZmFzdA0KPiA+ID4gPiA+IHBhdGggbGlrZSBnZW5lcmljIGJsb2NrIGxheWVyLCBpdCdz
IG5vdCBvayB0byBtZSB0byBzd2l0Y2ggdG8NCj4gPiA+ID4gPiBwZXJjcHVfcmVmIGZvciBub3cu
DQo+ID4NCj4gPiBUaGUgbWFpbiBwdXJwb3NlIG9mIHRoaXMgcGF0Y2hzZXQgaXMgdG8gaW1wcm92
ZSBSQUlENSBwZXJmb3JtYW5jZS4NCj4gPiBJbiB0aGUgY3VycmVudCBSQUlEIDEvMTAgZGVzaWdu
LCB0aGUgdmFsdWUgb2YgbnJfcGVuZGluZyBpcw0KPiA+IGludGVudGlvbmFsbHkgYWx3YXlzIGlu
IGF0b21pYyBtb2RlIGJlY2F1c2UgaXQgbXVzdCBiZSByZWFkIGluIElPDQo+ID4gZmFzdCBwYXRo
LiBVbmxlc3MgdGhlIGRlc2lnbiBvZiByZWFkaW5nIHRoZSB2YWx1ZSBvZiBucl9wZW5kaW5nIGhh
cw0KPiA+IGNoYW5nZWQsIEkgYmVsaWV2ZSB0aGF0IHRoaXMgcGF0Y2hzZXQgaXMgYSByZWFzb25h
YmxlIGRlc2lnbiBhbmQNCj4gPiBSQUlEMSBwZXJmb3JtYW5jZSBpcyBhYm91dCB0aGUgc2FtZSBh
cyBhdG9taWNfdCBiZWZvcmUgdGhpcyBwYXRjaHNldA0KPiA+IHdhcyBhcHBsaWVkLiBQYXVsJ3Mg
cmVzdWx0cyBhbHNvIHNob3cgdGhhdC4NCj4gPg0KPiA+IEJlc3QgUmVnYXJkcywNCj4gPiBLZWlz
dWtlDQo+IA0KPiBJIG9ubHkgdGVzdGVkIFJBSUQxIGFuZCBkbyBiZWxpZXZlIHRoYXQgc2ltcGxl
ciBpcyBiZXR0ZXIgc28gd291bGQNCj4gcHJlZmVyIG5vdCB0byBjaGFuZ2UgdGhlIFJBSUQxIGNv
ZGUuICBJIGNhbiBydW4gc29tZSBSQUlENSB0ZXN0cyBvbg0KPiB0aGlzIGFzIHdlbGwgdW5sZXNz
IHlvdSBoYXZlIHNvbWUgd2lkZSBzd2VlcGluZyByZXN1bHRzPyBXb3VsZCBsb3ZlIHRvDQo+IHNl
ZSBtb3JlIFJBSUQ1IHBlcmZvcm1hbmNlIGltcHJvdm1lbnRzLiAgU2h1c2h1IGhhcyBhbm90aGVy
IFJBSUQ1IHBlcmYNCj4gcGF0Y2ggb3V0IHRoZXJlIHRoYXQgSSB0aGluayBoYXMgc29tZSB2ZXJ5
IGdvb2QgcG90ZW50aWFsLCBpdCB3b3VsZCBiZQ0KPiBnb29kIGlmIHlvdSBjb3VsZCB0YWtlIGEg
bG9vayBhdCB0aGF0IG9uZS4NCj4gDQo+IC1QYXVsDQoNCldlIGFyZSBwbGFubmluZyB0byBtZWFz
dXJlIHRoZSBwZXJmb3JtYW5jZSBvZiBSQUlENSB1c2luZyBTU0RzLg0KDQpLZWlzdWtlDQo=

