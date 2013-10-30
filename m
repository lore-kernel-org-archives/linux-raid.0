From: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 2/3] block: Check bio can merge before call attempt_plug_merge.
Date: Wed, 30 Oct 2013 10:41:42 +0800
Message-ID: <2013103010413863125714@gmail.com>
Reply-To: majianpeng <majianpeng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

U2lnbmVkLW9mZi1ieTogSmlhbnBlbmcgTWEgPG1hamlhbnBlbmdAZ21haWwuY29tPg0KLS0tDQog
YmxvY2svYmxrLWNvcmUuYyB8IDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyks
IDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1jb3JlLmMgYi9ibG9jay9i
bGstY29yZS5jDQppbmRleCAwYTAwZTRlLi5mYjk3MGZkIDEwMDY0NA0KLS0tIGEvYmxvY2svYmxr
LWNvcmUuYw0KKysrIGIvYmxvY2svYmxrLWNvcmUuYw0KQEAgLTE0OTIsNyArMTQ5Miw3IEBAIHZv
aWQgYmxrX3F1ZXVlX2JpbyhzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IGJpbyAqYmlv
KQ0KIAkgKiBDaGVjayBpZiB3ZSBjYW4gbWVyZ2Ugd2l0aCB0aGUgcGx1Z2dlZCBsaXN0IGJlZm9y
ZSBncmFiYmluZw0KIAkgKiBhbnkgbG9ja3MuDQogCSAqLw0KLQlpZiAoYXR0ZW1wdF9wbHVnX21l
cmdlKHEsIGJpbywgJnJlcXVlc3RfY291bnQpKQ0KKwlpZiAobGlrZWx5KGJpb19tZXJnZWFibGUo
YmlvKSkgJiYgYXR0ZW1wdF9wbHVnX21lcmdlKHEsIGJpbywgJnJlcXVlc3RfY291bnQpKQ0KIAkJ
cmV0dXJuOw0KIA0KIAlzcGluX2xvY2tfaXJxKHEtPnF1ZXVlX2xvY2spOw0KLS0gDQoxLjguNA==
