Received: from sg-1-12.ptr.blmpb.com (sg-1-12.ptr.blmpb.com [118.26.132.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2018C72606
	for <linux-raid@vger.kernel.org>; Fri, 28 Nov 2025 02:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764297972; cv=none; b=K8HruQjzsp1cBnYKwCbCUB+/daz4k3z8UP8qJuRuddQC0z6jhnus5+kFHBmOSF1NKKvityrqog1lMdwV9kGOdNQ84rMPxtk5ug6VeUrvFZTY9FCVaWzMRjQM3WmF4paCeZbyj0bDKc1APns7HA4b3Jtwprw20jtoXatjdZtMCwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764297972; c=relaxed/simple;
	bh=8tiv3fV30SaPBjrmq74SeRSx0vdegrVP3mUhZU85L10=;
	h=From:Subject:Message-Id:Content-Type:In-Reply-To:References:To:Cc:
	 Mime-Version:Date; b=GFwyiwbC9kqoX6FEPz6Ly8oE9GiQrbPIItuY2wOmjBiaOWv20bbok25mmAySWScuGmz6PQGJRcFOmXr2eawQwj8fGkSWNy8p1Ck9SRGnxrAKnVpxUZxg1dolK7SVXYxHjTzRZX9ODSHatkRKBN3rqI2opv60d5OuGtV7cQ8QEIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=3kchXDao; arc=none smtp.client-ip=118.26.132.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="3kchXDao"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1764297956;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=8tiv3fV30SaPBjrmq74SeRSx0vdegrVP3mUhZU85L10=;
 b=3kchXDaoZ/CbRtecr4tUcIl20wwYAX0NYGsG0Z1ZIzfjHBS/nk+0+J8jgW/OImk3P+45By
 L30uwiocQSfCbYZsLJm7FLrKRUlAYJiNfBaZSpo0kxNqww2XOwq8UxlRQzdzfELgrcwQVL
 S7lMVAIr67qvlgRObSPwo5PkN59KkEpBXRfkcsW0NU2qqqqKzKyvJtoiu1qq9YRKUNufHX
 2Xmgn88W8APHRVkQaSKG2Bnek6cU+055yQpl6SLD5AzwJTR1zNLqI5a9UozSHX0n7gBlLP
 Vh9ykPdafGOPIUbucZzcANrowVN97QaKazZbWaJO4V3o7HqTzPKHrnOR8CES3w==
Reply-To: yukuai@fnnas.com
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH v2 03/11] md/raid1,raid10: return actual write status in narrow_write_error
Message-Id: <9aa88fa3-cf57-46d0-92db-d4a96ecfa70f@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.153]) by smtp.feishu.cn with ESMTPS; Fri, 28 Nov 2025 10:45:53 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
In-Reply-To: <ae9fde4f-eaf3-b5a2-4fea-8d83cad42ae4@huaweicloud.com>
References: <20251106115935.2148714-1-linan666@huaweicloud.com> <20251106115935.2148714-4-linan666@huaweicloud.com> <63857ce2-0521-4f38-b3d4-d95c8eafc175@fnnas.com> <ae9fde4f-eaf3-b5a2-4fea-8d83cad42ae4@huaweicloud.com>
X-Lms-Return-Path: <lba+269290ce2+6b3453+vger.kernel.org+yukuai@fnnas.com>
To: "Li Nan" <linan666@huaweicloud.com>, <song@kernel.org>, 
	<neil@brown.name>, <namhyung@gmail.com>, "Yu Kuai" <yukuai@fnnas.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<xni@redhat.com>, <k@mgml.me>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Date: Fri, 28 Nov 2025 10:45:50 +0800
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: base64
Organization: fnnas

SGksDQoNCuWcqCAyMDI1LzExLzEwIDE5OjU2LCBMaSBOYW4g5YaZ6YGTOg0KPg0KPg0KPiDlnKgg
MjAyNS8xMS84IDE4OjA3LCBZdSBLdWFpIOWGmemBkzoNCj4+IEhpLA0KPj4NCj4+IOWcqCAyMDI1
LzExLzYgMTk6NTksIGxpbmFuNjY2QGh1YXdlaWNsb3VkLmNvbSDlhpnpgZM6DQo+Pj4gRnJvbTog
TGkgTmFuIDxsaW5hbjEyMkBodWF3ZWkuY29tPg0KPj4+DQo+Pj4gbmFycm93X3dyaXRlX2Vycm9y
KCkgY3VycmVudGx5IHJldHVybnMgdHJ1ZSB3aGVuIHNldHRpbmcgYmFkYmxvY2tzIA0KPj4+IGZh
aWxzLg0KPj4+IEluc3RlYWQsIHJldHVybiBhY3R1YWwgc3RhdHVzIG9mIGFsbCByZXRyaWVkIHdy
aXRlcywgc3VjY2VlZGluZyBvbmx5IA0KPj4+IHdoZW4NCj4+PiBhbGwgcmV0cmllZCB3cml0ZXMg
Y29tcGxldGUgc3VjY2Vzc2Z1bGx5LiBUaGlzIGdpdmVzIHVwcGVyIGxheWVycyANCj4+PiBhY2N1
cmF0ZQ0KPj4+IGluZm9ybWF0aW9uIGFib3V0IHdyaXRlIG91dGNvbWVzLg0KPj4+DQo+Pj4gV2hl
biBzZXR0aW5nIGJhZGJsb2NrcyBmYWlscywgbWFyayB0aGUgZGV2aWNlIGFzIGZhdWx0eSBhbmQg
cmV0dXJuIA0KPj4+IGF0IG9uY2UuDQo+Pj4gTm8gbmVlZCB0byBjb250aW51ZSBwcm9jZXNzaW5n
IHJlbWFpbmluZyBzZWN0aW9ucyBpbiBzdWNoIGNhc2VzLg0KPj4+DQo+Pj4gU2lnbmVkLW9mZi1i
eTogTGkgTmFuIDxsaW5hbjEyMkBodWF3ZWkuY29tPg0KPj4+IC0tLQ0KPj4+IMKgwqAgZHJpdmVy
cy9tZC9yYWlkMS5jwqAgfCAxNyArKysrKysrKystLS0tLS0tLQ0KPj4+IMKgwqAgZHJpdmVycy9t
ZC9yYWlkMTAuYyB8IDE1ICsrKysrKysrKy0tLS0tLQ0KPj4+IMKgwqAgMiBmaWxlcyBjaGFuZ2Vk
LCAxOCBpbnNlcnRpb25zKCspLCAxNCBkZWxldGlvbnMoLSkNCj4+Pg0KPj4+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL21kL3JhaWQxLmMgYi9kcml2ZXJzL21kL3JhaWQxLmMNCj4+PiBpbmRleCBlNjVk
MTA0Y2I5YzUuLjA5MGZlOGY3MTIyNCAxMDA2NDQNCj4+PiAtLS0gYS9kcml2ZXJzL21kL3JhaWQx
LmMNCj4+PiArKysgYi9kcml2ZXJzL21kL3JhaWQxLmMNCj4+PiBAQCAtMjU0MSwxMSArMjU0MSwx
NSBAQCBzdGF0aWMgYm9vbCBuYXJyb3dfd3JpdGVfZXJyb3Ioc3RydWN0IHIxYmlvIA0KPj4+ICpy
MV9iaW8sIGludCBpKQ0KPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJpb190cmltKHdiaW8sIHNl
Y3RvciAtIHIxX2Jpby0+c2VjdG9yLCBzZWN0b3JzKTsNCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDC
oCB3YmlvLT5iaV9pdGVyLmJpX3NlY3RvciArPSByZGV2LT5kYXRhX29mZnNldDsNCj4+PiDCoMKg
IC3CoMKgwqDCoMKgwqDCoCBpZiAoc3VibWl0X2Jpb193YWl0KHdiaW8pIDwgMCkNCj4+PiArwqDC
oMKgwqDCoMKgwqAgaWYgKHN1Ym1pdF9iaW9fd2FpdCh3YmlvKSkgew0KPj4+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgLyogZmFpbHVyZSEgKi8NCj4+PiAtwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBvayA9IHJkZXZfc2V0X2JhZGJsb2NrcyhyZGV2LCBzZWN0b3IsDQo+Pj4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2VjdG9ycywgMCkNCj4+PiAt
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICYmIG9rOw0KPj4+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIG9rID0gZmFsc2U7DQo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKCFy
ZGV2X3NldF9iYWRibG9ja3MocmRldiwgc2VjdG9yLCBzZWN0b3JzLCAwKSkgew0KPj4+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbWRfZXJyb3IobWRkZXYsIHJkZXYpOw0KPj4+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYmlvX3B1dCh3YmlvKTsNCj4+PiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOw0KPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIH0NCj4+PiArwqDCoMKgwqDCoMKgwqAgfQ0KPj4+IMKgwqAgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgYmlvX3B1dCh3YmlvKTsNCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzZWN0X3RvX3dyaXRl
IC09IHNlY3RvcnM7DQo+Pj4gQEAgLTI1OTYsMTAgKzI2MDAsNyBAQCBzdGF0aWMgdm9pZCBoYW5k
bGVfd3JpdGVfZmluaXNoZWQoc3RydWN0IA0KPj4+IHIxY29uZiAqY29uZiwgc3RydWN0IHIxYmlv
ICpyMV9iaW8pDQo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogZXJyb3JzLg0K
Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqLw0KPj4+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgZmFpbCA9IHRydWU7DQo+Pj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
aWYgKCFuYXJyb3dfd3JpdGVfZXJyb3IocjFfYmlvLCBtKSkNCj4+PiAtwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIG1kX2Vycm9yKGNvbmYtPm1kZGV2LA0KPj4+IC3CoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbmYtPm1pcnJvcnNbbV0ucmRldik7DQo+Pj4g
LcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKiBhbiBJL08gZmFpbGVkLCB3ZSBjYW4n
dCBjbGVhciB0aGUgYml0bWFwICovDQo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbmFycm93
X3dyaXRlX2Vycm9yKHIxX2JpbywgbSk7DQo+Pg0KPj4gTm93IHRoYXQgcmV0dXJuIHZhbHVlIGlz
IG5vdCB1c2VkLCB5b3UgY2FuIG1ha2UgdGhpcyBoZWxwZXIgdm9pZC4NCj4+DQo+PiBUaGFua3Ms
DQo+PiBLdWFpDQo+Pg0KPg0KPiBIaSwgS3VhaQ0KPg0KPiBJbiB2MSwgSSBjaGFuZ2VkIHJldHVy
biB0eXBlIG9mIG5hcnJvd193cml0ZV9lcnJvcigpIHRvIHZvaWQuDQo+IEJ1dCBhIGJldHRlciBy
ZXR1cm4gdmFsdWUgd2lsbCBoZWxwIEFrYWdpJ3MgZml4Og0KPiBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9hbGwvODEzNmI3NDYtNTBjOS01MWViLTQ4M2ItZjI2NjFlODZkM2ViQGh1YXdlaWNsb3Vk
LmNvbS8gDQo+DQo+DQpQbGVhc2UgY2hhbmdlIHRvIHZvaWQgbm93LCBwZW9wbGUgd2hvIHdhbnQg
dG8gdXNlIHRoZSByZXR1cm4gdmFsdWUgbGF0ZXIgY2FuDQpjaGFuZ2UgcmV0dXJuIHR5cGUNCg0K
LS0gDQpUaGFua3MsDQpLdWFp
