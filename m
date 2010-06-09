From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 06/23] imsm: FIX: crash during reshape on recovery start
 update
Date: Wed, 9 Jun 2010 15:27:49 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11EECE8BE@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

KE9ubGluZSBDYXBhY2l0eSBFeHBhbnNpb24gZm9yIElNU00pDQpXaGVuIGRpc2sgZXhwYW5zaW9u
IGlzIHByZXBhcmVkLCBzaXR1YXRpb24gaXMgdmVyeSBzaW1pbGFyIHRvIHJlYnVpbGQgY29uZGl0
aW9ucy4NCkltc20gdHJpZXMgdG8gdXBkYXRlIHJlY292ZXJ5IHN0YXJ0LCB0aGlzIGNhdXNlcyBO
VUxMIHBvaW50ZXIgcmVmZXJlbmNlLg0KVG8gYXZvaWQgdGhpcyBwcm9wZXIgcG9pbnRlciBjaGVj
ayBpcyBpbnRyb2R1Y2VkLg0KDQpTaWduZWQtb2ZmLWJ5OiBBZGFtIEt3b2xlayA8YWRhbS5rd29s
ZWtAaW50ZWwuY29tPg0KLS0tDQoNCiBzdXBlci1pbnRlbC5jIHwgICAgMyArKysNCiAxIGZpbGVz
IGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBh
L3N1cGVyLWludGVsLmMgYi9zdXBlci1pbnRlbC5jIGluZGV4IDExNWE1ZjAuLjY2ODNlZjggMTAw
NjQ0DQotLS0gYS9zdXBlci1pbnRlbC5jDQorKysgYi9zdXBlci1pbnRlbC5jDQpAQCAtNDM0Miw2
ICs0MzQyLDkgQEAgc3RhdGljIHZvaWQgdXBkYXRlX3JlY292ZXJ5X3N0YXJ0KHN0cnVjdCBpbXNt
X2RldiAqZGV2LCBzdHJ1Y3QgbWRpbmZvICphcnJheSkNCiAJCQlyZWJ1aWxkID0gZDsNCiAJCX0N
CiANCisJaWYgKHJlYnVpbGQgPT0gTlVMTCkNCisJCXJldHVybjsNCisNCiAJdW5pdHMgPSBfX2xl
MzJfdG9fY3B1KGRldi0+dm9sLmN1cnJfbWlncl91bml0KTsNCiAJcmVidWlsZC0+cmVjb3Zlcnlf
c3RhcnQgPSB1bml0cyAqIGJsb2Nrc19wZXJfbWlncl91bml0KGRldik7ICB9DQoNCg==
